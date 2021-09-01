import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language/api/my_api.dart';
import 'package:language/models/product.dart';
import 'package:language/components/customDialogue.dart';
import 'package:language/screens/detailProduct.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 1;
  bool server = false;
  int totalPage;
  List<Product> productsData = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future<void> _onRefresh() async {
    setState(() {
      currentPage = 1;
    });
    await CallApi().getProductsData(currentPage).then((value) {
      if (!mounted) return;
      setState(() {
        totalPage = value.lastPage;
        productsData = value.data;
      });
    });

    _refreshController.refreshCompleted(resetFooterState: true);
  }

  Future<void> _onLoading() async {
    currentPage++;
    if (currentPage <= totalPage) {
      await CallApi().getProductsData(currentPage).then((value) {
        setState(() {
          productsData.addAll(value.data);
        });
      }).catchError((error) => print(error));
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testServeur();
  }

  testServeur() async {
    await CallApi().testServer().then((value) {
      if (value) {
        setState(() {
          server = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("API Laravel home"),

          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProduct(),
                      settings: RouteSettings(
                          arguments: {"mode": true, "product": null}),
                    ),
                  ).then((_) => _onRefresh());
                }),
          ],
        ),
        body: server && productsData.length != null
            ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("Pull up load");
                    } else if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("release to load more");
                    } else {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(
                        child: body,
                      ),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                    itemCount: productsData.length,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailProduct(),
                              settings: RouteSettings(arguments: {
                                "mode": false,
                                "product": productsData[index]
                              }),
                            ),
                          ).then((_) => _onRefresh());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 15),
                            height: 90,
                            color: Colors.amber,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Id : ${productsData[index].id}'),
                                  Text(
                                    '${productsData[index].name}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 38,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialogue(
                                                title: "Delete product",
                                                message: t.question,
                                                icon: Icons.message,
                                                cancel: true,
                                                onClick: () {
                                                  CallApi()
                                                      .deleteProduct(int.parse(
                                                          '${productsData[index].id}'))
                                                      .then((value) => {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return CustomDialogue(
                                                                      title:
                                                                          "Delete product",
                                                                      message: value
                                                                          .message,
                                                                      icon: Icons
                                                                          .delete,
                                                                      cancel:
                                                                          false,
                                                                      onClick:
                                                                          () {
                                                                        Navigator.of(context).pushAndRemoveUntil(
                                                                            MaterialPageRoute(builder: (context) => Home()),
                                                                            (Route<dynamic> route) => false);
                                                                      });
                                                                })
                                                          });
                                                },
                                              );
                                            });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Serveur est activé : $server"),
                      ElevatedButton(
                          onPressed: () {
                            testServeur();
                            _onRefresh();
                          },
                          child: Text('Actualisé'))
                    ],
                  ),
                ),
              ));
  }
}
