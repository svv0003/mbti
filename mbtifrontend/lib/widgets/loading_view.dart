import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  const LoadingView({
    super.key,
    this.message
  });

  @override
  Widget build(BuildContext context) {
    return Center (
      child: Column(
        children: [
          CircularProgressIndicator(),
          if(message != null) ...[
            SizedBox(height: 24),
            Text(
              message!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600]
              ),
            )
          ]
        ],
      )
    );
  }
}
