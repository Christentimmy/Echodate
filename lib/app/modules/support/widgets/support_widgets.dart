import 'package:echodate/app/modules/support/controller/support_controller.dart';
import 'package:echodate/app/resources/text_style.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BuildSupportHeader extends StatelessWidget {
  const BuildSupportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[600]!, Colors.blue[800]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.mail_outline,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Get in Touch",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'd love to hear from you. Send us a message and we'll respond as soon as possible.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SupportFormFields extends StatelessWidget {
  SupportFormFields({super.key});

  final _supportController = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _supportController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send us a message",
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildDropdownField(context),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _supportController.subjectController,
              label: "Subject",
              icon: Icons.subject_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a subject";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Message Field
            _buildTextField(
              controller: _supportController.messageController,
              label: "Message",
              icon: Icons.message_outlined,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your message";
                }
                return null;
              },
            ),

            const SizedBox(height: 32),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[600]!, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.blue[600]),
                      onPressed: () async {
                        await _supportController.addAttachment();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(() {
                    if (_supportController.attachments.isEmpty) {
                      return Text(
                        "No Attachments",
                        style: TextStyle(color: Colors.grey[600]),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  Obx(() {
                    if (_supportController.attachments.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _supportController.attachments.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final file = _supportController.attachments[index];
                          final label =
                              "${file.path.split('/').last.substring(0, 5)}..";
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Chip(
                              label: Text(label),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.red,
                              ),
                              onDeleted: () {
                                _supportController.attachments.removeAt(index);
                              },
                              backgroundColor: Colors.blue[50],
                              labelStyle: TextStyle(color: Colors.blue[600]),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Send Button
            CustomButton(
              // isLoading: _supportController.userController.isLoading,
              ontap: () async {
                await _supportController.sendMessage();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Send Message",
                    style: AppTextStyles.buttonTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _supportController.selectedCategory.value.isEmpty
            ? null
            : _supportController.selectedCategory.value,
        decoration: InputDecoration(
          labelText: "Category",
          prefixIcon: Icon(Icons.category_outlined, color: Colors.blue[600]),
          labelStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        hint: Text(
          "Select a category",
          style: TextStyle(color: Colors.grey[600]),
        ),
        dropdownColor: Colors.white,
        items: _supportController.categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category.substring(0, 1).toUpperCase() + category.substring(1),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _supportController.selectedCategory.value = newValue!;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select a category";
          }
          return null;
        },
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue[600]),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
