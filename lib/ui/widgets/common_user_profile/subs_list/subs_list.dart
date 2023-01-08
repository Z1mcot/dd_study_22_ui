import 'package:dd_study_22_ui/domain/enums/user_list_type.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/subs_list/subs_list_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/users_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubsList extends StatelessWidget {
  const SubsList({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SubsListViewModel>();
    int? usersCount = viewModel.users?.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Subscribers")),
      body: SafeArea(
        child: Container(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.users == null
                  ? const Center(
                      child: Text("Time to meet new users..."),
                    )
                  : Column(
                      children: [
                        UsersList(
                          usersCount: usersCount ?? 0,
                          userListType: viewModel.listType,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  static create(Object? arg, {required UserListTypeEnum listType}) {
    String? userId;
    if (arg != null && arg is TabNavigatiorArguments) {
      userId = arg.userId;
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) => SubsListViewModel(
          context: context, userId: userId ?? "", listType: listType),
      child: const SubsList(),
    );
  }
}
