import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'dart:io';

import '../globals/globals.dart';

class SitePage extends StatefulWidget {
  const SitePage({Key? key}) : super(key: key);

  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  String url = "";
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(
          color: Colors.grey,
        ),
        onRefresh: () async {
          if (Platform.isAndroid) {
            inAppWebViewController?.reload();
          } else if (Platform.isIOS) {
            inAppWebViewController?.loadUrl(
                urlRequest:
                    URLRequest(url: await inAppWebViewController?.getUrl()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
            url: Uri.parse(Global.currentSite['website']),
          ),
          onWebViewCreated: (controller) {
            inAppWebViewController = controller;
          },
          pullToRefreshController: pullToRefreshController,
          onLoadStop: (controller, url) async {
            pullToRefreshController.endRefreshing();
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },
          initialOptions: options,
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 12),
            FloatingActionButton(
              onPressed: () {
                inAppWebViewController?.goBack();
              },
              mini: true,
              child: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
            FloatingActionButton(
              onPressed: () {
                Global.bookMarkList.add(url);
                Global.bookMarkList.toSet().toList();
              },
              mini: true,
              child: const Icon(Icons.bookmark_add_outlined),
            ),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Center(
                          child: Text('All Bookmarks',
                              style: TextStyle(color: Colors.green))),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.75,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: ListView.separated(
                          itemCount: Global.bookMarkList.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).pop();
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: Uri.parse(Global.bookMarkList[i]),
                                  ),
                                );
                              },
                              onLongPress: () {
                                setState(() {
                                  Global.bookMarkList.removeAt(i);
                                });
                              },
                              title: Text(
                                Global.bookMarkList[i],
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                              ),
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider(
                              color: Colors.black,
                              endIndent: 30,
                              indent: 30,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              mini: true,
              child: const Icon(Icons.bookmark_border),
            ),
            FloatingActionButton(
              onPressed: () {
                inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: Uri.parse(Global.currentSite['website']),
                  ),
                );
              },
              mini: true,
              child: const Icon(Icons.home),
            ),
            FloatingActionButton(
              onPressed: () {
                inAppWebViewController?.reload();
              },
              mini: true,
              child: const Icon(Icons.refresh),
            ),
            FloatingActionButton(
              onPressed: () {
                inAppWebViewController?.goForward();
              },
              mini: true,
              child: const Icon(Icons.arrow_forward_ios_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
