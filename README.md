This is a custom component package, which also includes some theme extension and type extension.

## Features

Add this to your Flutter app to:
1. Use more customized widgets and support global and local theme configurations.
2. Some custom theme extensions are provided, such as color, spacing, round corner, shadow, etc.
3. Some type extensions are provided.

## Installing
Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  tx_design: ^latest
```

## Import
```dart
import 'package:tx_design/tx_design.dart';
```

## Usage

Use widget and set widget's theme:
```dart
const TxCellTheme(
  data: TxCellThemeData(),
  child: TxCell(labelText: 'labelText', contentText: 'contentText'),
);
```

Add themeExtension to your themeData:
```dart
ThemeData(
    extensions: [
      RadiusThemeData(),
    ]
);
```

Use type extension:
```dart
fianl String formattedTime = DateTime.now().format('yyyy-MM-dd HH:mm');
```
