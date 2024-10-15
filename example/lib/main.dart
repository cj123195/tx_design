import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
          TxFieldTileThemeData(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tx Design')),
      body: const FormView(),
    );
  }
}

class FormView extends StatefulWidget {
  const FormView({super.key});

  static const List<String> sources = ['选项1', '选项2', '选项3'];
  static const List<(String, String)> sources1 = [
    ('选项1', '值1'),
    ('选项2', '值2'),
    ('选项3', '值3'),
  ];

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map form = {'text': 'text'};

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   tileColor: Colors.blue,
    //   title: const Text('测试'),
    //   subtitle: const Text('测试'),
    //   // visualDensity: VisualDensity.compact,
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TxCheckboxFormFieldTile<String, String>(
                    source: FormView.sources,
                    labelMapper: (val) => val,
                    labelText: 'Checkbox',
                    onChanged: (val) => form['checkbox'] = val,
                    initialData: form['checkbox'],
                    minCount: 1,
                    maxCount: 2,
                    required: true,
                  ),
                  TxTextFormFieldTile(
                    initialValue: form['text'],
                    labelText: '文字输入',
                    onChanged: (val) => form['text'] = val,
                    required: true,
                  ),
                  TxPickerFormFieldTile(
                    labelText: '单项选择',
                    source: FormView.sources,
                    labelMapper: (val) => val,
                    onChanged: (val) => form['pickerValue'] = val,
                    initialValue: form['pickerValue'],
                    required: true,
                  ),
                  TxDatePickerFormFieldTile(
                    labelText: '日期选择器',
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                    onChanged: (date) => form['date'] = date,
                    maximumYear: 2024,
                    initialDate: form['date'],
                    format: 'yyyy/MM/dd',
                    titleText: '日期选择器',
                    required: true,
                    validator: (date) {
                      if (date!.isBefore(DateTime.now())) {
                        return '请选择大于今日的日期';
                      }
                      return null;
                    },
                  ),
                  TxDatetimePickerFormFieldTile(
                    labelText: '日期时间选择器',
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                    onChanged: (date) => form['datetime'] = date,
                    maximumYear: 2024,
                    initialDatetime: form['datetime'],
                    titleText: '日期时间选择器',
                    required: true,
                    validator: (date) {
                      if (date!.isBefore(DateTime.now())) {
                        return '请选择大于今日的日期';
                      }
                      return null;
                    },
                  ),
                  TxDateRangePickerFormFieldTile(
                    labelText: '日期区间选择',
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                    onChanged: (date) => form['dateRange'] = date,
                    initialDateRange: form['dateRange'],
                    helpText: '请选择本年时间',
                    required: true,
                  ),
                  TxDatetimeRangePickerFormFieldTile(
                    labelText: '日期时间区间选择',
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                    onChanged: (date) => form['datetimeRange'] = date,
                    initialDatetimeRange: form['datetimeRange'],
                    helpText: '请选择本年时间',
                    required: true,
                  ),
                  TxDropdownFormFieldTile(
                    labelText: '下拉选择',
                    source: FormView.sources,
                    labelMapper: (val) => val,
                    onChanged: (val) => form['dropdown'] = val,
                    initialValue: form['dropdown'],
                    required: true,
                  ),
                  TxMonthPickerFormFieldTile(
                    labelText: '月份选择',
                    minimumMonth: DateTime(2024),
                    maximumMonth: DateTime(2025),
                    onChanged: (month) => form['month'] = month,
                    maximumYear: 2024,
                    initialMonth: form['month'],
                    titleText: '月份选择',
                    required: true,
                  ),
                  TxMultiPickerFormFieldTile<String, String>(
                    source: FormView.sources,
                    labelMapper: (val) => val,
                    labelText: '多项选择',
                    minCount: 1,
                    maxCount: 2,
                    required: true,
                    onChanged: (val) => form['multiPickerValue'] = val,
                    initialData: form['multiPickerValue'],
                  ),
                  TxNumberFormFieldTile<int>(
                    onChanged: (val) => form['number'] = val,
                    initialValue: form['number'],
                    labelText: '数字输入',
                    required: true,
                    minValue: 12,
                    maxValue: 100,
                    autodecrement: true,
                  ),
                  TxRadioFormFieldTile<String, String>(
                    source: FormView.sources,
                    initialValue: form['radioValue'],
                    labelText: 'Radio 单选',
                    required: true,
                    onChanged: (val) => form['radioValue'] = val,
                    labelMapper: (val) => val,
                  ),
                  TxChipFormFieldTile<String, String>(
                    onChanged: (val) => form['chipValue'] = val,
                    initialData: form['chipValue'],
                    source: FormView.sources,
                    labelMapper: (val) => val,
                    labelText: 'Chip 选择',
                    // required: true,
                    minCount: 1,
                    maxCount: 2,
                    required: true,
                  ),
                  TxSwitchFormFieldTile(
                    onChanged: (val) => form['switchValue'] = val,
                    initialValue: form['switchValue'],
                    labelText: 'Switch 开关',
                    required: true,
                  ),
                  TxAutoIncrementFormFieldTile<String>.tile(
                    titleBuilder: (context, index, list, change) => TxTextField(
                      initialValue: list[index],
                      onChanged: (val) {
                        list[index] = val ?? '';
                        change(list);
                      },
                    ),
                    onAddTap: (context, data) => Future.value(''),
                    labelText: '自增组件',
                    onChanged: (val) => form['autoIncrement'] = val,
                    initialValue: form['autoIncrement'],
                    minCount: 2,
                    maxCount: 3,
                    required: true,
                  ),
                  TxTimePickerFormFieldTile(
                    labelText: '时间选择',
                    minimumTime: const TimeOfDay(hour: 6, minute: 0),
                    maximumTime: const TimeOfDay(hour: 18, minute: 0),
                    onChanged: (time) => form['time'] = time,
                    initialTime: form['time'],
                    titleText: '时间选择',
                    required: true,
                  ),
                  TxYearPickerFormFieldTile(
                    labelText: '年份选择',
                    minimumYear: 2000,
                    onChanged: (year) => form['year'] = year,
                    maximumYear: 2024,
                    initialYear: form['year'],
                    titleText: '年份选择',
                    required: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => _formKey.currentState!.validate(),
          child: const Text('验证'),
        ),
      ],
    );
  }
}
