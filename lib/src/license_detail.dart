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

class LicenseDetail extends StatelessWidget {
  const LicenseDetail({Key key, this.package, this.paragraphs})
      : super(key: key);

  final String package;

  final List<LicenseParagraph> paragraphs;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    final List<Widget> _licenses = <Widget>[];

    for (LicenseParagraph paragraph in paragraphs) {
      if (paragraph.indent == LicenseParagraph.centeredIndent) {
        _licenses.add(Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            paragraph.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        assert(paragraph.indent >= 0);
        _licenses.add(Padding(
          padding: EdgeInsetsDirectional.only(
              top: 8, start: 16.0 * paragraph.indent),
          child: Text(paragraph.text),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(package),
      ),
      body: Localizations.override(
        locale: const Locale('en', 'US'),
        context: context,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.caption,
          child: SafeArea(
            bottom: false,
            child: Scrollbar(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                children: _licenses,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
