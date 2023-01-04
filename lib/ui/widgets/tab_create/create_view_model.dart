import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateViewModel extends ChangeNotifier {
  BuildContext context;
  CreateViewModel({
    required this.context,
  });

  void toContentCreation(String route) async {
    var appViewModel = context.read<AppViewModel>();
    appViewModel.isBottomBarVisible = false;
    notifyListeners();

    await Navigator.of(context).pushNamed(route);
  }
}