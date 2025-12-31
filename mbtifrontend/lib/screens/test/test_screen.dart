import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbtifrontend/widgets/error_view.dart';

import '../../models/question_model.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_view.dart';

class TestScreen extends StatefulWidget {
  final String userName;
  const TestScreen({super.key, required this.userName});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // final List<Map<String, String>> questions = [ // 추후 API 교체할 것이다.
  //   {
  //     'text': '친구들과 노는 것이 좋다.',
  //     'optionA': '매우 그렇다.',
  //     'optionB': '그렇지 않다.',
  //   },
  //   {
  //     'text': '계획 세우는 것을 좋아한다.',
  //     'optionA': '매우 그렇다.',
  //     'optionB': '그렇지 않다.',
  //   },
  // ];
  List<Question> questions = [];                 // 백엔드에서 가져온 질문들이 들어갈 배열 목록 세팅한다. dynamic 대신 object 사용 가능!
  int currentQuestion = 0;                      // 현재 질문 번호 (0부터 시작하기 때문에 0으로 설정)
  Map<int, String> answers = {};                // 답변 저장 {질문 번호: 'A', 'B'}
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    // 화면이 보이자마자 세팅할 것인데 백엔드 데이터 질문 가져오기
    super.initState();
    loadQuestions();
  } // 백엔드 데이터를 가지고 올 동안 잠시 대기하는 로딩중

  // 백엔드에서 질문 불러오기
  void loadQuestions() async {
    try {
      final data = await ApiService.getQuestions();
      setState(() {
        questions = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = true;
        errorMessage = "질문을 불러오는데 실패했어영!";
      });;
    }
  }

  void selectAnswer(String option) {
    setState((){
      // answers[currentQuestion] = option;
      answers[questions[currentQuestion].id] = option;

      // if(currentQuestion < 12) {
      if(currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        /*
        결과 화면으로 이동 처리하고, 잠시 결과 화면 보여주는 함수 호출한다.
        screens에 /result/result_screen 명칭으로 폴더와 파일 생성 후,
        main router 설정한 다음 context.go('/result') 이동 처리한다.
        main에서는 builder에 answers 결과까지 함께 전달한다.
         */
        // _showResult();
        submitTest();
      }
    });
  }

  // 백엔드에 결과 저장하기
  void submitTest() async {
    try {
      final result = await ApiService.submitTest(widget.userName, answers);
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(title: Text('검사 완료'),
      //   content: Text(
      //       '${widget.userName}님은 ${result['resultType']}입니다.'
      //   ),
      //   actions: [
      //     TextButton(
      //       onPressed: () => context.go('/'),
      //       child: Text("처음으로")
      //     )
      //   ],
      //   )
      // );
      /*
      mounted : 화면이 존재한다면? 기능
       */
      if(mounted) {
        context.go("/result", extra: {
          'userName': widget.userName,
          'resultType': result.resultType,
          'eScore' : result.eScore,
          'iScore' : result.iScore,
          'sScore' : result.sScore,
          'nScore' : result.nScore,
          'tScore' : result.tScore,
          'fScore' : result.fScore,
          'jScore' : result.jScore,
          'pScore' : result.pScore,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제출 실패했어영!"))
      );
    }
  }

  /*
  결과 화면을 Go_Router 설정할 수 있고,
  함수 호출을 이용하여 임시적으로 결과에 대한 창을 띄울 수 있다.
  _showResult = private 외부에서 사용할 수 없는 함수
   */
  void _showResult(){
    showDialog(context: context,
    builder: (context) => AlertDialog(
      title: Text("검사완료"),
      content: Text(
        "${widget.userName}님의 답변 : \n ${answers.toString()}"
      ),
      actions: [
        TextButton(onPressed: (){
          context.go('/');
        }, child: Text("처음으로"))
      ],
    ));
  }

  /*
  selectAnswer(String option)
  선택한 답변 저장하고, 다음 질문으로 넘어가기
  12문제가 끝나면 결과 화면으로 이동하기

  void showResult(){...}
  결과 확인
  검사 완료 후 검사 결과를 보이고, 처음으로 이동하는 로직 작성하기
   */

  // UI 작성
  @override
  Widget build(BuildContext context) {
    /*
    백엔드에서 데이터를 가져오는 중인 경우의 로딩 화면 불러오기
     */
    if(isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('불러오는 중...')),
        body: LoadingView(message: '질문을 불러오는 중입니다.') // Center(child: CircularProgressIndicator()),
      );
    }

    if(errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("오류 발생")
        ),
        body: ErrorView(
          message: errorMessage!,
          onRetry: loadQuestions
        )
      );
    }
    /*
    임시로 2 문제만 있으므로 인덱스 처리하는 것이며,
    나중에는 삭제할 코드이다.
     */
    int questionIndex = currentQuestion - 1;
    if(questionIndex >= questions.length) {
      questionIndex = questions.length - 1;
    }
    /*
    백엔드에서 가졍온 데이터 중에서 현재 질문에 해당하는 데이터를 변수에 담기
     */
    // var q = questions[currentQuestion];
    Question q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사'),
        leading: IconButton(
            onPressed: ()=>context.go('/'),
            icon: Icon(Icons.arrow_back)
        )
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              진행도
              ${변수명.내부속성명}
              $변수명단독
               */
              Text(
                '질문 ${currentQuestion + 1} / ${questions.length}문제',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 20),
              /*
              진행바
              currentQuestion: 12 => 처음 시작하고 있기 때문에 진행중인 표기
              minHeight: 10 => 최소 유지해야 하는 프로그레스바 세로 크기
               */
              LinearProgressIndicator(
                value: (currentQuestion + 1) / questions.length,
                minHeight: 10,
              ),
              SizedBox(height: 20),
              Text(
                /*
                만약 데이터가 없을 경우에는 질문 없음 표기를 Text 내부에 사용한다.
                questions[questionIndex]['text'] ?? "질문 없음"

                data가 null이 아니고 반드시 존재한다라는 표기를 작성한다.
                questions[questionIndex]['text']!

                questions[questionIndex]['text'] as String,
                 */
                q.questionText ?? "질문 없음",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => selectAnswer('A'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                  ),
                  child: Text(q.optionA,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => selectAnswer('B'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                  ),
                  child: Text(q.optionB,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              ),

              ],
            ))
    );
  }
}