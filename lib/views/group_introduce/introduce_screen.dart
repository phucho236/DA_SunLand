import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_screen.dart';
import 'package:flutter_core/views/group_introduce/data.dart';

class IntroduceScreen extends StatefulWidget {
  static String id = "IntroduceScreen";
  @override
  _IntroduceScreenState createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/introduce.gif",
                fit: BoxFit.cover,
                height: getScreenHeight(),
                width: getScreenWidth(),
              ),
              PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                  });
                },
                children: <Widget>[
                  SlideTile(
                    imagePath: mySLides[0].getImageAssetPath(),
                    title: mySLides[0].getTitle(),
                    desc: mySLides[0].getDesc(),
                  ),
                  SlideTile(
                    imagePath: mySLides[1].getImageAssetPath(),
                    title: mySLides[1].getTitle(),
                    desc: mySLides[1].getDesc(),
                  ),
                  SlideTile(
                    imagePath: mySLides[2].getImageAssetPath(),
                    title: mySLides[2].getTitle(),
                    desc: mySLides[2].getDesc(),
                  )
                ],
              ),
            ],
          ),
        ),
        bottomSheet: slideIndex != 2
            ? Container(
                height: 70,
                color: colorAppbar,
                //margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        controller.animateToPage(2,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear);
                      },
                      splashColor: Colors.blue[50],
                      child: Text(
                        "Bỏ qua",
                        style: styleTextContentWhite,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          _buildPageIndicator(slideIndex == 0),
                          _buildPageIndicator(slideIndex == 1),
                          _buildPageIndicator(slideIndex == 2),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print("this is slideIndex: $slideIndex");
                        controller.animateToPage(slideIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      splashColor: Colors.blue[50],
                      child: Text(
                        "Tiếp tục",
                        style: styleTextContentWhite,
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () async {
                  await setIntroduce(viewed_introduce: true);
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: Container(
                  color: colorAppbar,
                  height: 70,
                  alignment: Alignment.center,
                  child: Text(
                    "Bắt đầu",
                    style: styleTextTitleInAppWhite,
                  ),
                ),
              ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(setWidthSize(size: 15)),
        child: Material(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(setWidthSize(size: 15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
