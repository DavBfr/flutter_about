/*
 * Copyright (C) 2019, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:about/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test AboutPage Material', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AboutPage(
        applicationVersion: '1.0',
        applicationLegalese: 'Copyright © David PHAM-VAN, {{ year }}',
        applicationDescription: const Text(
          'Displays an About dialog, which describes the application.',
        ),
        children: <Widget>[
          MarkdownPageListTile(
            icon: Icon(Icons.list),
            title: const Text('Changelog'),
            filename: 'CHANGELOG.md',
          ),
          LicensesPageListTile(
            icon: Icon(Icons.favorite),
          ),
        ],
        applicationIcon: const SizedBox(
          width: 100,
          height: 100,
          child: FlutterLogo(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test AboutPage Cupertino', (WidgetTester tester) async {
    await tester.pumpWidget(CupertinoApp(
      home: AboutPage(
        applicationVersion: '1.0',
        applicationLegalese: 'Copyright © David PHAM-VAN, {{ year }}',
        applicationDescription: const Text(
          'Displays an About dialog, which describes the application.',
        ),
        children: <Widget>[
          MarkdownPageListTile(
            icon: Icon(Icons.list),
            title: const Text('Changelog'),
            filename: 'CHANGELOG.md',
          ),
          LicensesPageListTile(
            title: const Text('Licenses'),
            icon: Icon(Icons.favorite),
          ),
        ],
        applicationIcon: const SizedBox(
          width: 100,
          height: 100,
          child: FlutterLogo(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test LicenseListPage Material', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LicenseListPage(),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test LicenseListPage Cupertino', (WidgetTester tester) async {
    await tester.pumpWidget(const CupertinoApp(
      home: LicenseListPage(),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test LicenseDetail Material', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LicenseDetail(
        package: 'About',
        paragraphs: <LicenseParagraph>[
          LicenseParagraph('para1', LicenseParagraph.centeredIndent),
          LicenseParagraph('para2', 0),
          LicenseParagraph('para2', 1),
          LicenseParagraph('para2', 2),
        ],
      ),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test LicenseDetail Cupertino', (WidgetTester tester) async {
    await tester.pumpWidget(const CupertinoApp(
      home: LicenseDetail(
        package: 'About',
        paragraphs: <LicenseParagraph>[
          LicenseParagraph('para1', LicenseParagraph.centeredIndent),
          LicenseParagraph('para2', 0),
        ],
      ),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test AboutPageListTile Material', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: AboutPageListTile(),
      ),
    ));
    await tester.pumpAndSettle();
  });

  testWidgets('test MarkdownPage Material', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MarkdownPage(
          filename: '../CHANGELOG.md',
        ),
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('test MarkdownPage Cupertino', (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: MarkdownPage(
          filename: '../README.md',
        ),
      ),
    );
    await tester.pumpAndSettle();
  });
}
