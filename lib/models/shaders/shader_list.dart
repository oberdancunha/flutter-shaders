import 'shader_model.dart';

abstract class ShaderList {
  late String mainPath;
  late int count;

  List<ShaderModel> get shadersList => List.generate(count, (index) {
    final int fileIndex = index + 1;
    final fileName = '$mainPath/${mainPath}_example_$fileIndex';

    return ShaderModel(image: '$fileName.png', fileName: '$fileName.glsl');
  });
}
