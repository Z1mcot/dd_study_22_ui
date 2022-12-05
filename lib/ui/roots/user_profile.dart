import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/roots/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  // final _authService = AuthService();

  _ViewModel({required this.context}) {
    _asyncInit();
  }

  User? _user;

  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var user = viewModel.user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            user.nameTag,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: (viewModel.headers != null)
                          ? NetworkImage(
                              "$baseUrl${user.avatarLink}",
                              headers: viewModel.headers,
                            )
                          : null,
                      radius: 50,
                    ),
                    Column(
                      children: [
                        Text("${user.postsCount}",
                            style: const TextStyle(fontSize: 16)),
                        const Text("Posts")
                      ],
                    ),
                    Column(
                      children: [
                        Text("${user.subscribersCount}",
                            style: const TextStyle(fontSize: 16)),
                        const Text("Followers")
                      ],
                    ),
                    Column(
                      children: [
                        Text("${user.subscriptionsCount}",
                            style: const TextStyle(fontSize: 16)),
                        const Text("Following")
                      ],
                    )
                  ],
                ),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                    "Contact email: ${user.email}\nBirth Date: ${user.birthDate}"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavigationBar(
            selectedIcon: NavigationIconSelection.profile),
      );
    } else {
      return const Scaffold(
        body: Text("Couldn't retrieve user info"),
      );
    }
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const UserProfile(),
    );
  }
}
