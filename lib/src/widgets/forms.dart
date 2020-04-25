import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vsartist/src/global/uidata.dart';
import 'package:path/path.dart' as path;

class FormsWidget {
  inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.elliptical(0, 0)),
      //borderRadius: BorderRadius.all(Radius.circular(22.0)),
      borderSide: const BorderSide(color: Colors.white, width: 0.0),
    );
  }

  formDecoration(title, {icon}) {
    return InputDecoration(
      focusedBorder: inputBorder(),
      errorBorder: inputBorder(),
      hintText: title,
      prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
      hintStyle: new TextStyle(color: Colors.white),
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      fillColor: Colors.transparent,
      enabledBorder: inputBorder(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
    );
  }

  dropdownDecoration(title, {icon, surfix}) {
    return InputDecoration(
      hintText: title,
      filled: true,
      fillColor: Colors.transparent,
      prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
      suffixIcon: surfix != null ? Icon(surfix, color: Colors.white) : null,
      hintStyle: new TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: inputBorder(),
      errorBorder: inputBorder(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }

  linearProgressBar(value) {
    return LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.orange.shade700,
        ));
  }

  delayTime(delay) async {
    //await new Future.delayed(Duration(seconds: delay));
    sleep(Duration(seconds: delay));
  }

  appIcon() {
    return new Container(
      child: new Image(
        image: new AssetImage("assets/images/vibe-logo-on-black.png"),
        height: 100.0,
        width: 100.0,
      ),
      margin: EdgeInsets.symmetric(vertical: 40.0),
    );
  }

  dropdownField(hint, items, value, onChange, {prefix, label}) {
    return Container(
      child: DropdownButtonHideUnderline(
        child: Theme(
            data: ThemeData.dark(),
            child: DropdownButtonFormField<String>(
              decoration: dropdownDecoration(hint, icon: prefix),
              validator: (val) {
                return val == null ? "$hint Cannot be empty" : null;
              },
              items: items,
              onChanged: (String newValue) {
                onChange(newValue);
              },
              value: value,
            )),
      ),
    );
  }

  Widget textInput(title, onSaved, {prefixIcon}) {
    return new TextFormField(
      onSaved: (val) => onSaved(val),
      style: TextStyle(color: Colors.white),
      validator: (val) {
        return val.length < 1 ? "$title Cannot be empty" : null;
      },
      decoration: formDecoration(title, icon: prefixIcon),
    );
  }

  Widget emailInput(title, onSaved, {prefixIcon}) {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (val) => onSaved(val),
      style: TextStyle(color: Colors.white),
      validator: (val) {
        return val.length < 1 ? "$title Cannot be empty" : null;
      },
      decoration: formDecoration(title, icon: prefixIcon),
    );
  }

  Widget phoneInput(title, onSaved, {prefixIcon}) {
    return new TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (val) => onSaved(val),
      style: TextStyle(color: Colors.white),
      validator: (val) {
        return val.length < 1 ? "$title Cannot be empty" : null;
      },
      decoration: formDecoration(title, icon: prefixIcon),
    );
  }

  Widget textAreaInput(title, onSaved, {prefixIcon, lines}) {
    return new TextFormField(
      onSaved: (val) => onSaved(val),
      maxLines: lines ?? 5,
      style: TextStyle(color: Colors.white),
      validator: (val) {
        return val.length < 1 ? "$title Cannot be empty" : null;
      },
      decoration: formDecoration(title, icon: prefixIcon),
    );
  }

  Widget passwordInput(title, onSaved, {prefixIcon}) {
    return new TextFormField(
      onSaved: (val) => onSaved(val),
      style: TextStyle(color: Colors.white),
      obscureText: true,
      validator: (val) {
        return val.length < 1 ? "$title Cannot be empty" : null;
      },
      decoration: formDecoration(title, icon: prefixIcon),
    );
  }

  Widget imageInput(title, image, pressAction) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
      child: new SizedBox(
        child: Center(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: image == null
                  ? Text('No Image Selected',
                      style: TextStyle(color: Colors.white))
                  : Image.file(image),
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
                      title,
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: pressAction,
              shape: const StadiumBorder(),
            ),
            SizedBox(height: 10)
          ]),
        ),
      ),
    );
  }

  Widget uploadFile(filePath, _getFilePath) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
      child: new SizedBox(
        height: 90.0,
        child: Center(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.all(7),
              child: Text(
                  filePath != null
                      ? path.basename(filePath)
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

  Widget formLabel(label) {
    return Text(label,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400));
  }

  Widget fieldSpace() => SizedBox(height: 17);

  Widget header(title) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: new Text(
        title,
        style: new TextStyle(
          color: Colors.orange.shade700,
          fontFamily: 'Poppins-Bold',
          fontSize: 20.0,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget sectionHeader(title, {position: TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 30),
      child: new Text(
        title,
        style: new TextStyle(
          color: Colors.orange.shade700,
          fontFamily: 'Poppins-Bold',
          fontSize: 20.0,
        ),
        textAlign: position,
      ),
    );
  }

  Widget sectionHeaderTooltip(title, tooltip) {
    return Padding(
        padding: EdgeInsets.only(left: 10, top: 30),
        child: Row(children: [
          new Text(
            title,
            style: new TextStyle(
              color: Colors.orange.shade700,
              fontFamily: 'Poppins-Bold',
              fontSize: 20.0,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(width: 5),
          Tooltip(
              padding: EdgeInsets.all(10),
              preferBelow: false,
              message: tooltip,
              child: Icon(
                Icons.info,
                color: Colors.white70,
              ))
        ]));
  }

  Widget sectionH3(title, {position: TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 30),
      child: new Text(
        title,
        style: new TextStyle(
          color: Colors.orange.shade700,
          fontFamily: 'Poppins-Bold',
          fontSize: 25.0,
        ),
        textAlign: position,
      ),
    );
  }

  Widget sectionH1(title, {position: TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 10),
      child: new Text(
        title,
        style: new TextStyle(
          color: Colors.orange.shade700,
          fontFamily: 'Poppins-Bold',
          fontSize: 35.0,
          fontWeight: FontWeight.w600,
        ),
        textAlign: position,
      ),
    );
  }

  Widget sectionBody(content, {position: TextAlign.left, size: 15.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
      child: new Text(
        content,
        style: new TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: size,
        ),
        textAlign: position,
      ),
    );
  }

  Widget wideButton(title, context, _continue,{disable:false}) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width,
      height: 55.0,
      buttonColor: disable?Colors.grey:UiData.orange,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        elevation: 5,
        onPressed: _continue,
        child: Text(title, style: TextStyle(fontSize: 17, color: Colors.white)),
      ),
    );
  }

  Widget smallButton(title, context, _continue) {
    return ButtonTheme(
      //minWidth: MediaQuery.of(context).size.width,
      height: 20.0,
      buttonColor: UiData.orange,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        elevation: 5,
        onPressed: _continue,
        child: Text(title, style: TextStyle(fontSize: 10, color: Colors.white)),
      ),
    );
  }

  Widget imageUpload(imageLocalFile, imageLink, controller,
      {title = 'Pick image'}) {
    return Center(
      child: new SizedBox(
        child: Center(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: imageLocalFile == null
                    ? imageLink != null
                        ? NetworkImage(imageLink)
                        : AssetImage(UiData.userPlaceholder)
                    : FileImage(imageLocalFile),
              ),
            ),
            new SizedBox(
                width: 120.0,
                height: 35.0,
                child: OutlineButton(
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: controller,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
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
}

class PasswordEye extends StatefulWidget {
  dynamic model;
  final String title;
  PasswordEye({this.model, this.title});
  @override
  _PasswordEyeState createState() => _PasswordEyeState();
}

class _PasswordEyeState extends State<PasswordEye> {
  bool _obscureText = true;

  String _password;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(1.0),
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: UiData.orange, width: 1.0),
            borderRadius: BorderRadius.circular(4.0)),
        color: Colors.white,
        //elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: new TextFormField(
                  onSaved: (val) => widget.model(val),
                  style: TextStyle(color: Colors.black),
                  obscureText: _obscureText,
                  validator: (val) {
                    return val.length < 1
                        ? "${widget.title} Cannot be empty"
                        : null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: widget.title),
                ),
              ),
              InkWell(
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: UiData.orange),
                onTap: _toggle,
              ),
            ],
          ),
        ));
  }
}
