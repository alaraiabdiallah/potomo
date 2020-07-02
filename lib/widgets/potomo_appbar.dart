import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SubTitlePosition {
  ABOVE,
  BELOW
}

class PotomoAppBar extends StatefulWidget {

  final String title;
  final String subtitle;
  final SubTitlePosition subTitlePosition;

  const PotomoAppBar({Key key, this.title = "", this.subtitle = "", this.subTitlePosition = SubTitlePosition.ABOVE}) : super(key: key);

  @override
  _PotomoAppBarState createState() => _PotomoAppBarState();
}

class _PotomoAppBarState extends State<PotomoAppBar> {

  double _verticalPadd = 15;
  double _horizontalPadd = 25;

  TextStyle _titleTextStyle() => Theme.of(context).textTheme.headline4.copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w600
  );

  TextStyle _subtitleTextStyle() => Theme.of(context).textTheme.headline6;

  Widget _leading() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if(widget.subtitle.isNotEmpty && widget.subTitlePosition == SubTitlePosition.ABOVE)...[
        Text(widget.subtitle, style: GoogleFonts.hindVadodara(textStyle: _subtitleTextStyle()),)
      ],
      Text(widget.title, style: GoogleFonts.hindVadodara(
        textStyle: _titleTextStyle()
      ),),
      if(widget.subtitle.isNotEmpty && widget.subTitlePosition == SubTitlePosition.BELOW)...[
        Text(widget.subtitle, style: GoogleFonts.hindVadodara(textStyle: _subtitleTextStyle()),)
      ],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _verticalPadd, horizontal: _horizontalPadd),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _leading(),
              ),
//              Expanded(
//                child: Container(
//                  alignment: Alignment.centerRight,
//                  child: Text("Text2"),
//                ),
//              )

            ],
          ),
//          Container(
//            decoration: BoxDecoration(
//              color: Colors.grey.withOpacity(0.5),
//            ),
//            margin: EdgeInsets.only(top: 15),
//            width: double.infinity,
//            height: 1,
//          )
        ],
      ),
    );
  }
}
