import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtest/page/create_user_info/create_user_info_data.dart';
import '../login/login_page.dart';
import 'homepage_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();

}

class _HomePageState extends ConsumerState<HomePage> {
  late WeatherService weatherService;
  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(ref: ref);
    weatherService.fetchWeather(nx: 60,ny: 127);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        leading:logOutButton(),
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
}
