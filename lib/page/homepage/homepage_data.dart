import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoListProvider = StateProvider<List<Memo>>((ref)=>[]);



class Memo{
  final String date;
  final String memo;

  Memo({
    required this.date,
    required this.memo
});
}