import 'package:flutter/foundation.dart';

import '../shaders/shader_model.dart';

@immutable
final class MainMenuModel {
  final String title;
  final String image;
  final List<ShaderModel> shaders;

  const MainMenuModel({
    required this.title,
    required this.image,
    required this.shaders,
  });
}
