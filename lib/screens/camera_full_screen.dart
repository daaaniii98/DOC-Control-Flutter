import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/painting.dart';

class ForcePicRefresh extends StatefulWidget {
  final String url;

  /*
  Count-down to display cam-footage (Hack)
  Current count is >=3
   */
  int camPerceptionCount = 0;

  /*
Flag to check if the widget has to display one camera footage or not
   */
  final bool isSingleImg;

  ForcePicRefresh(this.url, this.isSingleImg);

  @override
  _ForcePicRefresh createState() => _ForcePicRefresh();
}

class _ForcePicRefresh extends State<ForcePicRefresh> {
  Widget? _pic;
  var _isLive = false;
  var _isPause = false;
  Uint8List? oldImgBytes;
  int _uniqueId = 1;

  @override
  void initState() {
    // clearCache();
    _isLive = true;
    _updateImgWidget();
    _pic = Image.network(widget.url);
    super.initState();
  }

  Widget _getDisplay(dynamic data, Widget child) {
    _uniqueId++;
    print('Unique_id ${_uniqueId}');
    return Stack(
      key: ValueKey<int>(_uniqueId),
      children: [
        Positioned.fill(child: child),
        if (_isPause)
          Positioned.fill(
            right: 0,
            bottom: 0,
            top: 0,
            left: 0,
            child: Icon(
              Icons.pause_circle_outline,
              color: MyConstants.BLUE_ARTIC_CAM_COLOR,
              size: 100,
            ),
          ),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    _isLive = false;
    print('DISPOSE');
    // clearCache();
    super.dispose();
  }

  void clearCache() {
    imageCache!.clear();
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();
    evictImage();
  }

  void evictImage() {
    final NetworkImage provider = NetworkImage(widget.url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  _updateImgWidget() async {
    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(widget.url)).load(widget.url))
            .buffer
            .asUint8List();
    oldImgBytes = bytes;
    Future.delayed(Duration(seconds: 1), () {
      if (_isLive) {
        print('Widget_Live');
        _updateImgWidget();
      } else {
        print('No Live');
      }
    });

    updateWidgetState(bytes);
  }

  @override
  Widget build(BuildContext context) {
    print('Calling_BUILD PIC == ${_pic == null}');
    widget.camPerceptionCount++;
    return SizedBox(
      height: getHeight(),
      child: GestureDetector(
        child: widget.camPerceptionCount >= 3
            ? AnimatedSwitcher(duration: Duration(seconds: 2), child: _pic,switchInCurve: Curves.ease,switchOutCurve:  Curves.ease,)
            : Center(child: CircularProgressIndicator.adaptive()),
        onTap: () {
          if (widget.camPerceptionCount >= 3) {
            _isPause = !_isPause;
            // print('Is_pause $_isPause');
            // updateWidgetState(null);
            if (mounted) {
              setState(() {
                _pic = _getDisplay(
                  oldImgBytes,
                  Image.memory(
                    oldImgBytes!,
                    // fit: BoxFit.fill,
                  ),
                );
              });
            }
          }
          // _updateImgWidget();
        },
      ),
    );
  }

  void updateWidgetState(Uint8List? bytes) {
    if (_isLive && !_isPause) {
      _pic = _getDisplay(
        bytes,
        Image.memory(
          bytes!,
          // fit: BoxFit.fill,
        ),
      );
      if(mounted) {
        setState(() {});
      }
    }
  }

  getHeight() {
    var height = MediaQuery.of(context).size.height;
    return widget.isSingleImg ? height * 0.25 : height * 0.5;
  }
}
