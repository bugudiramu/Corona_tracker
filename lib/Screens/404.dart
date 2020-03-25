import 'package:flutter/material.dart';

class Page404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("404", style: Theme.of(context).textTheme.display1),
      ),
    );
  }
}
