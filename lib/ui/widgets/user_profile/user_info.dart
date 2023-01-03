import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfo extends StatelessWidget {
  final String name;
  final String email;
  final DateTime birthDate;

  const UserInfo({
    super.key,
    required this.name,
    required this.email,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy HH:mm");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          "Contact email: $email",
        ),
        Text("Birth Date: ${dtf.format(birthDate)}"),
      ],
    );
  }
}
