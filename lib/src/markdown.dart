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

part of about;

void showMarkdownPage({
  @required BuildContext context,
  Widget title,
  String applicationName,
  Widget applicationIcon,
  @required String filename,
  bool useMustache,
  Map<String, String> mustacheValues,
}) {
  assert(context != null);
  if (_isCupertino(context)) {
    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (BuildContext context) => MarkdownPage(
          title: title,
          applicationName: applicationName,
          filename: filename,
          useMustache: useMustache,
          mustacheValues: mustacheValues,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MarkdownPage(
          title: title,
          applicationName: applicationName,
          filename: filename,
          useMustache: useMustache,
          mustacheValues: mustacheValues,
        ),
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
    Key key,
    this.applicationName,
    bool useMustache,
    this.mustacheValues,
    @required this.filename,
  })  : assert(filename != null),
        useMustache = useMustache ?? mustacheValues != null,
        super(key: key);

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String applicationName;

  final String filename;

  final bool useMustache;

  final Map<String, String> mustacheValues;

  @override
  MarkdownTemplateState createState() => MarkdownTemplateState();
}

class MarkdownTemplateState extends State<MarkdownTemplate> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initMarkdown(context);
  }

  String _md;

  Future<void> _initMarkdown(BuildContext context) async {
    if (_md != null) {
      return;
    }

    final Locale locale = Localizations.localeOf(context);
    final AssetBundle bundle = DefaultAssetBundle.of(context);

    String md = '';

    final String base = path.join(
      path.dirname(widget.filename),
      path.basenameWithoutExtension(widget.filename),
    );
    final String ext = path.extension(widget.filename);

    for (String filename in <String>[
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

    if (widget.useMustache) {
      final Map<String, String> map = <String, String>{};
      map.addAll(await Template.populateValues());
      final String name =
          widget.applicationName ?? _defaultApplicationName(context);
      map['title'] = name;
      if (widget.mustacheValues != null) {
        map.addAll(widget.mustacheValues);
      }
      print(map);
      md = Template(md).render(map);
    }

    setState(() {
      _md = md;
    });
  }

  Future<void> _launchURL(String href) async {
    if (await url_launcher.canLaunch(href)) {
      await url_launcher.launch(href);
    } else {
      print('Could not launch $href');
    }
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

    return MarkdownBody(data: _md, onTapLink: _launchURL);
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
    Key key,
    this.title,
    this.applicationName,
    bool useMustache,
    this.mustacheValues,
    @required this.filename,
  })  : assert(filename != null),
        useMustache = useMustache ?? mustacheValues != null,
        super(key: key);

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String applicationName;

  final String filename;

  final Widget title;

  final bool useMustache;

  final Map<String, String> mustacheValues;

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
    final String name =
        widget.applicationName ?? _defaultApplicationName(context);

    final Widget body = Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: SafeArea(
            child: MarkdownTemplate(
              filename: widget.filename,
              applicationName: name,
              mustacheValues: widget.mustacheValues,
              useMustache: widget.useMustache,
            ),
          ),
        ),
      ),
    );

    if (_isCupertino(context)) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(name),
        ),
        child: body,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.title ?? Text(name),
      ),
      body: body,
    );
  }
}
