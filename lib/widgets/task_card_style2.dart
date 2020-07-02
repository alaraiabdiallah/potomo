import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:potomo/widgets/badges.dart';

class TaskCardStyle2 extends StatelessWidget {

  final int percentage;
  final String title;
  final String dateString;

  const TaskCardStyle2({Key key, this.percentage = 0, this.title = "", this.dateString}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle _titleStyle() => Theme.of(context).textTheme.headline6.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircularPercentIndicator(
              radius: 45.0,
              lineWidth: 4.0,
              percent: (percentage/100),
              center: Text("${percentage.toString()}%"),
              progressColor: Theme.of(context).primaryColor,
            ),
            Expanded(child: Container(),),
            Text(title, style: _titleStyle(), maxLines: 3, overflow: TextOverflow.ellipsis,),
            Expanded(child: Container(),),
            ThemeBadge(label: dateString,)
          ],
        ),
      ),
    );
  }
}
