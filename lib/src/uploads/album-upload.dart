import 'package:flutter/material.dart';
import 'package:vsartist/src/global/functions.dart';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:flutter/services.dart';
import 'package:vsartist/src/global/networks.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:vsartist/src/uploads/upload-common.dart';
import 'package:vsartist/src/uploads/upload-bloc.dart';

class AlbumUpload extends StatefulWidget {
  final int pages;
  final int page;
  final String releaseName;
  final UploadAlbum uploadAlbum;

  AlbumUpload({this.pages, this.page, this.releaseName, this.uploadAlbum});
  @override
  _AlbumUploadState createState() => _AlbumUploadState();
}

class _AlbumUploadState extends State<AlbumUpload>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  FormsWidget formsWidget = FormsWidget();
  Functions functions = Functions();
  UploadCommon uploadCommon = UploadCommon();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Music musicUpload = new Music();
  UploadAlbum uploadAlbum;

  String _filePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    functions.checkInternet(scaffoldState);
    uploadAlbum = widget.uploadAlbum;
  }

  onSavedTrackTitle(value) => setState(() {
        musicUpload.title = value;
      });
  onSavedTrackDescription(value) => setState(() {
        musicUpload.description = value;
      });

  onChangeGenre(value) => setState(() {
        musicUpload.genre = value;
      });

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

      if (musicUpload.genre == null) {
        functions.showSnack('Genre cannot be empty', scaffoldState);
        return;
      }

      if (musicUpload.song == null) {
        functions.showSnack('Track file cannot be empty', scaffoldState);
        return;
      }

      uploadAlbum.tracks[widget.page] = musicUpload;
      if (widget.page + 1 < widget.pages) {
        uploadCommon.albumTrackUploadPage(context, widget.pages,
            widget.page + 1, uploadAlbum.title, uploadAlbum);
      } else {
        convertImage(uploadAlbum.image);

        uploadBloc.uploadAlbum(uploadAlbum, context);

        uploadBloc.snacksBar.listen((data) async {
          if (data != null) {
            functions.showSnack(data, scaffoldState);
            formsWidget.delayTime(3);
          }
        });
      }
    }
  }

  void convertImage(image) {
    if (image == null || image.contains(';')) return;

    image = File(image);
    String base64Image = base64Encode(image.readAsBytesSync());
    String extension = path.extension(image.path);
    extension.replaceAll('.', '');
    setState(() {
      uploadAlbum.image = '$extension;$base64Image';
      print('Image is ${uploadAlbum.image}');
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
                              formsWidget.uploadFile(
                                  musicUpload.song, _getFilePath),
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
