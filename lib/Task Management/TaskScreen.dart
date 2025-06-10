// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final List<String> tabs = ['All Tasks', 'Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
       _checkInitialConnection();
   _setupConnectivityListener();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }


    Future<void> _checkInitialConnection() async {
    if (!(await _connectivityService.isConnected())) {
      _connectivityService.showNoInternetScreen();
    }
  }

    void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService.listenToConnectivityChanges(
      onConnected: () {
        // Optional: You can automatically go back if connection is restored
        // Get.back();
      },
      onDisconnected: () {
        _connectivityService.showNoInternetScreen();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: false,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: const CustomText(
          text: "Task Management",
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: CRMColors.whiteColor,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: tabs.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [showTodayTask(), showPendingTasks(), showCompletedTasks()],
      ),
    );
  }

  Widget showTodayTask() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        // Sample dynamic content
        final statusList = ['Pending', 'In Progress', 'Completed'];
        final priorities = ['High', 'Medium', 'Low'];
        final colors = [Colors.red, Colors.orange, Colors.green];
        final status = statusList[index % 3];
        final priority = priorities[index % 3];
        final color = colors[index % 3];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Title + Priority Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Task ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  CustomText(
                    text: 'Priority: ',
                    color: CRMColors.darkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: priority,
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                'Design the new login screen and ensure responsiveness across devices.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 12),

              // Info Row: Status + Due Time + Assigned To
              Row(
                children: [
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timelapse,
                          size: 14,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Due Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Today, 4:30 PM',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Assigned User
                  const CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/100?img=3',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  ///////////////////////  Pending Task  ///////////////////////
  Widget showPendingTasks() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // You can change this to your actual pending tasks length
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Priority
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Task ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'High Priority',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'Fix UI bugs on dashboard screen and test on all screen sizes.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),

              // Status, Time, Assigned
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.timelapse, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'Pending',
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Due: Today, 3:00 PM',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/100?img=4',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  ///////////////////////  Completed Task  ///////////////////////

  Widget showCompletedTasks() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with your completed task count
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title with Check Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed Task ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'Integrated new API for user login and tested successfully.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),

              // Status, Time, Assigned
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      CustomText(
                        text: 'Yesterday, 5:45 PM',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),

                  // const Spacer(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
