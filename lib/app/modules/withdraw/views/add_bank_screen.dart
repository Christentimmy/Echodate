import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({super.key});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  RxString selectedBank = 'Select bank'.obs;
  RxString accountName = ''.obs;
  RxString accountNumber = ''.obs;
  RxString selectedAccountType = 'Savings'.obs;

  List<String> banks = [
    'Select bank',
    'GTBank',
    'Access Bank',
    'FirstBank',
  ];

  List<String> accountTypes = [
    'Savings',
    'Current',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add bank',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide your bank account details where you can easily withdraw your money to.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Choose your bank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBank.value,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      dropdownColor: Colors.white,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        selectedBank.value = newValue!;
                      },
                      items:
                          banks.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              CustomTextField(
                hintText: "Enter Account Name",
                onChanged: (value) {
                  accountName.value = value;
                },
              ),
              SizedBox(height: Get.height * 0.02),
              CustomTextField(
                keyboardType: TextInputType.number,
                hintText: "Enter Account No",
                onChanged: (value) {
                  accountNumber.value = value;
                },
              ),
              SizedBox(height: Get.height * 0.02),
              const Text(
                'Choose account type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedAccountType.value,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        selectedAccountType.value = newValue!;
                      },
                      items: accountTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.1),
              CustomButton(
                ontap: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
