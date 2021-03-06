import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller}) : super(key: key) {
    height = Tween<double>(begin: 0, end: 300).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
        reverseCurve: Interval(0.0, 0.6, curve: Curves.easeIn)));

    ColorTween colorTween1 = ColorTween(begin: Colors.green, end: Colors.red);
    ColorTween colorTween2 = ColorTween(begin: Colors.red, end: Colors.yellow);
    color = TweenSequence([
      TweenSequenceItem(tween: colorTween1, weight: 60),
      TweenSequenceItem(tween: colorTween2, weight: 40),
    ]).animate(controller);

    padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: .0),
      end: EdgeInsets.only(left: 250.0),
    )
        .chain(CurveTween(curve: Interval(0.6, 1.0, curve: Curves.ease)))
        .animate(controller);
  }

  final AnimationController controller;
  Animation<double> height;
  Animation<Color> color;
  Animation<EdgeInsets> padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          alignment: Alignment.bottomLeft,
          padding: padding.value,
          child: Container(
            color: color.value,
            width: 50,
            height: height.value,
          ),
        );
      },
    );
  }
}

class StaggerRoute extends StatefulWidget {
  @override
  _StaggerRouteState createState() => _StaggerRouteState();
}

class _StaggerRouteState extends State<StaggerRoute>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  Future<Null> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _playAnimation();
      },
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          child: StaggerAnimation(
            controller: _controller,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
