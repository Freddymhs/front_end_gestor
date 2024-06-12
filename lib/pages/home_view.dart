import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/pages/Layout/main_layout.dart';

class HomeView extends StatelessWidget {
  static const routeName = homeRoute;
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      child: ModuleGrid(),
    );
  }
}

class ModuleGrid extends StatelessWidget {
  const ModuleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _getColumnCount(constraints.maxWidth);
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * 16.0) / columns;

        return SingleChildScrollView(
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: List.generate(20, (index) {
              return ModuleItem(
                width: itemWidth,
                index: index,
              );
            }),
          ),
        );
      },
    );
  }

  int _getColumnCount(double width) {
    if (width >= 1200) {
      return 4;
    } else if (width >= 800) {
      return 3;
    } else if (width >= 600) {
      return 2;
    } else {
      return 1;
    }
  }
}

class ModuleItem extends StatelessWidget {
  final double width;
  final int index;

  const ModuleItem({
    required this.width,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 150,
      color: Colors.blueAccent,
      child: Center(
        child: Text(
          '$module ${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
