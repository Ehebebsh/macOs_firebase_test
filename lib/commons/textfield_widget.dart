import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final String? title;
  final String hintText;
  final StateProvider<String> provider;
  final bool isPassword;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.title,
    required this.hintText,
    required this.provider,
    this.isPassword = false,
    this.enabled = true,
  });

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // TextEditingController를 초기화하고 provider의 초기값을 설정
    _controller = TextEditingController(text: ref.read(widget.provider));
    // TextEditingController 값 변경 시 provider 상태를 업데이트
    _controller.addListener(() {
      ref.read(widget.provider.notifier).state = _controller.text;
    });
  }

  @override
  void dispose() {
    // TextEditingController를 해제하여 메모리 누수 방지
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _controller,
          obscureText: widget.isPassword,
          enabled: widget.enabled,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: widget.enabled ? Colors.white : Colors.grey[200],
          ),
          onChanged: (value){
            ref.read(widget.provider.notifier).state = value;
            if (kDebugMode) {
              print('+++ value: ${ref.watch(widget.provider)}');
            }
          },
        ),
      ],
    );
  }
}
