import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtest/commons/textfield_widget.dart';
import 'package:testtest/create_user_info/create_user_info_data.dart';

class CreateUserInfo extends ConsumerStatefulWidget {
  const CreateUserInfo({super.key});

  @override
  ConsumerState<CreateUserInfo> createState() => _CreateUserInfoState();
}

class _CreateUserInfoState extends ConsumerState<CreateUserInfo> {
  Future<bool> _onWillPop() async {
    // 뒤로가기 버튼 동작 전에 nameProvider 초기화
    resultValue();
    return true; // true를 반환하여 뒤로가기가 실행되도록 허용
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // 뒤로가기 동작 가로채기
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원정보 입력'),
        ),
        body: Column(
          children: [
            nameFieldWidget(),
            idFieldWidget(),
            passwordFieldWidget(),
            Spacer(),
            bottomWidget()
          ],
        ),
      ),
    );
  }


  Widget nameFieldWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTextField(
        title: '이름',
        hintText: '이름',
        provider: nameProvider,
      ),
    );
  }

  Widget idFieldWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTextField(
        title: '아아디',
        hintText: '아이디',
        provider: idProvider,
      ),
    );
  }

  Widget passwordFieldWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTextField(
        isPassword: true,
        title: '비밀번호',
        hintText: '비밀번호',
        provider: passwordProvider,
      ),
    );
  }

  Widget bottomWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () async{
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: ref.watch(idProvider),
                    password: ref.read(passwordProvider)
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('회원가입 성공!')),
                  );
                  resultValue();
                  Navigator.of(context).pop();
                } catch (e) {
                  if (kDebugMode) {
                    print('+++ e: $e');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 실패: $e')),
                  );
                }
              },
              child: Text('회원가입')
          )
        ],
      ),
    );
  }

  void resultValue() {
    ref.read(nameProvider.notifier).state = ''; // 상태 초기화
    ref.read(idProvider.notifier).state  = '';
    ref.read(passwordProvider.notifier).state = '';
  }
}
