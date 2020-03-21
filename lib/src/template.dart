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

@immutable
class Template {
  const Template(
    this.source,
  ) : assert(source != null);

  final String source;

  String render(Map<String, String> values) {
    return source.replaceAllMapped(RegExp(r'{{\s*(\w+)\s*}}'), (Match match) {
      if (values.containsKey(match.group(1))) {
        return values[match.group(1)];
      }
      assert(false, 'Value "${match.group(1)}" not found');
      return '"${match.group(1)}"';
    });
  }

  static Map<String, String> map;

  static Future<Map<String, String>> populateValues() async {
    if (map != null) {
      return map;
    }

    map = <String, String>{};

    map['year'] = DateTime.now().year.toString();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      map['operatingSystem'] = Platform.operatingSystem;

      final info = await package_info.PackageInfo.fromPlatform();
      map['version'] = info.version;
      map['buildNumber'] = info.buildNumber;
      map['packageName'] = info.packageName;
      map['appName'] = info.appName;
    } on UnsupportedError {
      print('Error getting operatingSystem');
    } on PlatformException {
      print('Error getting Package Info');
    } on MissingPluginException {
      print('Error getting Package Info: Not implemented');
    }

    return map;
  }
}
