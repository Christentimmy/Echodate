import 'package:echodate/app/modules/withdraw/views/add_bank_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalScreen extends StatelessWidget {
  WithdrawalScreen({super.key});

  final _amountController = TextEditingController();

  final RxInt selectedIndex = (-1).obs;
  final List<Map<String, String>> bankAccounts = [
    {
      'name': 'Alfred David',
      'bank': 'GTBank',
      'accountNumber': '6858',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/GTBank_logo.svg/2048px-GTBank_logo.svg.png'
    },
    {
      'name': 'David Alfred',
      'bank': 'Access Bank',
      'accountNumber': '2847',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQy0M4p6y0y2GQX5C04tdBDJ-unoUgsuL_Jg&s'
    },
    {
      'name': 'David alfred J',
      'bank': 'FirstBank',
      'accountNumber': '3174',
      'imageUrl':
          'https://www.firstbanknigeria.com/wp-content/uploads/2021/02/Desktop-1.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.height * 0.3,
            child: Stack(
              children: [
                Container(
                  height: Get.height * 0.27,
                  color: AppColors.primaryColor,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Withdraw',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: Get.height * 0.05),
                      const Text(
                        "20 Cedis",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Total Earning From Live Gifts",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade50,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: Get.width * 0.6,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _amountController,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter your text here',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Choose bank account",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(() => const AddBankScreen());
                      },
                      child: const Text(
                        "Add new",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: Get.height * 0.4,
                  child: ListView.builder(
                    itemCount: bankAccounts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          selectedIndex.value = index;
                        },
                        child: Obx(
                          () => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: selectedIndex.value == index
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: bankAccounts[index]['imageUrl'] != null
                                  ? Image.network(
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      bankAccounts[index]['imageUrl']!,
                                    )
                                  : const Icon(Icons.account_balance),
                              title: Text(
                                bankAccounts[index]['name']!,
                              ),
                              subtitle: Text(
                                  '${bankAccounts[index]['bank']} **** ${bankAccounts[index]['accountNumber']}'),
                              trailing: selectedIndex.value == index
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.radio_button_unchecked),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Get.height * 0.1),
                CustomButton(
                  ontap: () {},
                  child: const Text(
                    "Withdraw",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
