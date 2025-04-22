import 'package:flutter/material.dart';

const double _defaultPadding = 16.0;

/// 显示全屏搜索页面，并在页面关闭时返回用户选择的搜索结果。
///
/// 详情参考[showSearch]
Future<T?> showTxSearch<T>({
  required BuildContext context,
  required TxSearchDelegate<T> delegate,
  String? query = '',
  bool useRootNavigator = false,
}) {
  delegate.query = query ?? delegate.query;
  delegate._currentBody = _SearchBody.suggestions;
  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push(_SearchPageRoute<T>(delegate: delegate));
}

/// 委托 [showTxSearch] 来定义搜索页面的内容。
///
/// 详情参考[SearchDelegate]
abstract class TxSearchDelegate<T> {
  TxSearchDelegate({
    this.searchFieldLabel,
    this.searchFieldStyle,
    this.searchFieldDecorationTheme,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
    this.automaticallyImplyLeading = false,
  });

  /// 页面初始化时调用
  ///
  /// 通常用于添加依赖
  void initState() {}

  /// 页面销毁时调用
  ///
  /// 通常用于删除依赖
  void dispose() {}

  /// [query] 变动时调用
  ///
  /// 通常再此方法中进行数据请求操作
  void onQueryChanged() {}

  Widget? buildPrefixIcon(BuildContext context) => const Icon(Icons.search);

  /// 从 [buildSuggestions] 返回的建议过渡到 [buildResults] 返回的 [query] 结果。
  ///
  /// 如果用户点击 [buildSuggestions] 提供的建议，屏幕通常应过渡到显示建议查询的搜索结果的
  /// 页面。可以通过调用此方法触发此转换。
  ///
  /// 另请参阅：
  ///
  ///  * [showSuggestions]，以再次显示搜索建议。
  void showResults(BuildContext context, [bool removeFocus = true]) {
    if (removeFocus) {
      _focusNode?.unfocus();
    }
    _currentBody = _SearchBody.results;
  }

  /// 关闭搜索页并返回到基础路由。
  ///
  /// 为“result”提供的值用作最初启动搜索的 [showSearch] 调用的返回值。
  void close(BuildContext context, T result) {
    _currentBody = null;
    _focusNode?.unfocus();
    Navigator.of(context)
      ..popUntil((Route<dynamic> route) => route == _route)
      ..pop(result);
  }

  /// 当用户在搜索字段中键入查询时，搜索页正文中显示的建议。
  ///
  /// 每当 [query] 的内容发生更改时，都会调用委托方法。建议应基于当前 [query] 字符串。如果
  /// 查询字符串为空，则最好根据过去的查询或当前上下文显示建议的查询。
  ///
  /// 通常，此方法将返回一个 [ListView]，每个建议有一个 [ListTile]。调用 [ListTile.onTap] 时，
  /// 应使用相应的建议更新 [query]，并且应通过调用 [showResults] 来显示结果页面。
  Widget buildSuggestions(BuildContext context);

  /// 用户从搜索页面提交搜索后显示的结果。
  ///
  /// [query] 的当前值可用于确定用户搜索的内容。
  ///
  /// 此方法可以多次应用于同一查询。如果 [buildResults] 方法的计算成本很高，则可能需要缓存
  /// 一个或多个查询的搜索结果。
  ///
  /// 通常，此方法返回包含搜索结果的 [列表视图]。当用户点击特定搜索结果时，应调用 [close]
  /// 并将所选结果作为参数。这将关闭搜索页面并将结果传达回 [showSearch] 的初始调用方。
  Widget buildResults(BuildContext context);

  /// 要在 [AppBar] 中的当前查询之前显示的小组件。
  ///
  /// 通常，配置了 [BackButtonIcon] 的 [IconButton] 以 [close] 退出搜索。还可以使用由
  /// [transitionAnimation] 驱动的 [AnimatedIcon]，当搜索叠加层淡入时，它会从汉堡菜单到
  /// 后退按钮进行动画处理。
  ///
  /// 如果不应显示任何小组件，则返回 null。
  ///
  /// 另请参阅：
  ///
  ///  * [AppBar.leading]，此方法的返回值的预期用途。
  Widget? buildLeading(BuildContext context) => null;

