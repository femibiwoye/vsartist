import 'package:flutter/material.dart';
import 'package:vsartist/src/profile/edit-profile.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/profile/profile-bloc.dart';
import 'package:vsartist/src/profile/profile-model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  ProfileModel data;

  @override
  void initState() {
    super.initState();
    checkInternet();
    profileBloc.fetchProfile(context);
    profileBloc.snacksBar.listen((data) {
      if(data != null){
      _scaffoldState.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 5), content: new Text('$data')));
      }
    });
  }

  checkInternet() async {
    if (await networkBloc.checkInternet() != null) {
      _showSnackBar(await networkBloc.checkInternet());
    }
  }

  void _showSnackBar(String text) {
    if (text != null && text.isNotEmpty)
      _scaffoldState.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
  }

  Widget list(title, value) => ListTile(
        title: new Text(title,
            style: new TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.normal,
              fontSize: 13.0,
              height: 1.0,
            )),
        subtitle: Text(value ?? '',
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 18.0,
              height: 1.5,
            )),
      );
  Widget divider() => new Divider(height: 3.0, color: Colors.grey);

  Widget dataBody(ProfileModel data) => Container(
      //height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            list('Firstname', data.firstname),
            divider(),
            list('Lastname', data.surname),
            divider(),
            list('Othernames', data.othernames),
            divider(),
            list('Phone', data.phone),
            divider(),
            list('Email', data.email),
            divider(),
            list('Username', data.username),
            divider(),
            list('State', data.state),
            divider(),
            list('City', data.city),
          ],
        ),
      ));

  Widget profileHeader(ProfileModel data) => Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.black,
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)),
                    child: CircleAvatar(
                      backgroundColor: UiData.orange,
                      radius: 30.0,
                      backgroundImage:  data.image != null && data.image != ''
                          ? NetworkImage(data.image)
                          : AssetImage(UiData.userPlaceholder),
                    ),
                  ),
                  data.stageName != null
                      ? Text(
                          data.stageName,
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        )
                      : Container(),
                  Text(
                    data.username,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget pageLayout(ProfileModel data) => SingleChildScrollView(
          child: Column(
        children: <Widget>[
          profileHeader(data),
          dataBody(data),
        ],
      ));

  Widget body() => StreamBuilder(
        stream: profileBloc.profile,
        builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data;
            return pageLayout(snapshot.data);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(UiData.orange),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: _scaffoldState,
      appTitle: 'Profile',
      bodyData: body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UiData.orange,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => EditProfile(profile: data)));
        },
      ),
      showDrawer: false,
    );
  }
}
