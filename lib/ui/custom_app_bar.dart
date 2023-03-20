import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Status { Updating, Complete, Internet }

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.title, required this.status})
      : super(key: key);
  final String title;
  final Status status;

  @override
  State<StatefulWidget> createState() {
    return _CustomAppBar();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBar extends State<CustomAppBar> {
  late String _statusText;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    switch (widget.status) {
      case Status.Updating:
        _statusText = "Updating";
        break;
      case Status.Complete:
        _statusText = "";
        break;
      case Status.Internet:
        _statusText = "No Connection";
        break;
    }
    return AppBar(
      title: Text(widget.title),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 20.0, top: 22.0),
            child: Text(_statusText)),
      ],
    );
  }
}
