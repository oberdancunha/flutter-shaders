import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import '../painter/shader_painter.dart';
import '../widgets/scaffold_widget.dart';

@immutable
final class ShaderPage extends StatefulWidget {
  const ShaderPage({
    super.key,
  });

  @override
  State<ShaderPage> createState() => _ShaderPageState();
}

class _ShaderPageState extends State<ShaderPage> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      _time += 0.016;
      setState(() {});
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final shaderFile =
        (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['shaderFile'];

    return ScaffoldWidget(
      title: 'Shader',
      body: Center(
        child: SizedBox(
          height: screenSize.height / 2,
          width: screenSize.width,
          child: ShaderBuilder(
            assetKey: 'shaders/$shaderFile',
            (_, shader, __) => RepaintBoundary(
              child: CustomPaint(
                painter: ShaderPainter(
                  shader: shader,
                  time: _time,
                ),
                isComplex: true,
                willChange: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
