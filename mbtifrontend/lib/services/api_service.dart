import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mbtifrontend/common/constants.dart';
import 'package:mbtifrontend/models/answer_model.dart';
import 'package:mbtifrontend/models/question_model.dart';
import 'package:mbtifrontend/models/result_model.dart';
import 'package:mbtifrontend/models/test_request_model.dart';

import '../models/mbti_type_model.dart';


/*
models에 작성한 자료형 변수명을 활용하여 데이터 타입을 지정한다.
 */
class ApiService {
  /*
  final에 비해 const가 가볍기 때문에 단기적으로 값을 상수 처리할 때는 final
  장기적으로 전체 공유하는 상수 처리할 때는 const 사용한다.
  전부 const 사용해도 상관없다.
  const : 어플 전체적으로 사용되는 상수 명칭
  final : 특정 기능 또는 특정 화면에서만 부분적으로 사용되는 상수 명칭
   */
  // constants.dart 파일에서 상태관리하는 url 주소 호출하여 사용한다.
  static const String url = ApiConstants.baseUrl;
  /*
  TODO 백엔드 컨트롤러에서 질문 가져오기
  보통 백엔드나 외부 api 데이터를 가져올 때
  자료형으로 Future 특정 자료형을 감싸서 사용한다.
   */
  // static Future<List<dynamic>> getQuestions() async {
  //   final res = await http.get(Uri.parse('$url/questions'));
  //   if(res.statusCode == 200) {
  //     return json.decode(res.body);
  //   } else {
  //     throw Exception('불러오기 실패');
  //   }
  // }
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.questions}'));
    /*
    http://localhost:8080/api/mbti/questions 접속했을 때 나오는 데이터
    res.body = 백엔드로부터 위 주소에서 전달받은 JSON 문자열 -> 한 줄 문자열로 가져온다.
    json.decode() = 한 줄로 되어있는 JSON 문자열 데이터를 Dart 형식의 객체로 변환해서 사용한다.
    .map((json) => Question.fromJson(json))
      = 변환 시 각 데이터를 하나씩 json 변수명에 담아서 Question 객체로 변환 작업을
        첫 데이터부터 끝 데이터까지 모두 수행한다.
    + .toList() = map으로 출력된 결과를 List 목록 형태로 변환하여 사용한다.
     */
    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 결과 제출하기
  // javaScript + java + c++ + sql
  //
  // static Future<Map<String, dynamic>> submitTest(String userName, Map<int, String> answers) async {
  //   // 어플에서 선택한 답변 결과를 API 형식으로 변환한다.
  //   List<Map<String, dynamic>> answerList = [];
  //   // 어플에서 선택한 질문 번호와 질문 답변을 [{질문1, 답변}, {질문2, 답변}, ...] JSON 형태로 변환하여 저장한다.
  //   answers.forEach((questionId, option) {
  //     answerList.add({
  //       'questionId' : questionId,
  //       'selectedOption' : option
  //     });
  //   });
  //   final res = await http.post(
  //     Uri.parse('$url/submit'),
  //     headers: {'Content-Type' : 'application/json'},
  //     body: json.encode({
  //       'userName' : userName,
  //       'answers' : answerList
  //     })
  //   );
  //   if(res.statusCode == 200){
  //     return json.decode(res.body);
  //   } else {
  //     throw Exception('제출 실패');
  //   }
  // }
  /*
  Map<int, String> answers = 클라이언트가 작성한 원본 데이터가 존재한다.
  Map<int, String> answers = {
                                1: 'A',
                                2: 'A',
                                3: 'B',
                                ...
                             }
  answers.entries = Map을 MapEntry 리스트로 변환한다.
  answers.entries = [
                      MapEntry(key: 1, value='A'),
                      MapEntry(key: 2, value='A'),
                      MapEntry(key: 3, value='B'),
                      ...
                    ]
  .map((en) {return TestAnswer(questionId: en.key, selectedOption: en.value);})
  = 각 MapEntry를 TestAnswer로 변환한다.
  .toList() = 최종 결과로 List 형태를 반환한다.

  MapEntry = Map의 K:V 쌍을 나타내는 객체이다.
  entry의 entries 반복문 형태
  현재 우리가 작성한 백엔드에서 위와 같은 형식을 유지하고 있기 때문에
  만약 TestAnswer와 같은 응답 전용 객체를 Java에서 사용하지 않는다면 entries 작업까지 할 필요 없다.

  Entry : DB 하나의 컬럼에 존재하는 데이터

  사전 한 권 = Map
  사전 각 항목 = Entry
  용어 정의 (apple : 사과) = entry (K:V) => 개체 3개(entry 3개)
  Entries = 모든 entry 항목 종합
            모든 K:V 쌍들

  전화번호부 한 줄 = 이름(key) : 홍길동
  전화번호(value) : 010-1234-5678

    -> entry 1개 = 객체 1개의 데이터
   */
  static Future<Result> submitTest(
    String userName, Map<int, String> answers) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();
    TestRequest request = TestRequest(userName: userName, answers: answerList);
    final res = await http.post(
      Uri.parse('$url${ApiConstants.submit}'),
      headers: {'Content-Type' : 'application/json'},
      body: json.encode(request.toJson())
    );
    if(res.statusCode == 200){
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

// 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}/$typeCode'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }


  /*
  Dart은 변수명 뒤에 하위 변수 또는 하위 기능이 존재하지 않을 경우
  $변수명처럼 {} 없이 작성 가능하다.
  변수명.하위변수명 또는 변수명.하위기능명() 존재할 경우
  ${변수명.하위변수명}
  ${변수명.하위기능명()} 처럼 {} 감싸서 작성한다.
   */
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.results}?userName=$userName'));
    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      // 추후 constants 지정한 에러 타입으로 교체할 것이다.
      // -> 상태 관리하기 편하당
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<Result> getResultById(int id) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.result}/$id'));
    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<void> deleteResult(int id) async {
    final res = await http.delete(Uri.parse('url${ApiConstants.result}/$id'));
    if(res.statusCode != 200) {
      throw Exception("삭제 실패했어영!");
    }
  }

  // 개발 회사 상태 확인용 API
  static Future<String> healthCheck() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.health}'));
    return res.body;
  }