  /// 在 [AppBar] 中搜索查询后显示的小组件。
  ///
  /// 如果 [query] 不为空，则通常应包含一个用于清除查询并再次显示建议（通过 [showSuggestions]）
  /// 的按钮（如果当前显示结果）。
  ///
  /// 如果不应显示任何小组件，则返回 null
  ///
  /// 另请参阅：
  ///
  ///  * [AppBar.actions]，此方法的返回值的预期用途。
  List<Widget>? buildActions(BuildContext context) => [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(minimumSize: Size.zero),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        )
      ];

  /// 要在 [AppBar] 底部显示的小部件
  ///
  /// 默认返回 null，即不包括底部小部件。
  ///
  /// 另请参阅：
  ///
  ///  * [AppBar.bottom]，此方法的返回值的预期用途。
  ///
  PreferredSizeWidget? buildBottom(BuildContext context) => null;

  /// 用于配置搜索页面的主题。
  ///
  /// 返回的 [ThemeData] 将用于包装整个搜索页面，因此它可用于使用适当的主题属性配置其任何组件。
  ///
  /// 除非被重写，否则默认主题将配置包含搜索输入文本字段的应用栏，该字段具有白色背景，浅色主题
  /// 上具有黑色文本。对于深色主题，默认值为深灰色背景和浅色文本。
  ///
  /// 另请参阅：
  ///
  ///  * [AppBarTheme]，用于配置应用栏的外观。
  ///  * [InputDecorationTheme]，用于配置搜索文本字段的外观。
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleSpacing: 0.0,
        elevation: 0,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            prefixIconColor: colorScheme.outline,
            suffixIconColor: colorScheme.outline,
            contentPadding: EdgeInsets.zero,
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4.0),
            ),
            filled: true,
          ),
    );
  }

  /// [AppBar] 中显示的当前查询字符串.
  ///
  /// 用户通过键盘操作此字符串。
  ///
  /// 如果用户点击 [buildSuggestions] 提供的建议，则应通过 setter 将此字符串更新为该建议。
  String get query => _queryTextController.text;

  /// 更改当前查询字符串。
  ///
  /// 以编程方式设置查询字符串会将光标移动到文本字段的末尾。
  set query(String value) {
    _queryTextController.text = value;
    if (_queryTextController.text.isNotEmpty) {
      _queryTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: _queryTextController.text.length));
    }
  }

  /// 从显示 [buildResults] 返回的结果过渡到显示 [buildSuggestions] 返回的建议。
  ///
  /// 调用此方法还会将输入焦点放回 [AppBar] 的搜索字段中。
  ///
  /// 如果当前显示结果，则可以使用此方法返回到显示搜索建议。
  ///
  /// 另请参阅:
  ///
  ///  * [showResults] 以显示搜索结果。
  void showSuggestions(BuildContext context) {
    assert(_focusNode != null,
        '_focusNode must be set by route before showSuggestions is called.');
    _focusNode!.requestFocus();
    _currentBody = _SearchBody.suggestions;
  }

  /// 搜索字段为空时显示在的提示文本。
  ///
  /// 如果此值设置为 null，则将改用“MaterialLocalizations.of（context）.searchFieldLabel”的值。
  final String? searchFieldLabel;

  /// [searchFieldLabel] 的样式。
  ///
  /// 如果此值设置为 null，则将改用环境 [Theme] 的 [InputDecorationTheme.hintStyle] 的值。
  ///
  /// [searchFieldStyle] 或 [searchFieldDecorationTheme] 中只有一个可以为非空。
  final TextStyle? searchFieldStyle;

  /// 用于配置搜索字段的视觉对象的 [InputDecorationTheme]。
  ///
  /// [searchFieldStyle] 或 [searchFieldDecorationTheme] 中只有一个可以为非空。
  final InputDecorationTheme? searchFieldDecorationTheme;

  /// 用于键盘的操作按钮的类型。
  ///
  /// 默认为 [TextField] 中指定的默认值。
  final TextInputType? keyboardType;

  /// 将软键盘配置为特定操作按钮的文本输入操作。
  ///
  /// 默认为 [TextInputAction.search]。
  final TextInputAction textInputAction;

  /// 在搜索页面淡入或淡出时触发的 [Animation]。
  ///
  /// 此动画通常用于对 [buildLeading] 或 [buildActions] 返回的 [IconButton] 的
  /// [AnimatedIcon] 进行动画处理。它还可用于对搜索页面下方路线中包含的 [图标按钮] 进行动画处理。
  Animation<double> get transitionAnimation => _proxyAnimation;

  // 用于在搜索页面上操作焦点的焦点节点。
  //
  // 由使用此委托的_SearchPageRoute管理、拥有和设置。
  FocusNode? _focusNode;

  /// 是否自动设置返回按钮
  final bool automaticallyImplyLeading;

  final TextEditingController _queryTextController = TextEditingController();

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  final ValueNotifier<_SearchBody?> _currentBodyNotifier =
      ValueNotifier<_SearchBody?>(null);

  _SearchBody? get _currentBody => _currentBodyNotifier.value;

  set _currentBody(_SearchBody? value) {
    _currentBodyNotifier.value = value;
  }

  _SearchPageRoute<T>? _route;
}

