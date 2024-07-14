[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/minimals_state_manager.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/kauemurakami/minimals_state_manager)  

  The minimals_state_manager package is a minimalist implementation of state management for Flutter apps, using only native Flutter packages. The goal is to simplify the process of managing states in your projects by providing an easy-to-use framework that takes full advantage of Flutter's native functionality.  

  For this, the package uses important packages such as InheritedWidget, ChangeNotifier, ValueNotifier, ValueListenableBuilder to control the lifecycle of the application in its controllers.  

  With minimals_state_manager, you will have a minimal state management implementation that is easy to understand and that speeds up Flutter application development. **However, it is important to point out that this package is intended for study about state management, observables, lifecycle and best practices only and is not recommended for production as it is still in alpha version.**  

## Features
#### Providers
  `MinProvider and MinMultiProvider`are state management providers that allow you to easily manage and share the state of your Flutter application between different components.  
  `MinProvider` is used for single state management, while `MinMultiProvider` is used for managing multiple states in a single provider.  
  By using `MinProvider` and `MinMultiProvider`,   
  you can simplify the process of managing state and reduce boilerplate code in your Flutter projects.  
  Using `InheritedWidget` to add `controllers` to the widget tree.  
  In turn, we abandoned `MinController` which extended our `ChangeNotifier` to create, with some changes, our `controllers`, 
  Now we decided to directly use `ChangeNotifier` in the creation of controllers, avoiding outsourcing and boilerplate of using Flutter, as it is already available in Flutter, example of the expected `Controller`:  
  ```dart
    class YourController1 extends ChangeNotifier{
      ValueNotifier<int> count = 0.minx;
      //or 
      //final count = 0.minx;

      increment(){
        count.value++;  
        notifyListeners();
      }
      decrement(){
        count.value;
        notifyListeners();
      }
    }
  ```
  `minx` helps you avoid boilerplate when assigning values ​​in `ValueNotifier<T>`, you can set an initial value ordeclare using the `.minx` extension to return a value notifier of the same type with the entered value. <br/>

  ```dart
    MinProvider(
      controller: YourController(),
      child: YourPage()
    )
  ```
  Or
  ```dart
    MinMultiProvider(
      controllers: [YourController1(), YourController2()],
      child: YourPage()
    )
  ```
  Remember, if you want to keep some controller alive and avoid restarting, create an instance of it before passing it, available in our example on the `dash` route, example:  
  Create a file in routes > `routes/providers.dart` to define global controllers:
```dart
  final yourController1 = YouController1();
  final yourController2 = YouController2();
```
And call this in `MinProvider` or `MinMultiProvider` example with `MinMultiProvider`, the same is valid to `MinProvider`:  
```dart
  MinMultiProvider(
      controllers: [yourController1, yourController2],
      child: YourPage()
  )
```
  This keeps their state the same throughout the widget tree.<br/><br/>

  You can retrieve the controllers in the widget tree after they are injected with one of the `Providers` with:  
  ```dart 
  Widget build(BuildContext context) {
    final controller = MinProvider.use<YourController>(context);
    return Widget
  }
  ```
  Or  
  ```dart 
  ...
  final controller = MinMultiProvider.use<YourController1>(context)
  final controller = MinMultiProvider.use<YourController2>(context)
  ```
#### Observable widget
  This widgets is 
  Observable widget `$(ValueNotifier<T> listener , (value) => Widget())`, this is a generic observable widget that can be used to listen for changes to a value and update notifier the specific user interface.  
  Value notifier and constructor required function that defines how the UI should be updated based on the current value of the notifier, where our ValueNotifier listener is inserted into the build function to pass its primitive value with each update.  
  This widget is useful for cases where you want to decouple the UI from the data source, allowing changes in the data to automatically update the UI without having to manually manage the state.  
  It can be used in a variety of scenarios such as form input fields, status indicators or progress bars.  

  ```dart
  $(controller.count, // our listener provided by widget count is ValueNotifier<int> 
    (count) => Text('Count $count'), // function returns real value as int     
  )
  ```
  This widget use a `ValueListenableBuilder` widget to exist, if you want to be closer to Flutter's native code, nothing prevents you from using it with your controller's `ValueNotifier<T>`, example:  
  ```dart
   ValueListenableBuilder(valueListenable: controller.count,
    builder: (context, count, child) => Text('Count $count'), 
  )
  ```  

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

Use the observable widget `$(ValueNotifier<T> listener, (T listener) => Widget())` to listen for updates to your controller's observable variable, this widget expects a `ValueNotifier` type listener, and has a function that returns the real value of the object passed, updating whenever necessary.

```dart
class MyPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MinProvider.use<MyController>(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:  Column(
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
                  child:  Column(
                      children: [
                        $(
                          controller.user,
                          (User user) => Text(user.name),
                          ,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       $(
                          controller.count,
                          (count) => Text(
                            'Count $count',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
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
}
```

Extend `ChangeNotifier` in your controller to get application lifecycles.
Add your methods and your observables.
```dart
class MyController extends ChangeNotifier {
  MyController(){
    print('init controler')    ;

  }

  final count = 0.minx;
  ValueNotifier<User> user = User().minx;

  increment() {
    count.value++;
    notifyListeners();
  } 
  decrement() {
    count.value--;
    notifyListeners();
  }

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
The `update()` extension was made to update more complex objects,  but nothing stops you from using `notifyListeners` or `complex.notifyListeners()`  

## Additional information

Package is a work of studies about life cycles, dependency injection, objects and observable classes.  
Not recommended and not ready for production.


