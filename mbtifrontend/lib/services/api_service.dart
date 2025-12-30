import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  /*
  final에 비해 const가 가볍기 때문에 단기적으로 값을 상수 처리할 때는 final
  장기적으로 전체 공유하는 상수 처리할 때는 const 사용한다.
  전부 const 사용해도 상관없다.
  const : 어플 전체적으로 사용되는 상수 명칭
  final : 특정 기능 또는 특정 화면에서만 부분적으로 사용되는 상수 명칭
   */
  static const String url = "http://localhost:8080/api/mbti";
  /*
  TODO 백엔드 컨트롤러에서 질문 가져오기
  보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용한다.
   */
  static Future<List<dynamic>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));
    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('불러오기 실패');
    }
  }

  // 결과 제출하기
  static Future<Map<String, dynamic>> submitTest(String userName, Map<int, String> answers) async {
    // 어플에서 선택한 답변 결과를 API 형식으로 변환한다.
    List<Map<String, dynamic>> answerList = [];
    // 어플에서 선택한 질문 번호와 질문 답변을 [{질문1, 답변}, {질문2, 답변}, ...] JSON 형태로 변환하여 저장한다.
    answers.forEach((questionId, option) {
      answerList.add({
        'questionId' : questionId,
        'selectedOption' : option
      });
    });
    final res = await http.post(
      Uri.parse('$url/submit'),
      headers: {'Content-Type' : 'application/json'},
      body: json.encode({
        'userName' : userName,
        'answers' : answerList
      })
    );
    if(res.statusCode == 200){
      return json.decode(res.body);
    } else {
      throw Exception('제출 실패');
    }
  }

}