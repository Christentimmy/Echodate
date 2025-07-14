import 'dart:ui';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget buildBackDrop() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(color: Colors.transparent),
    ),
  );
}

Widget getGradientOverlay() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: AppColors.formFieldGradient,
      ),
    ),
  );
}

enum ContactType { email, phone }

class ContactUpdateBottomSheet extends StatefulWidget {
  final ContactType type;
  final String initialValue;
  final Function(String) onSave;
  final Color primaryColor;

  const ContactUpdateBottomSheet({
    super.key,
    required this.type,
    required this.initialValue,
    required this.onSave,
    this.primaryColor = Colors.orange,
  });

  // Static method to show the bottom sheet
  static Future<void> show({
    required BuildContext context,
    required ContactType type,
    required String initialValue,
    required Function(String) onSave,
    Color primaryColor = Colors.orange,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactUpdateBottomSheet(
        type: type,
        initialValue: initialValue,
        onSave: onSave,
        primaryColor: primaryColor,
      ),
    );
  }

  @override
  State<ContactUpdateBottomSheet> createState() =>
      _ContactUpdateBottomSheetState();
}

class _ContactUpdateBottomSheetState extends State<ContactUpdateBottomSheet> {
  late TextEditingController _controller;
  bool _isValid = false;
  String? _errorText;
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _validate(_controller.text);
    _controller.addListener(() {
      _validate(_controller.text);
    });
  }

  void _validate(String value) {
    setState(() {
      if (widget.type == ContactType.email) {
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        _isValid = emailRegex.hasMatch(value);
        _errorText = _isValid ? null : 'Please enter a valid email address';
      } else {
        // Simple phone validation (can be improved based on your requirements)
        final phoneRegex = RegExp(r'^\d{10,15}$');
        _isValid = phoneRegex.hasMatch(value);
        _errorText = _isValid ? null : 'Please enter a valid phone number';
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final title = widget.type == ContactType.email
        ? 'Update Email'
        : 'Update Phone Number';
    final hint = widget.type == ContactType.email
        ? 'Enter your email'
        : 'Enter your phone number';
    final keyboardType = widget.type == ContactType.email
        ? TextInputType.emailAddress
        : TextInputType.phone;

    final inputFormatters = widget.type == ContactType.phone
        ? [FilteringTextInputFormatter.digitsOnly]
        : null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: widget.primaryColor.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current ${widget.type == ContactType.email ? 'Email' : 'Phone Number'}:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.initialValue,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'New ${widget.type == ContactType.email ? 'Email' : 'Phone Number'}:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      hintText: hint,
                      errorText: _errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: widget.primaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isValid
                          ? () {
                              widget.onSave(_controller.text);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Obx(
                        () => _authController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
