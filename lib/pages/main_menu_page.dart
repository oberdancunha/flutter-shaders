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
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(
            mainMenu.length,
            (index) => Center(
              child: SizedBox(
                width: screenSize.width * 0.25,
                height: screenSize.height * 0.18,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonWidget(
                      image: mainMenu.elementAt(index).image,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/shaders',
                          arguments: <String, dynamic>{
                            'shaders': mainMenu.elementAt(index).shaders,
                            'title': 'Shaders - ${mainMenu.elementAt(index).title}',
                          },
                        );
                      },
                    ),
                    Text(
                      mainMenu.elementAt(index).title,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
