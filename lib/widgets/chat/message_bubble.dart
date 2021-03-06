import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isMe;
  final Key key;

  MessageBubble(this.message, this.userName, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(userName).get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text(
              "loading...",
              style: TextStyle(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline1.color),
            );
          return Stack(
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.grey.shade300
                          : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft:
                              !isMe ? Radius.circular(0) : Radius.circular(12),
                          bottomRight:
                              isMe ? Radius.circular(0) : Radius.circular(12)),
                    ),
                    width: 140,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline1
                                      .color),
                        ),
                        Text(
                          message,
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline1
                                      .color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 0,
                  left: isMe ? null : 120,
                  right: !isMe ? null : 120,
                  child: CircleAvatar(radius: 15,
                    backgroundImage: NetworkImage(snapshot.data['image_url']),
                  )),
            ],
            clipBehavior: Clip.none,
          );
        });
  }
}
