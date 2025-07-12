import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:get/get.dart';

// Dark Theme Colors
class DarkAppColors {
  // Dark background gradients
  static Color bgDark900 = const Color(0xFF0F0F0F);
  static Color bgDark800 = const Color(0xFF1A1A1A);
  static Color bgDark700 = const Color(0xFF2D2D2D);
  static Color bgDark600 = const Color(0xFF404040);
  static Color bgDark500 = const Color(0xFF525252);

  // Orange accents for dark theme
  static Color accentOrange400 = const Color(0xFFFF8C42);
  static Color accentOrange500 = const Color(0xFFFF7629);
  static Color accentOrange600 = const Color(0xFFE5651A);
  static Color accentOrange700 = const Color(0xFFCC5200);

  // Text colors for dark theme
  static Color textPrimary = const Color(0xFFFFFFFF);
  static Color textSecondary = const Color(0xFFB3B3B3);
  static Color textTertiary = const Color(0xFF808080);

  // Glass effect colors
  static Color glassDark = const Color(0xFF1A1A1A).withOpacity(0.8);
  static Color glassLight = const Color(0xFF2D2D2D).withOpacity(0.6);

  // Form field colors
  static Color fieldBackground = const Color(0xFF262626);
  static Color fieldBorder = const Color(0xFF404040);
  static Color fieldFocus = const Color(0xFFFF8C42);
}

class DarkLoginScreen extends StatelessWidget {
  const DarkLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: DarkAppColors.bgDark900,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              DarkAppColors.bgDark800,
              DarkAppColors.bgDark700,
              DarkAppColors.bgDark900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDarkHeader(),
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: DarkAppColors.glassDark,
                  border: Border.all(
                    color: DarkAppColors.fieldBorder,
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    buildDarkBackDrop(),
                    buildDarkGradientOverlay(),
                    const DarkLoginFormField(),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              Text(
                "Join millions finding love every day ❤️",
                style: TextStyle(
                  color: DarkAppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildDarkHeader() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: MediaQuery.of(Get.context!).size.height * 0.12),
            const Center(child: DarkRotatingImage()),
            SizedBox(height: MediaQuery.of(Get.context!).size.height * 0.04),
            Center(
              child: Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: DarkAppColors.textPrimary,
                ),
              ),
            ),
            Center(
              child: Text(
                "Continue your love story",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: DarkAppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(Get.context!).size.height * 0.06,
          left: MediaQuery.of(Get.context!).size.width * 0.18,
          child: const DarkBouncingBallWidget(),
        ),
        Positioned(
          top: MediaQuery.of(Get.context!).size.height * 0.2,
          right: MediaQuery.of(Get.context!).size.width * 0.2,
          child: const DarkRotatingStarWidget(),
        ),
      ],
    );
  }
}

class DarkLoginFormField extends StatelessWidget {
  const DarkLoginFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign In",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: DarkAppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Enter your credentials to continue",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: DarkAppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 15),
          const Form(
            child: Column(
              children: [
                DarkCustomTextField(
                  hintText: "Email/Number",
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 15),
                DarkCustomTextField(
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  isObscure: true,
                  suffixIcon: Icons.visibility,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          DarkCustomButton(
            onTap: () {
              // Login logic here
              HapticFeedback.lightImpact();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: DarkAppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: DarkAppColors.textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // Navigate to reset password
              },
              child: Text(
                "Forgot your password?",
                style: TextStyle(
                  color: DarkAppColors.accentOrange400,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              Text(
                "New to EchoDate? ",
                style: TextStyle(color: DarkAppColors.textSecondary),
              ),
              InkWell(
                onTap: () {
                  // Navigate to register
                },
                child: Text(
                  "Create account",
                  style: TextStyle(
                    color: DarkAppColors.accentOrange400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DarkCustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isObscure;
  final IconData? suffixIcon;

  const DarkCustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isObscure = false,
    this.suffixIcon,
  });

  @override
  State<DarkCustomTextField> createState() => _DarkCustomTextFieldState();
}

class _DarkCustomTextFieldState extends State<DarkCustomTextField> {
  bool _isFocused = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DarkAppColors.fieldBackground,
        border: Border.all(
          color:
              _isFocused ? DarkAppColors.fieldFocus : DarkAppColors.fieldBorder,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: DarkAppColors.accentOrange400.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        obscureText: widget.isObscure ? _isObscured : false,
        style: TextStyle(
          color: DarkAppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: DarkAppColors.textTertiary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: _isFocused
                ? DarkAppColors.accentOrange400
                : DarkAppColors.textTertiary,
          ),
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    widget.isObscure
                        ? (_isObscured
                            ? Icons.visibility
                            : Icons.visibility_off)
                        : widget.suffixIcon,
                    color: DarkAppColors.textTertiary,
                  ),
                  onPressed: widget.isObscure
                      ? () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        }
                      : null,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onTapOutside: (event) {
          setState(() {
            _isFocused = false;
          });
        },
      ),
    );
  }
}

class DarkCustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const DarkCustomButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            DarkAppColors.accentOrange400,
            DarkAppColors.accentOrange600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: DarkAppColors.accentOrange400.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

// Dark theme animated widgets
class DarkRotatingImage extends StatefulWidget {
  const DarkRotatingImage({super.key});

  @override
  State<DarkRotatingImage> createState() => _DarkRotatingImageState();
}

class _DarkRotatingImageState extends State<DarkRotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  DarkAppColors.accentOrange400,
                  DarkAppColors.accentOrange600,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: DarkAppColors.accentOrange400.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite,
              color: DarkAppColors.textPrimary,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}

class DarkBouncingBallWidget extends StatefulWidget {
  const DarkBouncingBallWidget({super.key});

  @override
  State<DarkBouncingBallWidget> createState() => _DarkBouncingBallWidgetState();
}

class _DarkBouncingBallWidgetState extends State<DarkBouncingBallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DarkAppColors.accentOrange400,
              boxShadow: [
                BoxShadow(
                  color: DarkAppColors.accentOrange400.withOpacity(0.6),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DarkRotatingStarWidget extends StatefulWidget {
  const DarkRotatingStarWidget({super.key});

  @override
  State<DarkRotatingStarWidget> createState() => _DarkRotatingStarWidgetState();
}

class _DarkRotatingStarWidgetState extends State<DarkRotatingStarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Icon(
            Icons.auto_awesome,
            color: DarkAppColors.accentOrange400,
            size: 20,
          ),
        );
      },
    );
  }
}

Container buildDarkGradientOverlay() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          DarkAppColors.accentOrange400.withOpacity(0.05),
        ],
      ),
    ),
  );
}

ClipRRect buildDarkBackDrop() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(color: Colors.transparent),
    ),
  );
}
