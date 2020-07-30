
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:potomo/utils/format.dart';
import 'package:potomo/utils/str.dart';
import 'package:potomo/widgets/checklist_item.dart';

import '../models/sqlite_model.dart';

class TodoFormScreen extends StatefulWidget {
  final Task task;
  final bool viewMode;
  final Function onChange;
  const TodoFormScreen({Key key, this.task, this.viewMode = false, this.onChange}) : super(key: key);
  @override
  _TodoFormScreenState createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  DateTime _todoDate;
  DateTime _todoTimeDoAt;
  TextEditingController _todoDateTxtCtrl = TextEditingController();
  TextEditingController _todoTitleTxtCtrl = TextEditingController();
  TextEditingController _todoDescTxtCtrl = TextEditingController();
  TextEditingController _todoTimeDoAtTxtCtrl = TextEditingController();

  List<Taskchecklist> _checklists = List<Taskchecklist>();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  Task _task;
  FocusNode _editFocus;
  int _editIndex;
  bool _viewMode = false;

  @override
  void initState() {
    _viewMode = widget.viewMode;
    _editFocus = FocusNode();
    _task = widget.task;
    _initFormFieldData();
  }

  @override
  void dispose() {
    _editFocus.dispose();
    super.dispose();
  }

  _loadChecklist(int taskId) async{
    var results = await Taskchecklist().select().tasksId.equals(taskId).toList();
    setState(() {
      _checklists = results;  
    });
  }

  _initFormFieldData() async {
    if(_task != null){
      _todoTitleTxtCtrl.text = _task.title;
      _todoDescTxtCtrl.text = _task.description;
      _loadChecklist(_task.id);
      _todoDateChange(_task.date);
      if(_task.time_do_at != null) _todoTimeChange(_task.time_do_at);
    }else {
      _todoDateChange(DateTime.now());
    }
  }

  _todoDateFormat(DateTime dt) => DateFormat(Format.DATE_FULL).format(dt);
  _todoTimeFormat(DateTime dt) => DateFormat(Format.TIME_SHORT).format(dt);

  _todoDateChange(DateTime dt) {
    if(_todoDate == null) _todoDate = dt;
    String ds = _todoDateFormat(dt);
    _todoDateTxtCtrl.text = ds;
    if(ds == _todoDateFormat(DateTime.now())) _todoDateTxtCtrl.text = "Today";
    _todoDate = dt;
  }

  _todoTimeChange(DateTime dt) {
    if(_todoTimeDoAt == null) _todoTimeDoAt = dt;
    String ds = _todoTimeFormat(dt);
    _todoTimeDoAtTxtCtrl.text = ds;
    _todoTimeDoAt = dt;
  }

