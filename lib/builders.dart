import 'dart:async';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

Builder pubspecBuilder(BuilderOptions options) => PubspecBuilder();

class PubspecBuilder extends Builder {
  @override
  Map<String, List<String>> get buildExtensions => const <String, List<String>>{
        r'$lib$': <String>['pubspec.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    if (buildStep.inputId.path == r'lib/$lib$') {
      final AssetId inputId = AssetId(
        buildStep.inputId.package,
        'pubspec.yaml',
      );

      final AssetId outputId = AssetId(
        buildStep.inputId.package,
        'lib/pubspec.dart',
      );

      final String contents = await buildStep.readAsString(inputId);
      final String source = convertPubspec(contents);
      buildStep.writeAsString(outputId, source);
    }
  }
}

String outputStr(String s) {
  s = s.trim();
  s = s.replaceAll(r'\', r'\\');
  s = s.replaceAll('\n', r'\n');
  s = s.replaceAll('\r', '');
  s = s.replaceAll("'", r"\'");
  return "'$s'";
}

String convertPubspec(String source) {
  final dynamic data = loadYaml(source);
  final List<String> output = <String>[];

  output.add('// This file is generated automatically, do not modify');

  final List<String> authors = <String>[];

  if (data is Map) {
    for (MapEntry<dynamic, dynamic> v in data.entries) {
      switch (v.key) {
        case 'version':
          final List<String> splitted = v.value.split('+');
          output.add('const String version = ${outputStr(splitted.first)};');
          final int build = splitted.length > 1 ? int.parse(splitted[1]) : 0;
          output.add('const int build = $build;');
          break;
        case 'author':
          authors.add(outputStr(v.value));
          break;
        case 'authors':
          for (String author in v.value) {
            authors.add(outputStr(author));
          }
          break;
        default:
          if (v.value is String) {
            output.add('const String ${v.key} = ${outputStr(v.value)};');
          } else if (v.value is int) {
            output.add('const int ${v.key} = ${v.value};');
          } else if (v.value is double) {
            output.add('const double ${v.key} = ${v.value};');
          } else if (v.value is bool) {
            output.add('const bool ${v.key} = ${v.value};');
          }
      }
    }

    output.add('const List<String> authors = <String>[${authors.join(',')},];');
  }

  return DartFormatter().format(output.join('\n\n')).toString();
}
