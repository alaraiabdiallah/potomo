
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:potomo/utils/str.dart';

class TodoFormScreen extends StatefulWidget {
  @override
  _TodoFormScreenState createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  DateTime _todoDate;
  DateTime _todoTimeDoAt = DateTime.now();
  TextEditingController _todoDateTxtCtrl = TextEditingController();
  TextEditingController _todoTitleTxtCtrl = TextEditingController();
  TextEditingController _todoDescTxtCtrl = TextEditingController();
  TextEditingController _todoTimeDoAtTxtCtrl = TextEditingController();

  List<TextEditingController> _todoChecklist = List<TextEditingController>();

  int editIndex;

  @override
  void initState() {
    var editor = TextEditingController();
    editor.text = "Test";
    _todoChecklist.add(editor);
    _todoChecklist.add(editor);
    _todoDateChange(DateTime.now());
  }

  _todoDateFormat(DateTime dt) => DateFormat("d MMMM y").format(dt);
  _todoTimeFormat(DateTime dt) => DateFormat("HH:mm").format(dt);

  _todoDateChange(DateTime dt) {
    if(_todoDate == null) _todoDate = dt;
    String ds = _todoDateFormat(dt);
    _todoDateTxtCtrl.text = ds;
    if(ds == _todoDateFormat(_todoDate)) _todoDateTxtCtrl.text = "Today";
    _todoDate = dt;
  }

  _todoTimeChange(DateTime dt) {
    if(_todoTimeDoAt == null) _todoTimeDoAt = dt;
    String ds = _todoTimeFormat(dt);
    _todoTimeDoAtTxtCtrl.text = ds;
    _todoTimeDoAt = dt;
  }

  _todoCheckListItem(int index, TextEditingController editor) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              readOnly: index == editIndex? false: true,
              controller: editor,
              onTap: (){
                setState(() => editIndex = index);
                print(editIndex);
              },
            ),
          ),
          if(index == editIndex)...[
            IconButton(icon: Icon(Icons.check), color: Colors.green, onPressed: (){
              setState(() => editIndex = null);
            }),
            IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: (){
              setState(() => editIndex = null);
            },)
          ],
          if(index != editIndex)...[
            IconButton(icon: Icon(Icons.check_box_outline_blank), onPressed: (){
              setState(() => editIndex = null);
            })
          ]
        ],
      ),
    );
  }

  _todoInfoWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _todoDateTxtCtrl,
            decoration: InputDecoration(
                hintText: Str.DATE_TASK_HINT_INPUT,
                labelText: Str.DATE_TASK_LABEL_INPUT,
                border: OutlineInputBorder()
            ),
            readOnly: true,
            onTap: (){
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: _todoDate,
                  maxTime: _todoDate.add(Duration(days: 365)),
                  onConfirm: (date) {
                      setState(() => _todoDateChange(date));
                  }, currentTime: _todoDate, locale: LocaleType.id);
            },
          ),
          SizedBox(height: 5,),
          TextFormField(
            controller: _todoTitleTxtCtrl,
            decoration: InputDecoration(
                hintText: Str.TITLE_TASK_HINT_INPUT,
                labelText: Str.TITLE_TASK_LABEL_INPUT,
                border: OutlineInputBorder()
            ),
          ),
          SizedBox(height: 5,),
          TextFormField(
            controller: _todoDescTxtCtrl,
            decoration: InputDecoration(
                hintText: Str.DESC_TASK_HINT_INPUT,
                labelText: Str.DESC_TASK_LABEL_INPUT,
                border: OutlineInputBorder()
            ),
            maxLines: 8,
          ),
          SizedBox(height: 5,),
          TextFormField(
            controller: _todoTimeDoAtTxtCtrl,
            decoration: InputDecoration(
                hintText: Str.TIME_DO_TASK_HINT_INPUT,
                labelText: Str.TIME_DO_TASK_LABEL_INPUT,
                border: OutlineInputBorder()
            ),
            readOnly: true,
            onTap: (){
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  onConfirm: (date) {
                    setState(() => _todoTimeChange(date));
                  }, currentTime: _todoTimeDoAt, locale: LocaleType.id);
            }
          )
        ],
      ),
    );
  }

  _todoChecklistWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView(
        children: <Widget>[
            ..._todoChecklist.asMap().map((i,e) => MapEntry(i, _todoCheckListItem(i,e)) ).values.toList(),
            RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: (){},
                color: Colors.red,
                child: Text(Str.ADD_CHECKLIST, style: TextStyle(color: Colors.white),),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Task"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: "Task",),
              Tab(text: "Checklist",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _todoInfoWidget(),
            _todoChecklistWidget(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
