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

import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:about/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'scaffold_builder.dart';
import 'template.dart';
import 'utils.dart';

/// Show a markdown document in a screen
void showMarkdownPage({
  required BuildContext context,
  Widget? title,
  ScaffoldBuilder? scaffoldBuilder,
  String? applicationName,
  Widget? applicationIcon,
  required String filename,
  bool? useMustache,
  Map<String, String>? mustacheValues,
  MarkdownTapHandler? tapHandler,
  MarkdownStyleSheet? styleSheet,
  String? imageDirectory,
  List<md.BlockSyntax>? blockSyntaxes,
  List<md.InlineSyntax>? inlineSyntaxes,
  md.ExtensionSet? extensionSet,
  MarkdownImageBuilder? imageBuilder,
  MarkdownCheckboxBuilder? checkboxBuilder,
  Map<String, MarkdownElementBuilder> builders = const {},
  bool fitContent = true,
  bool selectable = false,
  bool shrinkWrap = true,
  MarkdownStyleSheetBaseTheme? styleSheetTheme,
  SyntaxHighlighter? syntaxHighlighter,
}) {
  final cupertino = isCupertino(context);

  styleSheetTheme ??= cupertino
      ? MarkdownStyleSheetBaseTheme.cupertino
      : MarkdownStyleSheetBaseTheme.material;

  final page = MarkdownPage(
    title: title,
    scaffoldBuilder: scaffoldBuilder,
    applicationName: applicationName,
    filename: filename,
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

  if (cupertino) {
    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  }
}

/// A page that shows a markdown document.
///
/// To show a [MarkdownPage], use [showMarkdownPage].
///
/// The [AboutContent] shown by [showAboutPage] and [AboutPageListTile] includes
/// a button that calls [showMarkdownPage].
///
/// The document shown on the [MarkdownPage]
class MarkdownTemplate extends StatefulWidget {
  /// Creates a page that shows a markdown document.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version and legalese values
  /// default to the empty string.
  const MarkdownTemplate({
    Key? key,
    this.applicationName,
    bool? useMustache,
    this.mustacheValues,
    required this.filename,
    MarkdownTapHandler? tapHandler,
    this.styleSheet,
    this.imageDirectory,
    this.blockSyntaxes,
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
  })  : useMustache = useMustache ?? mustacheValues != null,
        tapHandler = tapHandler ?? const UrlMarkdownTapHandler(),
        super(key: key);

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String? applicationName;

  /// The markdown asset file to load
  final String filename;

  /// Whether to replace {{ }} strings with [mustacheValues]
  final bool useMustache;

  /// Values to replace in the texts
  final Map<String, String>? mustacheValues;

  /// The handler that handles taps on links in the template.
  /// Defaults to [UrlMarkdownTapHandler].
  final MarkdownTapHandler tapHandler;

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
  _MarkdownTemplateState createState() => _MarkdownTemplateState();
}

class _MarkdownTemplateState extends State<MarkdownTemplate> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initMarkdown(context);
  }

  String? _md;

  Future<void> _initMarkdown(BuildContext context) async {
    if (_md != null) {
      return;
    }

    final locale = Localizations.localeOf(context)!;
    final bundle = DefaultAssetBundle.of(context);

    var md = '';

    final base = path.join(
      path.dirname(widget.filename),
      path.basenameWithoutExtension(widget.filename),
    );
    final ext = path.extension(widget.filename);

    for (final filename in <String>[
      '$base-$locale$ext',
      '$base-${locale.languageCode}$ext',
      '${widget.filename}'
    ]) {
      try {
        assert(() {
          print('Try $filename');
          return true;
        }());
        md = await bundle.loadString(filename);
        print('Loaded $filename');
        break;
      } catch (e) {
        assert(() {
          md = e.toString();
          return true;
        }());
      }
    }

    md = _stripYamlHeader(md);

    if (widget.useMustache) {
      final map = <String, String>{};
      final name = widget.applicationName ?? defaultApplicationName(context);
      map['title'] = name;
      if (widget.mustacheValues != null) {
        map.addAll(widget.mustacheValues!);
      }
      md = Template(md).render(map);
    }

    setState(() {
      _md = md;
    });
  }

  String _stripYamlHeader(String data) {
    final regex = RegExp(r'^---\n(.*)---\n', dotAll: true);
    final match = regex.firstMatch(data);
    if (match == null) {
      return data;
    }

    return data.substring(match.end);
  }

  @override
  Widget build(BuildContext context) {
    if (_md == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MarkdownBody(
      data: _md!,
      onTapLink: (text, href, title) =>
          widget.tapHandler.onTap(context, text, href, title),
      styleSheet: widget.styleSheet,
      blockSyntaxes: widget.blockSyntaxes,
      builders: widget.builders,
      checkboxBuilder: widget.checkboxBuilder,
      extensionSet: widget.extensionSet,
      fitContent: widget.fitContent,
      imageBuilder: widget.imageBuilder,
      imageDirectory: widget.imageDirectory,
      inlineSyntaxes: widget.inlineSyntaxes,
      selectable: widget.selectable,
      shrinkWrap: widget.shrinkWrap,
      styleSheetTheme: widget.styleSheetTheme,
      syntaxHighlighter: widget.syntaxHighlighter,
    );
  }
}

