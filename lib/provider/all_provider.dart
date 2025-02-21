
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/provider/asset_provider.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/provider/dashboard_provider.dart';
import 'package:auscurator/provider/info_provider.dart';
import 'package:auscurator/provider/layout_provider.dart';
import 'package:auscurator/provider/mttr_provider.dart';
import 'package:auscurator/provider/spare_provider.dart';
import 'package:auscurator/provider/ticket_provider.dart';
import 'package:auscurator/provider/work_log_provider.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> providersAll = [
  
  ChangeNotifierProvider<SpareProvider>(create: (context) => SpareProvider()),
  ChangeNotifierProvider<InfoProvider>(create: (context) => InfoProvider()),
  ChangeNotifierProvider<WorkLogProvider>(create: (context) => WorkLogProvider()),
  ChangeNotifierProvider<TicketProvider>(create: (context) => TicketProvider()),
  ChangeNotifierProvider<DashboardProvider>(create: (context) => DashboardProvider()),
  ChangeNotifierProvider<AssetProvider>(create: (context) => AssetProvider()),
  ChangeNotifierProvider<LayoutProvider>(create: (context) => LayoutProvider()),
  ChangeNotifierProvider<BreakkdownProvider>(create: (context) => BreakkdownProvider()),
  ChangeNotifierProvider<MttrProvider>(create: (context) => MttrProvider()),
];

var provdSpare =
    Provider.of<SpareProvider>(mainKey.currentContext!, listen: false);
var infoProvider =
    Provider.of<InfoProvider>(mainKey.currentContext!, listen: false);
var workLogProvider =
    Provider.of<WorkLogProvider>(mainKey.currentContext!, listen: false);
var ticketProvider =
    Provider.of<TicketProvider>(mainKey.currentContext!, listen: false);
var dashboardProvider =
    Provider.of<DashboardProvider>(mainKey.currentContext!, listen: false);
var assetProvider =
    Provider.of<AssetProvider>(mainKey.currentContext!, listen: false);
var layoutProvider =
    Provider.of<LayoutProvider>(mainKey.currentContext!, listen: false);
var breakProvider =
    Provider.of<BreakkdownProvider>(mainKey.currentContext!, listen: false);
var mttrProvider =
    Provider.of<MttrProvider>(mainKey.currentContext!, listen: false);