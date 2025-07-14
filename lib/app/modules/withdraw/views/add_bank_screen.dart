import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/bank_model.dart';
import 'package:echodate/app/modules/withdraw/widgets/withdraw_screen_widgets.dart';
import 'package:echodate/app/services/user_service.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({super.key});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  RxString selectedBank = 'Select Bank'.obs;
  RxString bankCode = ''.obs;
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List allBanks = await _userService.fetchBank();
      if (allBanks.isNotEmpty) {
        banks.value = allBanks;
      }
    });
  }

  RxList banks = [].obs;

  List<String> accountTypes = [
    'Savings',
    'Current',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              const SizedBox(height: 5),
              Obx(
                () => NewCustomTextField(
                  hintText: selectedBank.value,
                  readOnly: true,
                  onTap: () {
                    showBankSelectionDialog(
                      context: context,
                      banks: banks,
                      bankCode: bankCode,
                      selectedBank: selectedBank,
                    );
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    NewCustomTextField(
                      hintText: "Enter Account Name",
                      controller: _accountNameController,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    NewCustomTextField(
                      keyboardType: TextInputType.number,
                      hintText: "Enter Account No",
                      controller: _accountNumberController,
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.1),
              Obx(
                () => CustomButton(
                  ontap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    if (bankCode.isEmpty) {
                      CustomSnackbar.showErrorSnackBar("Select a bank");
                      return;
                    }
                    BankModel bankModel = BankModel(
                      bankCode: bankCode.value,
                      accountNumber: _accountNumberController.text,
                      accountName: _accountNameController.text,
                    );
                    await _userController.addBank(
                      bankModel: bankModel,
                      context: context,
                    );
                  },
                  child: _userController.isloading.value
                      ? const Loader()
                      : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
