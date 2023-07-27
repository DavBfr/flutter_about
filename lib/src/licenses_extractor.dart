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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'license_detail.dart';
import 'utils.dart';

class PackageLicense {
  PackageLicense({
    required this.name,
    required this.excerpt,
    required this.paragraphs,
  });

  final String name;

  final String excerpt;

  final List<LicenseParagraph> paragraphs;

  String get license => paragraphs
      .map((e) => e is LicenseParagraphSeparator ? '' : e.text)
      .join('\n\n');
}

Stream<PackageLicense> extractPackages(BuildContext context) async* {
  final packages = <String>{};
  final licenses = <LicenseEntry>[];

  await for (LicenseEntry license in LicenseRegistry.licenses) {
    packages.addAll(license.packages);

    licenses.add(license);
  }

  final sortedPackages = packages.toList()
    ..sort(
      (String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()),
    );

  final localIsCupertino = isCupertino(context);

  for (final package in sortedPackages) {
    final excerpts = <String>[];
    for (final license in licenses) {
      if (license.packages.contains(package)) {
        final p = license.paragraphs.first.text.trim();
        // Third party such as `asn1lib`, the license is a link
        final reg = RegExp(p.startsWith('http') ? r' |,|，' : r'\.|。');
        var excerpt = p.split(reg).first.trim();
        if (excerpt.startsWith('//') || excerpt.startsWith('/*')) {
          // Ignore symbol of comment in LICENSE file
          excerpt = excerpt.substring(2).trim();
        }
        if (excerpt.length > 70) {
          // Avoid sub title too long
          excerpt = '${excerpt.substring(0, 70)}...';
        }
        excerpts.add(excerpt);
      }
    }

    final String excerpt;

    if (localIsCupertino) {
      excerpt = excerpts.length > 1
          ? '${excerpts.length} licenses.'
          : excerpts.join('\n');
    } else {
      excerpt = excerpts.length > 1
          ? MaterialLocalizations.of(context)
              .licensesPackageDetailText(excerpts.length)
          : excerpts.join('\n');
    }

    // Do not handle the package name to avoid unpredictable problems
    final packageName = package;

    final paragraphs = <LicenseParagraph>[];

    for (final license in licenses) {
      if (license.packages.contains(package)) {
        paragraphs.addAll(license.paragraphs);
        paragraphs.add(LicenseParagraphSeparator());
      }
    }

    if (paragraphs.isNotEmpty) {
      paragraphs.removeLast();
    }

    yield PackageLicense(
      name: packageName,
      excerpt: excerpt,
      paragraphs: paragraphs,
    );
  }
}
