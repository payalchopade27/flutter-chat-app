import 'package:chat_app/widgets/mesage_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  // 🔹 Bottom sheet for Edit & Delete
  void _showEditDeleteDialog(
      BuildContext context,
      String docId,
      String oldText,
      ) {
    final controller = TextEditingController(text: oldText);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✏️ Edit Message
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Message'),
                onTap: () async {
                  Navigator.pop(ctx);

                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Edit Message'),
                      content: TextField(
                        controller: controller,
                        maxLines: null,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('chat')
                                .doc(docId)
                                .update({
                              'text': controller.text,
                              'edited': true,
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 🗑 Delete Message
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Message'),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('chat')
                      .doc(docId)
                      .delete();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatDoc = loadedMessages[index];
            final chatMessage = chatDoc.data() as Map<String, dynamic>;

            final isMe =
                authenticatedUser.uid == chatMessage['userId'];

            final timestamp = chatMessage['createdAt'] as Timestamp?;
            final formattedTime = timestamp != null
                ? DateFormat('hh:mm a').format(timestamp.toDate())
                : '';

            return GestureDetector(
              onLongPress: isMe
                  ? () => _showEditDeleteDialog(
                context,
                chatDoc.id,
                chatMessage['text'],
              )
                  : null,
              child: Column(
                crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: isMe,
                  ),

                  // ⏱ Timestamp + Edited label
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 6),
                    child: Text(
                      formattedTime +
                          (chatMessage['edited'] == true
                              ? ' (edited)'
                              : ''),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}