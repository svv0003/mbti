class Question {
  final int id;
  final int questionNumber;
  final String questionText;
  final String dimension;
  final String optionA;
  final String optionB;
  final String optionAType;
  final String optionBType;

  Question({
    required this.id,
    required this.questionNumber,
    required this.questionText,
    required this.dimension,
    required this.optionA,
    required this.optionB,
    required this.optionAType,
    required this.optionBType,
  });

  /*
  생성자 내부에 try-catch문 사용하는 이유는
  JSON 파싱 실패를 조기에 발견하고 디버깅하기 쉽게 만들기 위함이다.
  JSON → Dart 객체 변환(fromJson)은 항상 안전하지 않다.
  서버에서 예상치 못한 데이터가 오면 앱이 바로 크래시(죽음)할 수 있다.
  try-catch를 넣음으로써 이런 문제를 방지하고, 문제 원인을 정확히 알 수 있게 해준다.

  예)
  키가 없을 때
  예: 서버에서 questionText 키를 빼먹고 보냄
  → json['questionText'] → null
  → as String → 에러 발생!
  타입이 다를 때
  예: id가 숫자 대신 문자열 "1"로 옴
  → json['id'] as int → 타입 캐스팅 에러!
  null 값이 들어올 때
  예: optionA가 null로 옴 (String?가 아니고 String이라면 에러)
  서버 버전 변경
  백엔드가 업데이트되면서 JSON 구조가 바뀜
  → 기존 코드가 갑자기 깨짐

  이런 상황에서 try-catch 없이 그냥 쓰면 앱이 화면에서 바로 크래시되고, 에러 메시지도 모호하지만
  
  try-catch 사용하면
  앱이 바로 죽지 않음
  → 상위 코드에서 이 에러를 catch해서 대체 처리 가능 (예: 에러 화면 표시)
  에러 메시지가 매우 상세함
  → $e : 어떤 종류의 에러인지 (TypeError, NoSuchMethodError 등)
  → $json : 문제의 원인인 실제 JSON 데이터 전체를 출력함
  디버깅이 훨씬 쉬워짐
  특히 팀으로 개발하거나, 나중에 유지보수할 때 유용함
  */
  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      return Question(
        id: json['id'] as int,
        questionNumber: json['questionNumber'] as int,
        questionText: json['questionText'] as String,
        dimension: json['dimension'] as String,
        optionA: json['optionA'] as String,
        optionB: json['optionB'] as String,
        optionAType: json['optionAType'] as String,
        optionBType: json['optionBType'] as String,
      );
    } catch (e) {
      throw Exception('Question.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'questionText': questionText,
      'dimension': dimension,
      'optionA': optionA,
      'optionB': optionB,
      'optionAType': optionAType,
      'optionBType': optionBType,
    };
  }
}
