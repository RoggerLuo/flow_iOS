import 'package:flutter/material.dart';
Widget buildProgressIndicator(bool isPerformingRequest) {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isPerformingRequest ? 1.0 : 0.0,
        child: new CircularProgressIndicator(),
      ),
    ),
  );
}
