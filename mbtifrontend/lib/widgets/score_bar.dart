import 'package:flutter/material.dart';

/*
위부 파일에서 위젯을 호출할 경우에는
import '../../widgets/score_bar.dart';
형식으로 import 호출하여 사용한다.
*/
class ScoreBar extends StatelessWidget {
  // 변수명만 선언 가능하다.
  /*
  E/I, S/N, T/F, J/P 점수 바를 4번 반복해서 보여줘야 하니까,
  똑같은 코드를 4번 쓰는 대신 한 번만 만들어서 여러 번 불러쓰는 게 훨씬 깔끔하다.
  같은 위젯을 데이터만 바꿔서 재사용하는 것이 Flutter의 위젯 재사용성의 핵심이다.
  
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
  */
  final String label1;
  final String label2;
  final int score1;
  final int score2;
  
  const ScoreBar({
    super.key,
    required this.label1,
    required this.label2,
    required this.score1,
    required this.score2,
  });

  @override
  Widget build(BuildContext context) {
    int total = score1 + score2;
    double ratio1 = total > 0 ? score1 / total : 0.5;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label1: $score1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$label2: $score2',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
              /*
              Row 내부에서는 SizedBox 사용하면 문제 발생한다.
              SizedBox를 사용하고자 한다면 Row를 Column으로 교체한다.
               */
            ],
          ),
          SizedBox(height: 4),
          /*
          ClipRRect : 자식 위젯의 모서리를 둥글게 잘라낸 위젯이다.
           */
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio1,
                minHeight: 20,
                backgroundColor: Colors.orange[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              )
          )
        ],
      )
    );
  }
}
