import 'package:flutter/material.dart';

@immutable
final class ShaderModel {
  final String image;
  final String fileName;

  const ShaderModel({
    required this.image,
    required this.fileName,
  });
}
