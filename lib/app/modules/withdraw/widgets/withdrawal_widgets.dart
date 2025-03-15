import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showBankSelectionDialog({
  required BuildContext context,
  required RxList banks,
  required RxString bankCode,
  required RxString selectedBank,
}) {
  RxString filteredBanks = "".obs;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 40,
        ),
        title: const Text("Select Bank"),
        content: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'Search',
                onChanged: (query) {
                  filteredBanks.value = query;
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (filteredBanks.isNotEmpty) {
                    List filteredBankList = banks
                        .where((bank) => bank["name"]
                            .toLowerCase()
                            .contains(filteredBanks.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredBankList.length,
                      itemBuilder: (context, index) {
                        var bank = filteredBankList[index];
                        return ListTile(
                          title: Text(
                            bank["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            selectedBank.value = bank["name"];
                            bankCode.value = bank["code"];
                            filteredBanks.value = "";
                            Get.back();
                          },
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: banks.length,
                      itemBuilder: (context, index) {
                        var bank = banks[index];
                        return ListTile(
                          title: Text(
                            bank["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            selectedBank.value = bank["name"];
                            bankCode.value = bank["code"];
                            Get.back();
                          },
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
