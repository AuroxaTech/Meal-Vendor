// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:vendor/services/app.service.dart';
// import 'package:vendor/widgets/base.page.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class CustomWebViewPage extends StatefulWidget {
//   //
//   const CustomWebViewPage({
//     super.key,
//     required this.selectedUrl,
//   });
//
//   final String selectedUrl;
//
//   @override
//   State<CustomWebViewPage> createState() => _CustomWebViewPageState();
// }
//
// class _CustomWebViewPageState extends State<CustomWebViewPage> {
//   //
//   String pageTitle = "";
//   String selectedUrl = "";
//   bool isLoading = false;
//   final GlobalKey webViewKey = GlobalKey();
//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//         clearCache: true,
//         cacheEnabled: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//         clearSessionCache: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));
//
//   PullToRefreshController? pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//   bool pageClosed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     pageClosed = false;
//
//     //
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//
//     ///
//     selectedUrl = widget.selectedUrl.replaceFirst("http://", "https://");
//     if (!selectedUrl.contains("?")) {
//       selectedUrl =
//           "$selectedUrl?lan=${LocalizeAndTranslate.getLocale().languageCode}";
//     } else {
//       selectedUrl =
//           "$selectedUrl&lan=${LocalizeAndTranslate.getLocale().languageCode}";
//     }
//
//     setState(() {
//       selectedUrl = selectedUrl;
//     });
//   }
//
//   //setup listeners
//   setupCustomEventListener(
//     InAppWebViewController controller,
//     BuildContext context,
//   ) {
//     //close page
//     controller.addJavaScriptHandler(
//       handlerName: 'handlerClosePage',
//       callback: (args) {
//         //only call once
//         if (pageClosed) {
//           return;
//         }
//         closePage();
//       },
//     );
//     //open link in browser
//     controller.addJavaScriptHandler(
//       handlerName: 'handlerOpenLink',
//       callback: (args) {
//         //only call once
//         if (pageClosed) {
//           return;
//         }
//
//         bool closePage = args[1] ?? true;
//         String url = args[0];
//         if (closePage) {
//           this.closePage();
//         }
//         launchUrlString(
//           url,
//           mode: LaunchMode.externalApplication,
//         );
//       },
//     );
//   }
//
//   //close page
//   closePage() {
//     //only call once
//     if (pageClosed) {
//       return;
//     }
//     if (null != AppService().navigatorKey.currentContext) {
//       Navigator.pop(AppService().navigatorKey.currentContext!);
//     }
//     pageClosed = true;
//     setState(() {
//       pageClosed = true;
//     });
//   }
//
//   //UI Build
//   @override
//   Widget build(BuildContext context) {
//     //
//     return BasePage(
//       showAppBar: true,
//       showLeadingAction: true,
//       title: pageTitle,
//       leading: IconButton(
//         icon: const Icon(
//           FlutterIcons.arrow_left_fea,
//           color: Colors.white,
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       body: VStack(
//         [
//           //loading
//           Visibility(
//             visible: isLoading,
//             child: const LinearProgressIndicator(),
//           ),
//           //page
//           InAppWebView(
//             key: webViewKey,
//             initialUrlRequest:
//                 URLRequest(url: (Uri.parse(selectedUrl))),
//             initialOptions: options,
//             pullToRefreshController: pullToRefreshController,
//             onWebViewCreated: (controller) {
//               webViewController = controller;
//               setupCustomEventListener(controller, context);
//             },
//             onLoadStart: (controller, url) {
//               setState(() {
//                 this.url = url.toString();
//                 urlController.text = this.url;
//               });
//             },
//             androidOnPermissionRequest: (controller, origin, resources) async {
//               return PermissionRequestResponse(
//                 resources: resources,
//                 action: PermissionRequestResponseAction.GRANT,
//               );
//             },
//             shouldOverrideUrlLoading: (controller, navigationAction) async {
//               var uri = navigationAction.request.url;
//
//               if (![
//                 "http",
//                 "https",
//                 "file",
//                 "chrome",
//                 "data",
//                 "javascript",
//                 "about"
//               ].contains(uri?.scheme)) {
//                 if (await canLaunchUrlString(url)) {
//                   // Launch the App
//                   await launchUrlString(
//                     url,
//                     mode: LaunchMode.externalApplication,
//                   );
//                   // and cancel the request
//                   return NavigationActionPolicy.CANCEL;
//                 }
//               }
//
//               return NavigationActionPolicy.ALLOW;
//             },
//             onLoadStop: (controller, url) async {
//               pullToRefreshController?.endRefreshing();
//               setState(() {
//                 this.url = url.toString();
//                 urlController.text = this.url;
//               });
//             },
//             onLoadError: (controller, url, code, message) {
//               pullToRefreshController?.endRefreshing();
//             },
//             onProgressChanged: (controller, progress) {
//               if (progress == 100) {
//                 pullToRefreshController?.endRefreshing();
//               }
//               setState(() {
//                 this.progress = progress / 100;
//                 urlController.text = this.url;
//                 isLoading = this.progress != 1;
//               });
//             },
//             onUpdateVisitedHistory: (controller, url, androidIsReload) {
//               setState(() {
//                 this.url = url.toString();
//                 urlController.text = this.url;
//               });
//             },
//             onConsoleMessage: (controller, consoleMessage) {
//               if (kDebugMode) {
//                 log("console log ===> $consoleMessage");
//               }
//             },
//           ).pOnly(bottom: context.mq.viewInsets.bottom).expand(),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:vendor/services/app.service.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomWebViewPage extends StatefulWidget {
  const CustomWebViewPage({super.key, required this.selectedUrl});

  final String selectedUrl;

  @override
  State<CustomWebViewPage> createState() => _CustomWebViewPageState();
}