/*
final               res = http.Response 라는 타입으로 자동 지정
final http.Response res =

final               res = 타입 명식을 하지 않아 Dart 에서 자동으로 반환 타입 파악
final String        res = 타입을 명확히 지정
final int           res = 타입을 명확히 지정

final   a = 1; // int 로 자동 타입 확인
개발자가 만든 자료형이나 클래스형 자료형은 필히 타입을 작성해주는 것이 좋음
 */


}


/*
 Map<String, dynamic> jsonData= json.decode(res.body);
 String = 키 명칭들은 문자열로 확정!
 <String   ,     dynamic>
    "id"            1       숫자
   "userName"    "강감찬"    문자열
   "resulType"    "ENFP"     문자열
   "isActive"     true,     불리언
   "createdAt"    null,    null
   "scores"       [2,3,1,..] List

dynamic 대신에 Object 사용하면 안되나요?  ^^ 안돼요.

Object 에는 null 불가능
      └─────── Dart Object 타입은 null 불가능 컴파일에서는 연산 불가 2.1.2 부터 null 사용 금지이고 dynamic 써라
      └─────── Java Object 타입은 null   가능~
dynamic  은 null   가능
      └───────  컴파일에서는 우선 타입이 무엇인지 ???? 상태로 일단 OK
            └─────── 실행하면서 타입이 맞지 않으면 에러 발생
 */


