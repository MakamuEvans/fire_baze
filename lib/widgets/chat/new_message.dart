import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add({'text': _enteredMessage, 'created_at': Timestamp.now(), 'userId': user.uid});
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send Message!'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: _enteredMessage.trim().isEmpty ? null :_sendMessage)
        ],
      ),
    );
  }
}
