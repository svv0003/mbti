// lib/widgets/home/guest_section.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestSection extends StatelessWidget {
  final TextEditingController nameController;
  final String? errorText;
  final ValueChanged<String>? onChanged;  // 입력 시작 시 에러 지우기용 (선택)

  const GuestSection({
    super.key,
    required this.nameController,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "MBTI 검사를 위해\n이름을 입력해주세요",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 300,
          child: TextField(
            controller: nameController,      // HomeScreen에서 받은 컨트롤러
            onChanged: onChanged,            // 입력할 때마다 에러 호출
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "이름",
              hintText: "이름을 입력하세요",
              border: const OutlineInputBorder(),
              errorText: errorText,
              errorStyle: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/login"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("로그인", style: TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/signup"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("회원가입", style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}