// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/utils.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:nomnom/widgets/wrapper.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Customization3D extends StatefulWidget {
  const Customization3D({super.key});

  @override
  State<Customization3D> createState() => _Customization3DState();
}

class _Customization3DState extends State<Customization3D> {
  late final WebViewController _controller;
  final fc = Get.find<FoodScreenController>();
  var pos = 0.obs;
  String callBackUrl = '';
  bool closeWebView = false;
  final int ix = Get.arguments['ix'];
  final String name = Get.arguments['name'];

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          debugPrint('WebView is loading (progress : $progress%)');
        }, onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        }, onPageFinished: (String url) {
          debugPrint('Page finished loading: $url');
        }, onWebResourceError: (WebResourceError error) {
          debugPrint('''Page resource error: 
                        code: ${error.errorCode}
                        description: ${error.description}
                        errorType: ${error.errorType}
                        isForMainFrame: ${error.isForMainFrame}
          ''');
        }, onNavigationRequest: (NavigationRequest request) async {
          if (!request.url.startsWith("https:")) {
            debugPrint("The URL is ${request.url}");
            if (await canLaunchUrlString(request.url)) {
              launchUrlString(request.url);
            }
            return NavigationDecision.prevent;
          }
          debugPrint('allowing navigation to ${request.url}');
          return NavigationDecision.navigate;
        }, onUrlChange: (UrlChange change) async {
          Uri uri = Uri.parse(change.url!);
          fc.customizations[ix] = uri.queryParameters['customizations'];
          print(fc.customizations[ix]);
        }),
      )
      ..loadRequest(Uri.parse('https://hackniche2-3d.vercel.app/'));
    _controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      child: FocusedLayout(
        fab: FloatingActionButton(
          backgroundColor: AppColors.greenAccent,
          onPressed: () {
            Get.back();
            Utils.showBottomSnackBar(
                title: "Success!",
                message: "Added ingredients, you may view them in the cart",
                ic: Icon(
                  EvaIcons.doneAllOutline,
                  color: AppColors.greenAccent,
                ));
          },
          child: Icon(
            EvaIcons.checkmark,
            color: Colors.white,
          ),
        ),
        appBarTitle: 'Add Ingredients',
        child: Obx(() => SafeArea(
              child: closeWebView
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orangeAccent,
                        ),
                      ),
                    )
                  : IndexedStack(
                      index: pos.value,
                      children: [
                        WebViewWidget(controller: _controller),
                        Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orangeAccent,
                            ),
                          ),
                        )
                      ],
                    ),
            )),
      ),
    );
  }
}
