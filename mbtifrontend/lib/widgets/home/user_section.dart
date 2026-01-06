import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {

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
   */
  bool _validateName() {
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




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SizedBox(
            width: 300,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: "이름",
                  hintText: "이름을 입력하세요.",
                  border: OutlineInputBorder(),
                  errorText: _errorText
              ),
              onChanged: (value) {
                final input = value.trim(); // 앞뒤 공백 제거

                setState(() {
                  // 입력이 완전히 비었으면 에러 없음
                  if (input.isEmpty) {
                    _errorText = null;
                    return;
                  }

                  // 전체가 한글 또는 영문으로만 이루어졌는지 확인
                  if (RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(
                      input)) {
                    _errorText = null; // 통과
                  } else {
                    _errorText = "한글과 영문만 입력 가능합니다.";
                  }
                  /*
                            모든 상태 실시간 변경은 setState(()=>{...}) 내부에 작성해야 한다.
                            setState()로 감싸지 않은 if-else문은 변수 값만 변경하지만 화면 업데이트는 안 된다.
                            화면 자동 업데이트되도록 상태 변경하는 것이 중요하다.
                             */
                });
              },
            )
          /*
                      onChanged: (value) {
                          if(_errorText != null) {
                            setState(() {
                              _errorText = null;
                            });
                          }
                      },
                      글자 입력 시 무조건 에러 메세지를 비우라는 코드이다.
                      1111입력하는 순간에도 계속 에러 메세지를 지워버리기 때문에
                      정상적으로 _errorText 작동하지만 마치 작동하지 않는 것처럼 보인다.
                      _validateName()을 onChanged에서 사용하지 않았다.
                       */
        ),
        SizedBox(height: 10),
        SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                print("버튼 눌림");
                if (_validateName()) {
                  String name = _nameController.text.trim();
                  context.go("/test", extra: name);
                }
              },
              child: Text(
                  "검사 시작하기",
                  style: TextStyle(fontSize: 16)
              ),
            )
        ),
        /*
              div와 같은 성격인 SizedBox 이용하여 이전 결과보기 버튼 생성 가능하다.
              굳이 SizedBox 사용하여 버튼을 감쌀 필요는 없지만 상태 관리나 디자인을 위하여
              SizedBox 감싼 다음 버튼을 작성하는 것도 하나의 방법이다.
               */
        SizedBox(height: 10),
        SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  if (_validateName()) {
                    String name = _nameController.text
                        .trim();
                    context.go("/history", extra: name);
                  }
                },
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