class ModelApiService {
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
  보통 백엔드나 외부 api 데이터를 가져올 때
  자료형으로 Future 특정 자료형을 감싸서 사용한다.
   */
  // static Future<List<dynamic>> getQuestions() async {
  //   final res = await http.get(Uri.parse('$url/questions'));
  //   if(res.statusCode == 200) {
  //     return json.decode(res.body);
  //   } else {
  //     throw Exception('불러오기 실패');
  //   }
  // }
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));
    /*
    http://localhost:8080/api/mbti/questions 접속했을 때 나오는 데이터
    res.body = 백엔드로부터 위 주소에서 전달받은 JSON 문자열 -> 한 줄 문자열로 가져온다.
    json.decode() = 한 줄로 되어있는 JSON 문자열 데이터를 Dart 형식의 객체로 변환해서 사용한다.
    .map((json) => Question.fromJson(json))
      = 변환 시 각 데이터를 하나씩 json 변수명에 담아서 Question 객체로 변환 작업을
        첫 데이터부터 끝 데이터까지 모두 수행한다.
    + .toList() = map으로 출력된 결과를 List 목록 형태로 변환하여 사용한다.
     */
    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('불러오기 실패');
    }
  }

  // 결과 제출하기
  // javaScript + java + c++ + sql
  //
  // static Future<Map<String, dynamic>> submitTest(String userName, Map<int, String> answers) async {
  //   // 어플에서 선택한 답변 결과를 API 형식으로 변환한다.
  //   List<Map<String, dynamic>> answerList = [];
  //   // 어플에서 선택한 질문 번호와 질문 답변을 [{질문1, 답변}, {질문2, 답변}, ...] JSON 형태로 변환하여 저장한다.
  //   answers.forEach((questionId, option) {
  //     answerList.add({
  //       'questionId' : questionId,
  //       'selectedOption' : option
  //     });
  //   });
  //   final res = await http.post(
  //     Uri.parse('$url/submit'),
  //     headers: {'Content-Type' : 'application/json'},
  //     body: json.encode({
  //       'userName' : userName,
  //       'answers' : answerList
  //     })
  //   );
  //   if(res.statusCode == 200){
  //     return json.decode(res.body);
  //   } else {
  //     throw Exception('제출 실패');
  //   }
  // }
  /*
  Map<int, String> answers = 클라이언트가 작성한 원본 데이터가 존재한다.
  Map<int, String> answers = {
                                1: 'A',
                                2: 'A',
                                3: 'B',
                                ...
                             }
  answers.entries = Map을 MapEntry 리스트로 변환한다.
  answers.entries = [
                      MapEntry(key: 1, value='A'),
                      MapEntry(key: 2, value='A'),
                      MapEntry(key: 3, value='B'),
                      ...
                    ]
  .map((en) {return TestAnswer(questionId: en.key, selectedOption: en.value);})
  = 각 MapEntry를 TestAnswer로 변환한다.
  .toList() = 최종 결과로 List 형태를 반환한다.

  MapEntry = Map의 K:V 쌍을 나타내는 객체이다.
  entry의 entries 반복문 형태
  현재 우리가 작성한 백엔드에서 위와 같은 형식을 유지하고 있기 때문에
  만약 TestAnswer와 같은 응답 전용 객체를 Java에서 사용하지 않는다면 entries 작업까지 할 필요 없다.

  Entry : DB 하나의 컬럼에 존재하는 데이터

  사전 한 권 = Map
  사전 각 항목 = Entry
  용어 정의 (apple : 사과) = entry (K:V) => 개체 3개(entry 3개)
  Entries = 모든 entry 항목 종합
            모든 K:V 쌍들

  전화번호부 한 줄 = 이름(key) : 홍길동
  전화번호(value) : 010-1234-5678

    -> entry 1개 = 객체 1개의 데이터
   */
  static Future<Result> submitTest(
      String userName, Map<int, String> answers) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();
    TestRequest request = TestRequest(userName: userName, answers: answerList);
    final res = await http.post(
        Uri.parse('$url/submit'),
        headers: {'Content-Type' : 'application/json'},
        body: json.encode(request.toJson())
    );
    if(res.statusCode == 200){
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception('제출 실패');
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url/types'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception('MBTI 유형 불러오기 실패');
    }
  }

// 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(Uri.parse('$url/types/$typeCode'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception('MBTI 유형 조회 실패');
    }
  }


  /*
  Dart은 변수명 뒤에 하위 변수 또는 하위 기능이 존재하지 않을 경우
  $변수명처럼 {} 없이 작성 가능하다.
  변수명.하위변수명 또는 변수명.하위기능명() 존재할 경우
  ${변수명.하위변수명}
  ${변수명.하위기능명()} 처럼 {} 감싸서 작성한다.
   */
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url/results?userName=$userName'));
    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      // 추후 constants 지정한 에러 타입으로 교체할 것이다.
      // -> 상태 관리하기 편하당
      throw Exception('불러오기 실패');
    }
  }
}


class DynamicApiService {

  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용

  static Future<List<dynamic>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));
    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('불러오기 실패');
    }
  }

  // 결과 제출하기 post
  static Future<Map<String,dynamic>> submitTest(String userName, Map<int, String> answers) async {
    List<Map<String, dynamic>> answerList = [];
    answers.forEach((questionId, option) {
      answerList.add({
        'questionId' : questionId,
        'selectedOption':option
      });
    });
    final res = await http.post(
        Uri.parse('$url/submit'),
        headers: {'Content-Type':'application/json'},
        body: json.encode({
          'userName':userName,
          'answers':answerList
        })
    );
    if(res.statusCode == 200 ){
      return json.decode(res.body);
    } else {
      throw Exception('제출 실패');
    }
  }


}

