import 'package:flexible_pageview/custom/page_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'flexible_page_model.dart';

typedef GestureTapCallback = void Function(dynamic data);

typedef IndexedWidgetBuilder = Widget Function(
    BuildContext context, int index, double height, FlexiblePageModel model);

class FlexiblePageView extends StatefulWidget {
  List<dynamic> models;
  bool hasIndicator;
  bool hasFlexible;
  double height;
  ScrollPhysics physics;

  // lamda
  IndexedWidgetBuilder itemBuilder;

  FlexiblePageView({
    this.models,
    this.hasIndicator = false,
    this.hasFlexible = true,
    this.height,
    this.physics,
    @required this.itemBuilder,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FlexiblePageState(
      models,
      hasIndicator: this.hasIndicator,
      hasFlexible: hasFlexible,
      height: height,
      physics: physics,
      itemBuilder: itemBuilder,
    );
  }
}

class _FlexiblePageState extends State<FlexiblePageView> {
  double totalHeight = 0.0;
  List<dynamic> _models = new List();
  bool hasIndicator = false;
  bool hasFlexible;
  double height;
  ScrollPhysics physics;

  // lamda
  IndexedWidgetBuilder itemBuilder;

  // controller
  PageController _pageBannerController;

  _FlexiblePageState(
    this._models, {
    this.hasIndicator = false,
    this.hasFlexible = true,
    this.height = 200.0,
    this.physics,
    @required this.itemBuilder,
  });

  @override
  void initState() {
    super.initState();
    _pageBannerController = new PageController();
    if (hasFlexible) {
      _pageBannerController.addListener(() {
        double ratio = _pageBannerController.page;
        int x1 = _pageBannerController.page.toInt();
        if (x1 == _models.length - 1) {
          return;
        }
        int x2 = x1 + 1;
        FlexiblePageModel model1 = _models[x1];
        FlexiblePageModel model2 = _models[x2];
        setState(() {
          totalHeight =
              model1.height + (ratio - x1) * (model2.height - model1.height);
        });
      });
    }
  }

  @override
  void dispose() {
    _pageBannerController.dispose();
    super.dispose();
  }

  // widget
  Widget indicator() {
    return new Positioned(
      bottom: 10.0,
      right: 0.0,
      left: 0.0,
      child: Container(
        child: Center(
          child: Container(
            width: _models.length * 20.0,
            height: 20.0,
            child: PageIndicator(
              controller: _pageBannerController,
              itemCount: _models.length,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (hasFlexible) {
      if (totalHeight == 0) {
        initBannerHeight(screenSize);
      }
    }
    return Container(
      height: hasFlexible ? totalHeight : height,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            physics: this.physics,
            controller: _pageBannerController,
            itemCount: _models.length,
            itemBuilder: (BuildContext context, int index) {
              FlexiblePageModel model = _models[index];
              return FutureBuilder<ui.Image>(
                future: model.completer.future,
                builder: (context, snapshot) {
                  if (snapshot == null || snapshot.data == null) {
                    return Center();
                  }
                  double h = height;
                  if (hasFlexible) {
                    h = screenSize.width /
                        (snapshot.data.width / snapshot.data.height);
                    model.height = h;
                  }
                  return itemBuilder(context, index, h, model);
                },
              );
            },
          ),
          hasIndicator ? indicator() : Container(),
        ],
      ),
    );
  }

  Future<void> initBannerHeight(Size size) async {
    FlexiblePageModel model = _models[0];
    model.completer.future.then((value) {
      double h = size.width / (value.width / value.height);
      setState(() {
        totalHeight = h;
      });
    });
  }
}
