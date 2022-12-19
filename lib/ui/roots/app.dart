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
  final _authService = AuthService();

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

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: (viewModel.user != null && viewModel.headers != null)
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  "$baseUrl${viewModel.user!.avatarLink}",
                  headers: viewModel.headers,
                ),
              )
            : null,
        title: Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [],
      ),
      // Переход между главной страницей и профилем через этот navbar
      bottomNavigationBar: const AppBottomNavigationBar(
        selectedIcon: NavigationIconSelection.home,
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const App(),
    );
  }
}
