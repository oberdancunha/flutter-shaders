import 'package:flutter/material.dart';

import '../models/shaders/shader_model.dart';
import '../widgets/button_widget.dart';
import '../widgets/shaders_list_widget.dart';

@immutable
final class ShadersMenuPage extends StatelessWidget {
  const ShadersMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final shaders =
        (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['shaders']!
            as List<ShaderModel>;
    final title =
        (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['title']! as String;

    return ShadersListWidget(
      title: title,
      gridCount: shaders.length,
      gridBuilder:
          (_, index) => Center(
            child: SizedBox(
              width: screenSize.width * 0.25,
              height: screenSize.height * 0.15,
              child: ButtonWidget(
                image: shaders.elementAt(index).image,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/shader',
                    arguments: <String, String>{'shaderFile': shaders.elementAt(index).fileName},
                  );
                },
              ),
            ),
          ),
    );
  }
}
