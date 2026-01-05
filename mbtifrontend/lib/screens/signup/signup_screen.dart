import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  // 이름 입력 필드 제어를 위한 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  // 유효성 검사 에러 메세지 저장
  String? _errorText;
  // 회원가입 진행 중 상태 관리
  bool _isLoading = false;
  // 유효성 검사
  bool _validateName() {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = "이름을 입력해주세요.";
      });
      return false;
    }
    if (name.length < 2) {
      setState(() {
        _errorText = "이름은 최소 2글자 이상이어야 합니다.";
      });
      return false;
    }
    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = "한글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 사용 불가)";
      });
      return false;
    }
    setState(() {
      _errorText = null;
    });
    return true;
  }

  /*
  백엔드 API 호출하여 회원가입 진행하고,
  성공 시 자동 로그인 및 검사 화면 이동,
  실패 시 에러 메세지 표시 및 로딩 해제
   */
  void _handleSignup(name) async {
    _isLoading = true;
    _validateName();
    try {
      final user = await ApiService.signup(name);
      setState(() {
        if(user != null){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${user.userName}님, 회원가입이 완료되었습니다!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context.go('/test', extra: user.userName);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    } if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
        leading: IconButton(
            onPressed: ()=> context.go("/"),
            icon: Icon(Icons.arrow_back))
      ),
      body: SingleChildScrollView(
        child: Center(
          // Container 설정 시 가로 세로 padding 속성은 거의 기본으로 작성한다.
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 20
            ),
            child: Column(
              // Column 설정 시 반드시 사용한다.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add, size: 70, color: Colors.green),
                SizedBox(height: 30),
                Text(
                  "MBTI 검사를 위해\n회원가입해주세요.",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center
                ),
                SizedBox(height: 40),
                /*
                테두리를 만드는 방법은 Container, SizedBox 두 가지가 있다.

                SizedBox
                간격 만들거나 레이아웃 제약만 담당하며, 가볍고 성능 좋다.
                색, 테두리, radius, 그림자 꾸밈(Decoration) 불가능하다.

                Container
                크기 지정, 패딩 / 마진, 색상, 테두리, radius, 그림자, 정렬(alignment) 등
                디자인 목적에 최적화된 위젯으로, 내부적으로 여러 위젯의 조합을 위해 쓰이지만
                무겁기 때문에 필요한 경우에만 사용한다.
                 */
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    enabled: !_isLoading,              // 로딩 중에는 입력 불가 -> T/F에 따른 disabled 효과 적용한다.
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력해주세요.',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      final input = value.trim();
                      setState(() {
                        if (input.isEmpty) {
                          _errorText = null;
                          return;
                        }
                        if (RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(input)) {
                          _errorText = null; // 통과
                        }
                        else if (RegExp(r'[0-9]').hasMatch(input)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        }
                        else {
                          _errorText = "한글과 영문만 입력 가능합니다.";
                        }
                      });
                    },
                  ),
                ),
                /*
                SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _errorText == null ? Colors.blue : Colors.pink,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _nameController,
                    enabled: !_isLoading,              // 로딩 중에는 입력 불가 -> T/F에 따른 disabled 효과 적용한다.
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력해주세요.',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                      border: InputBorder.none, // ⭐ 기본 테두리 제거
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      final input = value.trim();
                      setState(() {
                        if (input.isEmpty) {
                          _errorText = null;
                          return;
                        }
                        if (RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(input)) {
                          _errorText = null;
                        } else if (RegExp(r'[0-9]').hasMatch(input)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        } else {
                          _errorText = '한글과 영문만 입력 가능합니다.';
                        }
                      });
                    },
                  ),
                ),

                 */
                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                    ? null
                    : () async {
                      _handleSignup(_nameController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                      '회원가입',
                      style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이미 계정이 있으신가요?'),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.go('/login'),
                      child: Text('로그인'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 위젯 제거 시 리소스 해제
  /// TextEditingController 메모리 누수 방지
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}