import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String inputText;
  final Icon inputIcon;
  final Color inputColor;
  final Function onChanged;
  final TextInputType inputType;
  final Stream<dynamic> streamDataTransform;
  final TextEditingController controller;
  final bool addObsucre;
  const AppTextField(
      {this.inputText,
      
      this.inputIcon,
      this.inputColor,
      this.onChanged,
      this.inputType,
      this.streamDataTransform,
      this.addObsucre,
      this.controller});

  Widget getAppTextFieldStream() {
    return StreamBuilder(
        stream: streamDataTransform,
        builder: (context, snapshot) {
          return TextField(
            controller: controller!=null ? controller: null,
            obscureText:addObsucre ,
            keyboardType: inputType != null ? inputType : TextInputType.text,
            onChanged: onChanged,
            style: TextStyle(color: inputColor),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintStyle: TextStyle(color: inputColor),
                errorText: snapshot != null ? snapshot.error : null,
                hintText: inputText,
                prefixIcon: inputIcon,
                prefixStyle: TextStyle(color: inputColor),
                focusColor: inputColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(color: inputColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return getAppTextFieldStream();
  }
}
