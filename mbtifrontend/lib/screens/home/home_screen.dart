import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbtifrontend/common/constants.dart';

// 상태에 따른 화면 변화가 일어날 예정이기 때문에 stateful 사용한다.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen 내부에서 사용할 변수명, 함수명
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
  
  // UI 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MBTI 유형 검사")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, size: 100, color: Colors.blue),
            SizedBox(height: 30),
            Text(
                "나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문",
                style: TextStyle(fontSize: 20)
            ),
            SizedBox(height: 40),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "이름",
                    hintText: "이름을 입력하세요.",
                    border: OutlineInputBorder()
                  )
                )
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    if(name.isEmpty){
                      return;
                    }
                    context.go('/test', extra:name);
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
          ],
        )
      ),
    );
  }
}
