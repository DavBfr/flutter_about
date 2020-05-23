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

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:flutter/rendering.dart';

import 'license_detail.dart';
import 'utils.dart';

/// Displays a [LicenseListPage], which shows licenses for software used by the
/// application.
///
/// The arguments correspond to the properties on [LicenseListPage].
///
/// If the application has a [Drawer], consider using [AboutPageListTile] instead
/// of calling this directly.
///
/// The [AboutContent] shown by [showAboutPage] includes a button that calls
/// [showLicensePage].
///
/// The licenses shown on the [LicenseListPage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
void showLicensePage({
  @required BuildContext context,
  Widget title,
  Map<String, String> values,
}) {
  assert(context != null);

  if (isCupertino(context)) {
    Navigator.push(
        context,
        CupertinoPageRoute<void>(
            builder: (BuildContext context) => LicenseListPage(
                  title: title,
                  values: values,
                )));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => LicenseListPage(
                  title: title,
                  values: values,
                )));
  }
}

/// A page that shows licenses for software used by the application.
///
/// To show a [LicenseListPage], use [showLicensePage].
///
/// The [AboutContent] shown by [showAboutPage] and [AboutPageListTile] includes
/// a button that calls [showLicensePage].
///
/// The licenses shown on the [LicenseListPage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
class LicenseListPage extends StatefulWidget {
  /// Creates a page that shows licenses for software used by the application.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version and legalese values
  /// default to the empty string.
  ///
  /// The licenses shown on the [LicenseListPage] are those returned by the
  /// [LicenseRegistry] API, which can be used to add more licenses to the list.
  const LicenseListPage({
    Key key,
    this.title,
    this.values,
  }) : super(key: key);

  /// The page title
  final Widget title;

  /// Template replacement values
  final Map<String, String> values;

  @override
  _LicenseListPageState createState() => _LicenseListPageState();
}

class _LicenseListPageState extends State<LicenseListPage> {
  @override
  void initState() {
    _initLicenses();
    super.initState();
  }

  List<Widget> _licenses;

  Future<void> _initLicenses() async {
    final packages = <String>{};
    final lisenses = <LicenseEntry>[];

    await for (LicenseEntry license in LicenseRegistry.licenses) {
      packages.addAll(license.packages);

      lisenses.add(license);
    }

    final licenseWidgets = <Widget>[];

    final sortedPackages = packages.toList()
      ..sort(
        (String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()),
      );

    for (final package in sortedPackages) {
      String exerpt;
      for (final license in lisenses) {
        if (license.packages.contains(package)) {
          final p = license.paragraphs.first.text.trim();
          // Third party such as `asn1lib`, the license is a link
          final reg = RegExp(p.startsWith('http') ? r' |,|，' : r'\.|。');
          exerpt = p.split(reg).first.trim();
          if (exerpt.startsWith('//') || exerpt.startsWith('/*')) {
            // Ignore symbol of comment in LICENSE file
            exerpt = exerpt.substring(2).trim();
          }
          if (exerpt.length > 70) {
            // Avoid sub title too long
            exerpt = exerpt.substring(0, 70) + '...';
          }
          break;
        }
      }

      // Do not handle the package name to avoid unpredictable problems
      final packageName = package;

      licenseWidgets.add(
        ListTile(
          title: Text(packageName),
          subtitle: Text(exerpt),
          onTap: () {
            final Function(BuildContext context) builder =
                (BuildContext context) {
              final paragraphs = <LicenseParagraph>[];

              for (final license in lisenses) {
                if (license.packages.contains(package)) {
                  paragraphs.addAll(license.paragraphs);
                }
              }

              return LicenseDetail(
                package: packageName,
                paragraphs: paragraphs,
              );
            };

            if (isCupertino(context)) {
              return Navigator.push(
                context,
                CupertinoPageRoute<void>(builder: builder),
              );
            } else {
              return Navigator.push(
                context,
                MaterialPageRoute<void>(builder: builder),
              );
            }
          },
        ),
      );
    }

    setState(() {
      _licenses = licenseWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contents = <Widget>[];

    if (_licenses == null) {
      contents.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      contents.addAll(_licenses);
    }

    final Widget body = DefaultTextStyle(
      style: Theme.of(context).textTheme.caption,
      child: SafeArea(
        bottom: false,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            children: contents,
          ),
        ),
      ),
    );

    if (isCupertino(context)) {
      final theme = CupertinoTheme.of(context);

      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: widget.title ?? const Text('Licenses'),
        ),
        child: Theme(
          data: themeFromCupertino(theme),
          child: Material(child: body),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.title ?? const Text('Licenses'),
      ),
      // All of the licenses page text is English. We don't want localized text
      // or text direction.
      body: body,
    );
  }
}
