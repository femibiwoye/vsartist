import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/bloc/change_theme_bloc.dart';
import 'package:vsartist/src/bloc/change_theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vsartist/src/widgets/drawer.dart';
//import 'package:vsartist/src/widgets/common_drawer.dart';

class ScaffoldCommon extends StatelessWidget {
  final String appTitle;
  final Widget bodyData;
  final Widget floatingActionButton;
  final dynamic leading;
  final dynamic scaffoldState;
  final elevation;
  final backGroundColor;
  final showDrawer;
  
  ScaffoldCommon(
      {this.appTitle,
      this.bodyData,
      this.scaffoldState,
      this.leading,
      this.floatingActionButton,
      this.elevation = 4.0,
      this.backGroundColor,
      this.showDrawer});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Scaffold(
              key: scaffoldState,
              appBar: new AppBar(
                elevation: elevation,
                leading: leading,
                iconTheme: state.themeData.iconTheme,
                title: Text(
                  appTitle,
                  style: state.themeData.textTheme.headline,
                ),
                backgroundColor: state.themeData.primaryColor,
              ),
              drawer: showDrawer ? CommonDrawer() : null,
              backgroundColor: state.themeData.backgroundColor,
              body: bodyData,
              floatingActionButton: floatingActionButton);
        });
  }
}
