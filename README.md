[PAUSED]

[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/minimals_state_manager.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/kauemurakami/minimals_state_manager)  

  The minimals_state_manager package is a minimalist implementation of state management for Flutter apps, using only native Flutter packages. The goal is to simplify the process of managing states in your projects by providing an easy-to-use framework that takes full advantage of Flutter's native functionality.  

  For this, the package uses important packages such as InheritedWidget, ChangeNotifier, ValueNotifier, ValueNotifierBuilder and WidgetsBindingObserver to control the lifecycle of the application in its controllers.  

  With minimals_state_manager, you will have a minimal state management implementation that is easy to understand and that speeds up Flutter application development. **However, it is important to point out that this package is intended for study about state management, observables, lifecycle and best practices only and is not recommended for production as it is still in alpha version.**  

## Features

  MinProvider and MinMultiProvider are state management providers that allow you to easily  
    manage and share the state of your Flutter application between different components.  
    MinProvider is used for single state management, while MinMultiProvider is used for  
    managing multiple states in a single provider. By using MinProvider and MinMultiProvider,   
    you can simplify the process of managing state and reduce boilerplate code in your  
    Flutter projects.  

   
    MinProvider(
      controller: YourController(),
      child: YourPage()
    )
   

    or

    
    MinMultiProvider(
      controllers: [YourController1(), YourController2()],
      child: YourPage()
    )
    

  Observable widget $(), this is a generic observable widget that  
    can be used to listen for changes to a value notifier and update  
    the UI accordingly. It takes in a value notifier and a builder  
    function that defines how the UI should be updated based on the  
    current value of the notifier. This widget is useful for cases where  
    you want to decouple the UI from the data source, allowing for changes  
    in the data to automatically update the UI without having to manually  
    manage state. It can be used in a variety of scenarios such as form  
    input fields, status indicators, or progress bars.  

    
    $(
      (count) => Text('Count $count'), // function returns real value as int
      listener: controller.count // count is ValueNotifier<int> 
    )
    

  MinController, this is an abstraction for creating state  
    controllers that use Flutter ChangeNotifier class and implement  
    the WidgetsBindingObserver mixin. This allows controllers to react  
    to changes in the application lifecycle, as well as notify observers  
    when state changes occur. The class has methods to handle application  
    lifecycle and other startup and shutdown operations. It is useful for  
    creating reactive and observable controllers that can be used  
    throughout an application.  

    
    class YourController extends MinController {
      @override
      void onInit() {
        print('init controller');
        super.onInit();
      }

      final count = 0.minx;
      ValueNotifier<User> user = User().minx;

      increment() => count.value++;
      decrement() => count.value--;
      refresh() => count.value = 0;

      onChangedName(str) => user.update((val) => val.name = str);
      onSaveName(str) => user.update((val) => val.name = str);
      validateName(str) => str.length < 2 ? 'insert valid name' : null;
    }

    class User {
      User({this.name});
      String? name;
    }
    

  `MinX<Controller>` MinX is a widget that provides a generic  
    way to obtain a MinController and rebuild the widget  
    tree when the controller's state changes. It uses the  
    MinProvider and MinMultiProvider classes to retrieve  
    the controller from the widget tree, depending on its  
    type. The controller is then passed to a builder function  
    that returns the widget tree to be built.  

    
    MinX<YourController>(
      builder: (context, controller) => Text(controller.name)
    )
    

## Getting started

```
$ flutter pub add minimals_state_manager
```
or add in your dependencies
```
dependencies:
  minimals_state_manager: <latest>
```

## Usage

This is simple example, for a more complete and complex, see the [`/example`](https://github.com/kauemurakami/minimals_state_manager/tree/main/example) folder.

In your main.dart

Use the `MinProvider()` widget to provide a Controller for the child widget tree. If you need more than one Controller, you can use `MinMultiProvider()` to pass a list of controllers. 

```dart
void main() {
  runApp(
    MaterialApp(
      home: MinProvider(
        controller: MyController(), 
        child: const MyPage(),
      ),
    ),
  );
}

```
Use `MinX<YourController>()` widget to retrieve the available controller instance to use its methods and attributes in certain parts of the code.

Use the observable widget `$()` to listen for updates to your controller's observable variable, this widget expects a `ValueNotifier` type listener, and has a function that returns the real value of the object passed, updating whenever necessary.

```dart
class MyPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: MinX<MyController>(
          builder: (context, controller) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () => controller.increment(),
                child: const Icon(Icons.add),
              ),
              const SizedBox(
                height: 16.0,
              ),
              FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () => controller.decrement(),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(
                height: 16.0,
              ),
              FloatingActionButton(
                onPressed: () => controller.refresh(),
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('check out the full example in the example folder'),
                Container(
                margin: const EdgeInsets.only(
                    left: 32.0, right: 32.0, bottom: 32.0),
                child: Form(
                  key: formKey,
                  child: MinX<MyController>(
                    builder: (context, controller) => Column(
                      children: [
                        $(
                          (user) => Text('${user.name}'),
                          listener: controller.user,
                        ),
                        TextFormField(
                          onChanged: (value) => controller.onChangedName(value),
                          validator: (value) => controller.validateName(value),
                          onSaved: (newValue) =>
                              controller.onSaveName(newValue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MinX<MyController>(
                        builder: (context, controller) => $(
                          (count) => Text(
                            'Count $count',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          listener: controller.count,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
```

Extend `MinController` in your controller to get application lifecycles.
Add your methods and your observables.
```dart
class MyController extends MinController {
  @override
  void onInit() {
    print('init controller');
    super.onInit();
  }

  final count = 0.minx;
  ValueNotifier<User> user = User().minx;

  increment() => count.value++;
  decrement() => count.value--;
  refresh() => count.value = 0;

  onChangedName(str) => user.update((val) => val.name = str);
  onSaveName(str) => user.update((val) => val.name = str);
  validateName(str) => str.length < 2 ? 'insert valid name' : null;
}
class User {
  User({this.name});
  String? name;
}


```

## Additional information

Package is a work of studies about life cycles, dependency injection, objects and observable classes.  
Not recommended and not ready for production.

Next steps:
  - Fix navigation 2.0
  - Provide controller for every page
  - Add more complex usage examples
  - Fix folders
  - Fix imports
