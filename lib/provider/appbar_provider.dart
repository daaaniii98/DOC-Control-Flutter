import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyAppbar {
  late Widget _myAppbar;

  Widget get myAppbar => _myAppbar;

  MyAppbar(AppbarBuilder builder) {
    if (Platform.isIOS) {
      _myAppbar = CupertinoNavigationBar(
        automaticallyImplyLeading: builder._automaticallyImplyLeading,
        middle: Text(builder.title!),
        trailing: builder._actions.isNotEmpty == true
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  builder._actionFunctions[0]();
                },
                child: Text(
                  builder._actions[0],
                  style: TextStyle(fontSize: 16),
                ))
            : null,
      );
    } else {
      _myAppbar = AppBar(
          automaticallyImplyLeading: builder._automaticallyImplyLeading,
          title: Text(builder.title!),
          actions: builder._actions.isNotEmpty == true
              ? [
                  TextButton(
                    child: Text(builder._actions[0],style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      builder._actionFunctions[0]();
                    },
                  )
                ]
              : null);
    }
  }
}

class AppbarBuilder {
  List<String> _actions = List.empty(growable: true);
  List<Function> _actionFunctions = List.empty(growable: true);
  String? _title;
  bool _automaticallyImplyLeading = true;

  List<Function> get actionFunctions => _actionFunctions;

  List<String> get actions => _actions;

  String? get title => _title;

  bool get automaticallyImplyLeading => _automaticallyImplyLeading;

  set automaticallyImplyLeading(bool value) {
    _automaticallyImplyLeading = value;
  }

  set actionFunctions(List<Function> value) {
    _actionFunctions = value;
  }

  set actions(List<String> value) {
    _actions = value;
  }

  set title(String? value) {
    _title = value;
  }

  Widget build() {
    return MyAppbar(this).myAppbar;
  }
}
