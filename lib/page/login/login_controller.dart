import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../create_user_info/create_user_info_data.dart';
import '../homepage/hompage_page.dart';

class LoginController {
  final WidgetRef ref;

  LoginController({required this.ref});

  Future<void> login(BuildContext context) async {
    try {
      // ID와 비밀번호를 읽기
      final email = ref.read(idProvider);
      final password = ref.read(passwordProvider);

      // Firebase Auth를 사용한 로그인 시도
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 성공 시 피드백
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공')),
        );

        // HomePage로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      // 에러 처리
      if (kDebugMode) {
        print('+++ e: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    }
  }
}