/// A page that shows a markdown document.
///
/// To show a [MarkdownPage], use [showMarkdownPage].
///
/// The [AboutContent] shown by [showAboutPage] and [AboutPageListTile] includes
/// a button that calls [showMarkdownPage].
///
/// The document shown on the [MarkdownPage]
class MarkdownPage extends StatefulWidget {
  /// Creates a page that shows a markdown document.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version and legalese values
  /// default to the empty string.
  const MarkdownPage({
    Key? key,
    this.title,
    this.scaffoldBuilder,
    this.applicationName,
    bool? useMustache,
    this.mustacheValues,
    required this.filename,
    this.tapHandler,
    this.styleSheet,
    this.imageDirectory,
    this.blockSyntaxes,
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
  })  : useMustache = useMustache ?? mustacheValues != null,
        super(key: key);

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String? applicationName;

  /// The markdown asset file to load
  final String filename;

  /// The screen title
  final Widget? title;

  /// The builder for the Scaffold around the content.
  ///
  /// Defaults to [defaultScaffoldBuilder] if not set.
  final ScaffoldBuilder? scaffoldBuilder;

  /// Whether to replace {{ }} strings with [mustacheValues]
  final bool useMustache;

  /// Values to replace in the texts
  final Map<String, String>? mustacheValues;

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
  _MarkdownPageState createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.applicationName ?? defaultApplicationName(context);

    return (widget.scaffoldBuilder ?? defaultScaffoldBuilder)(
      context,
      widget.title ?? Text(name),
      Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: SafeArea(
              child: MarkdownTemplate(
                filename: widget.filename,
                applicationName: name,
                mustacheValues: widget.mustacheValues,
                useMustache: widget.useMustache,
                tapHandler: widget.tapHandler,
                styleSheet: widget.styleSheet,
                blockSyntaxes: widget.blockSyntaxes,
                builders: widget.builders,
                checkboxBuilder: widget.checkboxBuilder,
                extensionSet: widget.extensionSet,
                fitContent: widget.fitContent,
                imageBuilder: widget.imageBuilder,
                imageDirectory: widget.imageDirectory,
                inlineSyntaxes: widget.inlineSyntaxes,
                selectable: widget.selectable,
                shrinkWrap: widget.shrinkWrap,
                styleSheetTheme: widget.styleSheetTheme,
                syntaxHighlighter: widget.syntaxHighlighter,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Defines a handler that can intercept and handle taps on links
/// in markdown templates. Implement this or extend [UrlMarkdownTapHandler].
///
abstract class MarkdownTapHandler {
  /// Handles the tap on a link in the markdown page.
  FutureOr<void> onTap(
      BuildContext context, String text, String href, String title);
}

/// The default implementation of a [MarkdownTapHandler].
/// It simply tries to open the URL with a system handler.
/// Does nothing if the URL scheme is not supported by the system.
class UrlMarkdownTapHandler implements MarkdownTapHandler {
  /// Creates a [UrlMarkdownTapHandler]
  const UrlMarkdownTapHandler();

  @override
  Future<void> onTap(
    BuildContext context,
    String text,
    String href,
    String title,
  ) async {
    if (await url_launcher.canLaunch(href)) {
      await url_launcher.launch(href);
    } else {
      print('Could not launch $href');
    }
  }
}
