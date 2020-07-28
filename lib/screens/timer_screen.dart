import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  int _seconds = 60;
  int _tick = 0;
  Timer _timer;
  bool _isPause = false;

  _secondToTimerString(int time){
    var hrs = (time / 3600).floor();
    var mins = ((time % 3600) / 60).floor();
    var secs = (time % 60).floor();

    // Output like "1:01" or "4:03:59" or "123:03:59"
    var ret = "";
    if (hrs > 0) {
      ret += (hrs < 10 ? "0" : "") + hrs.toString() + ":" + (mins < 10 ? "0" : "");
    }else{
      ret += "00" + ":" + (mins < 10 ? "0" : "");
    }
    ret += "" + mins.toString() + ":" + (secs < 10 ? "0" : "");
    ret += "" + secs.toString();
    return ret;
  }

  _onTick(Timer timer) {
    if(_tick < 1){
      setState(() {
        _isPause = true;
        _tick = _seconds;
      });

      timer.cancel();
    } else{
      setState(() => _tick -= 1);
    }

  }

  _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), _onTick );
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width / 2,
              lineWidth: 4.0,
              percent: (_tick/_seconds),
              center: Text(_secondToTimerString(_tick), style: TextStyle(
                color: _tick < 1? Colors.grey : Theme.of(context).primaryColor,
                fontSize: 32
              ),),
              progressColor: Theme.of(context).primaryColor,
            ),
            RaisedButton(child: Text("Start"), onPressed: (){
              setState(() {
                _tick = 60;
                _timer.cancel();
                _startTimer();
              });
            }),
            RaisedButton(child: Text(_isPause? "Unpause" : "Pause"), onPressed: (){
              if(!_isPause)
                setState((){
                  _isPause = true;
                  _timer.cancel();
                });
              else
                setState((){
                  _isPause = false;
                  _startTimer();
                });
            }),
            RaisedButton(child: Text("Stop"), onPressed: (){
              setState(() {
                _tick = 0;
                _timer.cancel();
              });
            }),
          ],
        ),
      )
    );
  }
}
