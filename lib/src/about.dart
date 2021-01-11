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
import 'dart:io';

import 'package:about/src/scaffold_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Flow;

import 'about_content.dart';
import 'utils.dart';

/// An about box. This is a dialog box with the application's icon, name,
/// version number, and copyright, plus a button to show licenses for software
/// used by the application.
///
/// To show an [AboutPage], use [showAboutPage].
///
/// If the application has a [Drawer], the [AboutPageListTile] widget can make the
/// process of showing an about dialog simpler.
///
/// The [AboutPage] shown by [showAboutPage] includes a button that calls
/// [showLicensePage].
///
/// The licenses shown on the [MarkdownPage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
class AboutPage extends StatelessWidget {
  /// Creates an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const AboutPage({
    Key? key,
    this.title,
    this.scaffoldBuilder,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.applicationDescription,
    this.dialog = false,
    this.children,
    this.values = const {},
  }) : super(key: key);

  /// The title of the page.
  ///
  /// Defaults to a Text widget with the value of [Title.title],
  /// if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final Widget? title;

  /// The builder for the Scaffold around the content.
  ///
  /// Defaults to [defaultScaffoldBuilder] if not set.
  final ScaffoldBuilder? scaffoldBuilder;

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String? applicationName;

  /// The version of this build of the application.
  ///
  /// This string is shown under the application name.
  ///
  /// Defaults to the empty string.
  final String? applicationVersion;

  /// The icon to show next to the application name.
  ///
  /// By default no icon is shown.
  ///
  /// Typically this will be an [ImageIcon] widget. It should honor the
  /// [IconTheme]'s [IconThemeData.size].
  final Widget? applicationIcon;

  /// A string to show in small print.
  ///
  /// Typically this is a copyright notice.
  ///
  /// Defaults to the empty string.
  final String? applicationLegalese;

  /// A widget to show the app description.
  ///
  /// Defaults null.
  final Widget? applicationDescription;

  /// Show a dialog instead of a fullscreen page
  final bool dialog;

  /// Widgets to add to the dialog box after the name, version, and legalese.
  ///
  /// This could include a link to a Web site, some descriptive text, credits,
  /// or other information to show in the about box.
  ///
  /// Defaults to nothing.
  final List<Widget>? children;

  /// Template replacement values
  final Map<String, String> values;

  @override
  Widget build(BuildContext context) {
    final name = applicationName ?? defaultApplicationName(context);
    final _title = title ??
        Text(MaterialLocalizations.of(context).aboutListTileTitle(name));

    Widget body = AboutContent(
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
      applicationDescription: applicationDescription,
      children: children,
      values: values,
    );

    if (dialog) {
      if (isCupertino(context)) {
        body = SafeArea(
          child: Material(
            child: body,
          ),
        );
      }

      return SimpleDialog(
        title: _title,
        children: <Widget>[
          body,
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      );
    }

    return (scaffoldBuilder ?? defaultScaffoldBuilder)(context, _title, body);
  }
}

/// Displays an [AboutPage], which describes the application and provides a
/// button to show licenses for software used by the application.
///
/// The arguments correspond to the properties on [AboutPage].
///
/// If the application has a [Drawer], consider using [AboutPageListTile] instead
/// of calling this directly.
///
/// If you do not need an about box in your application, you should at least
/// provide an affordance to call [showLicensePage].
///
/// The licenses shown on the [MarkdownPage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
///
/// The `context` argument is passed to [showDialog], the documentation for
/// which discusses how it is used.
Future<void> showAboutPage({
  required BuildContext context,
  Widget? title,
  ScaffoldBuilder? scaffoldBuilder,
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  Widget? applicationDescription,
  bool dialog = false,
  List<Widget>? children,
  Map<String, String> values = const {},
}) async {
  final page = AboutPage(
    title: title,
    scaffoldBuilder: scaffoldBuilder,
    applicationName: applicationName,
    applicationVersion: applicationVersion,
    applicationIcon: applicationIcon,
    applicationLegalese: applicationLegalese,
    applicationDescription: applicationDescription,
    dialog: dialog,
    children: children,
    values: values,
  );

  if (dialog) {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return page;
      },
    );
  }

  if (isCupertino(context)) {
    return await Navigator.of(context).push<void>(
      CupertinoPageRoute(
        builder: (context) => page,
      ),
    );
  }

  return await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
