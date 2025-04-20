import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample notification data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "New Match",
      message: "You've matched with Sarah!",
      time: "2 min ago",
      isRead: false,
      icon: Icons.favorite,
    ),
    NotificationItem(
      title: "Upcoming Date",
      message: "Reminder: Coffee with James tomorrow at 3 PM",
      time: "1 hour ago",
      isRead: false,
      icon: Icons.calendar_today,
    ),
    NotificationItem(
      title: "New Message",
      message: "Alex sent you a message",
      time: "3 hours ago",
      isRead: true,
      icon: Icons.message,
    ),
    NotificationItem(
      title: "Profile View",
      message: "Someone viewed your profile",
      time: "Yesterday",
      isRead: true,
      icon: Icons.visibility,
    ),
    NotificationItem(
      title: "Account Update",
      message: "Your premium subscription has been renewed",
      time: "2 days ago",
      isRead: true,
      icon: Icons.card_membership,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read functionality
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
            },
            child: const Text(
              "Mark all as read",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.orange.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "No notifications",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You're all caught up!",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: _notifications.length + 1, // +1 for the filter section
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildFilterSection();
        }
        final notification = _notifications[index - 1];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("Unread", isSelected: true),
                _buildFilterChip("Matches"),
                _buildFilterChip("Messages"),
                _buildFilterChip("System"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        selectedColor: Colors.orange.withOpacity(0.2),
        checkmarkColor: Colors.orange,
        backgroundColor: Colors.grey[200],
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.orange : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onSelected: (bool selected) {
          // Handle filter selection
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: Icon(
            notification.icon,
            color: Colors.orange,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight:
                      notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            notification.message,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
        ),
        trailing: !notification.isRead
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Mark notification as read when tapped
          setState(() {
            notification.isRead = true;
          });
          // Handle notification tap
        },
        onLongPress: () {
          // Show options to delete or mute
          _showNotificationOptions(notification);
        },
      ),
    );
  }

  void _showNotificationOptions(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text("Delete"),
                onTap: () {
                  setState(() {
                    _notifications.remove(notification);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  notification.isRead
                      ? Icons.mark_email_unread_outlined
                      : Icons.mark_email_read_outlined,
                  color: Colors.orange,
                ),
                title: Text(
                    notification.isRead ? "Mark as unread" : "Mark as read"),
                onTap: () {
                  setState(() {
                    notification.isRead = !notification.isRead;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_off_outlined,
                    color: Colors.grey),
                title: const Text("Mute notifications like this"),
                onTap: () {
                  // Mute similar notifications logic
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  bool isRead;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
  });
}
