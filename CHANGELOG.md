# 0.2.15
* Fixed issues DateRangePicker sometimes went wrong.

# 0.2.14
* Fixed initialValue issues in date pickers.
* Fixed focus management when switching between form fields.
* Improved keyboard handling during sheet transitions.

# 0.2.13
* Update forms.
* Enhanced `DateTimeRange` extension
  - Added support for uppercase date formats (e.g., YYYY-MM-DD)
  - Added predefined datetime formats
* Improved `Duration` extension
  - Refactored `format` method to support custom formatting patterns
  - Added support for days in formatting
  - Smart omission of zero time units
  - Added flexible format templates (e.g., dd days HH hours mm minutes ss seconds)

# 0.2.12
* Add contentMaxLines parameter to TxDataGrid.fromMap constructor and TxDataRow.fromMap method.
* Fix issue that TxCell widget did not calculate the height correctly.

# 0.2.11
* Fix the issue that TxDataRow.fromMap displaying incorrectly.
* Delete charts.

# 0.2.10
* Update default return value of showDefaultDialog and showDefaultBottomSheet to null.
* Update time related pickers and form components.
* Update the style of RadioFormField and CheckboxFormField.
* Fix the issue where the toggle button of TxExpandableText cannot be displayed properly in some cases.

# 0.2.9
* Fix TxDataRow layout exception.
* Fix the issue of formatting the number input form that prevents the deletion of decimal points and numbers after decimal points.
* Update String extension.
* Update widgets exports.
* The charts will be deleted next version, please replace other chart libraries in advance.

# 0.2.8
* Upgrade flutter version to 3.19.5 and Migrate AGP.
* Update default buttonStyle of TxActionBar.
* Update default label's textStyle of FormItemContainer.
* Update some parameters of TxPanel an TxPanelThemeData and update layout of TxPanel.
* Add ExpansionPanelTheme and ExpansionPanelThemeData to set the style of TxExpansionPanel.
* Refactor TxCell.
* DataGrid and DataRow no longer use DataCell but instead use TxCell to build.
* DetailView no longer use DetailTile but instead use TxCell to build.
* Optimize the style of AxisChart through optimization algorithms.
* Update RadiusThemeData.
* Add TxBadge and TopSheet.

# 0.2.7
* Modify the radius parameter of PieChartSectionData to radiusRatio.

# 0.2.6
* Add charts.
* Add CircularLinearGradientIndicator.

# 0.2.5
* Fix bug that function validate of TxFormFieldState always return tru.
* Refactor some parameter type of form widgets.

# 0.2.4
* Fix the issue that onPickTap parameter of PickerFormField not working.

# 0.2.3
* Upgrade Flutter version to 3.16.0.
* Add TxExpansionPanel widget.
* Add TxTabBar and TxTabBarView widgets.
* Add crossAxisAlignment property of TxDataGrid.
* Add slots and dataMaxLines properties of TxDataGrid.fromData.
* Update default format of TxDatePickerButton.
* Change showDateRangeDialogs to showDateRangePickerDialog.
* Fix page bug caused by not configuring SpacingThemeData.
* Change default thickness from 0 to 0.5 of TxDivider and TxVerticalDivider.
* Update default foregroundColor of TxTip.
* Update default focusColor of DropdownFormField.

# 0.2.2
* Fix the shape mismatch between the foreground image and the background image of the square avatar.

# 0.2.1
* Remove all third-party dependencies and related widgets.

# 0.2.0
* Update Flutter SDK version to 3.13.3.
* Update Dart SDK version to 3.0.
* Remove DropdownButton and PopupMenu.

# 0.1.3
* Split TxImagePickerView to TxPhotoPickerView and TxVideoPickerView.

# 0.1.2
* Add methods for adding, deleting, and deleting all status listener in Toast widget.
* Modify the UI of ImagePicker when images is empty.
* Remove ColorExtension.
* Optimize the UI of TxSearch.
* Update TxImagePicker, ImagePickerFormField.
* Add showSimplePickerBottomSheet.
* Add SquareAvatar.
* Update extensions and localizations.
* Add TxDatePickerBar.
* Delete TxExpansionTile.
* Add AnchorScrollMixin and AnchorTabMixin.
* Add showFilterBottomSheet.

# 0.1.1
* Fix some bug of form widgets.
* Update default style of DefaultBottomSheet.
* Update default row and column spacing of TxDataGrid.
* Update some parameters name of TxPanel and remove default background color of Panel.
* Add TxDetailView, TxDetailViewThemeData, TxDetailTheme.
* Add DateRangePickerButton, DateRangePickerButtonThemeData, DateRangePickerButtonTheme.
* Update TxSkeleton, Add TxSkeletonThemeData, TxSkeletonTheme.
* Add TxWrapGridView.
* Update TxSearchDelegate.
* Add TxStatusIndicator, TxStatusIndicatorThemeData, TxStatusIndicatorTheme.

# 0.1.0
* Complete localization of all widgets.
* Refactoring Form series widgets.

# 0.0.10
* Fix bug that showDefaultDialog's showCancelButton parameter do not work.
* Fix bug that DateRangePickerFormField cannot pick date.
* Modify the confirmation button widget of the DefaultBottomSheet.
* Add TxLocalizations.
* Update DateRangePicker widget.
* Fixed issue with TxDatePickerButtonThemeData copyWith method not working.
* Update Form series widgets.

# 0.0.9
* Fix matching_text some cases where unmatched text cannot be displayed.
* Add animated_icon_button widget.

# 0.0.8
* Fix bug where datetimeRangePickerBottomSheet cannot scroll.
* Optimize FileSystemUtil
- Delete prepareDownloadDir, please replace it with getDownloadDir;
- Add createDirectory method to create a dictionary in the application directory if it doesn't exist；
- Modify all directory related operation methods to return a value type of Dictionary.
* Export Barcode in qr_scan.dart.
* Update TxRefreshListView
  - Modify the component name TxRefreshListView to TxRefreshView.
  - Delete separated constructor.
  - Add default constructor.
  - Modify builder constructor parameters.

# 0.0.7
* Fix that setting the background color of showDefaultDialog does not work due to assignment errors.

# 0.0.6
* Add new method called 'searchFile' in FileSystem util.
* Add widget TxLinearGradientProgressIndicator.

# 0.0.5
* Add widgets: showDialog、TxHelpToolTip、TxQrScanView、TxSkeleton.
* Add utils Throttle、divideTiles、FileSystem.
* Update TxImageViewer's exports and TxRefreshListView's exports.

# 0.0.4
* Add widgets: TxDatePickerButton、showInformationDialog、TxLoading、TxPanel、TxFileListTile、TxSignature、TxImagePickerView、TxImageGalleryViewer、TxVideoPlayerView、TxRefreshListView.
* Add form series widgets to create Form Forms Efficiently.
* Add AutoOrientationUtil to quick switch between horizontal and vertical screens.
* Add DurationExtension、TimeOfDayExtension and IterableExtension.
* Add linter rules.
* Update some widgets description and format code.

# 0.0.3
* Add example.

# 0.0.2

* Update Licence、README.

# 0.0.1

* Initial commit.