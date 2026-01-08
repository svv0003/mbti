import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {

  @override
  Widget build(BuildContext context) {

    // final user = context.watch<AuthProvider>().user;
    final user = context.watch<AuthProvider>();
    final userName = user.user?.userName;

    return Column(
      children: [
        SizedBox(
          child: Text(
            '${userName}쿤!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 300,
          height: 50,
          // child: Text("내 주변 10km 다른 유저의 MBTI 확인하기"),
          // /map 내 위치 지도 보기로 잠시 사용한다.
          child:ElevatedButton(
              onPressed: () => context.go('/map'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87
              ),
              child: Text("내 위치 보기"),
          ),
        ),
        SizedBox(height: 10),
        /*
        div와 같은 성격인 SizedBox 이용하여 이전 결과보기 버튼 생성 가능하다.
        굳이 SizedBox 사용하여 버튼을 감쌀 필요는 없지만 상태 관리나 디자인을 위하여
        SizedBox 감싼 다음 버튼을 작성하는 것도 하나의 방법이다.
         */
        SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
                // onPressed: () => context.go("/history", extra: user?.userName),
                onPressed: () => context.go("/history", extra: userName),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87
                ),
                child: Text("이전 결과 보기")
            )
        ),
      ],
    );
  }
}