# About

Displays an About dialog, which describes the application.

## Usage

To use this plugin, add `about` as a [dependency in your pubspec.yaml file](#-installing-tab-).

## Example

```dart
showAboutPage(
  applicationLegalese: 'Copyright © David PHAM-VAN, {{ year }}',
  applicationDescription:
      Text('Displays an About dialog, which describes the application.'),
  children: <Widget>[
    MarkdownPageListTile(
      icon: Icon(Icons.list),
      title: Text('Changelog'),
      filename: 'CHANGELOG.md',
    ),
    LicensesPageListTile(
      icon: Icon(Icons.favorite),
    ),
  ],
  applicationIcon: SizedBox(
      width: 100,
      height: 100,
      child: Image(image: const AssetImage('assets/icon.webp'))),
)
```
