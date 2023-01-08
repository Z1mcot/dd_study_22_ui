import 'package:dd_study_22_ui/domain/enums/user_list_type.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/user_list_view_model.dart';

class SubscriptionsListViewModel extends UserListViewModel {
  final String userId;
  final UserListTypeEnum userListType;
  SubscriptionsListViewModel(
      {required super.context,
      required this.userId,
      required this.userListType}) {
    asyncInit();

    lvc.addListener(() async {
      var max = lvc.position.maxScrollExtent;
      var current = lvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) {
              var usersCount = users!.length;
              loadMoreUsers(usersCount);
              users = <SimpleUser>[...users!, ...newUsers!];
              isLoading = false;
            },
          );
        }
      }
    });
  }

  @override
  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};

    await getUsers();
  }

  @override
  Future getUsers() async {
    if (!isLoading) {
      isLoading = true;

      users = await api.getSubscribtions(userId: userId);
    }

    isLoading = false;
  }

  @override
  void loadMoreUsers(int skip) async {
    newUsers = await api.getSubscribtions(userId: userId, skip: skip);
  }
}
