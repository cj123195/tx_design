import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tx_design/form/form_item_theme.dart';
import 'package:tx_design/localizations.dart';
import 'package:tx_design/tx_design.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.light,
        extensions: [
          const SpacingThemeData(),
          const RadiusThemeData(),
          ColorThemeData.light(),
          const TxCellThemeData(),
          const FormItemThemeData(
            padding: EdgeInsets.all(8.0),
            direction: Axis.horizontal,
            inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
          )
        ],
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.dark,
        extensions: [
          const SpacingThemeData(),
          const RadiusThemeData(),
          ColorThemeData.light(),
          const TxCellThemeData()
        ],
        useMaterial3: true,
      ),
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        TxLocalizations.delegate,
      ],
      home: MyHomePage(
          title: 'HomePage',
          changeTheme: () {
            setState(() {
              if (_themeMode == ThemeMode.dark) {
                _themeMode = ThemeMode.light;
              } else {
                _themeMode = ThemeMode.dark;
              }
            });
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.changeTheme});

  final String title;

  final VoidCallback changeTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const List<String> sources = ['选项1', '选项2', '选项3'];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: widget.changeTheme,
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InputFormField(
                labelText: '输入框',
                maxLines: 5,
              ),
              CheckboxFormField(
                sources: sources,
                labelMapper: (data) => data,
                labelText: 'CheckBox多选',
              ),
              DatePickerFormField(
                labelText: '日期选择',
              ),
              PhotoPickerFormField(),
              DateRangePickerFormField(),
              DatetimePickerFormField(labelText: '日期时间选择框')
            ],
          ),
        ),
      ),
    );
  }
}
