import 'package:flutter/material.dart';

import '../models/shaders/shader_model.dart';
import '../widgets/button_widget.dart';
import '../widgets/scaffold_widget.dart';

@immutable
final class ShadersMenuPage extends StatefulWidget {
  const ShadersMenuPage({super.key});

  @override
  State<ShadersMenuPage> createState() => _ShadersMenuPageState();
}

class _ShadersMenuPageState extends State<ShadersMenuPage> {
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final shaders = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['shaders']!
        as List<ShaderModel>;
    final title =
        (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['title']! as String;

    return ScaffoldWidget(
      title: title,
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            itemCount: shaders.length,
            itemBuilder: (_, index) => Center(
              child: SizedBox(
                width: screenSize.width * 0.25,
                height: screenSize.height * 0.15,
                child: ButtonWidget(
                  image: shaders.elementAt(index).image,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/shader',
                      arguments: <String, String>{
                        'shaderFile': shaders.elementAt(index).fileName,
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
