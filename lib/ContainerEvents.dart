import 'package:flutter/material.dart';
import 'package:progetto/Events.dart';

class ContainerEvents extends StatefulWidget {
  const ContainerEvents(
      {required this.selezionato,
      super.key,
      required this.visible,
      required this.lista});
  final DateTime selezionato;
  final bool visible;

  final List lista;

  _ContainerEvents createState() => _ContainerEvents();
}

class _ContainerEvents extends State<ContainerEvents> {
  bool controllo() {
    bool check = false;
    widget.lista.forEach((ele) {
      if (DateUtils.isSameDay(widget.selezionato, ele.data)) {
        check = true;
      }
    });

    return check;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
        visible: widget.visible,
        enter: fadeIn(),
        exit: fadeOut(),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(227, 170, 237, 255)
                        .withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 140, 219, 255)),
            child: controllo()
                ? Events(lista: widget.lista, data: widget.selezionato)
                : const Center(child: Text("NON CI SONO ATTIVITÀ"))));
  }
}

///////////////////   ANIMAZIONE  ////////////////////////
@immutable
class TransitionData {
  final Fade? fade;

  const TransitionData({
    this.fade,
  });
}

@immutable
class Fade {
  final Animatable<double> animation;
  const Fade(this.animation);
}

@immutable
abstract class EnterTransition {
  TransitionData get data;

  /// Combines different enter transitions.
  /// * [enter]- another EnterTransition to be combined
  EnterTransition operator +(EnterTransition enter) {
    return EnterTransitionImpl(
      TransitionData(
        fade: data.fade ?? enter.data.fade,
      ),
    );
  }
}

//////////    IMPLEMENTAZIONI   //////////

@immutable
class EnterTransitionImpl extends EnterTransition {
  @override
  final TransitionData data;

  EnterTransitionImpl(this.data);
}

@immutable
abstract class ExitTransition {
  TransitionData get data;

  /// Combines different exit transitions.
  ExitTransition operator +(ExitTransition exit) {
    return ExitTransitionImpl(
      TransitionData(
        fade: data.fade ?? exit.data.fade,
      ),
    );
  }
}

class ExitTransitionImpl extends ExitTransition {
  @override
  final TransitionData data;

  ExitTransitionImpl(this.data);
}

////////////    ENTRATA    ////////////

EnterTransition fadeIn({
  double initialAlpha = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> fadeInTransition = Tween<double>(
    begin: initialAlpha,
    end: 1.0,
  ).chain(CurveTween(curve: curve));

  return EnterTransitionImpl(
    TransitionData(fade: Fade(fadeInTransition)),
  );
}

////////////    USCITA     ///////////

ExitTransition fadeOut({
  double targetAlpha = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: targetAlpha,
  ).chain(CurveTween(curve: curve));

  return ExitTransitionImpl(
    TransitionData(fade: Fade(fadeOutTransition)),
  );
}

////////////    VISIBILITY    ///////////

class AnimatedVisibility extends StatefulWidget {
  static final defaultEnterTransition = fadeIn();
  static final defaultExitTransition = fadeOut();
  static const defaultEnterDuration = Duration(milliseconds: 500);
  static const defaultExitDuration = defaultEnterDuration;

  AnimatedVisibility({
    super.key,
    this.visible = true,
    this.child = const SizedBox.shrink(),
    EnterTransition? enter,
    ExitTransition? exit,
    Duration? enterDuration,
    Duration? exitDuration,
  })  : enter = enter ?? defaultEnterTransition,
        exit = exit ?? defaultExitTransition,
        enterDuration = enterDuration ?? defaultEnterDuration,
        exitDuration = exitDuration ?? defaultExitDuration;

  /// Whether the content should be visible or not.
  final bool visible;

  //// The widget to apply animated effects to.
  final Widget child;

  /// The enter transition to be used, [fadeIn] by default.
  final EnterTransition enter;

  /// The exit transition to be used, [fadeOut] by default.
  final ExitTransition exit;

  /// The duration of the enter transition, 500ms by default.
  final Duration enterDuration;

  /// The duration of the exit transition, 500ms by default.
  final Duration exitDuration;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      value: widget.visible ? 1.0 : 0.0,
      duration: widget.enterDuration,
      reverseDuration: widget.exitDuration,
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {});
      });

    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.visible && widget.visible) {
      _controller.forward();
    } else if (oldWidget.visible && !widget.visible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: _controller,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _build(context, child, animation, widget.enter.data) ??
            const SizedBox.shrink();
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _build(context, child, animation, widget.exit.data) ??
            const SizedBox.shrink();
      },
      child: Visibility(
        visible: _controller.status != AnimationStatus.dismissed,
        child: widget.child,
      ),
    );
  }

  Widget? _build(BuildContext context, Widget? child,
      Animation<double> animation, TransitionData data) {
    Widget? animatedChild = child;

    if (data.fade != null) {
      animatedChild = FadeTransition(
        opacity: data.fade!.animation.animate(animation),
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}
