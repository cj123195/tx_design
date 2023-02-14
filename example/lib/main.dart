import 'package:flutter/material.dart';
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
          const TxCellThemeData()
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

  int _counter = 0;

  void _incrementCounter() {
    _formKey.currentState!.validate();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TxCellTheme(
                data: const TxCellThemeData(),
                child: TxCell(
                  labelText: 'current count is',
                  contentText: '$_counter',
                ),
              ),
              Text(
                'Current datetime: ${DateTime.now().millisecondsSinceEpoch}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              PhotoPickerFormField()
              // FilePickerFormField(
              //   onChanged: (files) {
              //
              //   },
              //   labelText: '选择文件',
              //   required: true,
              //   drawEnabled: true,
              //   otherFiles: const [
              //     TxFileListTile(name: '测试文件1'),
              //     TxFileListTile(name: '测试文件2'),
              //     TxFileListTile(name: '测试文件3'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
