import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

void main() {
  const title = 'Material App';

  runApp(
    MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeView(),
    ),
  );
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var color1 = Colors.blue;
  var color2 = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = context.randomColor;
                    });
                  },
                  child: const Text('Change color1'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = context.randomColor;
                    });
                  },
                  child: const Text('Change color2'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

/// Note: Both [InheritedModel] and [InheritedModel] are constant,
/// so their variables must not be changed
/// I mean all variable have to be final,
/// and they need updatable thing such as [StatefulWidget] to update their variables.
/// I mean 'redraw the widget'.
class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget({
    super.key,
    required this.color1,
    required this.color2,
    required super.child,
  });

  /// This method only for the child of the this [InheritedModel],
  /// which means that it will not used by oneself.
  /// while this method using, the child will grab up to widget tree,
  /// so if the [InheritedModel] is not available it will throw Exception.
  /// - if this method is used by a widget which is not a child or
  /// sub child(child of child [of ...]) of the(this model) [InheritedModel],
  /// it will throw Exception.

  // Here I use '!', but it might be used like returning optional.
  static AvailableColorsWidget of(
    BuildContext context,
    AvailableColors aspects,
  ) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspects,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    dev.log('updateShouldNotify has been run');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant AvailableColorsWidget oldWidget,
    Set<AvailableColors> dependencies,
  ) {
    dev.log('updateShouldNotifyDependent has been run');

    if (dependencies.contains(AvailableColors.one) && color1 != oldWidget.color1) {
      return true;
    }

    if (dependencies.contains(AvailableColors.two) && color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }
}

class ColorWidget extends StatelessWidget {
  const ColorWidget({
    super.key,
    required this.color,
  });

  final AvailableColors color;

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        dev.log('Color1 widget got rebuild!');
        break;
      case AvailableColors.two:
        dev.log('Color2 widget got rebuild!');
        break;
    }

    final provider = AvailableColorsWidget.of(
      context,
      color,
    );

    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}
