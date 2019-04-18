import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';

class EditorWidget extends StatefulWidget {
  final String json;
  final String title;

  EditorWidget({this.json, this.title});
  @override
  EditorWidgetState createState() => EditorWidgetState();
}

class EditorWidgetState extends State<EditorWidget> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Create an empty document or load existing if you have one.
    // Here we create an empty document:
    var document = new NotusDocument();
    if (widget.json != null) {
      try {
        var _json = json.decode(widget.json);
        document = NotusDocument.fromJson(_json);
      } catch (e) {
        print('Error Parsing JSON: $e');
        try {
          document.insert(0, widget.json);
        } catch (exp) {
          print('Error Inserting into Document: $exp');
        }
      }
    }
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              NotusDocument _data = _controller.document;
              print(json.encode(_data.toPlainText()));
              Navigator.pop(context, json.encode(_data.toPlainText()));
            },
          ),
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
