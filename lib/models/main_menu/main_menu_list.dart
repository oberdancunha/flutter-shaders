import '../shaders/color_shader_list.dart';
import '../shaders/matrizes_2d_shader_list.dart';
import '../shaders/patterns_shader_list.dart';
import '../shaders/shape_shader_list.dart';
import 'main_menu_model.dart';

List<MainMenuModel> get mainMenu => [
      MainMenuModel(
        title: 'Color',
        image: 'main_menu/color.jpg',
        shaders: ColorShaderList().shadersList,
      ),
      MainMenuModel(
        title: 'Shape',
        image: 'main_menu/shape.png',
        shaders: ShapeShaderList().shadersList,
      ),
      MainMenuModel(
        title: 'Matrizes 2D',
        image: 'main_menu/matrizes_2d.gif',
        shaders: Matrizes2DShaderList().shadersList,
      ),
      MainMenuModel(
        title: 'Patterns',
        image: 'main_menu/patterns.jpg',
        shaders: PatternsShaderList().shadersList,
      ),
    ];
