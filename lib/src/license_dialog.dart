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

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'markdown.dart';

class LicenseDialog extends StatelessWidget {
  const LicenseDialog({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);

    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 500,
          child: MarkdownBody(
            data: text,
            softLineBreak: true,
            onTapLink: (text, href, title) =>
                const UrlMarkdownTapHandler().onTap(context, text, href, title),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            themeData.useMaterial3
                ? localizations.closeButtonLabel
                : localizations.closeButtonLabel.toUpperCase(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      scrollable: true,
    );
  }
}