enum _SearchBody {
  /// 建议的查询显示在正文中。
  ///
  /// 建议的查询由 [SearchDelegate.buildSuggestions] 生成。
  suggestions,

  /// 搜索结果当前显示在正文中。
  ///
  /// 搜索结果由[SearchDelegate.buildResults]生成。
  results,
}

class _SearchPageRoute<T> extends PageRoute<T> {
  _SearchPageRoute({
    required this.delegate,
  }) {
    assert(
      delegate._route == null,
      '${delegate.runtimeType} 实例当前被另一个活动搜索使用。 请在使用相同委托实例打开另一个搜索之前，'
      '通过调用 TxSearchDelegate 上的 close() 来关闭该搜索。',
    );
    delegate._route = this;
  }

  final TxSearchDelegate<T> delegate;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    delegate._proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _SearchPage<T>(
      delegate: delegate,
      animation: animation,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    assert(delegate._route == this);
    delegate._route = null;
    delegate._currentBody = null;
  }
}

const double _searchFieldHeight = 36.0;

class _SearchPage<T> extends StatefulWidget {
  const _SearchPage({
    required this.delegate,
    required this.animation,
  });

  final TxSearchDelegate<T> delegate;
  final Animation<double> animation;

  @override
  State<StatefulWidget> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<_SearchPage<T>> {
  // 此节点由搜索页面拥有，但不由其托管。 托管由文本字段完成。
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate.initState();
    widget.delegate._queryTextController.addListener(_onQueryChanged);
    widget.animation.addStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate._focusNode = focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate.dispose();
    widget.delegate._queryTextController.removeListener(_onQueryChanged);
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate._focusNode = null;
    focusNode.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    if (widget.delegate._currentBody == _SearchBody.suggestions) {
      focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(_SearchPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate._queryTextController.removeListener(_onQueryChanged);
      widget.delegate._queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate._currentBodyNotifier
          .removeListener(_onSearchBodyChanged);
      widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate._focusNode = null;
      widget.delegate._focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus &&
        widget.delegate._currentBody != _SearchBody.suggestions) {
      widget.delegate.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    widget.delegate.onQueryChanged();
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = widget.delegate.appBarTheme(context);
    final String searchFieldLabel = widget.delegate.searchFieldLabel ??
        MaterialLocalizations.of(context).searchFieldLabel;
    Widget? body;
    switch (widget.delegate._currentBody) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: widget.delegate.buildSuggestions(context),
        );
        break;
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: widget.delegate.buildResults(context),
        );
        break;
      case null:
        break;
    }

    late final String routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.ohos:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = searchFieldLabel;
    }

    Widget? suffixIcon;
    if (widget.delegate._queryTextController.text.isNotEmpty) {
      suffixIcon = InkWell(
        onTap: widget.delegate._queryTextController.clear,
        child: const Icon(Icons.cancel, color: Colors.grey, size: 18),
      );
    }

    final TextStyle effectiveStyle =
        widget.delegate.searchFieldStyle ?? theme.textTheme.bodyMedium!;

    EdgeInsetsGeometry? padding;
    final bool showBackButton = widget.delegate.automaticallyImplyLeading;
    final Widget? leading = widget.delegate.buildLeading(context);
    if (!showBackButton && leading == null) {
      padding = const EdgeInsets.only(left: _defaultPadding);
    }

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: showBackButton,
            leading: leading,
            title: Container(
              height: _searchFieldHeight,
              padding: padding,
              child: TextField(
                controller: widget.delegate._queryTextController,
                focusNode: focusNode,
                style: effectiveStyle,
                textInputAction: widget.delegate.textInputAction,
                keyboardType: widget.delegate.keyboardType,
                onSubmitted: (String _) {
                  widget.delegate.showResults(context);
                },
                decoration: InputDecoration(
                  hintText: searchFieldLabel,
                  prefixIcon: widget.delegate.buildPrefixIcon(context),
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
            actions: widget.delegate.buildActions(context),
            bottom: widget.delegate.buildBottom(context),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: body,
          ),
        ),
      ),
    );
  }
}
