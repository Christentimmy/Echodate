
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/transaction_model.dart';
import 'package:echodate/app/modules/echocoin/widget/filter_coin_history.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({super.key});

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  final _userController = Get.find<UserController>();
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions(refresh: true);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadTransactions();
      }
    });
  }

  Future<void> _loadTransactions({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _userController.userTransactionHistory.clear();
    }

    try {
      await _userController.getUserCoinHistory(
        limit: 20,
        page: _page,
        status: _selectedFilter == 'all' ? null : _selectedFilter,
      );
      if (!refresh) _page++;
    } catch (e) {
      debugPrint("❌ Error fetching transactions: $e");
      Get.snackbar(
        'Error',
        'Failed to load transactions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
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
        child: Column(
          children: [
            _buildSummaryCard(),
            _buildFilterChips(),
            Expanded(child: _buildTransactionsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      num coins = _userController.userModel.value?.echocoinsBalance ?? 0.0;
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spent',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'GH₵${coins.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.white30,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Successful', 'value': 'success'},
      {'label': 'Pending', 'value': 'pending'},
      {'label': 'Failed', 'value': 'failed'},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(filter['label']!),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['value']!;
                });
                _loadTransactions(refresh: true);
              },
              selectedColor: AppColors.primaryColor.withOpacity(0.2),
              checkmarkColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                color:
                    isSelected ? AppColors.primaryColor : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionsList() {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        await _userController.getUserCoinHistory(
          limit: 20,
          page: _page,
          showLoader: false,
        );
      },
      child: Obx(() {
        if (_userController.isloading.value &&
            _userController.userTransactionHistory.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (_userController.userTransactionHistory.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _userController.userTransactionHistory.length + 1,
          itemBuilder: (context, index) {
            if (index == _userController.userTransactionHistory.length) {
              return _userController.isloading.value
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 20);
            }

            final transaction = _userController.userTransactionHistory[index];
            return _buildTransactionCard(transaction, index);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your coin transactions will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction, int index) {
    final bool isDarkMode = Get.isDarkMode;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isDarkMode ? const Color.fromARGB(255, 24, 23, 23) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: _buildTransactionIcon(transaction),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTitle(transaction),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 16,
                        color: Colors.amber.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${transaction.coins} coins',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'GH₵${transaction.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(transaction.status),
                  ),
                ),
                _buildStatusChip(transaction.status),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    convertDateToNormal(transaction.createdAt.toString()),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: transaction.reference));
                  Get.snackbar(
                    'Copied',
                    'Reference ID copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${transaction.reference.substring(0, 8)}...',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.copy,
                        size: 14,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionIcon(TransactionModel transaction) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (transaction.status) {
      case 'pending':
        iconData = Icons.schedule;
        backgroundColor = Colors.orange.shade100;
        iconColor = Colors.orange.shade700;
        break;
      case 'failed':
        iconData = Icons.error_outline;
        backgroundColor = Colors.red.shade100;
        iconColor = Colors.red.shade700;
        break;
      case 'successful':
        final isPurchase =
            transaction.transactionType.toLowerCase().contains('purchase') ||
                transaction.transactionType.toLowerCase().contains('buy');
        iconData =
            isPurchase ? Icons.shopping_cart : Icons.account_balance_wallet;
        backgroundColor = Colors.green.shade100;
        iconColor = Colors.green.shade700;
        break;
      default:
        iconData = Icons.help_outline;
        backgroundColor = Colors.grey.shade100;
        iconColor = Colors.grey.shade700;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'successful':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'failed':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.capitalize ?? status,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _getTransactionTitle(TransactionModel transaction) {
    final type = transaction.transactionType.toLowerCase();
    if (type.contains('purchase') || type.contains('buy')) {
      return 'Coin Purchase';
    } else if (type.contains('refund')) {
      return 'Refund';
    } else if (type.contains('bonus')) {
      return 'Bonus Coins';
    }
    return transaction.transactionType.capitalize ?? 'Transaction';
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        "Coin History",
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              // backgroundColor: Colors.transparent,
              builder: (context) => FilterCoinHistory(),
            );
          },
          icon: const Icon(
            Icons.tune,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "success":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
