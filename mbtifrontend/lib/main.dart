import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbtifrontend/common/constants.dart';
import 'package:mbtifrontend/providers/auth_provider.dart';
import 'package:mbtifrontend/screens/history/result_detail_screen.dart';
import 'package:mbtifrontend/screens/home/home_screen.dart';
import 'package:mbtifrontend/screens/login/login_screen.dart';
import 'package:mbtifrontend/screens/result/result_screen.dart';
import 'package:mbtifrontend/screens/signup/signup_screen.dart';
import 'package:mbtifrontend/screens/test/test_screen.dart';
import 'package:mbtifrontend/screens/types/mbti_types_screen.dart';
import 'package:provider/provider.dart';

import 'models/result_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
    initialLocation: '/',        // 앱 처음 켜면 어디로 갈까? → 홈 화면
    routes: [                    // 각 경로별로 어떤 화면 띄울지 정의한다.
      GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen()
      ),
      GoRoute(
          path: '/test',
          builder: (context, state) {                   // /test로 이동할 때 반드시 userName(String)을 extra로 전달해야 한다. -> context.go('/test', extra: '홍길동');
            final userName = state.extra as String;     // 잠시 사용할 이름인데 문자열이에요~ 
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
          builder: (context, state) {          // /result로 갈 때 반드시 Result DTO 객체를 extra로 전달해야 한다. -> context.go('/result', extra: myResultObject);
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

/*
Flutter 앱의 가장 최상위(root) 위젯이다.
*/
class MyApp extends StatelessWidget {

  /*
  앱의 최상위 위젯 이름은 보통 MyApp이라고 짓는다.
  StatelessWidget을 상속 → 이 위젯 자체는 상태(데이터 변화)가 없다. (앱 전체 설정만 할 뿐)
  */
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    google에서 제공하는 기본 커스텀 css를 사용하며 특정 경로를 개발자가 직접 설정하겠다.
     */
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider())
      ],
      child: MaterialApp.router(
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
      )
    );
  }
}
