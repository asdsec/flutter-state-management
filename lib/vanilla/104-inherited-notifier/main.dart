import 'package:flutter/material.dart';
import 'package:flutter_state_management/_product/constants/constants.dart';
import 'package:flutter_state_management/_product/extensions/iterable_extensions.dart';

const kZero = 0.0;
void main() {
  runApp(
    MaterialApp(
      title: Constants.materialAppTitle.value,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeView(),
    ),
  );
}

class SliderData extends ChangeNotifier {
  double _value = kZero;
  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    super.key,
    required super.child,
    required SliderData sliderData,
  }) : super(notifier: sliderData);

  static double of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()?.notifier?.value ?? kZero;
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Slider(
                value: SliderInheritedNotifier.of(context),
                onChanged: (value) => sliderData.value = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: SliderInheritedNotifier.of(context),
                    child: Container(color: Colors.yellow, height: 150),
                  ),
                  Opacity(
                    opacity: SliderInheritedNotifier.of(context),
                    child: Container(color: Colors.blue, height: 150),
                  ),
                ].expandEqually().toList(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
