import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_notifiers.dart';
import 'package:minimals_state_manager/min_props.dart';
import 'package:minimals_state_manager/min_providers.dart';
import 'package:minimals_state_manager/min_widgets.dart';

class User extends MinProps {
  User({required this.email, required this.name});
  String name;
  String email;

  @override
  Record get props => (name: name, email: email);
}

// 2. A single Notifier encompassing all states for the tests
class TestNotifier extends MinNotifier {
  bool loading = false;
  User user = User(name: 'Kauê', email: 'kaue@test.com');
  List<String> items = [];

  // Neutral variable to verify that its changes do NOT trigger unwanted rebuilds
  int whatever = 0;

  void changeLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void changeUserName(String newName) {
    update(user, (u) => u.name = newName);
  }

  void changeUserEmail(String newEmail) {
    update(user, (u) => u.email = newEmail);
  }

  void addItem(String item) {
    items.add(item);
    notifyListeners();
  }

  // Modifies the neutral variable that should NOT trigger rebuilds in most selectors
  void incrementWhatever() {
    whatever++;
    notifyListeners();
  }
}

void main() {
  group('Selector \$ with MinProvider Test Suite\n', () {
    // ==========================================
    // 1. FILTERING PRIMITIVE STATE MUTATIONS
    // ==========================================
    testWidgets('1. Primitive: Should rebuild only when "loading" changes',
        (tester) async {
      int buildCount = 0;
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MaterialApp(
          // Injecting the notifier using your MinProvider
          home: MinProvider(
            create: () => notifier,
            child: Scaffold(
              // Using Builder to get the correct context below MinProvider
              body: Builder(
                builder: (context) {
                  return $<TestNotifier, bool>(
                    // Retrieving the injected notifier from context
                    notifier: context.read<TestNotifier>(),
                    selector: (c) => c.loading,
                    builder: (context, loading) {
                      buildCount++;
                      return Text(loading ? 'Loading...' : 'Ready');
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Ready'), findsOneWidget);
      expect(buildCount, 1);

      // Mutate 'whatever' and notify: Should NOT rebuild
      notifier.incrementWhatever();
      await tester.pump();
      expect(buildCount, 1);

      // Mutate 'loading': Should rebuild
      notifier.changeLoading(true);
      await tester.pump();
      expect(find.text('Loading...'), findsOneWidget);
      expect(buildCount, 2);
    }, variant: TargetPlatformVariant.all());

    // ==========================================
    // 2. GROUPING VALUES VIA NATIVE DART RECORDS
    // ==========================================
    testWidgets(
        '2. Records: Should rebuild when "name" or "loading" changes, but ignore "whatever"',
        (tester) async {
      int buildCount = 0;
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: MinProvider(
            create: () => notifier,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return $<TestNotifier, ({String name, bool loading})>(
                    notifier: context.read<TestNotifier>(),
                    selector: (notifier) =>
                        (name: notifier.user.name, loading: notifier.loading),
                    builder: (context, data) {
                      buildCount++;
                      return Text(
                          '${data.name} - ${data.loading ? 'Active' : 'Inactive'}');
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Kauê - Inactive'), findsOneWidget);
      expect(buildCount, 1);

      // Mutate 'whatever': Should NOT rebuild
      notifier.incrementWhatever();
      await tester.pump();
      expect(buildCount, 1);

      // Mutate 'loading': Should rebuild
      notifier.changeLoading(true);
      await tester.pump();
      expect(find.text('Kauê - Active'), findsOneWidget);
      expect(buildCount, 2);

      // Mutate 'name': Should rebuild
      notifier.changeUserName('Kauê Murakami');
      await tester.pump();
      expect(find.text('Kauê Murakami - Active'), findsOneWidget);
      expect(buildCount, 3);
    }, variant: TargetPlatformVariant.all());

    // ==========================================
    // 3. COMPLEX STRUCTURAL MODELS VIA MINPROPS
    // ==========================================
    testWidgets(
        '3. MinProps: Should rebuild only if the User props Record changes',
        (tester) async {
      int buildCount = 0;
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: MinProvider(
            create: () => notifier,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return $<TestNotifier, User>(
                    notifier: context.read<TestNotifier>(),
                    selector: (notifier) => notifier.user,
                    builder: (context, user) {
                      buildCount++;

                      return Text('User: ${user.name} | ${user.email}');
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('User: Kauê | kaue@test.com'), findsOneWidget);
      expect(buildCount, 1);

      // Mutate 'whatever': Should NOT rebuild
      notifier.incrementWhatever();
      await tester.pump();
      expect(buildCount, 1);

      // Mutate 'name': Should rebuild
      notifier.changeUserName('Murakami');
      await tester.pump();
      expect(find.text('User: Murakami | kaue@test.com'), findsOneWidget);
      expect(buildCount, 2);
    }, variant: TargetPlatformVariant.all());

    // ==========================================
    // 4. LISTS / MAPS / SETS
    // ==========================================
    testWidgets('4. Lists: Should rebuild when new items are added to the list',
        (tester) async {
      int buildCount = 0;
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: MinProvider(
            create: () => notifier,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return $<TestNotifier, List<String>>(
                    notifier: context.read<TestNotifier>(),
                    selector: (c) => c.items,
                    builder: (context, items) {
                      buildCount++;
                      return items.isEmpty
                          ? const Text('No items')
                          : Text('Total items: ${items.length}');
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
      expect(buildCount, 1);

      // Mutate 'whatever': Should NOT rebuild
      notifier.incrementWhatever();
      await tester.pump();
      expect(buildCount, 1);

      // Add an item: Should rebuild
      notifier.addItem('Flutter');
      await tester.pump();
      expect(find.text('Total items: 1'), findsOneWidget);
      expect(buildCount, 2);
    }, variant: TargetPlatformVariant.all());

    // ==========================================
    // 5. LISTEN ALL CHANGES IN YOUR NOTIFIER
    // ==========================================
    testWidgets(
        '5. Listen All: Should rebuild on absolutely any notifyListeners(), including "whatever"',
        (tester) async {
      int buildCount = 0;
      final notifier = TestNotifier();
      await tester.pumpWidget(
        MaterialApp(
          home: MinProvider(
            create: () => notifier,
            child: Scaffold(body: Builder(builder: (context) {
              return $<TestNotifier, TestNotifier>(
                notifier: context.read<TestNotifier>(),
                selector: (notifier) => notifier,
                builder: (context, notifier) {
                  buildCount++;
                  return Text(
                      'User: ${notifier.user.name} | Whatever: ${notifier.whatever}');
                },
              );
            })),
          ),
        ),
      );

      expect(find.text('User: Kauê | Whatever: 0'), findsOneWidget);
      expect(buildCount, 1);

      // Mutate 'whatever': Should rebuild in this scenario
      notifier.incrementWhatever();
      await tester.pump();
      expect(find.text('User: Kauê | Whatever: 1'), findsOneWidget);
      expect(buildCount, 2);
    }, variant: TargetPlatformVariant.all());

    // ==========================================
    // 6. 6. LIFECYCLE & EDGE CASES
    // ==========================================
    testWidgets(
        'didUpdateWidget should update listeners when the notifier instance changes',
        (tester) async {
      // Use o seu TestNotifier que já está definido no arquivo
      final notifier1 = TestNotifier();
      final notifier2 = TestNotifier();

      await tester.pumpWidget(
        $<TestNotifier, int>(
          // Ou o nome da sua classe se for diferente
          notifier: notifier1,
          selector: (n) => n.whatever,
          builder: (context, value) => Container(),
        ),
      );

      await tester.pumpWidget(
        $<TestNotifier, int>(
          notifier: notifier2,
          selector: (n) => n.whatever,
          builder: (context, value) => Container(),
        ),
      );

      expect(find.byType(Container), findsOneWidget);

      // Force didUpdateWidget by changing the notifier instance
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return $<TestNotifier, int>(
                notifier: notifier2,
                selector: (n) => n.whatever,
                builder: (context, val) => Text('$val'),
              );
            }),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
    }, variant: TargetPlatformVariant.all());
  });
}
