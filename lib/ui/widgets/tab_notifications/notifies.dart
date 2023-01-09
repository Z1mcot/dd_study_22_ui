import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_notifications/notifies_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifies extends StatelessWidget {
  const Notifies({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<NotifiesViewModel>();
    var notifiesCount = viewModel.notifications?.length;
    var notifications = viewModel.notifications;

    if (notifications != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notification center"),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RefreshIndicator(
              onRefresh: viewModel.refreshView,
              child: Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    Widget res;

                    var notify = notifications[index];
                    res = SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                viewModel.toUserProfile(notify.sender.id),
                            child: CircleAvatar(
                              foregroundImage: NetworkImage(
                                  "$baseUrl${notify.sender.avatarLink}",
                                  headers: viewModel.headers),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notify.sender.nameTag,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 220,
                                child: Text(
                                  notify.description,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (notify.post != null)
                                GestureDetector(
                                  onTap: () =>
                                      viewModel.toPostDetail(notify.post!.id),
                                  child: Image(
                                    width: 60,
                                    height: 60,
                                    image: NetworkImage(
                                        "$baseUrl${notify.post!.content[0].contentLink}"),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          )
                        ],
                      ),
                    );

                    return res;
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: notifiesCount ?? 0,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NotifiesViewModel(context: context),
      child: const Notifies(),
    );
  }
}
