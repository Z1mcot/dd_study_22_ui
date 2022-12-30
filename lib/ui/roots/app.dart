import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/common/camera_widget.dart';
import 'package:dd_study_22_ui/ui/posts/add_post_widget.dart';
import 'package:dd_study_22_ui/ui/roots/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  final _dataService = DataService();
  final _lvc = ScrollController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AppViewModel({required this.context}) {
    _asyncInit();
    _lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) {
              posts = <PostModel>[...posts!];
              isLoading = false;
            },
          );
        }
      }
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncPosts();
    posts = await _dataService.getPosts(user!.id);
    imagePaths = <String>[];
  }

  void onClick() {
    _lvc.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInCubic,
    );
  }

  List<String>? _imagePaths;
  List<String>? get imagePaths => _imagePaths;
  set imagePaths(List<String>? value) {
    _imagePaths = value;
    notifyListeners();
  }

  void createPost() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (newContext) => Scaffold(
          backgroundColor: Colors.black38,
          appBar: AppBar(backgroundColor: Colors.black38),
          body: SafeArea(
            child: CameraWidget(
              onFile: (file) {
                imagePaths!.add(file.path);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: IconButton(
              onPressed: () async => imagePaths!.isNotEmpty
                  ? await Navigator.of(newContext).push(MaterialPageRoute(
                      builder: (newContext) =>
                          AddPostWidget.create(imagePaths!),
                    ))
                  : null,
              icon: const Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: (viewModel.user != null && viewModel.headers != null)
            ? Padding(
                padding: const EdgeInsets.only(left: 5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "$baseUrl${viewModel.user!.avatarLink}",
                    headers: viewModel.headers,
                  ),
                ))
            : null,
        title: Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: viewModel.createPost,
          ),
        ],
      ),
      body: Container(
        child: viewModel.posts == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                    controller: viewModel._lvc,
                    itemBuilder: (listContext, listIndex) {
                      Widget res;
                      var posts = viewModel.posts;
                      if (posts != null) {
                        var post = posts[listIndex];
                        res = Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: size.width,
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  onPageChanged: (value) =>
                                      viewModel.onPageChanged(listIndex, value),
                                  itemCount: post.content.length,
                                  itemBuilder: (pageContext, pageIndex) =>
                                      Container(
                                    color: Colors.amber[300],
                                    child: Image(
                                      image: NetworkImage(
                                        "$baseUrl${post.content[pageIndex].contentLink}",
                                        headers: viewModel.headers,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              PageIndicator(
                                count: post.content.length,
                                current: viewModel.pager[listIndex],
                              ),
                              Text(post.description ?? "")
                            ],
                          ),
                        );
                      } else {
                        res = const SizedBox.shrink();
                      }
                      return res;
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: viewModel.posts?.length ?? 0,
                  )),
                  if (viewModel.isLoading) const LinearProgressIndicator(),
                ],
              ),
      ),
      // Переход между главной страницей и профилем через этот navbar
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIcon: NavigationIconSelection.home,
        onSelectedIconClick: viewModel.onClick,
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppViewModel(context: context),
      child: const App(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator({
    super.key,
    required this.count,
    required this.current,
    this.width = 10,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> indicator = <Widget>[];
    for (int i = 0; i < count; i++) {
      indicator.add(
        Icon(
          i == (current ?? 0) ? Icons.circle : Icons.circle_outlined,
          size: width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicator,
    );
  }
}
