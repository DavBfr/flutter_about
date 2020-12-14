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
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Flow;

String defaultApplicationName(BuildContext context) {
  // This doesn't handle the case of the application's title dynamically
  // changing. In theory, we should make Title expose the current application
  // title using an InheritedWidget, and so forth. However, in practice, if
  // someone really wants their application title to change dynamically, they
  // can provide an explicit applicationName to the widgets defined in this
  // file, instead of relying on the default.
  final ancestorTitle = context.findAncestorWidgetOfExactType<Title>();
  return ancestorTitle?.title ??
      Platform.resolvedExecutable.split(Platform.pathSeparator).last;
}

String defaultApplicationVersion(BuildContext context) {
  return 'Version {{ version }}';
}

Widget? defaultApplicationIcon(BuildContext context) {
  return null;
}

bool isCupertino(BuildContext context) {
  final ct = CupertinoTheme.of(context);

  return !(ct is MaterialBasedCupertinoThemeData);
}

ThemeData themeFromCupertino(CupertinoThemeData theme) {
  return ThemeData(
    brightness: theme.brightness,
    canvasColor: theme.barBackgroundColor,
    primaryColor: theme.primaryColor,
    accentColor: theme.primaryContrastingColor,
  );
}
