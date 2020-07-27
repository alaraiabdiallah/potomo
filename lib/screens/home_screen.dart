import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potomo/models/sqlite_model.dart';
import 'package:potomo/screens/todo_form_screen.dart';
import 'package:potomo/utils/str.dart';
import 'package:potomo/widgets/potomo_appbar.dart';
import 'package:potomo/widgets/task_card_style1.dart';
import 'package:potomo/widgets/task_card_style2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget _ongoingTask() => Container(
    margin: EdgeInsets.only(bottom: 15),
    height: 137,
    child: ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 25),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        TaskCardStyle1(title: "Design team meeting dawdia", subTitle: "Ongoing", highlight: true,),
        TaskCardStyle1(title: "cuci piring", subTitle: "1 hours later",),
      ],
    ),
  );

  Widget _otherTask() => Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: FutureBuilder(
        future: Task().select().toList(),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot){
          if(snapshot.hasData){
            return GridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              children: snapshot.data.map((e){
                return TaskCardStyle2(
                  title: e.title, 
                  date: e.date, 
                  time: e.time_do_at, 
                  percentage: 0,
                  onTap: (){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TodoFormScreen(task: e,viewMode: true,)));
                  },
                );
              }).toList(),
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text("Load Failed"),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        
      }),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              PotomoAppBar(title: Str.HOME_TITLE, subtitle: Str.HOME_SUBTITLE, subTitlePosition: SubTitlePosition.BELOW,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ongoingTask(),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(Str.OTHER_TASK, style: GoogleFonts.hindVadodara(
                              textStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            )
                          ),),
                          OutlineButton(
                              onPressed: (){},
                              child: Text(Str.MORE),
                              textColor: Colors.red,
                              borderSide: BorderSide(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    _otherTask()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TodoFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
