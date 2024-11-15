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
        extensions: const [
          SpacingThemeData(),
          RadiusThemeData(),
          TxCellThemeData(),
          FormItemThemeData(
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
        extensions: const [
          SpacingThemeData(),
          RadiusThemeData(),
          TxCellThemeData(),
        ],
        useMaterial3: true,
      ),
      locale: const Locale('zh', 'CN'),
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
        },
      ),
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
  final list = [
    {'id': '1'},
    {'id': '11', 'pid': '1'},
    {'id': '12', 'pid': '1'},
    {'id': '111', 'pid': '11'},
    {'id': '112', 'pid': '11'},
    {'id': '121', 'pid': '12'},
    {'id': '122', 'pid': '12'},
    {'id': '2'},
    {'id': '21', 'pid': '2'},
    {'id': '22', 'pid': '2'},
    {'id': '211', 'pid': '21'},
    {'id': '212', 'pid': '21'},
    {'id': '221', 'pid': '22'},
    {'id': '222', 'pid': '22'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tx Design')),
      body: ElevatedButton(
        onPressed: () async {
          final res = await showMapListCascadePicker(
              context: context, datasource: list, labelKey: 'id');
          print(res);
        },
        child: Text('选择数据'),
      ),
      // body: FormView(),
    );
  }
}

class FormView extends StatelessWidget {
  FormView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map form = {};

  static const List<String> sources = ['选项1', '选项2', '选项3'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InputFormField(
                    labelText: '输入框',
                    // required: true,
                    onChanged: (val) => form['field1'] = val,
                    initialValue: form['field1'],
                    // direction: Axis.horizontal,
                  ),
                  NumberFormField(
                    labelText: '数字输入框',
                    required: true,
                    minimumValue: -10,
                    maximumValue: 20,
                    onChanged: (val) => form['field2'] = val,
                    initialValue: form['field2'],
                    // direction: Axis.horizontal,
                  ),
                  // const SizedBox(height: 8.0),
                  CheckboxFormField(
                    sources: sources,
                    labelMapper: (data) => data,
                    labelText: 'CheckBox多选',
                    minPickNumber: 1,
                    onChanged: (val) =>
                        form['field3'] = val?.map((e) => e).toSet(),
                    initialValue: form['field3'],
                    required: true,
                  ),
                  // const SizedBox(height: 8.0),
                  YearPickerFormField(
                    labelText: '年份选择',
                    onChanged: (val) => form['fieldYear'] = val,
                    initialYear: form['fieldYear'],
                  ),
                  MonthPickerFormField(
                    labelText: '月份选择',
                    onChanged: (val) => form['fieldMonth'] = val?.format(),
                    initialMonth: form['fieldMonth'],
                  ),
                  DatePickerFormField(
                    labelText: '日期选择',
                    onChanged: (val) => form['field4'] = val?.format(),
                    initialDateStr: form['field4'],
                  ),
                  DatetimePickerFormField(
                    labelText: '日期时间选择',
                    onChanged: (val) => form['field5'] = val,
                    initialDatetime: form['field5'],
                    required: true,
                    minimumDate: DateTime.now(),
                  ),
                  TimePickerFormField(
                    labelText: '时间选择',
                    onChanged: (val) => form['field9'] = val,
                    initialTime: form['field9'],
                    required: true,
                  ),
                  // const SizedBox(height: 8.0),
                  DateRangePickerFormField(
                    labelText: '时间区间选择',
                    onChanged: (val) => form['field6'] = val,
                    initialValue: form['field6'],
                    required: true,
                    firstDate: DateTime.now(),
                  ),
                  DatetimeRangePickerFormField(
                    labelText: '时间区间选择',
                    onChanged: (val) => form['field6'] = val,
                    initialValue: form['field6'],
                    required: true,
                    firstDate: DateTime.now(),
                  ),
                  DropdownFormField(
                    sources: sources,
                    labelMapper: (data) => data,
                    labelText: '下拉选择',
                    onChanged: (val) => form['field7'] = val,
                    initialValue: form['field7'],
                    required: true,
                    direction: Axis.horizontal,
                    isDense: true,
                    isExpanded: true,
                  ),
                  PickerFormField(
                    sources: sources,
                    labelMapper: (data) => data,
                    labelText: '单项选择',
                    onChanged: (val) => form['field7'] = val,
                    initialValue: form['field7'],
                    required: true,
                  ),
                  RadioFormField(
                    sources: sources,
                    labelMapper: (data) => data,
                    labelText: 'Radio单选',
                    onChanged: (val) => form['field7'] = val,
                    initialValue: form['field7'],
                    required: true,
                    direction: Axis.horizontal,
                  ),
                  MultiPickerFormField(
                    sources: sources,
                    labelMapper: (data) => data,
                    labelText: '多选',
                    minPickNumber: 1,
                    onChanged: (val) =>
                        form['field3'] = val?.map((e) => e).toSet(),
                    initialValue: form['field3'],
                    required: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        TxButtonBar.more(
          mainButton: ElevatedButton(
            onPressed: () {
              _formKey.currentState?.validate();
            },
            child: const Text('验证'),
          ),
          menus: const [
            PopupMenuItem(child: Text('选项一')),
            PopupMenuItem(child: Text('选项二')),
            PopupMenuItem(child: Text('选项三'))
          ],
        ),
      ],
    );
  }
}
