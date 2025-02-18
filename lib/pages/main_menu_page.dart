import 'package:flutter/material.dart';

import '../models/main_menu/main_menu_list.dart';
import '../widgets/button_widget.dart';
import '../widgets/scaffold_widget.dart';

@immutable
final class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return ScaffoldWidget(
      title: 'Shaders',
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: mainMenu.length,
          itemBuilder: (_, index) {
            final menuElement = mainMenu.elementAt(index);
            final title = menuElement.title;
            final titleHeightMultiplayFactor = title.length <= 11 ? 0.18 : 0.21;

            return Center(
              child: SizedBox(
                width: screenSize.width * 0.25,
                height: screenSize.height * titleHeightMultiplayFactor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonWidget(
                      image: menuElement.image,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/shaders',
                          arguments: <String, dynamic>{
                            'shaders': menuElement.shaders,
                            'title': 'Shaders - $title',
                          },
                        );
                      },
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
