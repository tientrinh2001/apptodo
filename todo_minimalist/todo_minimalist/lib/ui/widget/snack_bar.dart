import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) {
  Flushbar().dismiss();
  Flushbar(
    title: 'notification'.tr(),
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 1),
  ).show(context);
}
