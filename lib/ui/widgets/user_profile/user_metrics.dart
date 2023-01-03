import 'package:flutter/material.dart';

class UserMetrics extends StatelessWidget {
  final int postsCount;
  final int subscribersCount;
  final int subscriptionsCount;

  const UserMetrics({
    super.key,
    required this.postsCount,
    required this.subscribersCount,
    required this.subscriptionsCount,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width - 140,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("$postsCount",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Posts")
            ],
          ),
          Column(
            children: [
              Text("$subscribersCount",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Followers")
            ],
          ),
          Column(
            children: [
              Text("$subscriptionsCount",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Following")
            ],
          ),
        ],
      ),
    );
  }
}
