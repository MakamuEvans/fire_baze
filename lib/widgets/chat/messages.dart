import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_baze/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final chatDocs = snapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, i) => MessageBubble(chatDocs[i]['text'], chatDocs[i]['userId'],
              chatDocs[i]['userId'] == user.uid, key: ValueKey(chatDocs[i].id),),
          itemCount: chatDocs.length,
        );
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('created_at', descending: true)
          .snapshots(),
    );
  }
}
