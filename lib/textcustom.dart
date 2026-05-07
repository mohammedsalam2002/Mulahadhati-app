import 'package:flutter/material.dart';

class Textcustom extends StatelessWidget {
  final String text;
  final FontWeight fontweight;
  final double fontsize;
  final Color fontcolor;

  const Textcustom({
    super.key,
    required this.text,
    required this.fontweight,
    required this.fontsize, required this.fontcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: TextStyle(fontSize: fontsize, 
      color: fontcolor,
      fontWeight: fontweight),
    );
  }
}
