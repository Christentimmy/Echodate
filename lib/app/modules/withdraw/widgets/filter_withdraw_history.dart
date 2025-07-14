
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class FilterWithdrawHistory extends StatelessWidget {
  FilterWithdrawHistory({super.key});

  final _userController = Get.find<UserController>();
  final Rxn<DateTime> _startDate = Rxn<DateTime>();
  final Rxn<DateTime> _endDate = Rxn<DateTime>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Month"),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cancel,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          const Text("Start Date"),
          Obx(
            () => NewCustomTextField(
              hintText: DateFormat("MMM dd yyyy").format(
                _startDate.value ?? DateTime.now(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.parse(
                    _userController.userModel.value?.createdAt.toString() ?? "",
                  ),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _startDate.value = date;
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text("End Date"),
          Obx(
            () => NewCustomTextField(
              hintText: DateFormat("MMM dd yyyy").format(
                _endDate.value ?? DateTime.now(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.parse(
                    _userController.userModel.value?.createdAt.toString() ?? "",
                  ),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _endDate.value = date;
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            ontap: () async {
              _userController.getUserWithdawHistory(
                startDate: _startDate.value.toString(),
                endDate: _endDate.value.toString(),
              );
              Navigator.pop(context);
            },
            child: const Text(
              "Confirm",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}