import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatelessWidget {
  // const NetworkErrorWidget({Key? key}) : super(key: key);
  final Function retryFunction;

  const NetworkErrorWidget({Key? key, required this.retryFunction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Theme.of(context).errorColor,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Network Error",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ElevatedButton(
              onPressed: ()=>retryFunction(),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.wifi_protected_setup_sharp,
                    color: Colors.white,
                  ),
                  Text("Retry")
                ],
              ))
        ],
      ),
    );
  }
}
