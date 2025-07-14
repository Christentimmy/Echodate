import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FilterCoinHistory extends StatelessWidget {
  FilterCoinHistory({super.key});

  final _userController = Get.find<UserController>();
  final Rxn<DateTime> _startDate = Rxn<DateTime>();
  final Rxn<DateTime> _endDate = Rxn<DateTime>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Filter by Date Range",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              "Start Date",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final userAccRegDate = _userController.userModel.value?.createdAt;
              if (userAccRegDate == null) return const SizedBox.shrink();
              return NewCustomTextField(
                hintText: _startDate.value != null
                    ? DateFormat("MMM dd, yyyy").format(_startDate.value!)
                    : "Select start date",
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: userAccRegDate,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _startDate.value = date;
                  }
                },
              );
            }),
            const SizedBox(height: 20),
            Text(
              "End Date",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final userAccRegDate = _userController.userModel.value?.createdAt;
              if (userAccRegDate == null) return const SizedBox.shrink();
              return NewCustomTextField(
                hintText: _endDate.value != null
                    ? DateFormat("MMM dd, yyyy").format(_endDate.value!)
                    : "Select end date",
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: userAccRegDate,
                    lastDate: DateTime.now(),
                    initialDate: _endDate.value ?? DateTime.now(),
                  );
                  if (date != null) {
                    _endDate.value = date;
                  }
                },
              );
            }),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _startDate.value = null;
                      _endDate.value = null;
                      _userController.getUserCoinHistory();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Clear Filter",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    ontap: () async {
                      if (_startDate.value != null && _endDate.value != null) {
                        if (_startDate.value!.isAfter(_endDate.value!)) {
                          Get.snackbar(
                            'Invalid Date Range',
                            'Start date must be before end date',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.red.shade800,
                          );
                          return;
                        }
                      }

                      await _userController.getUserCoinHistory(
                        startDate: _startDate.value?.toIso8601String(),
                        endDate: _endDate.value?.toIso8601String(),
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Apply Filter",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
