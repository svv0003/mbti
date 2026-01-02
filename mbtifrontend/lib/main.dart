import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbtifrontend/common/constants.dart';
import 'package:mbtifrontend/screens/history/result_detail_screen.dart';
import 'package:mbtifrontend/screens/home/home_screen.dart';
import 'package:mbtifrontend/screens/login/login_screen.dart';
import 'package:mbtifrontend/screens/result/result_screen.dart';
import 'package:mbtifrontend/screens/signup/signup_screen.dart';
import 'package:mbtifrontend/screens/test/test_screen.dart';
import 'package:mbtifrontend/screens/types/mbti_types_screen.dart';

import 'models/result_model.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen()
      ),
      GoRoute(
          path: '/test',
          builder: (context, state) {
            final userName = state.extra as String;     // 잠시 사용할 이름인데 문자열이에영~
            /*
            생성된 객체를 사용할 수 있으나 매개변수는 존재하지 않는 상태이다.
            단순히 화면만 보여주는 형태이다.
            const TestScreen({super.key});
             */
            return TestScreen(userName: userName);
          }
      ),
      GoRoute(
          path: '/result',
          builder: (context, state) {
            // final data = state.extra as Map<String, dynamic>;
            // final userName = state.extra as String;
            final result = state.extra as Result;
            // return ResultScreen(
            //   userName: data['userName']!,
            //   resultType: data['resultType']!,
            //   eScore: data['eScore']!,
            //   iScore: data['iScore']!,
            //   sScore: data['sScore']!,
            //   nScore: data['nScore']!,
            //   tScore: data['tScore']!,
            //   fScore: data['fScore']!,
            //   jScore: data['jScore']!,
            //   pScore: data['pScore']!,
            // );

            // return ResultScreen(userName: userName, result: result);
            return ResultScreen(result: result);
          }
      ),
      GoRoute(
          path: '/history',
          builder: (context, state) {
            final userName = state.extra as String;
            // return ResultDetailScreen(userName: state.extra as String);
            //                           required        final userName
            return ResultDetailScreen(userName: userName);
          }
      ),
      GoRoute(
          path: '/types',
          builder: (context, state) => MbtiTypesScreen()
      ),
      GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen()
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupScreen(),
      ),
    ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    google에서 제공하는 기본 커스텀 css를 사용하며 특정 경로를 개발자가 직접 설정하겠다.
     */
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      /*
      경로 설정에 관한 것은 _router 변수명을 참조해라.
       */
      routerConfig: _router,
      /*
      추후 라이트테마, 다크테마 설정할 것이다.
      theme
      darkTheme
      themeMode
      home을 사용할 때는 go_router와 같이 기본 메인 위치를 지정하지 않고,
      home을 기준으로 경로 이동 없이 작성할 때 사용한다.
      home: const HomeScreen();
       */
    );
  }
}