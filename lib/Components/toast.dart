import 'package:flutter/material.dart';
import 'package:recyclify/Constants/fonts.dart';
import 'package:toastification/toastification.dart';

void toast(
  BuildContext context,
  ToastificationType type,
  String title,
  String desc,
) {
  toastification.show(
    context: context,
    type: type,
    autoCloseDuration: const Duration(seconds: 3),
    title: Text(
      title,
      style: TextStyle(fontFamily: font),
    ),
    description: Text(
      desc,
      style: TextStyle(fontFamily: font),
    ),
    alignment: Alignment.bottomCenter,
    showProgressBar: false,
    applyBlurEffect: false,
  );
}
