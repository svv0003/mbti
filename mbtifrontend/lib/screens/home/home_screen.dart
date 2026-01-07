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

  /*
  TextField TextFormField처럼 텍스트를 제어하고 관리하는 클래스
  _nameController 변수명 앞의 _는 현재 파일에서만 사용 가능한 private 변수이다.
  사용 예시
  TextField(controller: _nameController)
  클라이언트는 필드 내부에 텍스트 작성하고,
  String name = _nameController.text;
  작성한 텍스트를 가져와서 변수에 담아 사용한다.
  _nameController.text = "홍길동"
  _nameController 내부 텍스트 변경하는 방법.
   */

  /*
  만약에 Input이나 Textarea를 사용할 경우에는 사용자들이 작성한 값(value)를 읽고,
  읽은 value 데이터를 가져오기 위해 기능을 작성해야 했지만
  Dart에서는 TextEditingController 객체를 미리 만들어 놓았기 때문에 편리하다.

  사용 방법
  1. Controller 상태를 담을 변수 공간 설정한다.
      _ private 설정하지 않아도 된다.

  2. TextField 연결한다.
      TextField(
        controller: _nameController와 같은 형태로 내부에 작성된 value 연결한다.
  3. 값을 가져와서 확인 또는 사용한다.
      String name = _nameController.text;

   */
  final TextEditingController _nameController = TextEditingController();

  /*
  에러 메세지 담을 변수
  ? : 변수에 null 들어갈 수 있다.
   */
  String? _errorText;

  /*
  유효성 검사 함수
  TextField 입력 중 실시간 유효성 검사하는 방식과
  ElevatedButton 제출 버튼 클릭 시 유효성 검사하는 방식으로 나뉜다.

  +
  로그인 상태에서 검사 시작하기 버튼 클릭 시
  _validateName 기능이 _nameController.text 접근하여 클라이언트가 작성한 데이터를 확인한다.
  _nameController 이름은 개발자가 지정한 변수명일 뿐
  클라이언트의 이름을 제어하기 위해서는 명칭 controller, name 추가하여 생성한다.
  로그인한 상태에서는 GuestSection이 렌더링 되지 않는다.
  _nameController가 초기화되지 않은 상태
  _nameController = null도 아닌 undefined 오류 발생한다.
   */
  bool _validateName() {
    // 게스트인 경우에만 _nameController가 클라이언트 입력값이 담긴 공간에 접근한다.
    String name = _nameController.text.trim();
    if(name.isEmpty){
      setState(() {
        _errorText = "이름을 입력해주세요.";
      });
      return false;
    }
    if(name.length < 2){
      setState(() {
        _errorText = "이름은 최소 2글자 이상이어야 합니다.";
      });
      return false;
    }
    /*
    r'^[가-힣a-zA-Z0-9]+$'
    - : 어디서부터 어디까지
    가-힣 : 가부터 힣까지
    힣-a : 힣부터 a까지는 잘못된 정규식 문법이라 동작하지 않는다.
     */
    if(!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)){
      setState(() {
        _errorText = "한글 또는 영문만 입력 가능합니다. (특수문자, 숫자 사용 불가)";
      });
      return false;
    }
    setState(() {
      _errorText = null;
    });
    return true;
  }

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
                if(isLoggedIn)
                  /*
                  분리된 프로필 메뉴 위젯에
                  userName 명칭으로 userName 내부 데이터 전달한다.
                  onLogout 명칭으로 _handleLogout 기능 전달한다.
                   */
                  ProfileMenu(
                      // userName: userName,
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
                          Icon(
                              Icons.psychology, size: 100,
                              color: Colors.blue),
                          SizedBox(height: 30),
                          Text(
                              "나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문",
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 40),
                          if(!isLoggedIn) ...[
                            GuestSection(
                              nameController: _nameController,
                              errorText: _errorText,
                              onChanged: (value) {
                                final input = value.trim();
                                setState(() {
                                  if (input.isEmpty) {
                                    _errorText = null;
                                  } else if (input.length < 2) {
                                    _errorText = "이름은 최소 2글자 이상이어야 합니다.";
                                  } else if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(input)) {
                                    _errorText = "한글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 사용 불가)";
                                  } else {
                                    _errorText = null;
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 10),
                          ]
                          else ...[
                            UserSection(),
                            SizedBox(height: 10),
                          ],
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                String nameToUse;

                                if (isLoggedIn) {
                                  // 로그인 상태: 사용자 이름 자동 사용
                                  nameToUse = userName!;
                                } else {
                                  // 비로그인 상태: 유효성 검사
                                  if (!_validateName()) {
                                    // 에러 메시지 SnackBar로 표시
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_errorText ?? "이름을 올바르게 입력해주세요."),
                                        backgroundColor: Colors.red[700],
                                        duration: const Duration(seconds: 3),
                                        // behavior: SnackBarBehavior.floating,
                                        // margin: const EdgeInsets.all(16),
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(12),
                                        // ),
                                      ),
                                    );
                                    return;
                                  }
                                  nameToUse = _nameController.text.trim();
                                }
                                // 성공: 테스트 페이지로 이동
                                context.go("/test", extra: nameToUse);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                isLoggedIn ? "$userName쿤의 MBTI는?" : "검사 시작하기",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
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
