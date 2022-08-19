import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  const title = 'Material App';

  runApp(
    MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ApiProvider(
        api: Api(),
        child: const HomeView(),
      ),
    ),
  );
}

/// all variable have to be final
class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  ApiProvider({
    super.key,
    required this.api,
    required super.child,
  }) : uuid = const Uuid().v4();

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApiProvider.of(context).api.dateAndTime ?? ''),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () async {
          final api = ApiProvider.of(context).api;
          final dateAndTime = await api.getDateAndTime();
          setState(() {
            _textKey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Container(
            color: Colors.black54,
            child: DateTimeWidget(key: _textKey),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  final text = 'Tap on screen to fetch date and time';

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Center(child: Text(api.dateAndTime ?? text));
  }
}

class Api {
  String? dateAndTime;

  Future<String> getDateAndTime() async {
    final value = await Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    );
    dateAndTime = value;
    return value;
  }
}
