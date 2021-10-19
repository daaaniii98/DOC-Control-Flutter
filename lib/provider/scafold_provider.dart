import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyScaffold {
  late Widget _myScaffold;

  Widget get myScaffold => _myScaffold;

  MyScaffold(ScaffoldBuilder builder) {
    if (Platform.isIOS) {
      _myScaffold = CupertinoPageScaffold(
        child: builder.body!,
        resizeToAvoidBottomInset: builder.resizeToAvoidBottomInset,
        navigationBar: builder.appBar! as CupertinoNavigationBar,
      );
    } else {
      _myScaffold = Scaffold(
          appBar: builder.appBar! as AppBar, body: builder.body!);
    }
  }
}

class ScaffoldBuilder {
  Widget? _appBar;
  Widget? _body;
  bool _resizeToAvoidBottomInset = true;

  final BuildContext _context;

  ScaffoldBuilder(this._context);

  Widget? get appBar => _appBar;

  Widget? get body => _body;

  bool get resizeToAvoidBottomInset => _resizeToAvoidBottomInset;

  set resizeToAvoidBottomInset(bool value) {
    _resizeToAvoidBottomInset = value;
  }

  set appBar(Widget? value) {
    _appBar = value;
  }

  set body(Widget? value) {
    _body = value;
  }

  Widget build() {
    return MyScaffold(this).myScaffold;
  }
}
