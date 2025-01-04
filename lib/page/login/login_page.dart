import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testtest/commons/textfield_widget.dart';

import '../create_user_info/create_user_info_data.dart';
import '../create_user_info/create_user_info_page.dart';
import 'login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late LoginController loginController;

 @override
  void initState() {
    super.initState();
    loginController = LoginController(ref: ref);
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('로그인'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(hintText: '아이디', provider: idProvider),
            CustomTextField(
              hintText: '비밀번호',
              provider: passwordProvider,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                var email = ref.read(idProvider);
                var password = ref.read(passwordProvider);
                loginController.login(context: context, email: email, password: password);
              },
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateUserInfo(),
                  ),
                );
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
