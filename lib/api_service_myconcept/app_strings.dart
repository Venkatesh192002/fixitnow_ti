import 'package:auscurator/util/shared_util.dart';

abstract class AppStrings {
  // Static method to get the base URL
  static String _getBaseUrl() {
    var baseUrl = "";

    final isIpOneCheck = SharedUtil().IpOneCheckStatus;
    final isIpTwoCheck = SharedUtil().IpTwoCheckStatus;
    final ipOneBaseUrl = SharedUtil().getIpOne;
    final ipTwoBaseUrl = SharedUtil().getIpTwo;

    if (isIpOneCheck) {
      baseUrl = ipOneBaseUrl;
    }

    if (isIpTwoCheck) {
      baseUrl = ipTwoBaseUrl;
    }
    return baseUrl;
  }

  /// App name
  static const String appName = "FixItNow";

  /// App Description
  static const String appDesc =
      "MapMan: Discover Your Neighborhood Gems MapMan is a user-friendly app that helps you identify nearby shops and businesses using interactive maps. With its intuitive interface and powerful search features, MapMan makes it easy to find the perfect place for your needs, whether you're looking for a new restaurant, a specialty store, or a local service provider.";

  // Use a static call to _getBaseUrl() to get the correct base URL
  static String _server = _getBaseUrl();

  /// Backend API url
  static String apiUrl = "$_server/";

  /// Backend Storage url
  static String storageUrl = "$_server/storage/";

  /// App's android [Google Play Store](https://play.google.com/store/apps/) url
  static const String androidStoreUrl = "https://play.google.com/store/apps/";

  /// App's Apple [App Store](https://apps.apple.com/in/app) url
  static const String iosStoreUrl = "";
}
