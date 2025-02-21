import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/ip_setting_screen_widget/ip_setting_item.dart';
import 'package:flutter/material.dart';

class IPSettingScreen extends StatefulWidget {
  const IPSettingScreen({super.key});

  @override
  State<IPSettingScreen> createState() => _IPSettingScreenState();
}

class _IPSettingScreenState extends State<IPSettingScreen> {
  bool isIpOneCheck = false;
  bool isIpTwoCheck = false;

  String ipOneAddress = "";
  String ipTwoAddress = "";

  @override
  void initState() {
    ipOneAddress = SharedUtil().getIpOne;
    ipTwoAddress = SharedUtil().getIpTwo;
    isIpOneCheck = SharedUtil().IpOneCheckStatus;
    isIpTwoCheck = SharedUtil().IpTwoCheckStatus;
    super.initState();
  }

  void isIpChecked(String title, bool isIpChecked) {
    print("build the component again.");
    setState(() {
      if (title == "ip_1") {
        isIpTwoCheck = false;
        isIpOneCheck = isIpChecked;
        SharedUtil().setIsIpOneChecked(isIpOneCheck);
      } else {
        SharedUtil().setIsIpOneChecked(false);
      }
      if (title == "ip_2") {
        isIpOneCheck = false;
        isIpTwoCheck = isIpChecked;
        SharedUtil().setIsIpTwoChecked(isIpTwoCheck);
      } else {
        SharedUtil().setIsIpTwoChecked(false);
      }
    });
  }

  void ipAddress(String title, String ipAddress) {
    setState(
      () {
        if (title == "ip_1") {
          ipOneAddress = ipAddress;
          SharedUtil().setIpOne(ipAddress);
        }
        if (title == "ip_2") {
          ipTwoAddress = ipAddress;
          SharedUtil().setIpTwo(ipAddress);
        }
        SharedUtil().reloadPref();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        title: Text(
          "Setting",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text(
            "IP Setting",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Color.fromRGBO(30, 152, 165, 1), fontSize: 20),
          ),
          IpSettingItem(
            ipTitle: "IP-1",
            isIpCheckedFun: isIpChecked,
            isChecked: isIpOneCheck,
            ipAddress: ipOneAddress,
            ipAddressFun: ipAddress,
          ),
          IpSettingItem(
              ipTitle: "IP-2",
              isIpCheckedFun: isIpChecked,
              isChecked: isIpTwoCheck,
              ipAddress: ipTwoAddress,
              ipAddressFun: ipAddress),
        ],
      ),
    );
  }
}
