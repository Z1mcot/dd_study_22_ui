import 'package:flutter/material.dart';

class UserMetrics extends StatelessWidget {
  final String userId;
  final int postsCount;
  final int subscribersCount;
  final void Function() toSubscribers;
  final int subscriptionsCount;
  final void Function() toSubscriptions;

  const UserMetrics({
    super.key,
    required this.userId,
    required this.postsCount,
    required this.subscribersCount,
    required this.subscriptionsCount,
    required this.toSubscribers,
    required this.toSubscriptions,
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
          GestureDetector(
            onTap: toSubscribers,
            child: Column(
              children: [
                Text("$subscribersCount",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Followers")
              ],
            ),
          ),
          GestureDetector(
            onTap: toSubscriptions,
            child: Column(
              children: [
                Text("$subscriptionsCount",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Following")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
