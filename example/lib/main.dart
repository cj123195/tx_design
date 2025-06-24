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
          TxTileThemeData(),
        ],
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.withOpacity(0.05),
          outlineBorder: const BorderSide(color: Colors.grey),
        ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tx Design')),
      body: Form(key: _formKey, child: const FormView()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () => _formKey.currentState!.validate(),
          child: const Text('验证'),
        ),
      ),
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
  static const sources2 = [
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
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
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
            child: Column(
              children: [
                TxCascadePickerFormField.fromMapList(
                  labelText: '级联选择',
                  source: FormView.sources2,
                  labelKey: 'id',
                  onChanged: (val) => form['cascadeValue'] = val,
                  initialData: form['cascadeValue'],
                  required: true,
                  // bordered: true,
                  // decoration: InputDecoration(filled: true),
                ),
                TxTextFormField(
                  initialValue: form['text'],
                  labelText: '文字输入',
                  onChanged: (val) => form['text'] = val,
                  required: true,
                  readOnly: true,
                ),
                TxPickerFormField(
                  labelText: '单项选择',
                  source: FormView.sources,
                  labelMapper: (val) => val,
                  onChanged: (val) => form['pickerValue'] = val,
                  initialValue: form['pickerValue'],
                  required: true,
                  readOnly: true,
                ),
                TxDatePickerFormField(
                  labelText: '日期选择器',
                  minimumDate: DateTime(2024),
                  maximumDate: DateTime(2025),
                  onChanged: (date) => form['date'] = date,
                  maximumYear: 2025,
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
                TxDatetimePickerFormField(
                  labelText: '日期时间选择器',
                  minimumDate: DateTime(2024),
                  maximumDate: DateTime(2025),
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
                TxDateRangePickerFormField(
                  labelText: '日期区间选择',
                  minimumDate: DateTime(2024),
                  maximumDate: DateTime(2025),
                  onChanged: (date) => form['dateRange'] = date,
                  initialDateRange: form['dateRange'],
                  helpText: '请选择本年时间',
                  required: true,
                ),
                TxDatetimeRangePickerFormField(
                  labelText: '日期时间区间选择',
                  minimumDate: DateTime(2024),
                  maximumDate: DateTime(2025),
                  onChanged: (date) => form['datetimeRange'] = date,
                  initialDatetimeRange: form['datetimeRange'],
                  helpText: '请选择本年时间',
                  required: true,
                ),
                TxTimeRangePickerFormField(
                  labelText: '时间段选择',
                  minimumTime: const TimeOfDay(hour: 10, minute: 5),
                  maximumTime: const TimeOfDay(hour: 20, minute: 5),
                  onChanged: (date) => form['timeRange'] = date,
                  initialTimeRange: form['timeRange'],
                  helpText: '请选择时间',
                  required: true,
                ),
                TxDropdownFormField(
                  labelText: '下拉选择',
                  source: FormView.sources,
                  labelMapper: (val) => val,
                  onChanged: (val) => form['dropdown'] = val,
                  initialValue: form['dropdown'],
                  required: true,
                ),
                TxMonthPickerFormField(
                  labelText: '月份选择',
                  minimumMonth: DateTime(2024),
                  maximumMonth: DateTime(2025),
                  onChanged: (month) => form['month'] = month,
                  maximumYear: 2024,
                  initialMonth: form['month'],
                  titleText: '月份选择',
                  required: true,
                ),
                TxMultiPickerFormField<String, String>(
                  source: FormView.sources,
                  labelMapper: (val) => val,
                  labelText: '多项选择',
                  minCount: 1,
                  maxCount: 2,
                  required: true,
                  onChanged: (val) => form['multiPickerValue'] = val,
                  initialData: form['multiPickerValue'],
                ),
                TxNumberFormField(
                  onChanged: (val) => form['number'] = val,
                  initialValue: form['number'],
                  labelText: '数字输入',
                  required: true,
                  minValue: 12,
                  maxValue: 100,
                  stepped: true,
                ),
                TxRadioFormField<String, String>(
                  source: FormView.sources,
                  initialValue: form['radioValue'],
                  labelText: 'Radio 单选',
                  required: true,
                  onChanged: (val) => form['radioValue'] = val,
                  labelMapper: (val) => val,
                ),
                TxChipFormField<String, String>(
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
                TxSwitchFormField(
                  onChanged: (val) => form['switchValue'] = val,
                  initialValue: form['switchValue'],
                  labelText: 'Switch 开关',
                  required: true,
                ),
                TxArrayFormField<String>.builder(
                  itemBuilder: (field, index, data, actions) => ListTile(
                    title: TxTextFormField(
                      initialValue: data,
                      onChanged: (val) => field.value![index] = val ?? '',
                    ),
                    trailing: actions == null
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions,
                          ),
                  ),
                  defaultValue: (index) => '',
                  labelText: '自增组件',
                  onChanged: (val) => form['autoIncrement'] = val,
                  initialValue: form['autoIncrement'],
                  limit: 3,
                  required: true,
                ),
                TxTimePickerFormField(
                  labelText: '时间选择',
                  minimumTime: const TimeOfDay(hour: 6, minute: 0),
                  maximumTime: const TimeOfDay(hour: 18, minute: 0),
                  onChanged: (time) => form['time'] = time,
                  initialTime: form['time'],
                  titleText: '时间选择',
                  required: true,
                ),
                TxYearPickerFormField(
                  labelText: '年份选择',
                  minimumYear: 2000,
                  onChanged: (year) => form['year'] = year,
                  maximumYear: 2023,
                  initialYear: form['year'],
                  titleText: '年份选择',
                  required: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
