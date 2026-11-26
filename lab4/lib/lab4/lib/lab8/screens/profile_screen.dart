import 'package:flutter/material.dart';

import '../theme.dart';

/// Вкладка 3 — профиль и простые настройки.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text('My profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          _Section(children: [
            ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: FlipColors.blue.withOpacity(0.12),
                child: const Icon(Icons.person, size: 36, color: FlipColors.blue),
              ),
              title: const Text('azat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: const Text('Profile management',
                  style: TextStyle(color: FlipColors.blue)),
              trailing: const Icon(Icons.qr_code_2),
            ),
          ]),
          _Section(children: const [
            _Tile(icon: Icons.description_outlined, color: FlipColors.blue, title: 'My orders'),
            _Tile(icon: Icons.inventory_2_outlined, color: Color(0xFF29A3D6), title: 'Packages'),
            _Tile(
              icon: Icons.location_on_outlined,
              color: Color(0xFF8E44EC),
              title: 'Курьерская доставка',
              subtitle: 'Тараз',
            ),
          ]),
          _Section(children: const [
            _Tile(icon: Icons.percent, color: FlipColors.yellow, title: 'Loyalty discount (3%)'),
            _Tile(icon: Icons.account_balance_wallet_outlined, color: Color(0xFF34C759), title: 'Personal account'),
          ]),
          _Section(children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text('Уведомления'),
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Тёмная тема'),
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Язык'),
              trailing: Text('Русский', style: TextStyle(color: FlipColors.grey)),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;

  const _Tile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
