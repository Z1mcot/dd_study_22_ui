import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:dd_study_22_ui/domain/models/comment/post_comment.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_db.dart';
import 'package:dd_study_22_ui/domain/models/post/post.dart';
import 'package:dd_study_22_ui/domain/models/post/post_content.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static late Database _db;
  static bool _isInitialized = false;

  Future init() async {
    if (!_isInitialized) {
      var databasePath = await getDatabasesPath();
      var path = join(databasePath, "db_v1.1.3.db");

      _db = await openDatabase(path, version: 1, onCreate: _createDB);
      _isInitialized = true;
    }
  }

  Future _createDB(Database db, int version) async {
    var dbInitScript = await rootBundle.loadString('assets/db_init.sql');

    dbInitScript.split(';').forEach((element) async {
      if (element.isNotEmpty) {
        await db.execute(element);
      }
    });
  }

  static final _factories = <Type, Function(Map<String, dynamic> map)>{
    User: (map) => User.fromMap(map),
    Post: (map) => Post.fromMap(map),
    PostContent: (map) => PostContent.fromMap(map),
    SimpleUser: (map) => SimpleUser.fromMap(map),
    PostComment: (map) => PostComment.fromMap(map),
    NotificationDb: (map) => NotificationDb.fromMap(map),
  };

  String _dbName(Type type) {
    if (type == DbModel) {
      throw Exception("Type is required");
    }
    return "t_${(type).toString()}";
  }

  Future<Iterable<T>> getAll<T extends DbModel>(
      {Map<String, Object?>? whereMap,
      bool? invertWhereClause,
      int? take,
      int? skip,
      String? orderBy}) async {
    Iterable<Map<String, dynamic>> query;

    if (whereMap != null) {
      var whereBuilder = <String>[];
      var whereArgs = <dynamic>[];

      whereMap.forEach((key, value) {
        if (value is Iterable<dynamic>) {
          var operator =
              invertWhereClause != null && invertWhereClause ? "NOT IN" : "IN";
          whereBuilder.add(
              "$key $operator (${List.filled(value.length, '?').join(',')})");
          whereArgs.addAll(value.map((e) => "$e"));
        } else {
          var operator =
              invertWhereClause != null && invertWhereClause ? "<>" : "=";
          whereBuilder.add("$key $operator ?");
          whereArgs.add(value);
        }
      });

      query = await _db.query(_dbName(T),
          where: whereBuilder.join(' and '),
          whereArgs: whereArgs,
          offset: skip,
          limit: take,
          orderBy: orderBy);
    } else {
      query = await _db.query(_dbName(T),
          offset: skip, limit: take, orderBy: orderBy);
    }

    var resList = query.map((e) => _factories[T]!(e)).cast<T>();

    return resList;
  }

  Future<T?> get<T extends DbModel>(dynamic id) async {
    var res = await _db.query(_dbName(T), where: 'id = ? ', whereArgs: [id]);
    return res.isNotEmpty ? _factories[T]!(res.first) : null;
  }

  Future<int> insert<T extends DbModel>(T model) async {
    if (model.id == "") {
      var modelMap = model.toMap();
      modelMap["id"] == const Uuid().v4();
      model = _factories[T]!(modelMap);
    }

    return await _db.insert(_dbName(T), model.toMap());
  }

  Future<int> update<T extends DbModel>(T model) async => _db.update(
        _dbName(T),
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      );

  Future<int> delete<T extends DbModel>(T model) async => _db.delete(
        _dbName(T),
        where: 'id = ?',
        whereArgs: [model.id],
      );

  Future<int> cleanTable<T extends DbModel>() async =>
      await _db.delete(_dbName(T));

  Future<int> createUpdate<T extends DbModel>(T model) async {
    var dbItem = await get<T>(model.id);
    var res = dbItem == null ? insert(model) : update(model);
    return await res;
  }

  Future insertRange<T extends DbModel>(Iterable<T> values) async {
    var batch = _db.batch();
    for (var row in values) {
      var data = row.toMap();
      if (row.id == "") {
        data["id"] = const Uuid().v4();
      }

      batch.insert(_dbName(T), data);
    }

    await batch.commit(noResult: true);
  }

  Future createUpdateRange<T extends DbModel>(Iterable<T> values,
      {bool Function(T oldItem, T newItem)? updateCondition}) async {
    var batch = _db.batch();

    for (var row in values) {
      var dbItem = await get<T>(row.id);
      var data = row.toMap();
      if (row.id == "") {
        data["id"] = const Uuid().v4();
      }

      if (dbItem == null) {
        batch.insert(_dbName(T), data);
      } else if (updateCondition == null || updateCondition(dbItem, row)) {
        batch.update(_dbName(T), data, where: 'id = ?', whereArgs: [row.id]);
      }
    }

    await batch.commit(noResult: true);
  }
}
