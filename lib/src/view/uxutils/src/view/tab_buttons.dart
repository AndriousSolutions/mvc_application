import 'package:flutter/material.dart';

/// Produces a list of Tabs long the screen.
class TabButtons extends StatefulWidget {
  /// Supply the 'general appearance' of the screen's [ListView]
  TabButtons({
    Key? key,
    this.foregroundOn = Colors.white,
    this.foregroundOff = Colors.black,
    this.backgroundOn = Colors.blue,
    this.backgroundOff,
    this.height = 49,
    this.physics,
    this.padding = 6,
    this.borderRadius = 7,
    this.durationOff = 75,
    this.durationOn = 150,
  }) : super(key: key);

  /// active button's foreground color
  final Color foregroundOn;

  /// inactive button's foreground color
  final Color foregroundOff;

  /// active button's background color
  final Color? backgroundOn;

  /// inactive button's background color
  final Color? backgroundOff;

  /// Tabs' height
  final double? height;

  /// Tabs' Scroll Physics
  final ScrollPhysics? physics;

  /// Tabs' padding
  final double? padding;

  /// Tabs' border thickness
  final double borderRadius;

  /// Tabs' duration off
  final int? durationOff;

  /// Tabs' duration on.
  final int? durationOn;

  /// The Tabs and Views displayed on the screen.
  Map<Widget, Widget> get tabView => _tabViews;

  /// Assign what's displayed on the screen.
  set tabView(Map<Widget, Widget>? tabViews) {
    if (tabViews == null) {
      return;
    }
    _tabViews.addAll(tabViews);
  }

  final Map<Widget, Widget> _tabViews = {};

  @override
  State createState() => _TabButtonsState();
}

class _TabButtonsState extends State<TabButtons> with TickerProviderStateMixin {
  // TickerProviderStateMixin allows the fade out/fade in animation when changing the active button

  // this will control the button clicks and tab changing
  TabController? _controller;

  // this will control the animation when a button changes from an off state to an ON state
  late AnimationController _animationControllerOn;

  // this will control the animation when a button changes from an on state to an OFF state
  late AnimationController _animationControllerOff;

  // this will give the background color values of a button when it changes to an ON state
  late Animation<Color?> _colorTweenBackgroundOn;

//  late Animation<Color?>? _colorTweenBackgroundOff;

  // this will give the foreground color values of a button when it changes to an ON state
  // Animation<Color> _colorTweenForegroundOn;
  // Animation<Color> _colorTweenForegroundOff;

  // when swiping, the _controller.index value only changes after the animation, therefore, we need this to trigger the animations and save the current index
  int _currentIndex = 0;

  // saves the previous active tab
  int _prevControllerIndex = 0;

  // saves the value of the tab animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
  double _aniValue = 0;

  // saves the previous value of the tab animation. It's used to figure the direction of the animation
  double _prevAniValue = 0;

  // register if the the button was tapped
  bool _buttonTap = false;

  // scroll controller for the TabBar
  final ScrollController _scrollController = ScrollController();

  // this will save the keys for each Tab in the Tab Bar, so we can retrieve their position and size for the scroll controller
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    //
    super.initState();

    if (widget._tabViews.isEmpty) {
      _tabKeys = [];
      _tabValues = [];
    } else {
      _tabKeys = widget._tabViews.keys.toList();
      _tabValues = widget._tabViews.values.toList();
    }

    // _foregroundOn = widget.foregroundOn ?? Colors.white;
    // _foregroundOff = widget.foregroundOff ?? Colors.black;
    _backgroundOn = widget.backgroundOn ?? Colors.blue;
    _backgroundOff = widget.backgroundOff ?? Colors.grey[300];
    _height = widget.height ?? 49;
    _padding = widget.padding ?? 6;
//    _borderRadius = widget.borderRadius ?? 7;
    _durationOff = widget.durationOff ?? 75;
    _durationOn = widget.durationOn ?? 150;

    for (var index = 0; index < _tabKeys!.length; index++) {
      // create a GlobalKey for each Tab
      _keys.add(GlobalKey());
    }

    // this creates the controller with 6 tabs (in our case)
    _controller = TabController(vsync: this, length: _tabKeys!.length);
    // this will execute the function every time there's a swipe animation
    _controller!.animation!.addListener(_handleTabAnimation);
    // this will execute the function every time the _controller.index value changes
    _controller!.addListener(_handleTabChange);

