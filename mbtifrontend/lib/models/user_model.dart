/*
새로운 클래스(UserDTO)를 정의한다.
-> API에서 받은 JSON 데이터를 Dart 객체로 바꿔서 편하게 사용하기 위함이다.
DTO = Data Transfer Object, 즉 "데이터 전달용 객체"라는 뜻이다.

이 클래스가 가질 속성(필드)을 선언한다.
final
  - 한 번 값이 정해지면 절대 바꿀 수 없다 (불변성).
  - DTO는 보통 데이터를 전달만 할 뿐 수정하지 않기 때문에 final을 사용한다.
int? age
  - 물음표(?)는 "null이 될 수 있다"는 뜻이다.
  - API에서 age가 없을 수도 있으니까 null 허용으로 선언한 것이다.
*/
class User {
  final int id;
  final String userName;
  final String? createdAt;  // 선택적 필드 (null 가능)
  final String? lastLogin;  // 선택적 필드 (null 가능)

  /*
  생성자(Constructor)
  이 클래스로 객체를 만들 때 필요한 값을 받는다.
  required
    - id, userName 반드시 넣어야 한다. (null이면 안 됨)
  this.age
    - age는 선택사항이라 required 없이 선언한다.
    - 값 안 주면 null이 된다.
  
  예) User(id: 1, userName: "홍길동")
     User(id: 1, userName: "홍길동", createdAt: "2025.12.25")
  */
  User({
    required this.id,
    required this.userName,
    this.createdAt,
    this.lastLogin,
  });

  // JSON → 객체 (역직렬화)
  /*
  JSON 데이터를 이 클래스의 객체로 변환하여 반환한다. (가장 중요한 부분!)
  factory
    - 일반 생성자와 다르게 객체를 만들어서 돌려줄 수 있는 특별한 생성자이다.
  Map<String, dynamic> json
    - API에서 받은 JSON을 Dart가 해석한 Map 형태로 받는다.
  
  예) {"id": 1, "name": "홍길동", "email": "...", "age": 30}
  
  as int
    - json['id']의 값이 dynamic(어떤 타입인지 모름)이기 때문에 안전하게 int라고 알려준다.
  */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userName: json['userName'] as String,
      createdAt: json['createdAt'] as String?,
      lastLogin: json['lastLogin'] as String?,
    );
  }

  // 객체 → JSON (직렬화)
  /*
  현재 UserDTO 객체를 다시 JSON 형태(Map)로 변환한다.
  서버에 데이터를 보낼 때 (POST/PUT 요청) JSON 형태로 보내야 하기 때문이다.

  final user = UserDTO(id: 1, name: "홍길동", email: "hong@example.com", age: 30);
  final json = user.toJson();
  -> {"id":1, "name":"홍길동", ...} 형태로 다시 변환한다.
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }
}

/*
Dart는 기본적으로 final 필드 + 생성자로 불변성을 권장하지만,
Java처럼 mutable 객체를 만들고 싶다면 setter/getter를 자유롭게 쓸 수 있다.

class UserDTO {
  int _id;      // private 필드 (밑줄 _로 시작)
  String _name;
  String _email;
  int? _age;

  // 기본 생성자 (기본값 설정)
  UserDTO({
    int id = 0,
    String name = '',
    String email = '',
    int? age,
  })  : _id = id,
        _name = name,
        _email = email,
        _age = age;

  // Getter들
  int get id => _id;
  String get name => _name;
  String get email => _email;
  int? get age => _age;

  // Setter들
  set id(int value) {
    if (value <= 0) throw ArgumentError('ID는 1 이상이어야 합니다.');
    _id = value;
  }

  set name(String value) {
    if (value.isEmpty) throw ArgumentError('이름은 비워둘 수 없습니다.');
    _name = value;
  }

  set email(String value) {
    if (!value.contains('@')) throw ArgumentError('올바른 이메일 형식이 아닙니다.');
    _email = value;
  }

  set age(int? value) {
    if (value != null && value < 0) throw ArgumentError('나이는 0 이상이어야 합니다.');
    _age = value;
  }

  // 여전히 JSON 변환은 필요
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'age': _age,
    };
  }
}

===========================================
void main() {
  // 객체 생성
  final user = UserDTO(id: 1, name: '홍길동', email: 'hong@example.com');

  // Getter 사용 (Java와 동일)
  print(user.name);  // 홍길동
  print(user.id);    // 1

  // Setter 사용 (Java와 동일)
  user.name = '김철수';  // setter 호출
  user.age = 25;
  
  print(user.name);  // 김철수
  print(user.age);   // 25

  // 유효성 검사 동작
  // user.id = 0;  // 에러 발생! ArgumentError
}

===========================================
더 간단한 방식

class UserDTO {
  int _id = 0;
  String _name = '';
  String _email = '';
  int? _age;

  // getter만 쓰고 setter는 안 씀 (읽기 전용)
  int get id => _id;
  String get name => _name;

  // setter도 간단히
  set age(int? value) => _age = value;
}
*/
