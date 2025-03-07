import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_animationController);
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () {
                    // Navigate back
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.orange,
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -10, end: 0),
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 40),
                _emailSent ? _buildSuccessState() : _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _emailSent ? "Check Your Email" : "Reset Password",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -10, end: 0),
        const SizedBox(height: 12),
        Text(
          _emailSent 
              ? "We've sent password reset instructions to ${_emailController.text}"
              : "Enter your email and we'll send you instructions to reset your password.",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 10, end: 0),
      ],
    );
  }
  
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildAnimatedEmailField().animate().fadeIn(delay: 600.ms).slideX(begin: 30, end: 0),
          const SizedBox(height: 24),
          _buildSubmitButton().animate().fadeIn(delay: 800.ms).slideY(begin: 20, end: 0),
          const SizedBox(height: 40),
          _buildDecorationElements(),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email Address",
        hintText: "your.email@example.com",
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.orange.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
    );
  }
  
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Send Reset Link",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
  
  Widget _buildSuccessState() {
    return Column(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.orange,
                    size: 80,
                  ),
                ),
              );
            },
          ),
        ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
        const SizedBox(height: 40),
        Text(
          "Didn't receive the email?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text(
            "Try Again",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ).animate().fadeIn(delay: 800.ms),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to login
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Back to Login",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 1000.ms).slideY(begin: 20, end: 0),
      ],
    );
  }
  
  Widget _buildDecorationElements() {
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: _buildAnimatedCircle(Colors.orange.withOpacity(0.1), 100)
              .animate()
              .fadeIn(delay: 1000.ms)
              .move(delay: 1000.ms, duration: 3000.ms),
        ),
        Positioned(
          left: 40,
          bottom: 20,
          child: _buildAnimatedCircle(Colors.deepOrange.withOpacity(0.05), 80)
              .animate()
              .fadeIn(delay: 1200.ms)
              .move(delay: 1500.ms, duration: 4000.ms),
        ),
        Positioned(
          right: 80,
          bottom: 100,
          child: _buildAnimatedCircle(Colors.amber.withOpacity(0.07), 60)
              .animate()
              .fadeIn(delay: 1400.ms)
              .move(delay: 2000.ms, duration: 3500.ms),
        ),
      ],
    );
  }
  
  Widget _buildAnimatedCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}