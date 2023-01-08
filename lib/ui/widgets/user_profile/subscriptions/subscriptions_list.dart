import 'package:dd_study_22_ui/domain/enums/user_list_type.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/subscriptions/subscriptions_list_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/users_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionsList extends StatelessWidget {
  const SubscriptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SubscriptionsListViewModel>();
    int? usersCount = viewModel.users?.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Subscriptions")),
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
                          userListType: viewModel.userListType,
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
      create: (BuildContext context) => SubscriptionsListViewModel(
          context: context, userId: userId ?? "", userListType: listType),
      child: const SubscriptionsList(),
    );
  }
}
