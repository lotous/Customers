import 'package:flutter/material.dart';

class BottomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 100.0,
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            accentColor: Colors.white,
          ),
          child: new CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}