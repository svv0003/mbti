import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestSection extends StatelessWidget {
  const GuestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/login"),
            child: Text(
                "로그인",
                style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/signup"),
            child: Text(
                "회원가입",
                style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}