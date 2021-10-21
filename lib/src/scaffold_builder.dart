/*
 * Copyright (C) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

/// Scaffold used around all pages.
typedef ScaffoldBuilder = Widget Function(
  BuildContext context,
  Widget title,
  Widget child,
);

/// This is the default builder for the Scaffold
/// that is used around all pages.
Widget defaultScaffoldBuilder(
    BuildContext context, Widget title, Widget child) {
  if (isCupertino(context)) {
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: title,
      ),
      child: Theme(
        data: themeFromCupertino(theme),
        child: SafeArea(
          child: Material(
            child: child,
          ),
        ),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: title,
    ),
    body: child,
  );
}
