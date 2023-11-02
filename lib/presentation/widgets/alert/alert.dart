import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

showAlert(BuildContext context, String title, String subTitle) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subTitle),
              actions: <Widget>[
                MaterialButton(
                    onPressed: (() => Navigator.pop(context)),
                    elevation: 5,
                    textColor: Colors.blue,
                    child: const Text('Ok'))
              ],
            ));
  }

  if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(subTitle),
              actions: <Widget>[
                CupertinoDialogAction(
                    onPressed: (() => Navigator.pop(context)),
                    isDefaultAction: true,
                    child: const Text('Ok'))
              ],
            ));
  }
}
