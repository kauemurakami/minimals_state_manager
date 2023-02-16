import 'package:example/app/data/providers/api.dart';

class HomeRepository {
  final FakeApi api;

  HomeRepository(this.api);

  getItems() async => await api.getItems();
}
