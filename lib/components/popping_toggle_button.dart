import 'package:flutter/material.dart';

class PoppingToggleButton extends StatefulWidget {
  final Widget firstButton;
  final Widget secondButton;
  final Function() onTap;
  final Widget? customParticle;
  final double particleSize;
  final double startRadius;
  final double endRadius;
  final int milliseconds;
  final bool disabledButtonIsFirstButton;
  final bool isDisabled;

  const PoppingToggleButton({
    super.key,
    required this.firstButton,
    required this.secondButton,
    required this.onTap,
    this.customParticle,
    this.particleSize = 8,
    this.startRadius = 0.0,
    required this.endRadius,
    required this.milliseconds,
    this.disabledButtonIsFirstButton = true,
    this.isDisabled = false,
  });

  @override
  State<PoppingToggleButton> createState() => _PoppingToggleButtonState();
}

class _PoppingToggleButtonState extends State<PoppingToggleButton>
    with TickerProviderStateMixin {
  bool _isTapped = false;
  late AnimationController _scaleController1;
  late AnimationController _scaleController2;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.milliseconds / 2).ceil()),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _scaleController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.milliseconds / 2).ceil()),
    );
    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.milliseconds),
    );
    _scaleAnimation1 = CurvedAnimation(
      parent: _scaleController1,
      curve: Curves.linear,
    );
    _scaleAnimation2 = CurvedAnimation(
      parent: _scaleController2,
      curve: Curves.easeOutExpo,
    );
    _rotateAnimation = CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeOutExpo,
    );
  }

  @override
  void dispose() {
    _scaleController1.dispose();
    _scaleController2.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () async {
              setState(() {
                _isTapped = !_isTapped;
              });
              await widget.onTap();
              if (_isTapped) {
                _scaleController1
                    .forward()
                    .then((_) => _scaleController1.reverse());
                _rotateController.forward();
                _scaleController2.forward().then((_) {
                  _scaleController2
                      .reverse()
                      .then((value) => _rotateController.reset());
                });
              }
            },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _PositionedParticle(
            particle: widget.customParticle == null
                ? Icon(
                    Icons.circle_rounded,
                    size: widget.particleSize,
                    color: Colors.greenAccent,
                  )
                : widget.customParticle!,
            particleSize: widget.particleSize,
            endLeft: -widget.endRadius,
            endTop: -widget.endRadius,
            rotate: _rotateAnimation,
            scale: _scaleAnimation2,
          ),
          _PositionedParticle(
            particle: widget.customParticle == null
                ? Icon(
                    Icons.circle_rounded,
                    size: widget.particleSize,
                    color: Colors.deepPurpleAccent,
                  )
                : widget.customParticle!,
            particleSize: widget.particleSize,
            endLeft: widget.endRadius,
            endTop: -widget.endRadius,
            rotate: _rotateAnimation,
            scale: _scaleAnimation2,
          ),
          _PositionedParticle(
            particle: widget.customParticle == null
                ? Icon(
                    Icons.circle_rounded,
                    size: widget.particleSize,
                    color: Colors.pinkAccent,
                  )
                : widget.customParticle!,
            particleSize: widget.particleSize,
            endLeft: widget.endRadius,
            endTop: widget.endRadius,
            rotate: _rotateAnimation,
            scale: _scaleAnimation2,
          ),
          _PositionedParticle(
            particle: widget.customParticle == null
                ? Icon(
                    Icons.circle_rounded,
                    size: widget.particleSize,
                    color: Colors.blueAccent,
                  )
                : widget.customParticle!,
            particleSize: widget.particleSize,
            endLeft: -widget.endRadius,
            endTop: widget.endRadius,
            rotate: _rotateAnimation,
            scale: _scaleAnimation2,
          ),
          ScaleTransition(
            scale: _scaleAnimation1,
            child: AnimatedCrossFade(
              firstChild: widget.isDisabled
                  ? widget.disabledButtonIsFirstButton
                      ? widget.firstButton
                      : widget.secondButton
                  : widget.firstButton,
              secondChild: widget.secondButton,
              crossFadeState: _isTapped
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(
                milliseconds: (widget.milliseconds / 2).ceil(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionedParticle extends StatelessWidget {
  final Widget particle;
  final double particleSize;
  final double endLeft;
  final double endTop;
  final Animation<double> rotate;
  final Animation<double> scale;

  const _PositionedParticle({
    required this.particle,
    required this.particleSize,
    required this.endLeft,
    required this.rotate,
    required this.endTop,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
          const Rect.fromLTWH(0, 0, 0, 0),
          Size.zero,
        ),
        end: RelativeRect.fromSize(
          Rect.fromLTWH(
            endLeft,
            endTop,
            particleSize,
            particleSize,
          ),
          Size(particleSize, particleSize),
        ),
      ).animate(rotate),
      child: ScaleTransition(
        scale: scale,
        child: particle,
      ),
    );
  }
}
