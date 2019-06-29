import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vsartist/src/bloc/change_theme_bloc.dart';
import 'package:vsartist/src/bloc/change_theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/global/shared-data.dart';
import 'package:vsartist/src/dashboard.dart';
import 'package:vsartist/src/profile/profile.dart';
import 'package:vsartist/src/widgets/about_tile.dart';
import 'package:vsartist/src/account/login.dart';

class CommonDrawer extends StatefulWidget {
  @override
  _CommonDrawerState createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  int option;
  final List<Color> colors = [Colors.white, UiData.orange, Colors.black];
  final List<Color> borders = [Colors.black, Colors.white, Colors.white];
  final List<String> themes = ['Light', 'Dark', 'Amoled'];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedData _pref = SharedData();
    //print(await _pref.getAuthUserData());
  }

  TextStyle style = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.black);
  visitorsDrawer(state) => Expanded(
        child: Center(
          child: SingleChildScrollView(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                        backgroundColor: state.themeData.accentColor,
                        radius: 40,
                        child: Icon(
                          Icons.person_outline,
                          size: 40,
                          color: state.themeData.primaryColor,
                        )),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Log In / Sign Up',
                      style: state.themeData.textTheme.body2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget editProfile() => new SizedBox(
      width: 90.0,
      height: 30.0,
      child: OutlineButton(
        child: FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Profile()));
          },
          child: Text(
            'Edit Profile',
            style: TextStyle(
              color: UiData.orange,
              fontSize: 11.0,
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Profile()));
        }, //callback when button is clicked
        borderSide: BorderSide(
          color: UiData.orange, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 2, //width of the border
        ),
      ));

  Widget drawerList(title, {widget, url, web, theme}) => Container(
        height: 45,
        child: ListTile(
          onTap: () {
            Navigator.of(context).pop();
            url != null
                ? Navigator.of(context).pushNamed(url)
                : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return widget;
                    }),
                  );
          },
          title: Text(title, style: theme.textTheme.caption),
        ),
      );

  authDrawer(state) {
    SharedData _pref = SharedData();
    return Expanded(
        child: SingleChildScrollView(
            child: FutureBuilder<String>(
                future: _pref.getAuthUserData(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    var data = jsonDecode(snapshot.data);
                    return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          new Container(
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: AssetImage(UiData.shortBg1drawerbg),
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),

                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: data['image']
                                              .toString()
                                              .contains('http')
                                          ? NetworkImage(data['image'])
                                          : new AssetImage(
                                              UiData.userPlaceholder),
                                    ),
                                    Container(
                                        width: 130,
                                        child: Column(
                                          children: <Widget>[
                                            Text(data['stage_name']?? data['username'],
                                                style: state.themeData.textTheme
                                                    .caption),
                                            Text(data['email'],
                                                style: state.themeData.textTheme
                                                    .caption,
                                                overflow: TextOverflow.ellipsis)
                                          ],
                                        )),
                                    editProfile()
                                  ],
                                ),
                                Divider(height: 40),
                                drawerList('Home',
                                    url: UiData.dashboard,
                                    theme: state.themeData),
                                drawerList('Upload Singles',
                                    url: UiData.signlesUploadInstruction,
                                    theme: state.themeData),
                                drawerList('Upload Album',
                                    url: UiData.albumUploadInstruction,
                                    theme: state.themeData),
                                drawerList('My Music',
                                    url: UiData.myMusic,
                                    theme: state.themeData),
                                drawerList('Wallet',
                                    url: UiData.myBalance,
                                    theme: state.themeData),
                                drawerList('Services',
                                    url: UiData.servicesHome,
                                    theme: state.themeData),
                                Divider(height: 40),
                                ListTile(
                                    onTap: () {
                                      _pref.disposeLogin();
                                      Navigator.of(context)
                                          .popAndPushNamed(UiData.login);
                                    },
                                    title: Text('Logout',
                                        style:
                                            state.themeData.textTheme.caption)),
                                Divider(height: 40),
                              ],
                            ),
                          ),
                          MyAboutTile()
                        ]);
                  } else {
                    return Container(
                      color: Colors.orange,
                    );
                  }
                })));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Theme(
            data: state.themeData,
            child: SafeArea(
                child: Container(
              color: state.themeData.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loginState(state),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Theme',
                          style: state.themeData.textTheme.body2,
                        ),
                      ],
                    ),
                    subtitle: SizedBox(
                      height: 100,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2,
                                                color: borders[index]),
                                            color: colors[index]),
                                      ),
                                    ),
                                    Text(themes[index],
                                        style: state.themeData.textTheme.body2)
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            switch (index) {
                                              case 0:
                                                changeThemeBloc
                                                    .onLightThemeChange();
                                                break;
                                              case 1:
                                                changeThemeBloc
                                                    .onDarkThemeChange();
                                                break;
                                              case 2:
                                                changeThemeBloc
                                                    .onAmoledThemeChange();
                                                break;
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: state.themeData.primaryColor ==
                                                  colors[index]
                                              ? Icon(Icons.done,
                                                  color: state
                                                      .themeData.accentColor)
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                    Text(themes[index],
                                        style: state.themeData.textTheme.body2)
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }

  loginState(state) {
    SharedData _pref = SharedData();

    return FutureBuilder<bool>(
        future: _pref.getisUserLogin(),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data ? authDrawer(state) : visitorsDrawer(state);
        });
  }
}
