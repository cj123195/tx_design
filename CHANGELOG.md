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