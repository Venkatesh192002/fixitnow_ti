import 'package:flutter/material.dart';
import 'package:auscurator/util/shared_util.dart';


class IpSettingItem extends StatelessWidget {
  const IpSettingItem(
      {super.key,
      required this.ipTitle,
      required this.isIpCheckedFun,
      required this.ipAddress,
      required this.isChecked,
      required this.ipAddressFun});

  final String ipTitle;
  final Function isIpCheckedFun;
  final Function ipAddressFun;
  final String ipAddress;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _showIpDialog(context, ipAddress);
      },
      child: SizedBox(
        width: width,
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ipTitle,
                          textAlign: TextAlign.start,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: width * 0.7,
                        child: Text(ipAddress, textAlign: TextAlign.start),
                      ),
                    )
                  ],
                ),
                Switch(
                  activeColor: const Color.fromARGB(255, 16, 145, 41),
                  value: isChecked,
                  onChanged: (value) {
                    if (ipTitle == "IP-1") {
                      isIpCheckedFun("ip_1", value);
                    }
                    if (ipTitle == "IP-2") {
                      isIpCheckedFun("ip_2", value);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showIpDialog(BuildContext ctx, String ipAddress) {
    var ipController = ipAddress;
    showDialog(
      context: ctx,
      builder: (ctx) {
        return SizedBox(
          width: 150,
          height: 50,
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text("Set IP"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: ipController,
                  onChanged: (value) {
                    ipController = value;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Please enter IP!"),
                      ),
                      contentPadding: EdgeInsets.all(10)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            if (ipTitle == "IP-1") {
                              ipAddressFun("ip_1", ipController);
                            }
                            if (ipTitle == "IP-2") {
                              ipAddressFun("ip_2", ipController);
                            }
                            SharedUtil().reloadPref();
                          },
                          child: const Text("Submit"))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
