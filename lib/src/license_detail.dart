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

// ignore_for_file: public_member_api_docs

import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scaffold_builder.dart';

class LicenseParagraphSeparator implements LicenseParagraph {
  LicenseParagraphSeparator();

  @override
  int get indent => 0;

  @override
  String get text => 'SEP';
}

class LicenseDetail extends StatelessWidget {
  const LicenseDetail({
    super.key,
    this.package,
    this.scaffoldBuilder,
    required this.paragraphs,
  });

  /// The builder for the Scaffold around the content.
  ///
  /// Defaults to [defaultScaffoldBuilder] if not set.
  final ScaffoldBuilder? scaffoldBuilder;

  final String? package;

  final List<LicenseParagraph> paragraphs;

  Widget _buildBody(BuildContext context) {
    final localLicenses = <Widget>[];

    for (final paragraph in paragraphs) {
      if (paragraph is LicenseParagraphSeparator) {
        localLicenses.add(const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Divider(),
        ));
      } else if (paragraph.indent == LicenseParagraph.centeredIndent) {
        localLicenses.add(
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              paragraph.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        assert(paragraph.indent >= 0);
        localLicenses.add(
          Padding(
            padding: EdgeInsetsDirectional.only(
                top: 8, start: 16.0 * paragraph.indent),
            child: Text(
              paragraph.text,
              textAlign: TextAlign.justify,
            ),
          ),
        );
      }
    }

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodySmall!,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          children: localLicenses,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (scaffoldBuilder ?? defaultScaffoldBuilder)(
      context,
      Text(package!),
      _buildBody(context),
    );
  }
}
