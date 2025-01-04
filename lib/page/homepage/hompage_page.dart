import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtest/page/create_user_info/create_user_info_data.dart';
import 'package:testtest/page/homepage/add_memo_dialog/add_memo_dialog_page.dart';

import '../login/login_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        leading:logOutButton(),
        actions: [
          addMemoButton()
        ],
      ),
      body: const Center(
        child: Text('로그인 완료!'),
      ),
    );
  }

  Widget logOutButton(){
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        ref.read(idProvider.notifier).state = '';
        ref.read(passwordProvider.notifier).state = '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    );
  }

  Widget addMemoButton(){
    return IconButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => AddMemoDialogPage(),
          );
        },
        icon: const Icon(Icons.add)
    );
  }
}
