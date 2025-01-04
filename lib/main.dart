import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase Core 패키지 추가
import 'package:testtest/page/login/login_page.dart';
import 'firebase_options.dart'; // 자동 생성된 Firebase 옵션 파일


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 초기화 대기
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // 자동 생성된 Firebase 옵션 사용
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
