import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/date_converter.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({super.key});

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  final _userController = Get.find<UserController>();
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadTransactions();
      }
    });
  }



  Future<void> _loadTransactions() async {
    try {
      await _userController.getUserPaymentHistory(
        limit: 10,
        page: _page, 
      );
      _page++;
    } catch (e) {
      debugPrint("❌ Error fetching payments: $e");
    } finally {
      _userController.isloading.value = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (_userController.isloading.value &&
                    _userController.userTransactionHistory.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (_userController.userTransactionHistory.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text("Empty"),
                    ),
                  );
                }

                return Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E5EC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return FilterHistory();
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat("MMM").format(DateTime.now()),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(color: Colors.grey),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _userController.userTransactionHistory.length,
                            itemBuilder: (context, index) {
                              final payment =
                                  _userController.userTransactionHistory[index];
                              return ListTile(
                                horizontalTitleGap: 5.0,
                                minTileHeight: 90,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  child: Icon(
                                    payment.status == "pending"
                                        ? Icons.hourglass_top_sharp
                                        : payment.status == "failed"
                                            ? Icons.cancel
                                            : Icons.arrow_upward,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      payment.transactionType,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "GH₵${payment.amount.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          convertDateToNormal(
                                              payment.createdAt.toString()),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                        const Spacer(),
                                        RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 10),
                                            children: [
                                              const TextSpan(text: "status: "),
                                              TextSpan(
                                                text: payment.status,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: payment.status ==
                                                          "successful"
                                                      ? Colors.green
                                                      : payment.status ==
                                                              "failed"
                                                          ? Colors.red
                                                          : Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${payment.reference.toString().substring(0, 5)}...",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: payment.reference));
                                          },
                                          child: const Icon(Icons.copy),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          if (_userController.isloading.value) ...[
                            const SizedBox(height: 15),
                            const Center(child: CircularProgressIndicator()),
                          ],
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Payment History",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.menu),
          );
        },
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (String status) {
            if (status == "all") {
              _userController.getUserPaymentHistory();
              return;
            }
            _userController.getUserPaymentHistory(status: status);
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: "all", child: Text("All")),
            const PopupMenuItem(value: "pending", child: Text("Pending")),
            const PopupMenuItem(value: "successful", child: Text("Successful")),
            const PopupMenuItem(value: "failed", child: Text("Failed")),
          ],
          icon: const Icon(Icons.filter_alt_outlined),
        ),
      ],
    );
  }
}

class FilterHistory extends StatelessWidget {
  FilterHistory({super.key});

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
            () => CustomTextField(
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
            () => CustomTextField(
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
              _userController.getUserPaymentHistory(
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
