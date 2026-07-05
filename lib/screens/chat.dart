import 'package:chat_app/widgets/chat_messsages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'profile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver {

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setOnlineStatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setOnlineStatus(false);
    super.dispose();
  }

  // 🔴🟢 App lifecycle (background / foreground)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOnlineStatus(true);
    } else {
      _setOnlineStatus(false);
    }
  }

  // 🔴🟢 Firestore status update
  void _setOnlineStatus(bool status) {
    final user = _auth.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'isOnline': status,
      'lastSeen': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FlutterChat'),

            // 🟢 Online / 🔴 Offline text
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                }

                final data =
                snapshot.data!.data() as Map<String, dynamic>;
                final isOnline = data['isOnline'] ?? false;

                return Text(
                  isOnline ? '🟢 Online' : '🔴 Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOnline ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          // 🌙 Dark mode toggle
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),

          // 👤 Profile
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),

          // 🚪 Logout
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              _setOnlineStatus(false);
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      ),
    );
  }
}