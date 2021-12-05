import 'package:flutter/material.dart';

navigateAndReplacement(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}
