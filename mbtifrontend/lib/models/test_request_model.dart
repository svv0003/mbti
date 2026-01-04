import 'answer_model.dart';

class TestRequest {
  final String userName;
  final List<TestAnswer> answers;  // 10개의 답변 객체가 들어있는 리스트
                                    /*
                                    TestAnswer 객체는 자신만의 toJson() 메서드를 가지고 있다.
                                    예) { "questionId": 1, "selectedOption": "A" }

                                    서버에 보낼 때는 최종 JSON이 이렇게 돼야 한다.
                                    {
                                      "userName": "홍길동",
                                      "answers": [
                                        { "questionId": 1, "selectedOption": "A" },
                                        { "questionId": 2, "selectedOption": "B" },
                                        { "questionId": 3, "selectedOption": "A" },
                                        ...
                                      ]
                                    }

                                    그래서 사용하는 코드가 'answers': answers.map((a) => a.toJson()).toList() 이다.

                                    answers
                                    → 원래 리스트: [TestAnswer1, TestAnswer2, TestAnswer3, ...]

                                    .map((a) => a.toJson())
                                    → 리스트의 각 요소(a) 에 대해 toJson()을 호출해서
                                    → 새로운 리스트를 만듦: [json1, json2, json3, ...]
                                    (여기서 json1은 Map<String, dynamic> 형태)
                                    a는 리스트 안의 각 TestAnswer 객체를 의미해요.
                                    a.toJson() → 그 객체를 JSON(Map)으로 변환

                                    .toList()
                                    → map()은 엄밀히 말하면 Iterable을 반환해요.
                                    → JSON으로 보내려면 진짜 List가 필요하니까 .toList()로 변환!
                                    */

  TestRequest({
    required this.userName,
    required this.answers,
  });

  /*
  toJson() 메서드
    - 이 객체를 서버에 보낼 때 JSON 형태로 변환한다.
    - 특히 answers 리스트는 각 답변 객체의 toJson()을 호출해서 변환한다.

  answers.map((a) => a.toJson()).toList()
    - 리스트(배열) 안에 여러 객체가 있을 때 각 객체를 JSON으로 바꿔서 다시 리스트로 만드는 방법
  */
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  factory TestRequest.fromJson(Map<String, dynamic> json) {
    return TestRequest(
      userName: json['userName'],
      answers: (json['answers'] as List)
          .map((a) => TestAnswer.fromJson(a))
          .toList(),
    );
  }
}
