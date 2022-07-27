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

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'markdown.dart';
import 'scaffold_builder.dart';

/// A [ListTile] that displays the provided markdown template in a new page.
class MarkdownPageListTile extends StatelessWidget {
  /// Creates a list tile for showing a markdown page.
  ///
  /// The title and filename of the markdown template are required.
  const MarkdownPageListTile({
    Key? key,
    this.icon,
    required this.title,
    this.scaffoldBuilder,
    this.applicationName,
    this.applicationIcon,
    this.useMustache,
    required this.filename,
    this.mustacheValues,
    this.tapHandler,
    this.styleSheet,
    this.imageDirectory,
    this.blockSyntaxes,
    this.trailing,
    this.inlineSyntaxes,
    this.extensionSet,
    this.imageBuilder,
    this.checkboxBuilder,
    this.builders = const {},
    this.fitContent = true,
    this.selectable = false,
    this.shrinkWrap = true,
    this.styleSheetTheme = MarkdownStyleSheetBaseTheme.material,
    this.syntaxHighlighter,
  }) : super(key: key);

  /// The icon to show for this drawer item.
  ///
  /// By default no icon is shown.
  ///
  /// This is not necessarily the same as the image shown in the dialog box
  /// itself; which is controlled by the [applicationIcon] property.
  final Widget? icon;

  /// The label to show on this drawer item.
  ///
  /// Defaults to a text widget that says "About Foo" where "Foo" is the
  /// application name specified by [applicationName].
  final Widget title;

  /// The builder for the Scaffold around the content.
  ///
  /// Defaults to [defaultScaffoldBuilder] if not set.
  final ScaffoldBuilder? scaffoldBuilder;

  /// The name of the application.
  ///
  /// This string is used in the default label for this drawer item (see
  /// [title]) and as the caption of the [AboutContent] that is shown.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String? applicationName;

  /// The markdown asset file to load
  final String filename;

  /// Whether to replace {{ }} strings with [mustacheValues]
  final bool? useMustache;

  /// Values to replace in the texts
  final Map<String, String>? mustacheValues;

  /// Icon of the application
  final Widget? applicationIcon;

  final Widget? trailing;

  /// The handler that handles taps on links in the template.
  /// Defaults to [UrlMarkdownTapHandler].
  final MarkdownTapHandler? tapHandler;

  /// Defines which [TextStyle] objects to use for which Markdown elements.
  final MarkdownStyleSheet? styleSheet;

  /// The base directory holding images referenced by Img tags with local or network file paths.
  final String? imageDirectory;

  /// Collection of custom block syntax types to be used parsing the Markdown data.
  final List<md.BlockSyntax>? blockSyntaxes;

  /// Collection of custom inline syntax types to be used parsing the Markdown data.
  final List<md.InlineSyntax>? inlineSyntaxes;

  /// Markdown syntax extension set
  ///
  /// Defaults to [md.ExtensionSet.gitHubFlavored]
  final md.ExtensionSet? extensionSet;

  /// Call when build an image widget.
  final MarkdownImageBuilder? imageBuilder;

  /// Call when build a checkbox widget.
  final MarkdownCheckboxBuilder? checkboxBuilder;

  /// Render certain tags, usually used with [extensionSet]
  ///
  /// For example, we will add support for `sub` tag:
  ///
  /// ```dart
  /// builders: {
  ///   'sub': SubscriptBuilder(),
  /// }
  /// ```
  ///
  /// The `SubscriptBuilder` is a subclass of [MarkdownElementBuilder].
  final Map<String, MarkdownElementBuilder> builders;

  /// Whether to allow the widget to fit the child content.
  final bool fitContent;

  /// If true, the text is selectable.
  ///
  /// Defaults to false.
  final bool selectable;

  /// See [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// Setting to specify base theme for MarkdownStyleSheet
  ///
  /// Default to [MarkdownStyleSheetBaseTheme.material]
  final MarkdownStyleSheetBaseTheme styleSheetTheme;

  /// The syntax highlighter used to color text in `pre` elements.
  ///
  /// If null, the [MarkdownStyleSheet.code] style is used for `pre` elements.
  final SyntaxHighlighter? syntaxHighlighter;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    return ListTile(
      leading: icon,
      title: title,
      trailing: trailing ??
          Icon(
            Directionality.of(context) == TextDirection.ltr
                ? Icons.chevron_right
                : Icons.chevron_left,
          ),
      onTap: () {
        showMarkdownPage(
          applicationIcon: applicationIcon,
          context: context,
          applicationName: applicationName,
          filename: filename,
          title: title,
          scaffoldBuilder: scaffoldBuilder,
          useMustache: useMustache,
          mustacheValues: mustacheValues,
          tapHandler: tapHandler,
          styleSheet: styleSheet,
          imageDirectory: imageDirectory,
          blockSyntaxes: blockSyntaxes,
          inlineSyntaxes: inlineSyntaxes,
          extensionSet: extensionSet,
          imageBuilder: imageBuilder,
          checkboxBuilder: checkboxBuilder,
          builders: builders,
          fitContent: fitContent,
          selectable: selectable,
          shrinkWrap: shrinkWrap,
          styleSheetTheme: styleSheetTheme,
          syntaxHighlighter: syntaxHighlighter,
        );
      },
    );
  }
}
