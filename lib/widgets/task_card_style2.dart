import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:potomo/utils/format.dart';
import 'package:potomo/widgets/badges.dart';

class TaskCardStyle2 extends StatelessWidget {

  final int percentage;
  final String title;
  final DateTime date;
  final DateTime time;
  final Function onTap;

  const TaskCardStyle2({Key key, this.percentage = 0, this.title = "", this.date, this.time, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle _titleStyle() => Theme.of(context).textTheme.headline6.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600
    );

    dateFormatted() {
      String d = DateFormat(Format.DATE_SHORT1).format(date);
      String t = time != null ? ", "+DateFormat(Format.TIME_SHORT).format(time):"";
      return d+"th"+t;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
          onTap: onTap,
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
              if(date != null)...[
                ThemeBadge(label: dateFormatted(),)
              ]
              
            ],
          ),
        ),
      ),
    );
  }
}
