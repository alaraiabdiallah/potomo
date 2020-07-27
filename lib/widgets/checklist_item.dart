import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/sqlite_model.dart';
import '../models/sqlite_model.dart';

class ChecklistItem extends StatefulWidget {

  final bool isEdit;
  final FocusNode editFocus;
  final Taskchecklist data;
  final int index;
  final Function onCheck;
  final Function onSave;
  final Function onDelete;
  final Function onSelect;
  ChecklistItem({Key key,@required this.index, @required this.data, this.isEdit, this.editFocus, this.onCheck, this.onSave, this.onDelete, this.onSelect});

  @override
  _ChecklistItemState createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<ChecklistItem> {

  TextEditingController editor = TextEditingController();

  Taskchecklist check;

  _setEditorText(){
    check = widget.data;
    editor.text = check.name;
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _setEditorText();  
    });
    
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              readOnly: widget.isEdit == true? false:true,
              focusNode: widget.isEdit? widget.editFocus: null,
              controller: editor,
              onTap: (){
                widget.onSelect(widget.index);
              },
            ),
          ),
          if(widget.isEdit)...[
            IconButton(icon: Icon(Icons.check), color: Colors.green, onPressed: (){
              setState(() => check.name = editor.text);
              widget.onSave(widget.index, check);
            }),
            IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: (){
              widget.onDelete(widget.index, check);
            },)
          ],
          if(!widget.isEdit && widget.onCheck != null)...[
            IconButton(icon: Icon(check.is_done? Icons.check_box : Icons.check_box_outline_blank), onPressed: (){
              setState(() {
                check.is_done = check.is_done? false: true;
                widget.onCheck(widget.index, check);  
              });
            })
          ]
        ],
      ),
    );
  }
  

}