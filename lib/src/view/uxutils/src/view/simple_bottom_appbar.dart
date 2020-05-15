///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  05 Feb 2019
///
/// Special thanks to Manas Gupta for the class, SimpleBottomAppBarState
/// https://medium.com/@guptamanas1998/get-fluttered-a-deceptively-simple-bottom-app-bar-part-2-879ddb7b063c
///
///
import 'package:flutter/material.dart'
    show
        Animation,
        AnimationController,
        BottomAppBar,
        BuildContext,
        Center,
        Clip,
        ClipRect,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        CurvedAnimation,
        Curves,
        EdgeInsets,
        FlatButton,
        FlexFit,
        Flexible,
        FontWeight,
        FractionalTranslation,
        Icon,
        IconData,
        Icons,
        Interval,
        Key,
        MainAxisAlignment,
        MainAxisSize,
        Matrix4,
        Offset,
        Opacity,
        Row,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        TickerProviderStateMixin,
        Transform,
        Tween,
        VoidCallback,
        Widget,
        required;

class SimpleBottomAppBar extends StatefulWidget {
  SimpleBottomAppBar(
      {this.button01, this.button02, this.button03, this.button04, Key key})
      : super(key: key);
  final BarButton button01;
  final BarButton button02;
  final BarButton button03;
  final BarButton button04;

  @override
  State<StatefulWidget> createState() => SimpleBottomAppBarState();
}

class SimpleBottomAppBarState extends State<SimpleBottomAppBar>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  int previousIndex;
  List<int> flexValues = [150, 100, 100, 100];
  List<double> opacityValues = [1.0, 0.0, 0.0, 0.0];
  List<double> fractionalOffsetValues = [0.0, 0.0, 0.0, 0.0];
  List<double> verticalShiftValues = [-4.0, 8.0, 8.0, 8.0];
  List<double> skewValues = [0.0, 0.0, 0.0, 0.0];
  AnimationController _controller;
  Animation animation;
  Animation skewFirstHalfAnimation;
  Animation skewSecondHalfAnimation;
  Animation translationFirstHalfAnimation;
  Animation translationSecondHalfAnimation;
  Animation opacityFirstHalfAnimation;
  Animation opacitySecondHalfAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));
    translationFirstHalfAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Interval(0.0, 0.85, curve: Curves.easeIn),
            parent: _controller));
    translationSecondHalfAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            curve: Interval(0.15, 1.0, curve: Curves.easeOut),
            parent: _controller));
    opacityFirstHalfAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Interval(0.0, 0.50, curve: Curves.easeIn),
            parent: _controller));
    opacitySecondHalfAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Interval(0.50, 1.0, curve: Curves.easeOut),
            parent: _controller));
    skewFirstHalfAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
        CurvedAnimation(
            curve: Interval(0.0, 0.3, curve: Curves.easeIn),
            parent: _controller));
    skewSecondHalfAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
        CurvedAnimation(
            curve: Interval(0.7, 1.0, curve: Curves.easeOut),
            parent: _controller));

    animation.addListener(() {
      setState(() {
        flexValues[previousIndex] = 150 - (50 * animation.value).toInt();
        flexValues[currentIndex] = 100 + (50 * animation.value).toInt();
        opacityValues[previousIndex] = 1.0 - opacityFirstHalfAnimation.value;
        opacityValues[currentIndex] = 0.0 + opacitySecondHalfAnimation.value;
        verticalShiftValues[currentIndex] = 8 - (12 * animation.value);
        verticalShiftValues[previousIndex] = -4 + (12 * animation.value);
        if (currentIndex > previousIndex) {
          fractionalOffsetValues[currentIndex] =
              -1 + translationSecondHalfAnimation.value;
          fractionalOffsetValues[previousIndex] =
              translationFirstHalfAnimation.value;
          skewValues[currentIndex] =
              skewFirstHalfAnimation.value - skewSecondHalfAnimation.value;
          skewValues[previousIndex] =
              -skewFirstHalfAnimation.value + skewSecondHalfAnimation.value;
        } else if (currentIndex < previousIndex) {
          fractionalOffsetValues[currentIndex] =
              1 - translationSecondHalfAnimation.value;
          fractionalOffsetValues[previousIndex] =
              -translationFirstHalfAnimation.value;
          skewValues[currentIndex] =
              -skewFirstHalfAnimation.value + skewSecondHalfAnimation.value;
          skewValues[previousIndex] =
              skewFirstHalfAnimation.value - skewSecondHalfAnimation.value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        width: double.infinity,
        height: 56.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: _listButtons(widget.button01, widget.button02,
              widget.button03, widget.button04),
        ),
      ),
    );
  }

  _onOptionClicked({@required int pressedIndex}) {
    if (pressedIndex != currentIndex) {
      previousIndex = currentIndex;
      currentIndex = pressedIndex;
      _controller.reset();
      _controller.forward();
    }
  }

  List<Widget> _listButtons(
    BarButton button01,
    BarButton button02,
    BarButton button03,
    BarButton button04,
  ) {
    List<Widget> btnList = [];
    int btnCount = 0;
    if (button01 != null) {
      btnList.add(_barButton(button01, btnCount));
      btnCount++;
    }
    if (button02 != null) {
      btnList.add(_barButton(button02, btnCount));
      btnCount++;
    }
    if (button03 != null) {
      btnList.add(_barButton(button03, btnCount));
      btnCount++;
    }
    if (button04 != null) {
      btnList.add(_barButton(button04, btnCount));
      btnCount++;
    }
    return btnList;
  }

  Widget _barButton(BarButton btn, int count) {
    return Flexible(
      fit: FlexFit.tight,
      flex: flexValues[count],
      child: FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        clipBehavior: Clip.none,
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          _onOptionClicked(pressedIndex: count);
          btn.onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0.0, verticalShiftValues[count]),
              child: Transform(
                transform: Matrix4.skewY(skewValues[count]),
                child: Icon(
                  btn.icon,
                  size: 22.0,
                ),
              ),
            ),
            ClipRect(
              child: FractionalTranslation(
                translation: Offset(fractionalOffsetValues[count], 0.0),
                child: Opacity(
                  opacity: opacityValues[count],
                  child: Center(
                    child: Text(
                      btn.text,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BarButton {
  const BarButton({this.text, this.icon, this.onPressed});
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
}

class HomeBarButton extends BarButton {
  HomeBarButton({VoidCallback onPressed})
      : super(
          text: 'Home',
          icon: Icons.home,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}

class DeleteBarButton extends BarButton {
  DeleteBarButton({VoidCallback onPressed})
      : super(
          text: 'Delete',
          icon: Icons.delete,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}

class EditBarButton extends BarButton {
  EditBarButton({VoidCallback onPressed})
      : super(
          text: 'Edit',
          icon: Icons.edit,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}

class SearchBarButton extends BarButton {
  SearchBarButton({VoidCallback onPressed})
      : super(
          text: 'Search',
          icon: Icons.search,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}

class StatsBarButton extends BarButton {
  StatsBarButton({VoidCallback onPressed})
      : super(
          text: 'Stats',
          icon: Icons.timeline,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}

class EventsBarButton extends BarButton {
  EventsBarButton({VoidCallback onPressed})
      : super(
          text: 'Events',
          icon: Icons.event,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}

class HistoryBarButton extends BarButton {
  HistoryBarButton({VoidCallback onPressed})
      : super(
          text: 'History',
          icon: Icons.history,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
        );
}
