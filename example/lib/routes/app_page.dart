class MyAppPage {
  MyAppPage({this.name, required this.path, this.isSubpage = false}) {
    name ??= path.replaceFirst('/', '').replaceAll('/', '-');
    isSubpage
        ? path
            .replaceFirst('/', '')
            .replaceRange(path.length - 1, path.length, '')
        : null;
  }
  String path;
  String? name;
  final bool isSubpage;
}
