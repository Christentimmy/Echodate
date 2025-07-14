import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/withdraw/widgets/filter_withdraw_history.dart';
import 'package:echodate/app/modules/withdraw/widgets/withdraw_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawHistoryScreen extends StatefulWidget {
  const WithdrawHistoryScreen({super.key});

  @override
  State<WithdrawHistoryScreen> createState() => _WithdrawHistoryScreenState();
}

class _WithdrawHistoryScreenState extends State<WithdrawHistoryScreen> {
  final _userController = Get.find<UserController>();
  int _page = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isWithdrawHistoryFetched.value) {
        _userController.getUserWithdawHistory(page: _page);
      }
    });
  }

  void _loadNextPage() {
    setState(() {
      _page++;
    });
    _userController.getUserWithdawHistory(page: _page);
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
                if (_userController.isloading.value) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (_userController.userWithdrawHistory.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text("Empty")),
                  );
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: WithdrawHistoryListSection(
                      history: _userController.userWithdrawHistory,
                      onFilterTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => FilterWithdrawHistory(),
                        );
                      },
                      onLoadMore: _loadNextPage,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Withdraw History",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          );
        },
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (String status) {
            if (status == "all") {
              _userController.getUserWithdawHistory();
              return;
            }
            _userController.getUserWithdawHistory(status: status);
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
