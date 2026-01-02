import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbtifrontend/services/api_service.dart';

import '../../models/result_model.dart';
import '../../widgets/loading_view.dart';

/*
less 변경 후 ErrorView 추가하기
errorMessage = "검사 기록을 불러오는데 실패했습니다."
 */

class ResultDetailScreen extends StatefulWidget {
  /*
  GoRoute(
    path: '/history',
    builder: (context, state) {
      final userName = state.extra as String;
      // return ResultDetailScreen(userName: state.extra as String);
      //                           required        final userName
      return ResultDetailScreen(userName: userName);
    }
  )
  /history 명칭으로 ResultDetailScreen widget 화면을 보려고 할 때
  메인에서 작성한 명칭의 유저 MBTI 확인하고자 하지만,
  const ResultDetailScreen({super.key}); 와 같이 작성할 경우에는 기본 생성자이며,
  매개변수 데이터를 전달받는 생성자가 아니기 때문에
  main.dart에서 작성한 사용자 이름을 전달받지 못하는 상황이 발생한다.

  Java와 다르게 생성자를 기본생성자, 매개변수생성자 등 다수의 생성자를 만들 경우
  반드시 생성자마다 명칭을 다르게 설정하며, 일반적으로
  클래스명.기본생성자({super.key});
  클래스명.매개변수생성자({super.key, required this 전달받아사용할변수명});
  으로 작성한다.
   */
  final String userName;
  const ResultDetailScreen({super.key, required this.userName});

  // 화면 상태와 화면에서 상태 변경을 위한 위젯을 구분하여 만든 후 사용한다.
  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  // 변수, 기능 선언
  List<Result> results = [];
  bool isLoading = true;


  // 기본적으로 초기 상태를 생성하며, 추가적으로 호출할 기능을 함께 작성하기 위해 재사용한다.
  @override
  void initState() {
    super.initState();
    loadResults();
  }

  void loadResults() async {
    /*
    data 변수에 담은 다음에 results 변수에 담는 것을 권장한다.
    왜?
    results = await DynamicApiService.getResultsByUserName(widget.userName);
    처럼 작성하면 둘 다 ing 진행중인 상태라 꼬일 수 있는 문제 발생 가능성이 있다.
     */
    try{
      final data = await ApiService.getResultsByUserName(widget.userName);
      setState(() {
        results = data;
        isLoading = false;
      });
    } catch(e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("결과를 불러오지 못했습니다."))
      );
    }
  }


  // ui 작성
  // 상태 변경 필요한 변수 사용
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사 기록'),
        leading: IconButton(onPressed: () => context.go('/'),
        icon: Icon(Icons.arrow_back)),
      ),
      body: isLoading
        ? LoadingView(message: '유형을 불러오는 중입니다.')    // Center(child: CircularProgressIndicator())
      : results.isEmpty
        ? Center(
        child: Text(
          "검사 기록이 없습니다.",
          style: TextStyle(fontSize: 18),
        )
      )
        : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final res = results[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                      res.resultType,
                      style: TextStyle(color: Colors.white)
                  ),
                ),
                title: Text(
                  res.resultType,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                  'E:${res.eScore} I:${res.iScore} S:${res.sScore} N:${res.nScore}\n'
                      'T:${res.tScore} F:${res.fScore} J:${res.jScore} P:${res.pScore}'
                ),
                // 클릭 시 보이는 아이콘
                trailing: Icon(Icons.arrow_forward_ios),
                // 한 줄의 어떤 곳을 클릭하더라도 세부 정보 확인할 수 있는 모달 띄이기
                // 공유하기와 같은 세부 기능을 넣을 수도 있지만 되도록이면 위젯으로 따로 생성 후 기능 설정하는 것이 깔끔하다.
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(res.resultType),
                      content: Text(
                          '${res.typeName ?? res.resultType} \n\n'
                              ' ${res.description ?? "정보없음"}'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("닫기")
                        )
                      ],
                    )
                  );
                },
              ),
            );
          },
        )
          /*
          ListView(
            children: [
              Text('ABCD'),
              Text('EFGH'),
              Text('IJKL'),
              Text('MNOP'),
            ]
          )
          개발자가 하나하나 직접 목록을 작성할 경우 사용하는 방식
          -> 목차, 목록, 네비게이션

          개발자가 DB에서 데이터를 동적으로 가져와서 표현할 때는
          ListView.builder(
            itemCount: 총개수,
            itemBuilder: (context, index) {
              return Text('항목 $index)
            }
          )
          ListView.builder는 itemCount가 없으면
          내부 목록리스트 개수를 예상 못해서 RangeError 발생한다.
           */
    );
  }
}
