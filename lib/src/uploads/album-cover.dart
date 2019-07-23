import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/uploads/album-upload.dart';
import 'package:vsartist/src/uploads/singles-upload.dart';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AlbumCover extends StatefulWidget {
  @override
  _AlbumCoverState createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<AlbumCover> {
  FormsWidget formsWidget = FormsWidget();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  UploadAlbum tracksModel = UploadAlbum();

  String uploadCount;
  List _trackList = [];
  File _image;

  var uploadDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrackNumber(4, 15);
    uploadDate = uploadDate.add(Duration(days: 7));
  }

  getTrackNumber(start, end) {
    setState(() {
      for (int i = start; i <= end; i++) _trackList.add(i);
    });
  }

  trackLists() {
    return _trackList.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          '${item.toString()} tracks',
          style: TextStyle(color: Colors.white),
        ),
        value: item.toString(),
      );
    }).toList();
  }

  selectGalleryImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
      tracksModel.image = _image.path;
    });
  }

  onChange(value) {
    setState(() {
      uploadCount = value;
    });
  }

  onSavedTitle(value) => setState(() {
        tracksModel.title = value;
      });

  onSavedDescription(value) => setState(() {
        tracksModel.description = value;
      });

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
          tracksModel.title == null ||
          tracksModel.description == null ||
          tracksModel.releaseDate == null ||
          tracksModel.image == null) {
        scaffoldState.currentState.showSnackBar(new SnackBar(
            duration: Duration(seconds: 5),
            content: new Text('Fields cannot be empty')));
      } else {
        tracksModel.trackCount = int.parse(uploadCount);
        tracksModel.tracks = loopExpectedSongs(tracksModel.trackCount);

        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new AlbumUpload(
              pages: tracksModel.trackCount,
              releaseName: tracksModel.title,
              uploadAlbum: tracksModel,
              page: 0);
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle: 'Album Cover',
      bodyData: Center(
        child: Theme(
          data: new ThemeData(primarySwatch: Colors.orange),
          child: new Form(
              key: formKey,
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    formsWidget.header('Album Banner'),
                    formsWidget.fieldSpace(),
                    formsWidget.imageInput('Upload Cover',_image, selectGalleryImage),
                    
                    formsWidget.sectionHeader('Album details'),
                    formsWidget.fieldSpace(),
                    formsWidget.textInput('Album title', onSavedTitle),
                    //formsWidget.fieldSpace(),
                    formsWidget.textAreaInput('Album description', onSavedDescription),
                    //formsWidget.fieldSpace(),
                    formsWidget.dropdownField(
                        'Number of tracks', trackLists(), uploadCount, onChange,
                        label: 'Number of tracks'),
                    //SizedBox(height: 20.0),
                    DateTimePickerFormField(
                        inputType: InputType.date,
                        style: TextStyle(color: Colors.white),
                        format: DateFormat('yyyy-MM-dd'),
                        firstDate: uploadDate,
                        initialDate: uploadDate,
                        editable: false,
                        decoration:
                            formsWidget.formDecoration('Proposed Release Date'),
                        onChanged: (dt) {
                          print(dt);
                          setState(() => tracksModel.releaseDate = dt);
                        }),
                    
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