    _animationControllerOff = AnimationController(
        vsync: this, duration: Duration(milliseconds: _durationOff));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOff.value = 1.0;
    // _colorTweenBackgroundOff =
    //     ColorTween(begin: _backgroundOn, end: _backgroundOff)
    //         .animate(_animationControllerOff);
    // _colorTweenForegroundOff =
    //     ColorTween(begin: _foregroundOn, end: _foregroundOff)
    //         .animate(_animationControllerOff);

    _animationControllerOn = AnimationController(
        vsync: this, duration: Duration(milliseconds: _durationOn));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
    // _colorTweenForegroundOn =
    //     ColorTween(begin: _foregroundOff, end: _foregroundOn)
    //         .animate(_animationControllerOn);
  }

  //
  List<Widget>? _tabKeys;
  List<Widget>? _tabValues;

  // // active button's foreground color
  // Color _foregroundOn;
  // Color _foregroundOff;
  // active button's background color
  Color? _backgroundOn;
  Color? _backgroundOff;

  double? _height;
  late double _padding;
//  double _borderRadius;
  late int _durationOff;
  late int _durationOn;

  @override
  void dispose() {
    _tabKeys = null;
    _tabValues = null;
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        // this is the TabBar
        Container(
            height: _height! > 0 ? _height : 49,
            // this generates our tabs buttons
            child: ListView.builder(
              // this gives the TabBar a bounce effect when scrolling farther than it's size
              physics: widget.physics ?? const BouncingScrollPhysics(),
              controller: _scrollController,
              // make the list horizontal
              scrollDirection: Axis.horizontal,
              // number of tabs
              itemCount: _tabKeys!.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                // each button's key
                key: _keys[index],
                // padding for the buttons
                padding: EdgeInsets.all(_padding > 0 ? _padding : 6),
                child: ButtonTheme(
                  child: AnimatedBuilder(
                    animation: _colorTweenBackgroundOn,
                    builder: (context, child) => TextButton(
                      // get the color of the button's background (dependent of its state)
//                      color: _getBackgroundColor(index),
                      // make the button a rectangle with round corners
//                      shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                              _borderRadius > 0 ? _borderRadius : 7)),
                      onPressed: () {
                        setState(() {
                          _buttonTap = true;
                          // trigger the controller to change between Tab Views
                          _controller!.animateTo(index);
                          // set the current index
                          _setCurrentIndex(index);
                          // scroll to the tapped button (needed if we tap the active button and it's not on its position)
                          _scrollTo(index);
                        });
                      },
                      child: _tabKeys![index],
                    ),
                  ),
                ),
              ),
            )),
        Flexible(
            // this will host our Tab Views
            child: TabBarView(
          // and it is controlled by the controller
          controller: _controller,
          children: _tabValues!,
        )),
      ]);

  // runs during the switching tabs animation
  void _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = _controller!.animation!.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  void _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) {
      _setCurrentIndex(_controller!.index);
    }

    // this resets the button tap
    if ((_controller!.index == _prevControllerIndex) ||
        (_controller!.index == _aniValue.round())) {
      _buttonTap = false;
    }

    // save the previous controller index
    _prevControllerIndex = _controller!.index;
  }

  void _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });

      // trigger the button animation
      _triggerAnimation();
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  void _triggerAnimation() {
    // reset the animations so they're ready to go
    _animationControllerOn.reset();
    _animationControllerOff.reset();
    // run the animations!
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  void _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    var screenWidth = MediaQuery.of(context).size.width;

    // get the button we want to scroll to
    var renderBox =
        _keys[index].currentContext!.findRenderObject() as RenderBox;
    // get its size
    var size = renderBox.size.width;
    // and position
    var position = renderBox.localToGlobal(Offset.zero).dx;

    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    var offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = _keys[0].currentContext!.findRenderObject() as RenderBox;
      // get the position of the first button of the TabBar
      position = renderBox.localToGlobal(Offset.zero).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (position > offset) {
        offset = position;
      }
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = _keys[_tabKeys!.length - 1].currentContext!.findRenderObject()
          as RenderBox;
      // get its position
      position = renderBox.localToGlobal(Offset.zero).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) {
        screenWidth = position + size;
      }

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    // scroll the calculated amount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: const Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  // Color _getBackgroundColor(int index) {
  //   if (index == _currentIndex) {
  //     // if it's active button
  //     return _colorTweenBackgroundOn.value;
  //   } else if (index == _prevControllerIndex) {
  //     // if it's the previous active button
  //     return _colorTweenBackgroundOff.value;
  //   } else {
  //     // if the button is inactive
  //     return _backgroundOff;
  //   }
  // }

/*
  Color _getForegroundColor(int index) {
    // the same as the above
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return _foregroundOff;
    }
  }
*/
}
