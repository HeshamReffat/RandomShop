import 'package:flutter/material.dart';

Widget customButton({
  double wid = double.infinity,
  double rad = 10.0,
  @required String text,
  bool isUpper = true,
  Color back = Colors.blue,
  @required Function function,
}) =>
    Container(
      width: wid,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: back,
        borderRadius: BorderRadius.circular(
          rad,
        ),
      ),
      child: FlatButton(
        onPressed: function,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget customFormField({
  @required controller,
  hint = '',
  @required type,
  isPassword = false,
  Function changed,
  borderColor = Colors.grey,
  valid,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: borderColor,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        validator: valid,
        onChanged: changed,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
