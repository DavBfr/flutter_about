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
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Flow;

import 'about.dart';
import 'utils.dart';

/// A [ListTile] that shows an about box.
///
/// This widget is often added to an app's [Drawer]. When tapped it shows
/// an about box dialog with [showAboutPage].
///
/// The about box will include a button that shows licenses for software used by
/// the application. The licenses shown are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
///
/// If your application does not have a [Drawer], you should provide an
/// affordance to call [showAboutPage] or (at least) [showLicensePage].
class AboutPageListTile extends StatelessWidget {
  /// Creates a list tile for showing an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const AboutPageListTile({
    Key key,
    this.icon = const Icon(null),
    this.title,
    this.child,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.applicationDescription,
    this.dialog = false,
    this.aboutBoxChildren,
    this.values,
  }) : super(key: key);

  /// The icon to show for this drawer item.
  ///
  /// By default no icon is shown.
  ///
  /// This is not necessarily the same as the image shown in the dialog box
  /// itself; which is controlled by the [applicationIcon] property.
  final Widget icon;

  /// The label to show on this drawer item.
  ///
  /// Defaults to a text widget that says "About Foo" where "Foo" is the
  /// application name specified by [applicationName].
  final Widget child;

  /// The name of the application.
  ///
  /// This string is used in the default label for this drawer item (see
  /// [child]) and as the caption of the [AboutContent] that is shown.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String applicationName;

  /// Small description of the application
  final Widget applicationDescription;

  /// The version of this build of the application.
  ///
  /// This string is shown under the application name in the [AboutContent].
  ///
  /// Defaults to the empty string.
  final String applicationVersion;

  /// The icon to show next to the application name in the [AboutContent].
  ///
  /// By default no icon is shown.
  ///
  /// Typically this will be an [ImageIcon] widget. It should honor the
  /// [IconTheme]'s [IconThemeData.size].
  ///
  /// This is not necessarily the same as the icon shown on the drawer item
  /// itself, which is controlled by the [icon] property.
  final Widget applicationIcon;

  /// A string to show in small print in the [AboutContent].
  ///
  /// Typically this is a copyright notice.
  ///
  /// Defaults to the empty string.
  final String applicationLegalese;

  /// Show a dialog instead of a fullscreen page
  final bool dialog;

  /// Widgets to add to the [AboutContent] after the name, version, and legalese.
  ///
  /// This could include a link to a Web site, some descriptive text, credits,
  /// or other information to show in the about box.
  ///
  /// Defaults to nothing.
  final List<Widget> aboutBoxChildren;

  /// Template replacement values
  final Map<String, String> values;

  /// The about page title
  final Widget title;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    return ListTile(
      leading: icon,
      title: child ??
          Text(
            MaterialLocalizations.of(context)?.aboutListTileTitle(
                  applicationName ?? defaultApplicationName(context),
                ) ??
                defaultApplicationName(context),
          ),
      onTap: () {
        showAboutPage(
          context: context,
          title: title,
          applicationName: applicationName,
          applicationVersion: applicationVersion,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
          applicationDescription: applicationDescription,
          dialog: dialog,
          children: aboutBoxChildren,
          values: values,
        );
      },
    );
  }
}
