import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vsartist/src/global/functions.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:flutter/services.dart';
import 'package:vsartist/src/global/networks.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:vsartist/src/uploads/upload-common.dart';
import 'package:vsartist/src/uploads/upload-bloc.dart';

class SinglesUpload extends StatefulWidget {
  final int pages;
  final int page;

  ///Current index of track upload
  final String releaseName;
  final UploadSingles uploadSingles;
  SinglesUpload({this.pages, this.page, this.releaseName, this.uploadSingles});
  @override
  _SinglesUploadState createState() => _SinglesUploadState();
}

class _SinglesUploadState extends State<SinglesUpload>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  FormsWidget formsWidget = FormsWidget();
  UploadCommon uploadCommon = UploadCommon();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Music musicUpload = new Music();
  Functions functions = Functions();
  UploadSingles uploadSingles;

  File _image;
  //String progressTitle;
  String _filePath;
  List _states = [], _cities = [], _allCities;
  // static const MethodChannel _channel = const MethodChannel('music_finder');
  // TimeChangeHandler durationHandler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    functions.checkInternet(scaffoldState);
    loadStates();
    uploadSingles = widget.uploadSingles;
  }

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

  _selectGalleryImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
      // String base64Image = base64Encode(_image.readAsBytesSync());
      // String extension = path.extension(_image.path);
      //musicUpload.image =
      //  'data:image/${extension.replaceAll('.', '')};base64,$base64Image';
      musicUpload.image = _image.path;
    });
  }

  void _getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.AUDIO);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      setState(() {
        this._filePath = filePath;
        musicUpload.song = filePath;
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  var streamNumber = [
    '2',
    '3',
    '4',
    '5',
  ];

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

  vibeStateOnChange(newValue) {
    setState(() {
      musicUpload.vibe_state = newValue;
    });
  }

  pushStateOnChange(newValue) {
    setState(() {
      musicUpload.push_state = newValue;
      _cities = _allCities.where((l) => l['state'] == newValue).toList();
      musicUpload.push_city = null;
    });
  }

  pushCityOnChange(newValue) {
    setState(() {
      musicUpload.push_city = newValue;
    });
  }

  onSavedTrackTitle(value) => setState(() {
        musicUpload.title = value;
      });
  onSavedTrackDescription(value) => setState(() {
        musicUpload.description = value;
      });

  onChangeGenre(value) {
    setState(() {
      musicUpload.genre = value;
    });
  }

  onChangeStream(value) {
    setState(() {
      musicUpload.stream = value;
      print('Stream is ${musicUpload.stream}');
    });
  }

  streamNumbers() {
    return streamNumber.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item,
          style: TextStyle(color: Colors.grey),
        ),
        value: item.toString(),
      );
    }).toList();
  }

  Widget uploadCoverImage() {
    return Card(
      color: Colors.grey.shade700,
      child: new SizedBox(
        child: Center(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: _image == null
                  ? Text('No Image Selected',
                      style: TextStyle(color: Colors.white))
                  : Image.file(_image),
            ),
            RawMaterialButton(
              fillColor: Colors.black,
              splashColor: Colors.orange.shade700,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      color: Colors.orange.shade700,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "UPLOAD COVER",
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: _selectGalleryImage,
              shape: const StadiumBorder(),
            ),
            SizedBox(height: 10)
          ]),
        ),
      ),
    );
  }

  Widget uploadTrack() {
    return Card(
      color: Colors.grey.shade700,
      child: new SizedBox(
        height: 90.0,
        child: Center(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.all(7),
              child: Text(
                  musicUpload.song != null
                      ? path.basename(musicUpload.song)
                      : 'Audio file not selected',
                  style: TextStyle(color: Colors.white))),
          RawMaterialButton(
            fillColor: Colors.black,
            splashColor: Colors.orange.shade700,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.audiotrack,
                    color: Colors.orange.shade700,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "UPLOAD TRACK",
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: _getFilePath,
            shape: const StadiumBorder(),
          ),
        ])),
      ),
    );
  }

  submitButton(index, count) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<bool>(
            stream: uploadBloc.showProgress,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data) {
                return new Center(child: CircularProgressIndicator());
                // return Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 8.0, vertical: 20),
                //     child: (index < count)
                //         ? formsWidget.wideButton('NEXT', context, _submit)
                //         : formsWidget.wideButton('UPLOAD', context, _submit));
              } else {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20),
                    child: (index < count)
                        ? formsWidget.wideButton('NEXT', context, _submit)
                        : formsWidget.wideButton('UPLOAD', context, _submit));
              }
            }),
      );

  _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      if (musicUpload.image == null) {
        functions.showSnack('Track banner cannot be empty', scaffoldState);
        return;
      }
      if (musicUpload.genre == null) {
        functions.showSnack('Genre cannot be empty', scaffoldState);
        return;
      }

      if (musicUpload.vibe_state == null) {
        functions.showSnack('State vibes cannot be empty', scaffoldState);
        return;
      }
      if (musicUpload.push_state == null) {
        functions.showSnack('Push state cannot be empty', scaffoldState);
        return;
      }
      if (musicUpload.push_city == null) {
        functions.showSnack('Push city cannot be empty', scaffoldState);
        return;
      }
      if (musicUpload.stream == null) {
        functions.showSnack('Stream cannot be empty', scaffoldState);
        return;
      }
      if (musicUpload.song == null) {
        functions.showSnack('Track file cannot be empty', scaffoldState);
        return;
      }

      musicUpload.release_date = uploadSingles.releaseDate.toString();
      musicUpload.releaseName = uploadSingles.releaseName;

      uploadSingles.tracks[widget.page] = musicUpload;
      if (widget.page + 1 < widget.pages) {
        uploadCommon.singleUploadPage(context, widget.pages, widget.page + 1,
            uploadSingles.releaseName, uploadSingles);
      } else {
        for (var i = 0; i < widget.pages; i++) {
          convertImage(uploadSingles.tracks[i].image, i);
        }
        uploadBloc.uploadSongs(uploadSingles, context);

        uploadBloc.snacksBar.listen((data) async {
          if (data != null) {
            functions.showSnack(data, scaffoldState);
            formsWidget.delayTime(4);
            // if (data.contains('track uploaded')) {

            // }
          }
        });
      }
    }
  }

  void convertImage(image, index) {
    //print('image ebtered again $image');
    if (image == null || image.contains(';')) return;
    image = File(image);
    String base64Image = base64Encode(image.readAsBytesSync());
    String extension = path.extension(image.path);
    extension.replaceAll('.', '');
    setState(() {
      uploadSingles.tracks[index].image = '$extension;$base64Image';
      //print('This is after convertion to base64 ${musicUpload.image}');
    });
  }

  forms() => Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              formsWidget.header('Track Banner'),
                              formsWidget.fieldSpace(),
                              uploadCoverImage(),
                              formsWidget.sectionHeader('Track Release'),
                              formsWidget.fieldSpace(),
                              formsWidget.textInput(
                                  'Track Title', onSavedTrackTitle),
                              formsWidget.fieldSpace(),
                              formsWidget.textAreaInput(
                                  'Track Description', onSavedTrackDescription,
                                  lines: 3),
                              formsWidget.fieldSpace(),
                              formsWidget.dropdownField(
                                  'Genre',
                                  functions.genres(),
                                  musicUpload.genre,
                                  onChangeGenre,
                                  label: 'Genre'),
                              formsWidget.sectionHeader('Track file'),
                              formsWidget.fieldSpace(),
                              uploadTrack(),
                              formsWidget.sectionHeaderTooltip('State Vibes',
                                  'State vibe features a top Music per state.'),
                              formsWidget.fieldSpace(),
                              formsWidget.dropdownField(
                                  'Select State Vibes',
                                  states(),
                                  musicUpload.vibe_state,
                                  vibeStateOnChange,
                                  label: 'State'),
                              formsWidget.sectionHeaderTooltip(
                                  'Delivery/Push Locations',
                                  'Push your songs to individuals in the location.'),
                              formsWidget.fieldSpace(),
                              formsWidget.dropdownField(
                                  'Select Push State',
                                  states(),
                                  musicUpload.push_state,
                                  pushStateOnChange,
                                  label: 'State'),
                              formsWidget.fieldSpace(),
                              formsWidget.dropdownField(
                                  'Select Push City',
                                  cities(),
                                  musicUpload.push_city,
                                  pushCityOnChange,
                                  label: 'Cities'),
                              formsWidget.sectionHeaderTooltip('Stream Count',
                                  'The number of times your song will be available for stream before download. Fans will be paid for each stream.'),
                              formsWidget.fieldSpace(),
                              formsWidget.dropdownField(
                                  'Number of tracks',
                                  streamNumbers(),
                                  musicUpload.stream,
                                  onChangeStream,
                                  label: 'Number of stream'),
                              formsWidget.fieldSpace(),
                              functions
                                  .progressIndicator(networkBloc.sendProgress),
                              submitButton(widget.page + 1, widget.pages),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  body() => SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(padding: EdgeInsets.all(15), child: forms())
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle: '#${widget.page + 1}/${widget.pages} - ${widget.releaseName}',
      bodyData: body(),
      showDrawer: false,
    );
  }
}
