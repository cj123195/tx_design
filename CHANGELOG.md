## 0.0.1

* Initial commit.

## 0.0.2

* Update Licence、README.

## 0.0.3
* Add example.

## 0.0.4
* Add widgets: TxDatePickerButton、showInformationDialog、TxLoading、TxPanel、TxFileListTile、TxSignature、TxImagePickerView、TxImageGalleryViewer、TxVideoPlayerView、TxRefreshListView.
* Add form series widgets to create Form Forms Efficiently.
* Add AutoOrientationUtil to quick switch between horizontal and vertical screens.
* Add DurationExtension、TimeOfDayExtension and IterableExtension.
* Add linter rules.
* Update some widgets description and format code.

## 0.0.5
* Add widgets: showDialog、TxHelpToolTip、TxQrScanView、TxSkeleton.
* Add utils Throttle、divideTiles、FileSystem.
* Update TxImageViewer's exports and TxRefreshListView's exports.

## 0.0.6
* Add new method called 'searchFile' in FileSystem util.
* Add widget TxLinearGradientProgressIndicator.

## 0.0.7
* Fix that setting the background color of showDefaultDialog does not work due to assignment errors.

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

# 0.0.9
* Fix matching_text some cases where unmatched text cannot be displayed.
* Add animated_icon_button widget.