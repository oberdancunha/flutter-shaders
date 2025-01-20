import 'package:flutter/material.dart';

import '../misc/ui_colors.dart';

@immutable
final class ButtonWidget extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const ButtonWidget({
    required this.image,
    required this.onTap,
    super.key,
  });

  static const adjustColor = 40;

  @override
  Widget build(BuildContext context) {
    final backgroundBaseColor = UIColors(
      baseColor: UIColors(baseColor: Theme.of(context).colorScheme.primary).getColor(
        adjustColor: -adjustColor ~/ 2,
      ),
    );
    final buttonColor = UIColors(baseColor: Theme.of(context).colorScheme.primary);
    final width = MediaQuery.of(context).size.width * 0.25;

    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            width: width,
            height: width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[850]!,
                    offset: const Offset(3, 3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade700,
                    offset: const Offset(-3, -3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    backgroundBaseColor.getColor(adjustColor: -adjustColor),
                    backgroundBaseColor.getColor(adjustColor: adjustColor),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: width - 2,
            height: width - 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    buttonColor.getColor(adjustColor: 0),
                    buttonColor.getColor(adjustColor: -adjustColor),
                  ],
                ),
              ),
              child: Image.asset(
                'assets/images/$image',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
