import 'package:flutter/cupertino.dart';

class NewPostViewModel extends ChangeNotifier {
  final BuildContext context;

  List<String>? _imagePaths;
  List<String>? get imagePaths => _imagePaths;
  set imagePaths(List<String>? value) {
    _imagePaths = value;
    notifyListeners();
  }

  NewPostViewModel({
    required this.context,
  }) {
    _asyncInit();
  }

  void _asyncInit() async {
    imagePaths = <String>[];
  }
}
