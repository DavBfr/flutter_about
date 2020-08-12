/*
 * Copyright (C) 2019, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';

import 'package:markdown/markdown.dart' as md;

Iterable<String> getCode(List<md.Node> nodes, [bool isCode = false]) sync* {
  if (nodes == null) {
    return;
  }

  for (final node in nodes) {
    if (node is md.Element) {
      // print(node.tag);
      // print(node.attributes);
      yield* getCode(node.children,
          node.tag == 'code' && node.attributes['class'] == 'language-dart');
    } else if (node is md.Text) {
      if (isCode) {
        yield '// ------------';
        yield node.text;
        yield '// ------------';
      }
    } else {
      print(node);
    }
  }
}

void main() {
  final document = md.Document(
    extensionSet: md.ExtensionSet.commonMark,
    encodeHtml: false,
  );

  final output = File('test/readme_test.dart');
  final st = output.openWrite();
  st.writeln('''import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void readme(BuildContext context) {''');

  final data = File('README.md').readAsStringSync();
  final lines = data.replaceAll('\r\n', '\n').split('\n');
  final parsedLines = document.parseLines(lines);
  final code = getCode(parsedLines);

  st.writeln(code.join('\n'));

  st.writeln('''}

class Btn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => readme(context),
    );
  }
}

void main() {
  testWidgets('test showAboutPage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Btn()));
    await tester.pumpAndSettle();
  });
}''');

  st.close();
}
