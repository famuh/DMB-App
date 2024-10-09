import 'package:dmb_app/common/constant.dart';
import 'package:flutter/material.dart';

/// A reusable subheading widget for sections in the movie detail view.
class SubHeading extends StatelessWidget {
  final String title;

  const SubHeading({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: cGreen,
        fontSize: 16,

        fontWeight: FontWeight.w500,
      ),
    );
  }
}