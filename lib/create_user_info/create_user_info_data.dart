import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = StateProvider<String> ((ref)=>'');
final idProvider = StateProvider<String> ((ref)=>'');
final passwordProvider = StateProvider<String> ((ref)=>'');



// ref.watch(nameProvder); // 이걸 써주면 이걸 써준 위젯이 재빌드가 돼
// ref.read(nameProvider.notifier).state = '안녕하세요'; // 빈스트링에서 안녕하세요가 추가됨