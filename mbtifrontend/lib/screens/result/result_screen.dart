import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../models/result_model.dart';
import '../../widgets/score_bar.dart';

/*
result 스크린에서 채팅, 숫자 입력 등 실질적으로 화면 자체에서 변경되는
데이터가 없으므로 statelessWidget 작성 가능하다.

SingleChildScrollView는 화면이 움직이기 때문에 less 사용 불가능하다.
 */

// 로딩중 화면 메세지 없이 추가하기
// 개발자가 운하는 본인 방식대로 추가하도록 한다.
class ResultScreen extends StatefulWidget {
  // final String userName;
  // final String resultType;
  // final int eScore;
  // final int iScore;
  // final int sScore;
  // final int nScore;
  // final int tScore;
  // final int fScore;
  // final int jScore;
  // final int pScore;
  final Result result;


  const ResultScreen({
    super.key,
    // required this.userName,
    // required this.resultType,
    // required this.eScore,
    // required this.iScore,
    // required this.sScore,
    // required this.nScore,
    // required this.tScore,
    // required this.fScore,
    // required this.jScore,
    // required this.pScore,
    required this.result
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = true;

  // 링크 복사 함수
  void _copyResultLink() {
    String shareUrl = 'https://나의도메인주소.com/result/${widget.result.id}';
    Clipboard.setData(ClipboardData(text: shareUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "링크 복사되었습니다.",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
        automaticallyImplyLeading: false,  // 뒤로가기 버튼 숨김
      ),
      body: Center(
        /*
        SingleChildScrollView -> ListView 교체하는 것이 낫다.
         */
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                size: 20,
                color: Colors.amber
              ),
              // SizedBox(height: 30),
              Text(
                  '검사 완료',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 30
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text(
                        "${widget.result.userName}님의 MBTI는",
                        style: TextStyle(fontSize: 20)
                    ),
                    SizedBox(height: 10),
                    Text(
                        widget.result.resultType,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink
                        )
                    ),
                    SizedBox(height: 10),
                    Text(
                        "입니다!",
                        style: TextStyle(fontSize: 20)
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상세 점수'),
                    SizedBox(height: 16,),
                    ScoreBar(
                      label1: 'E (외향)',
                      label2: 'I (내향)',
                      score1: widget.result.eScore,
                      score2: widget.result.iScore,
                    ),
                    ScoreBar(
                      label1: 'S (감각)',
                      label2: 'N (직관)',
                      score1: widget.result.sScore,
                      score2: widget.result.nScore,
                    ),
                    ScoreBar(
                      label1: 'T (사고)',
                      label2: 'F (감정)',
                      score1: widget.result.tScore,
                      score2: widget.result.fScore,
                    ),
                    ScoreBar(
                      label1: 'J (판단)',
                      label2: 'P (인식)',
                      score1: widget.result.jScore,
                      score2: widget.result.pScore,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                  width: 300,
                  height: 50,
                  /*
                  아이콘이나 글자가 child에 위치
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: Text("결과 링크 복사하기",),
                    icon: Icon(Icons.share),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87
                    )

                    글자와 아이콘을 사용하는 버튼 형식
                    ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: Icon(Icons.share),
                      label: Text('결과 링크 복사하기')
                   */
                  /*
                  생성자가 onPressed icon label required,
                  나머지는 this 필수로 작성하지 않아도 되는 생성자
                   */
                  child: ElevatedButton.icon(
                    onPressed: () => _copyResultLink(),
                    label: Text("결과 링크 복사하기"),
                    icon: Icon(Icons.share),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87
                    )
                  )
              ),
              SizedBox(height: 30),
              SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: Text(
                        "처음으로",
                        style: TextStyle(fontSize: 16)
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}