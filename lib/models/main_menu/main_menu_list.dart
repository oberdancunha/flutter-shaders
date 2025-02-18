import '../shaders/cellular_noise_shader_list.dart';
import '../shaders/color_shader_list.dart';
import '../shaders/generative_designs_shader_list.dart';
import '../shaders/matrizes_2d_shader_list.dart';
import '../shaders/noise_shader_list.dart';
import '../shaders/patterns_shader_list.dart';
import '../shaders/shape_shader_list.dart';
import 'main_menu_model.dart';

const String mainMenuDirectoryName = 'main_menu';

List<MainMenuModel> get mainMenu => [
  MainMenuModel(
    title: 'Color',
    image: '$mainMenuDirectoryName/color.jpg',
    shaders: ColorShaderList().shadersList,
  ),
  MainMenuModel(
    title: 'Shape',
    image: '$mainMenuDirectoryName/shape.png',
    shaders: ShapeShaderList().shadersList,
  ),
  MainMenuModel(
    title: 'Matrizes 2D',
    image: '$mainMenuDirectoryName/matrizes_2d.gif',
    shaders: Matrizes2DShaderList().shadersList,
  ),
  MainMenuModel(
    title: 'Patterns',
    image: '$mainMenuDirectoryName/patterns.jpg',
    shaders: PatternsShaderList().shadersList,
  ),
  MainMenuModel(
    title: 'Generative designs',
    image: '$mainMenuDirectoryName/generative_designs.jpeg',
    shaders: GenerativeDesignsShaderList().shadersList,
  ),
  MainMenuModel(
    title: 'Noise',
    image: '$mainMenuDirectoryName/noise.jpg',
    shaders: NoiseShaderList().shadersList,
  ),
  MainMenuModel(
    title: 'Cellular noise',
    image: '$mainMenuDirectoryName/cellular_noise.jpg',
    shaders: CellularNoiseShaderList().shadersList,
  ),
];
