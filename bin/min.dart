// bin/min.dart
import 'dart:io';

void main(List<String> args) {
  // Agora o comando oficial é 'snapshot'
  if (args.isEmpty || args[0] != 'snapshot') {
    print('❌ Use: min snapshot <caminho_do_arquivo.dart>');
    return;
  }

  if (args.length < 2) {
    print('❌ Forneça o caminho do arquivo model.');
    return;
  }

  final file = File(args[1]);
  if (!file.existsSync()) {
    print('❌ Arquivo não encontrado: ${args[1]}');
    return;
  }

  String content = file.readAsStringSync();

  // Limpa QUALQUER implementação anterior do snapshot para sobrescrever
  content = content.replaceAll(
      RegExp(r'@override\s+(?:MinRecord\s+)?get\s+snapshot\s+=>[\s\S]*?;'), '');
  content = content.replaceAll(
      RegExp(r'@override\s+(?:MinRecord\s+)?get\s+snapshot\s*\{\s*[\s\S]*?\}'),
      '');

  final lines = content.split('\n');
  final tiposPrimitivos = [
    'String',
    'int',
    'double',
    'num',
    'bool',
    'DateTime'
  ];
  List<String> propsGeradas = [];

  final variableRegex = RegExp(
      r'^\s*(?:final|late|const)?\s*([a-zA-Z_0-9<>]+)\s+([a-zA-Z_0-9]+)\s*(?:=[^;]+)?\s*;');

  for (var line in lines) {
    if (line.contains('{') || line.contains('=>') || line.contains('(')) {
      continue;
    }

    final match = variableRegex.firstMatch(line);
    if (match != null) {
      final tipo = match.group(1)!.trim();
      final nomeVariavel = match.group(2)!.trim();

      if (line.contains('static') || nomeVariavel == 'snapshot') continue;

      if (tiposPrimitivos.contains(tipo)) {
        propsGeradas.add('$nomeVariavel: $nomeVariavel');
      } else if (tipo.startsWith('List') ||
          tipo.startsWith('Set') ||
          tipo.startsWith('Map')) {
        propsGeradas.add('$nomeVariavel: $nomeVariavel');
      } else {
        propsGeradas.add('$nomeVariavel: $nomeVariavel.snapshot');
      }
    }
  }

  if (propsGeradas.isEmpty) {
    print('⚠️ Nenhum atributo mapeável encontrado para o MinSnapshot.');
    return;
  }

  final metodoSnapshot =
      '\n  @override\n  MinRecord get snapshot => ({${propsGeradas.join(', ')}});\n';

  int lastCurly = content.lastIndexOf('}');
  if (lastCurly != -1) {
    final novoConteudo = content.substring(0, lastCurly) +
        metodoSnapshot +
        content.substring(lastCurly);
    file.writeAsStringSync(novoConteudo);
    print('🚀 [Min] `get snapshot` atualizado e sobrescrito com sucesso!');
  }
}
