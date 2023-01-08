import 'package:dd_study_22_ui/domain/enums/user_list_type.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/subs_list/subs_list_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/user_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  final int usersCount;
  final UserListTypeEnum userListType;

  const UsersList({
    super.key,
    required this.usersCount,
    required this.userListType,
  });

  @override
  Widget build(BuildContext context) {
    UserListViewModel viewModel;
    if (userListType == UserListTypeEnum.searchList) {
      viewModel = context.read<SearchViewModel>();
    } else {
      viewModel = context.read<SubsListViewModel>();
    }

    var users = viewModel.users;
    if (users != null) {
      return Expanded(
        child: ListView.separated(
            itemBuilder: (_, listIndex) {
              Widget res;

              var user = users[listIndex];
              res = GestureDetector(
                onTap: () => viewModel.toUserProfile(user.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    CircleAvatar(
                      foregroundImage: NetworkImage(
                          "$baseUrl${user.avatarLink}",
                          headers: viewModel.headers),
                    ),
                    Column(
                      children: [
                        Text(user.nameTag),
                        Text(
                          user.name,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ]),
                ),
              );

              return res;
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: usersCount),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
