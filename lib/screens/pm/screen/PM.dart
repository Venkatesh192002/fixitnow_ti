import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PM extends StatefulWidget {
  const PM({super.key});

  @override
  _PMState createState() => _PMState();
}

class _PMState extends State<PM> {
  late InAppWebViewController controller;

  String? loginId;
  String? employeeType;
  String url = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Fetch loginId and employeeType asynchronously
      loginId = await SharedUtil().getLoginId;
      employeeType = await SharedUtil().getEmployeeType;

      if (loginId == null || employeeType == null) {
        throw Exception('Login ID or Employee Type is null');
      }

      final empType = employeeType?.replaceAll("/", " ") ?? "";
      url = 'https://iots.aurolab.com/FixItNow/pm/app/$loginId/$empType';
      // url = 'http://192.168.1.220:4200/pm/app/$loginId/$empType';

      logger.f(url);
      // controller = WebViewController()
      //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //   ..setNavigationDelegate(
      //     NavigationDelegate(
      //       onPageStarted: (String url) {
      //         // logger.i('Page started: $url');
      //       },
      //       onPageFinished: (String url) {
      //         // logger.i('Page finished: $url');
      //       },
      //       // onWebResourceError: (WebResourceError error) {
      //       //   // logger.e('WebView error: ${error.description}');
      //       //   ScaffoldMessenger.of(context).showSnackBar(
      //       //     SnackBar(
      //       //         content: Text('Error loading page: ${error.description}')),
      //       //   );
      //       // },
      //     ),
      //   )
      //   ..loadRequest(Uri.parse(url));

      setState(() {}); // Trigger a rebuild once the data is loaded
    } catch (e) {
      logger.e('Failed to load data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PM Screen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No back history available")),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await controller.canGoForward()) {
                  controller.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("No forward history available")),
                  );
                }
              },
            ),
          ],
        ),
        body: loginId == null || employeeType == null
            ? const Center(child: CircularProgressIndicator())
            : InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(url)),
                onWebViewCreated: (InAppWebViewController webViewController) {
                  controller = webViewController;
                  setState(() {});
                },
              ));
  }
}
