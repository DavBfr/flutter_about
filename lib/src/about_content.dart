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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'template.dart';
import 'utils.dart';

/// An about box. This is a dialog box with the application's icon, name,
/// version number, and copyright, plus a button to show licenses for software
/// used by the application.
///
/// To show an [AboutContent], use [showAboutPage].
///
/// If the application has a [Drawer], the [AboutPageListTile] widget can make the
/// process of showing an about dialog simpler.
///
/// The [AboutContent] shown by [showAboutPage] includes a button that calls
/// [showLicensePage].
///
/// The licenses shown on the [MarkdownPage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
class AboutContent extends StatefulWidget {
  /// Creates an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const AboutContent({
    super.key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.applicationDescription,
    this.children,
    this.values = const {},
    this.orientation = Axis.vertical,
  });

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

  /// Widgets to add to the dialog box after the name, version, and legalese.
  ///
  /// This could include a link to a Web site, some descriptive text, credits,
  /// or other information to show in the about box.
  ///
  /// Defaults to nothing.
  final List<Widget>? children;

  /// Template replacement values
  final Map<String, String> values;

  final Axis orientation;

  @override
  AboutContentState createState() => AboutContentState();
}

class AboutContentState extends State<AboutContent> {
  @override
  Widget build(BuildContext context) {
    final name = widget.applicationName ?? defaultApplicationName(context);

    final icon = widget.applicationIcon ?? defaultApplicationIcon(context);

    final version = Template(
      widget.applicationVersion ?? defaultApplicationVersion(context),
    ).render(widget.values);

    final textAlign =
        widget.orientation == Axis.vertical ? TextAlign.center : null;

    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: ListBody(
        children: <Widget>[
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: textAlign,
          ),
          Text(
            version,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: textAlign,
          ),
          if (widget.applicationLegalese != null)
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                Template(widget.applicationLegalese!).render(widget.values),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: textAlign,
              ),
            ),
          if (widget.applicationDescription != null) ...[
            const Divider(),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: widget.applicationDescription,
            ),
            const Divider(),
          ],
        ],
      ),
    );

    if (widget.orientation == Axis.vertical) {
      return SingleChildScrollView(
        child: ListBody(
          children: [
            if (icon != null) ...[
              const SizedBox(height: 10),
              IconTheme(data: const IconThemeData(size: 48), child: icon),
            ],
            body,
            if (widget.children != null) ...widget.children!,
          ],
        ),
      );
    }

    final themeData = Theme.of(context);

    return SingleChildScrollView(
      child: ListBody(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (icon != null)
                IconTheme(data: themeData.iconTheme, child: icon),
              Expanded(child: body),
            ],
          ),
          if (widget.children != null) ...widget.children!,
        ],
      ),
    );
  }
}
