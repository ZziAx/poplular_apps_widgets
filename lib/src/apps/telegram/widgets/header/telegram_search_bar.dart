import 'package:flutter/material.dart';

class TelegramSearchBar extends StatelessWidget {
  const TelegramSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 37,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white12,
      ),
alignment: Alignment.centerLeft,
padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text("Search Chats",style: TextStyle(
        fontSize: 16,
        color: Colors.white30),),
    );
  }
}