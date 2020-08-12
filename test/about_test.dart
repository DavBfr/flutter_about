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

import 'package:about/about.dart';
import 'package:about/src/license_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/package_info');

void main() {
  setUpAll(() {
    _channel.setMockMethodCallHandler((methodCall) async {
      switch (methodCall.method) {
        case 'getAll':
          return {
            'appName': 'About Example',
            'packageName': 'about',
            'version': '1.0',
            'buildNumber': '1',
          };
        default:
          return null;
      }
    });
  });

  tearDownAll(() {
    _channel.setMockMethodCallHandler(null);
  });

  group('AboutPage', () {
    final widget = (ScaffoldBuilder scaffoldBuilder) => AboutPage(
          applicationLegalese: 'Copyright © David PHAM-VAN, {{ year }}',
          applicationDescription: const Text(
            'Displays an About dialog, which describes the application.',
          ),
          scaffoldBuilder: scaffoldBuilder,
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
        );

    testWidgets('Material', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget(null),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/about-page.material.png'),
      );
    });

    testWidgets('Cupertino', (WidgetTester tester) async {
      await tester.pumpWidget(CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: widget(null),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoApp),
        matchesGoldenFile('goldens/about-page.cupertino.png'),
      );
    });

    testWidgets('Custom', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget((context, title, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(items: [
              BottomNavigationBarItem(
                title: Text('Item 1'),
                icon: Icon(Icons.edit),
              ),
              BottomNavigationBarItem(
                title: Text('Item 2'),
                icon: Icon(Icons.email),
              ),
              BottomNavigationBarItem(
                title: Text('Item 3'),
                icon: Icon(Icons.add),
              ),
            ]),
          );
        }),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/about-page.custom.png'),
      );
    });
  });

  group('LicenseListPage', () {
    setUp(() {
      LicenseRegistry.addLicense(() => Stream.fromIterable([
            LicenseEntryWithLineBreaks(
              ['test'],
              'This is an example license text.',
            ),
          ]));
    });

    testWidgets('Material', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LicenseListPage(),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/license-list-page.material.png'),
      );
    });

    testWidgets('Cupertino', (WidgetTester tester) async {
      await tester.pumpWidget(const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: LicenseListPage(),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoApp),
        matchesGoldenFile('goldens/license-list-page.cupertino.png'),
      );
    });
  });

  group('LicenseDetail', () {
    testWidgets('Material', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        debugShowCheckedModeBanner: false,
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

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/license-detail.material.png'),
      );
    });

    testWidgets('Cupertino', (WidgetTester tester) async {
      await tester.pumpWidget(const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: LicenseDetail(
          package: 'About',
          paragraphs: <LicenseParagraph>[
            LicenseParagraph('para1', LicenseParagraph.centeredIndent),
            LicenseParagraph('para2', 0),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoApp),
        matchesGoldenFile('goldens/license-detail.cupertino.png'),
      );
    });
  });

  group('AboutPageListTile', () {
    testWidgets('Material', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
          child: AboutPageListTile(),
        ),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/about-page-list-tile.material.png'),
      );
    });
  });

  /// The markdown files can not be loaded since they are no assets.
  /// Additionally golden tests for files that change make no sense.
  /// TODO: Add some example markdown files to test assets and use here
  group('MarkdownPage', () {
    testWidgets('Material', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MarkdownPage(
          filename: '../CHANGELOG.md',
        ),
      ));
      await tester.pumpAndSettle();
    });

    testWidgets('Cupertino', (WidgetTester tester) async {
      await tester.pumpWidget(const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: MarkdownPage(
          filename: '../README.md',
        ),
      ));
      await tester.pumpAndSettle();
    });
  });
}