  _onDateFieldPressed(){
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: _todoDate,
        maxTime: _todoDate.add(Duration(days: 365)),
        onConfirm: (date) {
            setState(() => _todoDateChange(date));
        }, currentTime: _todoDate, locale: LocaleType.id);
  }

  _onDoAtFieldPressed(){
    DatePicker.showTimePicker(context,
        showTitleActions: true,
        onConfirm: (date) {
          setState(() => _todoTimeChange(date));
        }, currentTime: _todoTimeDoAt, locale: LocaleType.id);
  }

  _onCancelDoAtField(){
    setState(() {
      _todoTimeDoAtTxtCtrl.text = "";
      _todoTimeDoAt = null;  
    }); 
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
            onTap: _viewMode? null : _onDateFieldPressed,
            enabled: !_viewMode,
          ),
          SizedBox(height: 5,),
          TextFormField(
            controller: _todoTitleTxtCtrl,
            decoration: InputDecoration(
                hintText: Str.TITLE_TASK_HINT_INPUT,
                labelText: Str.TITLE_TASK_LABEL_INPUT,
                border: OutlineInputBorder()
            ),
            enabled: !_viewMode,
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
            enabled: !_viewMode,
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _todoTimeDoAtTxtCtrl,
                  decoration: InputDecoration(
                      hintText: Str.TIME_DO_TASK_HINT_INPUT,
                      labelText: Str.TIME_DO_TASK_LABEL_INPUT,
                      border: OutlineInputBorder()
                  ),
                  readOnly: true,
                  onTap: _viewMode? null : _onDoAtFieldPressed,
                  enabled: !_viewMode,
                ),
              ),
              if(_todoTimeDoAtTxtCtrl.text.isNotEmpty)...[
                IconButton(
                  icon: Icon(Icons.cancel), 
                  onPressed: _onCancelDoAtField
                )  
              ]
            ],
          )
          
        ],
      ),
    );
  }

  _onChecklistDelete(int i,Taskchecklist data) async{
    setState(() {
      _editIndex = null;
      _checklists.removeAt(i);
    });
    if(_task != null){
      await data.delete();
    }
  }
  _onCheck(int i,Taskchecklist data) async {
    setState(() {
      _checklists[i] = data;
    });
    if(_viewMode){
      _checklists[i].is_done = data.is_done;
      _checklists[i].save();
    }
  }

  _onSelectCheck(index){
    if(!_viewMode){
      setState(() => _editIndex = index);
      _editFocus.requestFocus();
    } 
  }

  _todoCheckListItem(int index, Taskchecklist data) {
    return ChecklistItem(
      data: data, 
      index: index, 
      editFocus: _editFocus, 
      isEdit: index == _editIndex,
      onSelect: _onSelectCheck,
      onSave: (int i,Taskchecklist data){
        setState(() {
          _editIndex = null;
          _checklists[i] = data;
        });

      },
      onDelete: _onChecklistDelete,
      onCheck: _viewMode? _onCheck : null,
    );
  }

  _todoChecklistWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView(
        children: <Widget>[
            ..._checklists.asMap().map((i,e) => MapEntry(i, _todoCheckListItem(i,e))).values.toList(),
            if(!_viewMode)...[
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: _editIndex != null ? null: (){
                  setState(() {
                    _checklists.add(Taskchecklist(name: ""));
                    _editIndex = _checklists.length - 1;
                    _editFocus.requestFocus();
                  });
                },
                color: Colors.red,
                child: Text(Str.ADD_CHECKLIST, style: TextStyle(color: Colors.white),),
              )
            ]

        ],
      ),
    );
  }

  _onSaveTaskToDB() async{
    Task task = Task(
      title: _todoTitleTxtCtrl.text,
      description: _todoDescTxtCtrl.text,
      date: _todoDate,
      time_do_at: _todoTimeDoAt
    );
    if(_task != null) task.id = _task.id;
    int taskId = await task.save();

    List<Future> concurr = _checklists.map((e){
      e.tasksId = taskId;
      return e;
    })
        .map((e) async => await e.save())
        .toList();

    await Future.wait(concurr);
    
  }

  _onSave() async{
    try {
      await _onSaveTaskToDB();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Str.SUCCESS_SAVE_TASK),));
      Navigator.of(context).pop();
      widget.onChange();
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,));
    }
  }

  _onEdit(){
    setState(() =>_viewMode = false);
  }

  @override
  Widget build(BuildContext context) {
    String title = _viewMode? Str.TASK: Str.ADD_TASK;
    if(!_viewMode && _task != null) title = Str.EDIT_TASK;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: <Widget>[
            if(_viewMode)...[
              IconButton(
                icon: Icon(_task.is_done? Icons.check_box:Icons.check_box_outline_blank, color: Colors.white,),
                onPressed: () async{
                  setState(() {
                    _task.is_done = _task.is_done? false: true;
                  });
                  await _task.save();
                  widget.onChange();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white,),
                onPressed: () async{
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text(Str.ALERT),
                          content: Text(Str.ALERT_DELETE),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(Str.NO),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(Str.YES),
                              onPressed: () async {
                                await _task.delete();
                                widget.onChange();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                  );
                },
              )
            ]
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: Str.TASK,),
              Tab(text: Str.CHECKLIST,),
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
          onPressed: _viewMode? _onEdit : _onSave,
          child: Icon(_viewMode? Icons.edit : Icons.save),
        ),
      ),
    );
  }
}
