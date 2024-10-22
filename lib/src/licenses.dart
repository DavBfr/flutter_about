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

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'license_detail.dart';
import 'licenses_extractor.dart';
import 'scaffold_builder.dart';
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
  required BuildContext context,
  Widget? title,
  ScaffoldBuilder? scaffoldBuilder,
  Map<String, String>? values,
}) {
  if (isCupertino(context)) {
    Navigator.push(
        context,
        CupertinoPageRoute<void>(
            builder: (BuildContext context) => LicenseListPage(
                  title: title,
                  scaffoldBuilder: scaffoldBuilder,
                  values: values,
                )));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => LicenseListPage(
                  title: title,
                  scaffoldBuilder: scaffoldBuilder,
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
    super.key,
    this.title,
    this.scaffoldBuilder,
    this.values,
  });

  /// The page title
  final Widget? title;

  /// The builder for the Scaffold around the content.
  ///
  /// Defaults to [defaultScaffoldBuilder] if not set.
  final ScaffoldBuilder? scaffoldBuilder;

  /// Template replacement values
  final Map<String, String>? values;

  @override
  LicenseListPageState createState() => LicenseListPageState();
}

class LicenseListPageState extends State<LicenseListPage> {
  @override
  void initState() {
    _initLicenses();
    super.initState();
  }

  List<Widget>? _licenses;

  Future<void> _initLicenses() async {
    final licenseWidgets = <Widget>[];

    await for (final package in extractPackages(context)) {
      licenseWidgets.add(
        ListTile(
          title: Text(package.name),
          subtitle: Text(package.excerpt),
          trailing: Icon(
            Directionality.of(context) == TextDirection.ltr
                ? Icons.chevron_right
                : Icons.chevron_left,
          ),
          onTap: () {
            Widget builder(BuildContext context) {
              return LicenseDetail(
                  package: package.name,
                  paragraphs: package.paragraphs,
                  scaffoldBuilder: widget.scaffoldBuilder);
            }

            if (isCupertino(context)) {
              Navigator.push(
                context,
                CupertinoPageRoute<void>(builder: builder),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: builder),
              );
            }
          },
        ),
      );
    }

    if (mounted) {
      setState(() {
        _licenses = licenseWidgets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.scaffoldBuilder ?? defaultScaffoldBuilder)(
      context,
      widget.title ?? const Text('Licenses'),
      DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: SafeArea(
          bottom: false,
          child: _licenses == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  children: _licenses!,
                ),
        ),
      ),
    );
  }
}
