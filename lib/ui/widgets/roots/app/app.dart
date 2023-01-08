import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/common/bottom_tabs.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () async {
            var isFirstRouteInCurrentTab = await AppNavigator
                .navigationKeys[viewModel.currentTab]!.currentState!
                .maybePop();

            if (isFirstRouteInCurrentTab) {
              if (viewModel.currentTab != TabEnums.defaultTab) {
                viewModel.selectTab(TabEnums.defaultTab);
              }
              return false;
            }
            return isFirstRouteInCurrentTab;
          },
          child: Scaffold(
            bottomNavigationBar: Visibility(
              visible: viewModel.isBottomBarVisible,
              child: BottomTabs(
                currentTab: viewModel.currentTab,
                onSelectTab: viewModel.selectTab,
              ),
            ),
            body: Stack(
              children: TabItemEnum.values
                  .map((e) => _buildOffstageNavigator(context, e))
                  .toList(),
            ),
          ),
        ));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppViewModel(context: context),
      child: const App(),
    );
  }

  Widget _buildOffstageNavigator(BuildContext context, TabItemEnum tabItem) {
    var viewModel = context.watch<AppViewModel>();

    return Offstage(
        offstage: viewModel.currentTab != tabItem,
        child: TabNavigator(
          navigatorKey: AppNavigator.navigationKeys[tabItem]!,
          tabItem: tabItem,
        ));
  }
}
