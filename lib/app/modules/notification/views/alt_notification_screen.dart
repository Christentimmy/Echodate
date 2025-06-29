import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AltNotificationScreen extends StatefulWidget {
  const AltNotificationScreen({super.key});

  @override
  State<AltNotificationScreen> createState() => _AltNotificationScreenState();
}

class _AltNotificationScreenState extends State<AltNotificationScreen> {
  Map<String, bool> notifications = {
    'matches': true,
    'messages': true,
    'likes': false,
    'promotions': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildNotificationSettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[100]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Push Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose what notifications you\'d like to receive',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            _buildSettingsItem(
              icon: Icons.favorite,
              title: 'New Matches',
              subtitle: 'When someone likes you back',
              hasToggle: true,
              toggleValue: notifications['matches']!,
              onToggle: (value) =>
                  setState(() => notifications['matches'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.message,
              title: 'Messages',
              subtitle: 'New message alerts',
              hasToggle: true,
              toggleValue: notifications['messages']!,
              onToggle: (value) =>
                  setState(() => notifications['messages'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.thumb_up,
              title: 'Profile Likes',
              subtitle: 'When someone likes your profile',
              hasToggle: true,
              toggleValue: notifications['likes']!,
              onToggle: (value) =>
                  setState(() => notifications['likes'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.local_offer,
              title: 'Promotions',
              subtitle: 'Special offers and deals',
              hasToggle: true,
              toggleValue: notifications['promotions']!,
              onToggle: (value) =>
                  setState(() => notifications['promotions'] = value),
              showChevron: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool hasToggle = false,
    bool toggleValue = false,
    Function(bool)? onToggle,
    bool showChevron = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasToggle ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.secondaryOrange
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasToggle)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggle?.call(!toggleValue);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: toggleValue
                          ? LinearGradient(
                              colors: [
                                AppColors.primaryOrange,
                                AppColors.secondaryOrange
                              ],
                            )
                          : null,
                      color: toggleValue ? null : Colors.grey[300],
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: toggleValue
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (showChevron)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
