// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dd_study_22_ui/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final dayNow = DateTime.now().day;

void main() {
  group('Sign up tests.', () {
    testWidgets('New user with valid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('nameField')), 'A B C');
      await tester.enterText(
          find.byKey(const Key('nametagField')), 'autoTesting');
      await tester.enterText(
          find.byKey(const Key('emailField')), 'atdasfasdf@maa.ru');
      await tester.enterText(find.byKey(const Key('passField')), 'Qwerty1op\$');
      await tester.enterText(
          find.byKey(const Key('retryPassField')), 'Qwerty1op\$');

      await tester.tap(find.byKey(const Key('birthdateField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$dayNow'));
      await tester.tap(find.text('OK'));

      final registerBtn = find.byKey(const Key('registerBtn'));

      expect(tester.widget<ElevatedButton>(registerBtn).enabled, isTrue);
      await tester.tap(registerBtn);
      await tester.pumpAndSettle(const Duration(seconds: 6));

      expect(find.byKey(const Key('errorTxt')), findsNothing);
    });

    testWidgets('New user with short (7 symbols) password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('nameField')), 'A B C');
      await tester.enterText(
          find.byKey(const Key('nametagField')), 'autoTesting');
      await tester.enterText(find.byKey(const Key('emailField')), 'at@m.ru');
      await tester.enterText(find.byKey(const Key('passField')), 'qwerty');
      await tester.enterText(find.byKey(const Key('retryPassField')), 'qwerty');

      await tester.tap(find.byKey(const Key('birthdateField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$dayNow'));
      await tester.tap(find.text('OK'));

      final registerBtn = find.byKey(const Key('registerBtn'));

      expect(tester.widget<ElevatedButton>(registerBtn).enabled, isFalse);
    });

    testWidgets('New user with long (33 symbols) password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('nameField')), 'A B C');
      await tester.enterText(
          find.byKey(const Key('nametagField')), 'autoTesting');
      await tester.enterText(find.byKey(const Key('emailField')), 'at@m.ru');
      await tester.enterText(find.byKey(const Key('passField')), 'qwerty');
      await tester.enterText(find.byKey(const Key('retryPassField')), 'qwerty');

      await tester.tap(find.byKey(const Key('birthdateField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$dayNow'));
      await tester.tap(find.text('OK'));

      final registerBtn = find.byKey(const Key('registerBtn'));

      expect(tester.widget<ElevatedButton>(registerBtn).enabled, isFalse);
    });

    testWidgets('New user with invalid symbols password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('nameField')), 'A B C');
      await tester.enterText(
          find.byKey(const Key('nametagField')), 'autoTesting');
      await tester.enterText(find.byKey(const Key('emailField')), 'at@m.ru');
      await tester.enterText(find.byKey(const Key('passField')), 'qwertyююqq');
      await tester.enterText(
          find.byKey(const Key('retryPassField')), 'qwertyююqq');

      await tester.tap(find.byKey(const Key('birthdateField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$dayNow'));
      await tester.tap(find.text('OK'));

      final registerBtn = find.byKey(const Key('registerBtn'));

      expect(tester.widget<ElevatedButton>(registerBtn).enabled, isFalse);
    });

    testWidgets('New user with email without email provider',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('nameField')), 'A B C');
      await tester.enterText(
          find.byKey(const Key('nametagField')), 'autoTesting');
      await tester.enterText(
          find.byKey(const Key('emailField')), 'atqwerqwere');
      await tester.enterText(find.byKey(const Key('passField')), 'qwertyiop');
      await tester.enterText(
          find.byKey(const Key('retryPassField')), 'qwertyiop');

      await tester.tap(find.byKey(const Key('birthdateField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$dayNow'));
      await tester.tap(find.text('OK'));

      final registerBtn = find.byKey(const Key('registerBtn'));

      expect(tester.widget<ElevatedButton>(registerBtn).enabled, isFalse);
    });
  });

  group('Login tests.', () {
    testWidgets('Login with existing credentials (email + password)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(
          find.byKey(const Key('loginField')), 'testing@m.ru');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'qwertyuiop');

      final loginBtn = find.byKey(const Key('loginBtn'));

      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('errorTxt')), findsNothing);
    });

    testWidgets('Login with existing credentials (login + password)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byKey(const Key('loginField')), 'string');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'qwertyuiop');

      final loginBtn = find.byKey(const Key('loginBtn'));

      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('errorTxt')), findsNothing);
    });

    testWidgets('Login with invalid password', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(
          find.byKey(const Key('loginField')), 'testing@m.ru');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'dddddddddd');

      final loginBtn = find.byKey(const Key('loginBtn'));

      await tester.tap(loginBtn);
      await tester.pump(const Duration(seconds: 5));

      expect(find.text('Incorrect username or password'), findsNothing);
    });

    testWidgets('Login with invalid login', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(
          find.byKey(const Key('loginField')), 'fffffffddddd');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'qwertyuiop');

      final loginBtn = find.byKey(const Key('loginBtn'));

      await tester.tap(loginBtn);
      await tester.pump(const Duration(seconds: 5));

      expect(find.text('Incorrect username or password'), findsNothing);
    });
  });

  group('Password change tests.', () {
    testWidgets('Valid password change', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // await tester.tap(find.byKey(const Key('profileTab')));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Edit profile'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Change password'));
      // await tester.pumpAndSettle();

      // await tester.enterText(
      //     find.byKey(const Key('oldPasswordField')), 'qwertyuiop');
      // await tester.enterText(
      //     find.byKey(const Key('newPasswordField')), 'qwertyuiop1');
      // await tester.enterText(
      //     find.byKey(const Key('retryPasswordField')), 'qwertyuiop1');

      // await tester.tap(find.text('Change password'));
      // await tester.pumpAndSettle();

      expect(0, 0);
    });

    testWidgets('Password change with invalid old password',
        (WidgetTester tester) async {
      // await tester.pumpWidget(const MyApp());

      // await tester.tap(find.byKey(const Key('profileTab')));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Edit profile'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Change password'));
      // await tester.pumpAndSettle();

      // await tester.enterText(
      //     find.byKey(const Key('oldPasswordField')), 'qwertyuiop333');
      // await tester.enterText(
      //     find.byKey(const Key('newPasswordField')), 'qwertyuiop1');
      // await tester.enterText(
      //     find.byKey(const Key('retryPasswordField')), 'qwertyuiop1');

      // await tester.tap(find.text('Change password'));
      // await tester.pumpAndSettle();

      expect(0, 0);
    });

    testWidgets(
        'Password change: new password and retry new password fields content doesn\'t match',
        (WidgetTester tester) async {
      // await tester.pumpWidget(const MyApp());

      // await tester.tap(find.byKey(const Key('profileTab')));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Edit profile'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Change password'));
      // await tester.pumpAndSettle();

      // await tester.enterText(
      //     find.byKey(const Key('oldPasswordField')), 'qwertyuiop1');
      // await tester.enterText(
      //     find.byKey(const Key('newPasswordField')), 'qwertyuiop444');
      // await tester.enterText(
      //     find.byKey(const Key('retryPasswordField')), 'qwertyuiop555');

      // var changeBtn = find.text('Change password');

      expect(0, 0);
    });

    testWidgets('Password change: invalid characters in new password',
        (WidgetTester tester) async {
      // await tester.pumpWidget(const MyApp());

      // await tester.tap(find.byKey(const Key('profileTab')));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Edit profile'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('Change password'));
      // await tester.pumpAndSettle();

      // await tester.enterText(
      //     find.byKey(const Key('oldPasswordField')), 'qwertyuiop1');
      // await tester.enterText(
      //     find.byKey(const Key('newPasswordField')), 'qwertyuiopффф');
      // await tester.enterText(
      //     find.byKey(const Key('retryPasswordField')), 'qwertyuiopффф');

      // var changeBtn = find.text('Change password');

      expect(0, 0);
    });
  });
}
