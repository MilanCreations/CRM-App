import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Chat',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 110, // ✅ Enough space for avatar + spacing + text
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const CircleAvatar(
                          radius: 28, // 56px tall
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'User ${index + 1}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),

          // Placeholder for main chat area
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    onTap: () {},
                    leading: CircleAvatar(
                      radius: 28, // 56px tall
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Row(
                      children: [
                        CustomText(text: 'User ${index + 1}'),
                        Spacer(),
                        CustomText(
                          text: DateFormat('HH:mm a').format(DateTime.now()),
                        ),
                      ],
                    ),
                    subtitle: CustomText(text: 'Message ${index + 1}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
