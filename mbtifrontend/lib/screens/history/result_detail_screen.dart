import 'package:flutter/material.dart';

class ResultDetailScreen extends StatefulWidget {
  const ResultDetailScreen({super.key});

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreen();
}

class _ResultDetailScreen extends State<ResultDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('result_detail_screen is working'),
      ),
    );
  }
}
