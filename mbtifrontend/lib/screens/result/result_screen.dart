import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String userName;
  final String resultType;
  const ResultScreen({super.key, required this.userName, required this.resultType});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ResultScreen is working'),
      ),
    );
  }
}
