import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbtifrontend/common/constants.dart';
import 'package:mbtifrontend/widgets/home/guest_section.dart';
import 'package:mbtifrontend/widgets/home/profile_menu.dart';
import 'package:mbtifrontend/widgets/home/user_section.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

/*
lib/
┣────── screens/
┃       └────── home_screen.dart            // 메인 홈 화면 (조립하는 역할)
┃
┣────── widgets/
┃       └────── home/
┃               ┣────── guest_section.dart  // 로그인 이전 화면
┃               ┣────── user_section.dart  // 로그인 이후 화면 + 입력 로직
┃               └────── profile_menu.dart  // appbar 프로필 메뉴
 */

// 상태에 따른 화면 변화가 일어날 예정이기 때문에 stateful 사용한다.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("로그아웃"),
        content: Text("로그아웃하시겠습니까?"),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () => context.pop(), // go_router pop
            child: Text('취소'),
          ),
          // 로그아웃 버튼
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout(); // 로그아웃 처리
              context.pop(); // 다이얼로그 닫기
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("로그아웃되었습니다.")));
              },
              child: Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  // 홈화면 시작하자마자 실행할 기능들 세팅
  // git init -> git 초기세팅 처럼 init 초기 세팅
  // state 상태 변화 기능
  // initState() -> 위젯 화면을 보여줄 때 초기 상태 화면 변화하여 보여주겠다
  // ex 화면에서 backend 데이터를 가져오겠다. 로그인 상태 복원하겠다.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
  }





  // UI 화면
  /*
  화면에서 키보드 사용하는 경우에는 화면이 가려기는 것을 방지하기 위해 스크롤 가능하게 처리한다.
  화면 하단에 위치한 키보드를 텍스트 입력 시 화면에 보이도록 올리는 과정이 필요하다.
   */
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final isLoggedIn = authProvider.isLoggedIn;
          final userName = authProvider.user?.userName;

          return Scaffold(
            appBar: AppBar(
              title: const Text("MBTI 유형 검사"),
              actions: [
                // 로그인 상태에 따라 버튼 표기한다.
                if(isLoggedIn)
                  /*
                  분리된 프로필 메뉴 위젯에
                  userName 명칭으로 userName 내부 데이터 전달한다.
                  onLogout 명칭으로 _handleLogout 기능 전달한다.
                   */
                  ProfileMenu(
                      userName: userName,
                      onLogout: _handleLogout)
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.psychology, size: 100,
                              color: Colors.blue),
                          SizedBox(height: 30),
                          Text(
                              "나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문",
                              style: TextStyle(fontSize: 20)
                          ),
                          SizedBox(height: 40),
                          if(!isLoggedIn) ...[
                            GuestSection()
                          ]
                          else ...[
                            UserSection()
                          ],
                          SizedBox(height: 10),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () => context.go('/types'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[300],
                                    foregroundColor: Colors.black87
                                ),
                                child: Text("MBTI 유형 보기")),
                          )
                        ],
                      )
                  )

              ),
            )
          );
        }
    );
  }
}
