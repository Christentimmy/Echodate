import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/support_ticket_model.dart';
import 'package:echodate/app/modules/support/controller/support_controller.dart';
import 'package:echodate/app/modules/support/widgets/support_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isAllMySupportTicketLoaded.value) {
        _userController.getMySupportTickert();
      }
    });
  }

  final supportController = Get.put(SupportController());

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<SupportController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Support",
          style: Get.textTheme.bodyLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? const Color.fromARGB(255, 27, 27, 27)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              indicator: BoxDecoration(
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.contact_support_outlined, size: 18),
                      SizedBox(width: 6),
                      Text("Message"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number_outlined, size: 18),
                      SizedBox(width: 6),
                      Text("All Tickets"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                _buildContactUsTab(),
                _buildAllTicketsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactUsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Get in Touch",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Header Section
          const BuildSupportHeader(),
          const SizedBox(height: 32),
          SupportFormFields(),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  icon: Icons.phone_outlined,
                  title: "Email",
                  subtitle: "Support@echodate.me",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContactCard(
                  icon: Icons.location_on_outlined,
                  title: "Address",
                  subtitle: "Soon...",
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAllTicketsTab() {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        await _userController.getMySupportTickert(isShowLoader: false);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "All Tickets",
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_userController.isloading.value) {
                return SizedBox(
                  width: Get.width,
                  height: Get.height * 0.6,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (_userController.allMySupportTicketList.isEmpty) {
                return SizedBox(
                  width: Get.width,
                  height: Get.height * 0.6,
                  child: const Center(
                    child: Text(
                      "No tickets found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userController.allMySupportTicketList.length,
                itemBuilder: (context, index) {
                  final ticket = _userController.allMySupportTicketList[index];
                  return _buildTicketCard(supportTickelModel: ticket);
                },
              );
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard({required SupportTicketModel supportTickelModel}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 22, 22, 22)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${supportTickelModel.category?.capitalizeFirst}",
                style: Get.textTheme.bodyLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getColor(supportTickelModel.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  supportTickelModel.status.capitalizeFirst ?? "",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: getColor(supportTickelModel.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            supportTickelModel.description.length > 115
                ? "${supportTickelModel.description.substring(0, 114)}..."
                : supportTickelModel.description,
            style: Get.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'CreatedAt: ${DateFormat('dd MMM yyyy').format(supportTickelModel.createdAt)}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'TicketId: ${supportTickelModel.id}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 27, 27, 27)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.orange[600], size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color getColor(String status) {
    switch (status) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
