import 'package:flutter/material.dart';
import './page_view_indicator.dart';
import './model.dart';
import './../global/uidata.dart';
import 'package:vsartist/src/global/shared-data.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: GymTutorialBody(),
    );
  }
}

class GymTutorialBody extends StatefulWidget {
  GymTutorialBody({Key key}) : super(key: key);

  @override
  GymTutorialBodyState createState() => GymTutorialBodyState();
}

class GymTutorialBodyState extends State<GymTutorialBody> {
  var deviceSize;
  PageController _pageController;
  CrossFadeState _bottomState = CrossFadeState.showFirst;
  
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
  }

  void _pageListener() {
    if (_pageController.hasClients) {
      double page = _pageController.page ?? _pageController.initialPage;
      setState(() {
        if (page >= 3) {
          _bottomState = CrossFadeState.showSecond;
        } else {
          _bottomState = CrossFadeState.showFirst;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage(pages[index].background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: deviceSize.height * 0.20,
                    ),
                    Image.asset(
                      pages[index].assetImagePath,
                      width: MediaQuery.of(context).size.width * 0.35,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                        padding: pages[index].title == ''
                            ? const EdgeInsets.only(top: 0.0)
                            : EdgeInsets.only(top: deviceSize.height * 0.10)),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30.0),
                      child: Text(
                        pages[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: pages[index].textColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'josefinSlab',
                            fontSize: 25.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30.0),
                      child: Text(
                        pages[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: pages[index].textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ));
          },
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 55.0,
              alignment: Alignment.center,
              child: AnimatedCrossFade(
                crossFadeState: _bottomState,
                duration: Duration(milliseconds: 300),
                firstChild: PageIndicators(pageController: _pageController),
                secondChild: FlatButton(
                  color: Colors.orangeAccent,
                  onPressed: () {
                    SharedData _pref = SharedData();
                    _pref.setScreenBaorded(true);
                    Navigator.of(context).pushReplacementNamed(UiData.login);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 98.0),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageIndicators extends StatelessWidget {
  final PageController pageController;

  const PageIndicators({Key key, this.pageController}) : super(key: key);

  Widget skipButton() => InkWell(
        onTap: () {
          pageController.animateToPage(3,
              curve: Curves.decelerate, duration: Duration(milliseconds: 500));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Text(
            'Skip',
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 19.0),
          ),
        ),
      );

  Widget finishButton(context) => InkWell(
        onTap: () {
          SharedData _pref = SharedData();
          _pref.setScreenBaorded(true);
          Navigator.of(context).pushReplacementNamed(UiData.login);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Text(
            'Finish',
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.w700,
                fontSize: 19.0),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.center,
            child: PageViewIndicator(
              controller: pageController,
              pageCount: 4,
              color: Colors.black,
            )),
        Align(
          alignment: Alignment.centerRight,
          child:
            //pageController.page!=null &&  pageController.page >= 3 ? finishButton(context) : skipButton(),
            pageController.page!=null &&  pageController.page.round() >= 3 ? finishButton(context) : skipButton(),
        ),
      ],
    );
  }
}
