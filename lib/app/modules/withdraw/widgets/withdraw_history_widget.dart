import 'package:echodate/app/models/withdraw_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WithdrawHistoryListSection extends StatelessWidget {
  final List<WithdrawModel> history;
  final VoidCallback onFilterTap;
  final VoidCallback onLoadMore;

  const WithdrawHistoryListSection({
    required this.history,
    required this.onFilterTap,
    required this.onLoadMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? const Color.fromARGB(255, 19, 18, 18) : const Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: onFilterTap,
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
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return WithdrawHistoryCard(payment: history[index]);
                },
              ),
              GestureDetector(
                onTap: onLoadMore,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Load More'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class WithdrawHistoryCard extends StatelessWidget {
  final WithdrawModel payment;

  const WithdrawHistoryCard({required this.payment, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 5.0,
      minTileHeight: 90,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
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
            payment.recipientCode,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            "GH₵${payment.amount.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                convertDateToNormal(payment.createdAt.toString()),
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                  children: [
                    const TextSpan(text: "status: "),
                    TextSpan(
                      text: payment.status,
                      style: TextStyle(
                        fontSize: 10,
                        color: payment.status == "successful"
                            ? Colors.green
                            : payment.status == "failed"
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
                "${payment.reference.substring(0, 5)}...",
                style: const TextStyle(fontSize: 12),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: payment.reference));
                },
                child: const Icon(Icons.copy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
