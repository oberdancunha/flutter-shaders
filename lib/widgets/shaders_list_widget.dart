import 'package:flutter/material.dart';

import 'scaffold_widget.dart';

@immutable
class ShadersListWidget extends StatefulWidget {
  final String title;
  final int gridCount;
  final Widget? Function(BuildContext, int) gridBuilder;

  const ShadersListWidget({
    required this.title,
    required this.gridCount,
    required this.gridBuilder,
    super.key,
  });

  @override
  State<ShadersListWidget> createState() => _ShadersListWidgetState();
}

class _ShadersListWidgetState extends State<ShadersListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldWidget(
    title: widget.title,
    body: Center(
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: widget.gridCount,
          itemBuilder: widget.gridBuilder,
        ),
      ),
    ),
  );
}
