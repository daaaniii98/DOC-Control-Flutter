import 'package:flutter/material.dart';

class TileButtonSimple extends StatelessWidget {
  // const TileButtonSimple({Key? key}) : super(key: key);
  final Function performAction;

  const TileButtonSimple({Key? key, required this.performAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton.icon(
                onPressed: ()=>performAction(),
                icon: Icon(Icons.arrow_forward_ios,size: 14,),
                label: Text('Perform Action')),
    );
  }
}
