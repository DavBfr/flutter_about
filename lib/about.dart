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

library about;

import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:package_info/package_info.dart' as package_info;
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

part 'src/about_content.dart';
part 'src/about_list_title.dart';
part 'src/about.dart';
part 'src/changelog_list_title.dart';
part 'src/changelog.dart';
part 'src/license_detail.dart';
part 'src/licenses_list_title.dart';
part 'src/licenses.dart';
part 'src/template.dart';
