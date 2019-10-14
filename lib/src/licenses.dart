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
}) {
  assert(context != null);

  if (_isCupertino(context)) {
    Navigator.push(
        context,
        CupertinoPageRoute<void>(
            builder: (BuildContext context) => LicenseListPage(
                  title: title,
                )));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => LicenseListPage(
                  title: title,
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
  }) : super(key: key);

  final Widget title;

  @override
  _LicenseListPageState createState() => _LicenseListPageState();
}

class _LicenseListPageState extends State<LicenseListPage> {
  @override
  void initState() {
    super.initState();
    _initLicenses();
    Template.populateValues().then((Map<String, String> map) {
      setState(() {
        _values = map;
      });
    });
  }

  List<Widget> _licenses;
  Map<String, String> _values;

  Future<void> _initLicenses() async {
    final Set<String> packages = <String>{};
    final List<LicenseEntry> lisenses = <LicenseEntry>[];

    await for (LicenseEntry license in LicenseRegistry.licenses) {
      packages.addAll(license.packages);

      lisenses.add(license);
    }

    final List<Widget> licenseWidgets = <Widget>[];

    final List<String> sortedPackages = packages.toList()
      ..sort(
        (String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()),
      );

    for (String package in sortedPackages) {
      String exerpt;
      for (LicenseEntry license in lisenses) {
        if (license.packages.contains(package)) {
          exerpt = license.paragraphs.first.text.split('.').first;
          break;
        }
      }

      String packageName = '';
      for (String word in package.split('_')) {
        packageName += word[0].toUpperCase() + word.substring(1) + ' ';
      }

      licenseWidgets.add(
        ListTile(
          title: Text(packageName),
          subtitle: Text(exerpt),
          onTap: () {
            final LicenseDetail Function(BuildContext context) builder =
                (BuildContext context) {
              final List<LicenseParagraph> paragraphs = <LicenseParagraph>[];

              for (LicenseEntry license in lisenses) {
                if (license.packages.contains(package)) {
                  paragraphs.addAll(license.paragraphs);
                }
              }

              return LicenseDetail(
                package: packageName,
                paragraphs: paragraphs,
              );
            };

            if (_isCupertino(context)) {
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
    final List<Widget> contents = <Widget>[];

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

    final Widget body = Localizations.override(
      locale: const Locale('en', 'US'),
      context: context,
      child: DefaultTextStyle(
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
      ),
    );

    if (_isCupertino(context)) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: widget.title ?? const Text('Licenses'),
        ),
        child: Material(child: body),
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
