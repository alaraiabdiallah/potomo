import 'package:flutter/material.dart';

class ThemeBadge extends StatelessWidget {
  final String label;

  const ThemeBadge({Key key, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    Color color() => Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color(), width: 1)
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(label, style: TextStyle(color: color(), fontSize: 10)),
    );
  }
}
