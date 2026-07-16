import 'package:example/app/data/services/auth/service.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_notifiers.dart';
import 'package:minimals_state_manager/min_providers.dart';
import 'package:minimals_state_manager/min_services.dart';
import 'package:minimals_state_manager/min_widgets.dart';

/// Complex example available (with GoRoute, DI, lifecycle methods)
/// to use, comment the simple example and run
// void main() {
//   setPathUrlStrategy();
//   setupLocator();
//   runApp(MaterialApp.router(
//     debugShowCheckedModeBanner: false,
//     routerConfig: GoRootDelegate.router,
//   ));
// }

// Simple example
void main(List<String> args) {
  setupLocator(); // DI - singletons / lazy Singletons
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MinProvider<AuthController>(
      create: () => AuthController(),
      child: AuthPage(),
    ),
  ));
}

final min = MinService.instance;

void setupLocator() {
  min.registerLazySingleton(() => AuthService());
  // min.registerSingleton(AnotherSingleton());
}

class AuthController extends MinNotifier {
  final AuthService _authService = min<AuthService>();
  bool loading = false;
  @override
  void onInit() {
    debugPrint('AuthController init');
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint('AuthController ready');
    super.onReady();
  }

  Future<void> login() async {
    loading = true;
    notifyListeners();
    await _authService.login();
    loading = false;
    notifyListeners();
  }

  //using update method helper (automatic notifier)
  void onChange(String name) => update(_authService.user, (u) => u.name = name);
  //or
  void onSave(String? name) {
    _authService.user.name = name;
    notifyListeners();
  }

  @override
  void dispose() {
    debugPrint('Auth controller disposed');
    super.dispose();
  }
}

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthController>();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            Form(
                key: _formKey,
                child: TextFormField(
                  onSaved: (newValue) => controller.onSave(newValue),
                  onChanged: (value) => controller.onChange(value),
                  validator: (value) =>
                      value!.length > 2 ? null : 'Insert a valid name',
                )),
            MaterialButton(
              color: Colors.purple,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await controller.login();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MinMultiProvider(create: [
                          () => MainController(),
                          () => AnotherController().tag('another')
                        ], child: MainPage()),
                      ));
                }
              },
              child: const Text(
                'CONTINUE',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class AnotherController extends MinNotifier {
  @override
  void onInit() {
    debugPrint('AnotherController init');
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint('AnotherController ready');

    super.onReady();
  }
}

class MainController extends MinNotifier {
  int counter = 0;
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    debugPrint('MainController init');

    getData();
  }

  @override
  void onReady() {
    debugPrint('MainController ready');
    super.onReady();
  }

  void increment() {
    counter++;
    notifyListeners();
  }

  void decrement() {
    counter--;
    notifyListeners();
  }

  void resetCounter() {
    if (counter == 0) {
      return;
    }
    counter = 0;
    notifyListeners();
  }

  Future<void> getData() async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

const TextStyle defaultStyle = TextStyle(color: Colors.white);

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final AuthService _authService = min<AuthService>();
  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainController>();
    //or
    // ignore: unused_local_variable
    final anotherController =
        MinMultiProvider.read<AnotherController>(context, tag: 'another');
    //or
    // final anotherController = context.read<AnotherController>(tag: 'another');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[200],
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hello ${_authService.user.name!}',
              style: defaultStyle,
            ),
          ),
        ),
        body: $<MainController, bool>(
            notifier: controller,
            selector: (notifier) => notifier.loading,
            builder: (context, loading) => loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                : SafeArea(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16.0,
                      children: [
                        Center(
                          child: $<MainController, int>(
                            notifier: controller,
                            selector: (notifier) => notifier.counter,
                            builder: (context, counter) => Text(
                              '$counter',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 54.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
        bottomNavigationBar: const BottomNavWidget());
  }
}

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          spacing: 16.0,
          children: [
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'dec',
                onPressed: controller.decrement,
                label: const Text(
                  'Decrement',
                  style: defaultStyle,
                ),
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red[400],
              ),
            ),
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'red',
                onPressed: controller.resetCounter,
                label: const Text(
                  'Reset',
                  style: defaultStyle,
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple[400],
              ),
            ),
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'inc',
                onPressed: controller.increment,
                label: const Text(
                  'Increment',
                  style: defaultStyle,
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
