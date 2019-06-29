import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vsartist/src/global/functions.dart';
import 'package:vsartist/src/profile/profile.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/profile/profile-bloc.dart';
import 'package:vsartist/src/profile/profile-model.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  final ProfileModel profile;
  EditProfile({this.profile});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Functions functions = Functions();

  FormsWidget formsWidget = FormsWidget();
  File _image;
  ProfileModel profile;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
    loadStates();
  }

  List _states = [], _cities = [], _allCities;

  Future<String> loadStates() async {
    String states = await rootBundle.loadString('assets/datas/states.json');
    String cities =
        await rootBundle.loadString('assets/datas/local_governments.json');

    setState(() {
      _states = json.decode(states);
      _cities = json.decode(cities);
      _allCities = _cities;
    });
  }

  states() {
    return _states.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item['name'],
          style: TextStyle(color: Colors.grey),
        ),
        value: item['alias'].toString(),
      );
    }).toList();
  }

  cities() {
    return _cities.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item['name'],
          style: TextStyle(color: Colors.grey),
        ),
        value: item['alias'].toString(),
      );
    }).toList();
  }

  pushStateOnChange(newValue) {
    setState(() {
      profile.state = newValue;
      _cities = _allCities.where((l) => l['state'] == newValue).toList();
      profile.city = null;
    });
  }

  pushCityOnChange(newValue) {
    setState(() {
      profile.city = newValue;
    });
  }

  Widget imageUpload(ProfileModel data) {
    return Center(
      child: new SizedBox(
        child: Center(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: _image == null
                    ? data.image != null
                        ? NetworkImage(data.image)
                        : AssetImage(UiData.userPlaceholder)
                    : FileImage(_image),
              ),
            ),
            new SizedBox(
                width: 120.0,
                height: 35.0,
                child: OutlineButton(
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: _selectGalleryImage,
                    child: Text(
                      'Pick Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: BorderSide(
                    color: UiData.orange, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 2, //width of the border
                  ),
                )),
          ]),
        ),
      ),
    );
  }

  forms() => Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  imageUpload(profile),
                  new Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new TextFormField(
                          onSaved: (val) => profile.stageName = val,
                          style: TextStyle(color: Colors.black),
                          initialValue: profile.stageName,
                          validator: (val) {
                            return val.length < 1
                                ? "Stage Name Cannot be empty"
                                : null;
                          },
                          decoration: formsWidget.formDecoration('Stage Name'),
                        ),
                        SizedBox(height: 15),
                        new TextFormField(
                          onSaved: (val) => profile.surname = val,
                          style: TextStyle(color: Colors.black),
                          initialValue: profile.surname,
                          validator: (val) {
                            return val.length < 1
                                ? "Surname Cannot be empty"
                                : null;
                          },
                          decoration: formsWidget.formDecoration('Surname'),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          onSaved: (val) => profile.firstname = val,
                          style: TextStyle(color: Colors.black),
                          initialValue: profile.firstname,
                          validator: (val) {
                            return val.length < 1
                                ? "Firstname Cannot be empty"
                                : null;
                          },
                          decoration: formsWidget.formDecoration('Firstname'),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          onSaved: (val) => profile.othernames = val,
                          style: TextStyle(color: Colors.black),
                          initialValue: profile.othernames,
                          decoration: formsWidget.formDecoration('Othernames'),
                        ),
                        SizedBox(height: 15),
                        new TextFormField(
                          keyboardType: TextInputType.phone,
                          onSaved: (val) => profile.phone = val,
                          style: TextStyle(color: Colors.black),
                          initialValue: profile.phone,
                          validator: (val) {
                            return val.length < 1
                                ? "Phone Cannot be empty"
                                : null;
                          },
                          decoration:
                              formsWidget.formDecoration('Phone Number'),
                        ),
                        SizedBox(height: 15),
                        formsWidget.dropdownField('Select Push State', states(),
                            profile.state, pushStateOnChange,
                            label: 'State'),
                        formsWidget.fieldSpace(),
                        formsWidget.dropdownField('Select Push City', cities(),
                            profile.city, pushCityOnChange,
                            label: 'Cities'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            signupButton(),
          ],
        ),
      );

  signupButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<bool>(
          stream: profileBloc.showProgress,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data) {
              return new Center(child: CircularProgressIndicator());
              // return Padding(
              //     padding: const EdgeInsets.only(top: 50.0),
              //     child: formsWidget.wideButton('Update', context, _continue));
            } else {
              return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: formsWidget.wideButton('Update', context, _continue));
            }
          }),
    );
  }

  Widget formLoyout() => SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[forms()],
      ));

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: _scaffoldState,
      appTitle: 'Edit Profile',
      leading: new IconButton(
        icon: new Icon(
          Icons.chevron_left,
          size: 40,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new Profile()),
          );
        },
      ),
      bodyData: Padding(padding: EdgeInsets.all(20), child: formLoyout()),
      showDrawer: false,
    );
  }

  void _continue() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      if (profile.state == null) {
        functions.showSnack('State cannot be empty', _scaffoldState);
        return;
      }
      if (profile.city == null) {
        functions.showSnack('City cannot be empty', _scaffoldState);
        return;
      }

      profileBloc.postProfile(profile);
      profileBloc.snacksBar.listen((data) {
        if(data!= null){
        _scaffoldState.currentState.showSnackBar(new SnackBar(
            duration: Duration(seconds: 5), content: new Text('$data')));
        }
      });
    }
  }

  _selectGalleryImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = imageFile;
      String base64Image = base64Encode(_image.readAsBytesSync());
      String extension = path.extension(_image.path);
      profile.image = '$extension;$base64Image';
    });
  }
}