class _CustomWebViewPageState extends State<CustomWebViewPage> {
  late final WebViewController _webViewController;
  String pageTitle = "";
  bool isLoading = true;
  bool pageClosed = false;
  String finalUrl = "";

  @override
  void initState() {
    super.initState();

    // Setup platform-specific WebView (important for Android)
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    finalUrl = widget.selectedUrl.replaceFirst("http://", "https://");
    final lan = LocalizeAndTranslate.getLocale().languageCode;
    if (!finalUrl.contains("?")) {
      finalUrl = "$finalUrl?lan=$lan";
    } else {
      finalUrl = "$finalUrl&lan=$lan";
    }

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          setState(() => isLoading = true);
        },
        onPageFinished: (_) {
          setState(() => isLoading = false);
        },
        onNavigationRequest: (NavigationRequest request) async {
          final uri = Uri.parse(request.url);
          if (!["http", "https"].contains(uri.scheme)) {
            if (await canLaunchUrlString(request.url)) {
              await launchUrlString(
                request.url,
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
      ))
      ..addJavaScriptChannel(
        'handlerClosePage',
        onMessageReceived: (_) => closePage(),
      )
      ..addJavaScriptChannel(
        'handlerOpenLink',
        onMessageReceived: (msg) async {
          final data = msg.message.split('|');
          final url = data[0];
          final shouldClose = data.length > 1 ? data[1] == 'true' : true;

          if (shouldClose) closePage();

          if (await canLaunchUrlString(url)) {
            await launchUrlString(
              url,
              mode: LaunchMode.externalApplication,
            );
          }
        },
      )
      ..loadRequest(Uri.parse(finalUrl));
  }

  void closePage() {
    if (pageClosed) return;
    pageClosed = true;
    if (AppService().navigatorKey.currentContext != null) {
      Navigator.pop(AppService().navigatorKey.currentContext!);
    }
    setState(() {
      pageClosed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      title: pageTitle,
      leading: IconButton(
        icon: const Icon(
          FlutterIcons.arrow_left_fea,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      body: VStack(
        [
          Visibility(
            visible: isLoading,
            child: const LinearProgressIndicator(),
          ),
          WebViewWidget(controller: _webViewController)
              .pOnly(bottom: context.mq.viewInsets.bottom)
              .expand(),
        ],
      ),
    );
  }
}
