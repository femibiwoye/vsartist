import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
        body: Container(color: Colors.deepPurpleAccent,)
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    } else
      return showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('music player will be stopped..'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(
                    'No',
                  ),
                ),
                new FlatButton(
                  onPressed: () {
                    //MyQueue.player.stop();
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
  }
}
