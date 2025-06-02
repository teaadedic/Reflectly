import 'package:flutter/material.dart';
import 'package:reflectly_admin/main.dart';
import 'package:reflectly_admin/screens/home_screen.dart';
import 'package:reflectly_admin/screens/mood_tracking_screen.dart'
    as mood_screen;
import 'package:reflectly_admin/screens/account_screen.dart';
import 'package:reflectly_admin/screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool reminders = true;

  static const purple = Color.fromARGB(255, 108, 104, 243);

  @override
void initState() {
  super.initState();
  _loadPrefs();
}

Future<void> _loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    notifications = prefs.getBool('notifications') ?? true;
    reminders = prefs.getBool('reminders') ?? true;
  });
}

Future<void> _updateNotificationToggle(bool val) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notifications', val);
  setState(() => notifications = val);

  if (val) {
    final token = await FirebaseMessaging.instance.getToken();
    print("📲 Notifications ON – FCM Token: $token");
    // TODO: send token to backend
  } else {
    await FirebaseMessaging.instance.deleteToken();
    print("🔕 Notifications OFF – FCM Token deleted");
  }
}

Future<void> _updateReminderToggle(bool val) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('reminders', val);
  setState(() => reminders = val);

  if (!val) {
    print("🕒 Reminders disabled (cancel scheduling here)");
    // TODO: cancel scheduled reminders
  } else {
    print("🕒 Reminders enabled (schedule them here)");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
            decoration: BoxDecoration(
              color: purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: Icon(Icons.chat_bubble_outline, color: purple, size: 28),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _SettingsCard(
              icon: Icons.person,
              label: "Account",
              purple: purple,
              trailing: null,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              icon: Icons.notifications,
              label: "Notifications",
              purple: purple,
              trailing: Switch(
                value: notifications,
                activeColor: purple,
                onChanged: _updateNotificationToggle,
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              icon: Icons.alarm,
              label: "Reminders",
              purple: purple,
              trailing: Switch(
                value: reminders,
                activeColor: purple,
                onChanged: _updateReminderToggle,
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              icon: Icons.logout,
              label: "Log Out",
              purple: purple,
              trailing: null,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder:
                        (context) => const mood_screen.MoodTrackingScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            // Middle icon with navigation to HomeScreen
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.grid_view_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: purple, shape: BoxShape.circle),
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.settings, color: Colors.black, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color purple;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.icon,
    required this.label,
    required this.purple,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: purple.withOpacity(0.18),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: purple, size: 28),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
