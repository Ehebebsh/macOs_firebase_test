import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtest/page/homepage/add_memo_dialog/add_memo_dialog_controller.dart';

import 'add_memo_dialog_data.dart';

class AddMemoDialogPage extends ConsumerStatefulWidget {
  const AddMemoDialogPage({super.key});

  @override
  ConsumerState<AddMemoDialogPage> createState() => _NoteDialogState();
}

class _NoteDialogState extends ConsumerState<AddMemoDialogPage> {
  final TextEditingController _noteController = TextEditingController(); // 메모 입력 컨트롤러
  late AddMemoDialogPageController addMemoDialogPageController;


  @override
  void initState() {
    super.initState();
    addMemoDialogPageController = AddMemoDialogPageController(ref: ref);
  }

  @override
  void dispose() {
    _noteController.dispose(); // 메모 컨트롤러 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '메모와 날짜 기록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            dateWidget(),
            memoWidget(),
            bottomWidget()
          ],
        ),
      ),
    );
  }

  Widget dateWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(
          ref.watch(dateProvider) == null
              ? '날짜를 선택하세요'
              : '선택된 날짜: ${ref.watch(dateProvider)!.toLocal().toString().split(' ')[0]}',
        ),
        onTap: () async {
          final result = await showCalendarDatePicker2Dialog(
            context: context,
            config: CalendarDatePicker2WithActionButtonsConfig(),
            dialogSize: const Size(325, 400),
            value: [ref.watch(dateProvider) ?? DateTime.now()],
          );

          if (result != null && result.isNotEmpty) {
            // 선택된 날짜를 Provider에 저장
            ref.read(dateProvider.notifier).state = result.first;
          }
        },
      ),
    );
  }

  Widget memoWidget(){
    return TextField(
      onChanged: (value){
        ref.read(memoProvider.notifier).state = value;
      },
      controller: _noteController,
      decoration: const InputDecoration(
        labelText: '메모를 입력하세요',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }


  Widget bottomWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              ref.read(dateProvider.notifier).state = null;
              ref.read(memoProvider.notifier).state = '';
              Navigator.pop(context); // Dialog 닫기
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              var date = ref.read(dateProvider);
              var memo = ref.read(memoProvider);
              if (date != null && memo.isNotEmpty) {
                try {
                  // 현재 로그인된 사용자 UUID 가져오기
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('사용자가 로그인되어 있지 않습니다')),
                    );
                    return;
                  }
                  addMemoDialogPageController.addMemo(date: date, memo: memo);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('메모가 저장되었습니다')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  if (kDebugMode) {
                    print('+++ error: $e');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('저장 실패: $e')),
                  );
                }
              } else {
                // 입력값 확인 메시지
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('날짜와 메모를 모두 입력해주세요')),
                );
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
