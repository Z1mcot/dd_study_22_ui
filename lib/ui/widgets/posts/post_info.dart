import 'package:dd_study_22_ui/ui/widgets/common/page_indicator.dart';
import 'package:flutter/material.dart';

class PostInfo extends StatelessWidget {
  final int postContentCount;
  final int? currentPostContent;
  final String? description;
  const PostInfo({
    super.key,
    required this.postContentCount,
    required this.currentPostContent,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 0,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                    ),
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.comment),
                    iconSize: 28,
                  ),
                ],
              ),
              PageIndicator(
                count: postContentCount,
                current: currentPostContent,
              ),
              const SizedBox(
                width: 100,
              )
            ],
          ),
          Align(
              alignment: Alignment.centerLeft, child: Text(description ?? "")),
        ],
      ),
    );
  }
}
