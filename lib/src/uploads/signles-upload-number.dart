import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/uploads/singles-upload.dart';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class SignlesUploadNumber extends StatefulWidget {
  @override
  _SignlesUploadNumberState createState() => _SignlesUploadNumberState();
}

class _SignlesUploadNumberState extends State<SignlesUploadNumber> {
  FormsWidget formsWidget = FormsWidget();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  UploadSingles tracksModel = UploadSingles();

String uploadCount;
  String releaseNameTooltip =
      'This is used to identify the upload of tracks and it is not seen by your listener';
  List<Map<String, dynamic>> _trackList = [
    {'count': '1', 'title': '1 track (Single)'},
    {'count': '2', 'title': '2 track (Single)'},
    {'count': '3', 'title': '3 track (Single)'},
  ];

  var uploadDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    uploadDate = uploadDate.add(Duration(days: 7));
  }

  trackLists() {
    return _trackList.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item['title'],
          style: TextStyle(color: Colors.grey),
        ),
        value: item['count'].toString(),
      );
    }).toList();
  }

  onChange(value) {
    setState(() {
      uploadCount = value;
      print('the selected is ${tracksModel.tracksNumber}');
    });
  }

  onSaved(value) {
    setState(() {
      tracksModel.releaseName = value;
      print('text selected ${tracksModel.releaseName}');
    });
  }

  List<Music> loopExpectedSongs(count) {
    List<Music> data = List();
    for (var i = 0; i < count; i++) {
      data.add(new Music());
    }
    print(data);
    return data;
  }

  _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      if (uploadCount == null ||
          tracksModel.releaseName == null ||
          tracksModel.releaseDate == null) {
        scaffoldState.currentState.showSnackBar(new SnackBar(
            duration: Duration(seconds: 5),
            content: new Text('Fields cannot be empty')));
      } else {
        tracksModel.tracksNumber = int.parse(uploadCount);
        tracksModel.tracks = loopExpectedSongs(tracksModel.tracksNumber);
        print('the first is ${tracksModel.tracksNumber}');
        print('the first is ${tracksModel.releaseName}');
        print('the first is ${tracksModel.releaseDate}');
        print('the first is ${tracksModel.tracks}');

        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new SinglesUpload(
            pages: tracksModel.tracksNumber,
            releaseName: tracksModel.releaseName,
            uploadSingles: tracksModel,
            page:0
          );
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle: 'Number of Tracks',
      bodyData: Center(
        child: Theme(
          data: new ThemeData(primarySwatch: Colors.orange),
          child: new Form(
              key: formKey,
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    formsWidget.sectionHeader('Release details'),
                    SizedBox(height: 15.0),
                    formsWidget.dropdownField('Number of tracks', trackLists(),
                        uploadCount, onChange,
                        label: 'Number of tracks'),
                    SizedBox(height: 20.0),
                    DateTimePickerFormField(
                      
                      inputType: InputType.date,
                      format: DateFormat('yyyy-MM-dd'),
                      firstDate: uploadDate,
                      initialDate: uploadDate,
                      //lastDate: uploadDate,
                      editable: false,
                      decoration:
                          formsWidget.formDecoration('Proposed Release Date'),
                      onChanged: (dt){
                        print(dt);
                          setState(() => tracksModel.releaseDate = dt);
                      }
                    ),
                    SizedBox(height: 20.0),
                    formsWidget.textInput('Release Name', onSaved),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Tooltip(
                            message: releaseNameTooltip,
                            child: Text(
                              releaseNameTooltip,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ))),
                    SizedBox(height: 15.0),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            formsWidget.wideButton('NEXT', context, _submit)),
                  ])),
        ),
      ),
      showDrawer: false,
    );
  }
}
