import 'package:flutter/material.dart';

void main() {
  runApp(const BusinessApp());
}

class BusinessApp extends StatelessWidget {
  const BusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileCardScreen(),
    );
  }
}

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key});

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  // Значения по умолчанию (для Reset)
  static const int _defaultFollowers = 1320;
  static const int _defaultLikes = 120;

  int _followerCount = _defaultFollowers;
  int _likesCount = _defaultLikes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.lime,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bigeldi Azat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Senior Developer',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStat('$_followerCount', 'Followers'),
                    const SizedBox(width: 40),
                    _buildStat('$_likesCount', 'Likes ❤️'),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _follow,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Follow'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _unfollow,
                      icon: const Icon(Icons.person_remove),
                      label: const Text('Unfollow'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _like,
                      icon: const Icon(Icons.thumb_up),
                      label: const Text('Like'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _dislike,
                      icon: const Icon(Icons.thumb_down),
                      label: const Text('Dislike'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  void _follow() {
    setState(() => _followerCount++);
  }

  void _unfollow() {
    setState(() {
      if (_followerCount > 0) _followerCount--;
    });
  }

  void _like() {
    setState(() => _likesCount++);
  }

  void _dislike() {
    setState(() {
      if (_likesCount > 0) _likesCount--;
    });
  }

  void _reset() {
    setState(() {
      _followerCount = _defaultFollowers;
      _likesCount = _defaultLikes;
    });
  }
}
