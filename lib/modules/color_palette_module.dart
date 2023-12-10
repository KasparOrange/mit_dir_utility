import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/theme_service.dart';

class ColorPaletteModule extends StatelessWidget {
  const ColorPaletteModule({super.key});

  Widget _colorBox(Color color, String? text) {
    return Container(
      width: 150,
      height: 50,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Center(child: Text(text ?? '', style: const TextStyle(overflow:  TextOverflow.ellipsis))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10, // horizontal space between children
      runSpacing: 10, // vertical space between lines
      children: ThemeService.colors.map.entries.map((e) => _colorBox(e.value, e.key)).toList(),
      
      // children: [
      //   _colorBox(colors.highlight, 'highlight'),
      //   _colorBox(colors.error, 'error'),
      //   _colorBox(colors.niceOrage, 'niceOrage'),
      //   ],
    );
  }
}
