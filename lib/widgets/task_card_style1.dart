import 'package:flutter/material.dart';

import '../utils/str.dart';

class TaskCardStyle1 extends StatelessWidget {

  final bool highlight;
  final String subTitle;
  final String title;
  final Function onTap;
  final Function onTimerPressed;
  final Function onDonePressed;

  const TaskCardStyle1({Key key, this.highlight = false, this.subTitle = "", this.title = "", this.onTap, this.onTimerPressed, this.onDonePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color _backgroundColor() => highlight ? Colors.red.withOpacity(0.8) : Colors.grey.withOpacity(0.5);
    Color _defaultTextColor() => highlight ? Colors.white : Colors.black;
    TextStyle _titleStyle() => Theme.of(context).textTheme.headline6.copyWith(
        color: _defaultTextColor(),
        fontWeight: FontWeight.w600
    );

    TextStyle _subTitleStyle() => TextStyle(
        color: _defaultTextColor(),
    );

    return Container(
      width: 250,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(subTitle, style: _subTitleStyle(),),
                      SizedBox(height: 3,),
                      Text(title, style: _titleStyle(), maxLines: 2, overflow: TextOverflow.ellipsis)
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: onTimerPressed,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.timer, color: _defaultTextColor(),),
                      SizedBox(width: 5,),
                      Text(Str.TIMER, style: TextStyle(color: _defaultTextColor()),)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDonePressed,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.check, color: _defaultTextColor(),),
                      SizedBox(width: 5,),
                      Text(Str.DONE, style: TextStyle(color: _defaultTextColor()),),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
