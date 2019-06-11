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

/// A [ListTile] that shows an about box.
///
/// This widget is often added to an app's [Drawer]. When tapped it shows
/// an about box dialog with [showAboutPage].
///
/// The about box will include a button that shows changelogs for software used by
/// the application. The changelogs shown are those returned by the
/// [ChangelogRegistry] API, which can be used to add more changelogs to the list.
///
/// If your application does not have a [Drawer], you should provide an
/// affordance to call [showAboutPage] or (at least) [showMarkdownPage].
class MarkdownPageListTile extends StatelessWidget {
  /// Creates a list tile for showing an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const MarkdownPageListTile({
    Key key,
    this.icon,
    @required this.title,
    this.applicationName,
    this.useMustache,
    @required this.filename,
    this.mustacheValues,
  })  : assert(title != null),
        super(key: key);

  /// The icon to show for this drawer item.
  ///
  /// By default no icon is shown.
  ///
  /// This is not necessarily the same as the image shown in the dialog box
  /// itself; which is controlled by the [applicationIcon] property.
  final Widget icon;

  /// The label to show on this drawer item.
  ///
  /// Defaults to a text widget that says "About Foo" where "Foo" is the
  /// application name specified by [applicationName].
  final Widget title;

  /// The name of the application.
  ///
  /// This string is used in the default label for this drawer item (see
  /// [title]) and as the caption of the [AboutPage] that is shown.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String applicationName;

  final String filename;

  final bool useMustache;

  final Map<String, String> mustacheValues;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    return ListTile(
      leading: icon,
      title: title,
      onTap: () {
        showMarkdownPage(
          context: context,
          applicationName: applicationName,
          filename: filename,
          title: title,
          useMustache: useMustache,
          mustacheValues: mustacheValues,
        );
      },
    );
  }
}
