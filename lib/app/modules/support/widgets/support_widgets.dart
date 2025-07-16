import 'package:echodate/app/modules/support/controller/support_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
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
          colors: [Colors.orange[600]!, Colors.orange[800]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
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
              fontSize: 14,
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

  final supportController = Get.find<SupportController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 27, 27, 27)
            : Colors.white,
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
        key: supportController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Send us a message",
              style: Get.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildDropdownField(context),
            const SizedBox(height: 20),
            NewCustomTextField(
              hintText: "Subject",
              controller: supportController.subjectController,
              prefixIcon: Icons.subject_outlined,
              prefixIconColor: AppColors.primaryColor,
            ),

            const SizedBox(height: 20),
            NewCustomTextField(
              label: "Message",
              controller: supportController.messageController,
              prefixIcon: Icons.message_outlined,
              maxLines: 3,
              prefixIconColor: AppColors.primaryColor,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),

            const SizedBox(height: 32),
            _buildAttachmentComponents(),
            const SizedBox(height: 32),

            // Send Button
            Obx(
              () => CustomButton(
                ontap: () async {
                  await supportController.sendMessage(
                    formKey: supportController.formKey,
                  );
                },
                bgColor: Colors.orange[600],
                child: supportController.userController.isloading.value
                    ? const Loader()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Send Message",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentComponents() {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.black : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[600]!, width: 2),
            ),
            child: IconButton(
              icon: Icon(Icons.attach_file, color: Colors.orange[600]),
              onPressed: () async {
                await supportController.addAttachment();
              },
            ),
          ),
          const SizedBox(width: 16),
          Obx(() {
            if (supportController.attachments.isEmpty) {
              return Text(
                "No Attachments",
                style: TextStyle(color: Colors.grey[600]),
              );
            }
            return Expanded(
              child: ListView.builder(
                itemCount: supportController.attachments.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final file = supportController.attachments[index];
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
                        supportController.attachments.removeAt(index);
                      },
                      backgroundColor:
                          Get.isDarkMode ? Colors.black : Colors.orange[50],
                      labelStyle: TextStyle(color: Colors.orange[600]),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.fieldBorder,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: supportController.selectedCategory.value.isEmpty
            ? null
            : supportController.selectedCategory.value,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.category_outlined, color: Colors.orange[600]),
          filled: true,
          fillColor: Get.isDarkMode ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
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
        hint: const Text("Select a category"),
        items: supportController.categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category.substring(0, 1).toUpperCase() + category.substring(1),
              style: TextStyle(
                fontSize: 16,
                color: Get.theme.primaryColor,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          supportController.selectedCategory.value = newValue!;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select a category";
          }
          return null;
        },
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange[600]),
      ),
    );
  }
}
