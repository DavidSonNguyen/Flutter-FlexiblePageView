import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'custom/flexible_page_model.dart';
import 'custom/flexible_pageview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flexible PageView'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> images = [
    'https://img1.ak.crunchyroll.com/i/spire4/56a5570a057475dd30cee3d6a9d7e7021545485130_full.jpg',
    'https://cdn.mos.cms.futurecdn.net/MB2ysM4LpcVVND4ibcfs37.jpg',
    'https://s3-ap-southeast-1.amazonaws.com/idoltv-website/wp-content/uploads/2018/10/18105039/hinh-nen-anime-ghoul-girl-IDOLTV-9.png',
    'https://vignette.wikia.nocookie.net/fc88e14f-1c5a-4348-89dd-2e74fb8a01e2/scale-to-width-down/800',
    'http://i0.wp.com/takoyaki.asia/wp-content/uploads/2019/03/Anime_Slider-e1553027358687.jpg?fit=670%2C335'
  ];
  List<FlexiblePageModel> listImageModel = new List();

  @override
  void initState() {
    super.initState();
    for (String link in images) {
      listImageModel.add(new FlexiblePageModel(image_link: link));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            FlexiblePageView(
              models: listImageModel,
              itemBuilder: (
                BuildContext context,
                int index,
                double height,
                FlexiblePageModel model,
              ) {
                return Container(
                  height: height,
                  child: FadeInImage(
                    placeholder: Image.asset('assets/placeholder.png').image,
                    image: model.image.image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Text('$index');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
