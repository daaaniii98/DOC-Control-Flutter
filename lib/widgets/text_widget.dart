import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String displayText;
  final TEXT_SIZE size;
  final Color textColor;

  const TextWidget(
      {Key? key, required this.displayText, this.size = TEXT_SIZE.SMALL,this.textColor = Colors.black})
      : super(key: key);

  TextStyle? textSizeGet(BuildContext context) {
    if (size == TEXT_SIZE.MEDIUM) {
      return Theme.of(context).textTheme.headline4!.copyWith(
          color: textColor
      );
    } else if (size == TEXT_SIZE.LARGE ) {
      return Theme.of(context).textTheme.headline2!.copyWith(
          color: textColor
      );
    } else if(size == TEXT_SIZE.SMALL){
      return Theme.of(context).textTheme.headline5!.copyWith(
          color: textColor
      );
    }else{
      return Theme.of(context).textTheme.headline6!.copyWith(
        color: textColor,
            fontSize: 17
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        displayText,
        style: textSizeGet(context),
    );
  }
}

enum TEXT_SIZE { VERY_SMALL,SMALL, MEDIUM, LARGE }
