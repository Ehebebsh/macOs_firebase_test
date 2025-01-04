import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_memo_dialog_data.dart';

class AddMemoDialogPageController{
  final WidgetRef ref;

  AddMemoDialogPageController({required this.ref});

  Future<void> addMemo({
    required DateTime date,
    required String memo,
}) async {
    try {
      // 현재 로그인된 사용자 가져오기
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }
      final uuid = user.uid;

      // Firestore에 데이터 저장
      await FirebaseFirestore.instance
          .collection('notes') // notes 컬렉션
          .doc(uuid) // UUID를 사용하여 문서 생성
          .collection('userNotes') // 사용자별 서브컬렉션
          .add({
        'date': date.toString(), // ISO8601 형식 날짜
        'note': memo, // 메모 내용
      });
    } catch (e) {
      rethrow; // 호출한 쪽에서 에러 처리 가능
    }
  }
}
