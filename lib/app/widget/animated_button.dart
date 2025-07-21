import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BouncingIconAnimation extends StatefulWidget {
  final Widget child;
  const BouncingIconAnimation({
    super.key,
    required this.child,
  });

  @override
  BouncingIconAnimationState createState() => BouncingIconAnimationState();
}

class BouncingIconAnimationState extends State<BouncingIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scale;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    _scale = Tween(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    super.initState();
  }

  Future<void> bounce() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class AnimatedCustomButton extends StatefulWidget {
  final String? text;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback ontap;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final Widget? child;
  final bool isLoading;
  final Duration animationDuration;
  final bool enableRipple;
  final bool enableScale;
  final bool enableShimmer;

  const AnimatedCustomButton({
    super.key,
    this.text,
    this.bgColor,
    required this.ontap,
    this.textColor,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    this.child,
    this.isLoading = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableRipple = true,
    this.enableScale = true,
    this.enableShimmer = false,
  });

  @override
  State<AnimatedCustomButton> createState() => _AnimatedCustomButtonState();
}

class _AnimatedCustomButtonState extends State<AnimatedCustomButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _shimmerAnimation;

  bool _isPressed = false;
  GlobalKey<BouncingIconAnimationState>? _bouncingIconKey;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    if (widget.enableShimmer) {
      _shimmerController.repeat();
    }

    // If the child is a BouncingIconAnimation, assign a key
    if (widget.child is BouncingIconAnimation) {
      _bouncingIconKey = GlobalKey<BouncingIconAnimationState>();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the child changes to/from BouncingIconAnimation, update the key
    if (widget.child is BouncingIconAnimation && _bouncingIconKey == null) {
      _bouncingIconKey = GlobalKey<BouncingIconAnimationState>();
    } else if (widget.child is! BouncingIconAnimation &&
        _bouncingIconKey != null) {
      _bouncingIconKey = null;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableScale) {
      _scaleController.forward();
    }
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) async {
    if (widget.enableScale) {
      _scaleController.reverse();
    }
    if (widget.enableRipple) {
      _rippleController.forward().then((_) {
        _rippleController.reset();
      });
    }
    setState(() {
      _isPressed = false;
    });

    // Trigger bounce if child is BouncingIconAnimation
    if (_bouncingIconKey != null && _bouncingIconKey!.currentState != null) {
      await _bouncingIconKey!.currentState!.bounce();
    }

    // Add slight delay for visual feedback
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.ontap();
    });
  }

  void _handleTapCancel() {
    if (widget.enableScale) {
      _scaleController.reverse();
    }
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? child = widget.child;
    if (child is BouncingIconAnimation && _bouncingIconKey != null) {
      child = BouncingIconAnimation(
        key: _bouncingIconKey,
        child: child.child,
      );
    }
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_scaleAnimation, _rippleAnimation, _shimmerAnimation]),
        builder: (context, _) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // Main button container
                Container(
                  height: widget.height ?? 55,
                  width: widget.width ?? double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.2),
                        blurRadius: _isPressed ? 1 : 2,
                        spreadRadius: _isPressed ? 0.5 : 1,
                        offset: Offset(0, _isPressed ? 0.7 : 1.4),
                      ),
                    ],
                    border: widget.border,
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(15),
                    color: widget.bgColor,
                    gradient: widget.bgColor == null
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE74C3C),
                              Color.fromARGB(255, 236, 167, 37),
                            ],
                          )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        if (widget.enableShimmer)
                          Positioned.fill(
                            child: Transform.translate(
                              offset: Offset(
                                _shimmerAnimation.value * (widget.width ?? 200),
                                0,
                              ),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Center(
                          child: widget.isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.textColor ?? Colors.white,
                                    ),
                                  ),
                                )
                              : child ??
                                  Text(
                                    widget.text.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: widget.textColor ?? Colors.white,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.enableRipple && _rippleAnimation.value > 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 2 * _rippleAnimation.value,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SwipeButtonsRow extends StatefulWidget {
  final String userId;
  final VoidCallback onDislike;
  final VoidCallback onLike;
  final bool isLoading;

  const SwipeButtonsRow({
    super.key,
    required this.userId,
    required this.onDislike,
    required this.onLike,
    this.isLoading = false,
  });

  @override
  State<SwipeButtonsRow> createState() => _SwipeButtonsRowState();
}

class _SwipeButtonsRowState extends State<SwipeButtonsRow> {
  bool _isDislikeLoading = false;
  bool _isLikeLoading = false;
  final GlobalKey<BouncingIconAnimationState> _likeIconKey =
      GlobalKey<BouncingIconAnimationState>();
  final GlobalKey<BouncingIconAnimationState> _disLikeIconKey =
      GlobalKey<BouncingIconAnimationState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedCustomButton(
            height: 43,
            borderRadius: BorderRadius.circular(10),
            bgColor: Colors.grey.withOpacity(0.7),
            isLoading: _isDislikeLoading,
            enableScale: true,
            enableRipple: true,
            ontap: () async {
              setState(() {
                _isDislikeLoading = true;
              });

              widget.onDislike();

              setState(() {
                _isDislikeLoading = false;
              });
            },
            child: BouncingIconAnimation(
              key: _disLikeIconKey,
              child: const Icon(
                FontAwesomeIcons.xmark,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AnimatedCustomButton(
            height: 43,
            borderRadius: BorderRadius.circular(10),
            bgColor: Colors.orange.withOpacity(0.8),
            isLoading: _isLikeLoading,
            enableScale: true,
            enableRipple: true,
            enableShimmer: true,
            ontap: () async {
              setState(() {
                _isLikeLoading = true;
              });

              widget.onLike();

              setState(() {
                _isLikeLoading = false;
              });
            },
            child: BouncingIconAnimation(
              key: _likeIconKey,
              child: const Icon(
                FontAwesomeIcons.solidHeart,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
