import 'package:flutter/material.dart';
import 'package:hyfix/Events.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:hyfix/FilterBox.dart';

class ContainerEvents extends StatefulWidget {
  const ContainerEvents({
    required this.selezionato,
    required this.lista,
    required this.data,
    required this.loading,
    required this.fetchRep,
    required this.dayReload,
    super.key,
    required this.visible,
  });

  final DateTime selezionato;
  final bool visible;
  final List<Reports> lista;
  final bool loading;
  final Function fetchRep;
  final DateTime data;
  final Function dayReload;

  @override
  _ContainerEvents createState() => _ContainerEvents();
}

class _ContainerEvents extends State<ContainerEvents> {
  bool controllo() {
    bool check = false;
    for (Reports ele in widget.lista) {
      if (DateUtils.isSameDay(widget.selezionato, ele.reportDate)) {
        check = true;
      }
    }

    return check;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it_IT', null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: AnimatedVisibility(
          enter: fadeIn(),
          exit: fadeOut(),
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              child: widget.loading
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        size: 80,
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                "${DateFormat.EEEE('it_IT').format(widget.selezionato)}, ${DateFormat.MMMd('it_IT').format(widget.selezionato)}, ${DateFormat.y('it_IT').format(widget.selezionato)}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            100 *
                                            2.5,
                                    fontWeight: FontWeight.bold)),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => Filterbox(
                                        fetchRep: widget.fetchRep,
                                        data: widget.data,
                                        aggiornaData: widget.dayReload),
                                  );
                                },
                                child: Icon(
                                  Icons.filter_alt,
                                  color:
                                      Theme.of(context).colorScheme.surface,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          //   child: Padding(
                          // padding: const EdgeInsets.only(bottom: 5),
                          child: Events(
                              data: widget.selezionato, lista: widget.lista),
                        ),
                      ],
                    ))),
    );
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
