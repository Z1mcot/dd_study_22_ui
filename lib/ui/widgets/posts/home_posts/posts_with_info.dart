import 'package:flutter/foundation.dart';

abstract class PostsWithInfo extends ChangeNotifier {
  void onLikeClick(String postId);
  void onCommentClick(String commentId);
  Future refreshView();
}
