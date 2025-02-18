import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

@immutable
final class ScaffoldWidget extends StatelessWidget {
  final String title;
  final Widget body;

  const ScaffoldWidget({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: AutoSizeText(title, maxLines: 1),
      titleTextStyle: TextStyle(
        fontSize: MediaQuery.sizeOf(context).width * 0.075,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    body: body,
  );
}
