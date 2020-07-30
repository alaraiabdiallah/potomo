import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:potomo/models/sqlite_model.dart';
import 'package:potomo/utils/str.dart';

enum PomodoroState {
  WORK,
  BREAK,
  LONG_BREAK
}

class PomodoroSecond{
  static final WORK = 1500;
  static final BREAK = 300;
  static final LONG_BREAK = 1500;
}


class TimerScreen extends StatefulWidget {
  final Task data;
  final Function onChange;

  const TimerScreen({Key key, this.data, this.onChange}) : super(key: key);
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  PomodoroState _pomoState = PomodoroState.WORK;
  int _round = 0;
  int _seconds;
  int _tick = 0;
  Timer _timer;
  bool _isPause = false;
  bool _isTicking = false;

  _secondToTimerString(int time){
    var hrs = (time / 3600).floor();
    var mins = ((time % 3600) / 60).floor();
    var secs = (time % 60).floor();

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

  _onTimerStop() {
    _isPause = true;
    if(_round > 0){
      switch(_pomoState){
        case PomodoroState.WORK:
          _seconds = _round % 4 == 0? PomodoroSecond.LONG_BREAK : PomodoroSecond.BREAK;
          _pomoState = _round % 4 == 0? PomodoroState.LONG_BREAK :PomodoroState.BREAK;
          break;
        case PomodoroState.BREAK:
          _seconds = PomodoroSecond.WORK;
          _pomoState = PomodoroState.WORK;
          break;
        case PomodoroState.LONG_BREAK:
          _seconds = PomodoroSecond.WORK;
          _pomoState = PomodoroState.WORK;
          break;
      }
    }
    _tick = _seconds;
    _isTicking = false;
  }

  _onTick(Timer timer) {
    if(_tick < 1){
      setState(_onTimerStop);
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
    _seconds = PomodoroSecond.WORK;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _onStartButtonPressed(){
    setState(() {
      _timer.cancel();
      _startTimer();
      _isTicking = true;
      if(_pomoState == PomodoroState.WORK)
        _round += 1;
    });
  }

  _onDone() async{
    widget.data.is_done = widget.data.is_done? false: true;
    await widget.data.save();
    widget.onChange();
    Navigator.of(context).pop();
  }

  _buildActionButton(){
    String startText;
    switch(_pomoState){
      case PomodoroState.WORK:
        startText = Str.START_WORK;
        break;
      case PomodoroState.BREAK:
        startText = Str.START_BREAK;
        break;
      case PomodoroState.LONG_BREAK:
        startText = Str.START_LONG_BREAK;
        break;

    }
    return [
      Row(
        children: <Widget>[
          Expanded(
              child: RaisedButton(
                child: Text(startText, style: TextStyle(color: Colors.white)),
                onPressed: _isTicking?null:_onStartButtonPressed,
                color: Theme.of(context).primaryColor,
              )
          ),
          SizedBox(width: 10,),
          if(_round > 0)...[
            Expanded(
              child: RaisedButton(
                child: Text(Str.DONE, style: TextStyle(color: Colors.white),),
                onPressed: _isTicking?null:_onDone,
                color: Theme.of(context).primaryColor,
              ),
            )
          ]
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var title = Str.TIMER;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Lap ${(_round == 0?_round + 1: _round).toString()} of work",style: Theme.of(context).textTheme.headline5,),
            SizedBox(height: 10,),
            CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width * (3/4),
              lineWidth: 5.0,
              percent: (_tick/_seconds),
              center: Text(_secondToTimerString(_tick), style: TextStyle(
                color: _tick < 1? Colors.grey : Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.headline2.fontSize
              ),),
              progressColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 10,),
            ..._buildActionButton()
          ],
        ),
      )
    );
  }
}
