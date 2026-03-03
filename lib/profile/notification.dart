import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = "notification";

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: 'Today'),
              const SizedBox(height: 12),
              const _NotificationCard(
                content:
                'Lorem ipsum dolor sit amet consectetur. Odio risus in tortor fermentum habitasse. Sed fermentum aenean erat ipsum facilisis ultrices porttitor. Egestas pharetra morbi tristique consectetur blandit eu dolor. Tellus suscipit rhoncus scelerisque in gravida gravida massa.',
                timestamp: 'Today at 2:00AM',
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Yesterday'),
              const SizedBox(height: 12),
              const _NotificationCard(
                content:
                'Lorem ipsum dolor sit amet consectetur. Odio risus in tortor fermentum habitasse. Sed fermentum aenean erat ipsum facilisis ultrices porttitor. Egestas pharetra morbi tristique consectetur blandit eu dolor. Tellus suscipit rhoncus scelerisque in gravida gravida massa.',
                timestamp: 'Today at 2:00AM',
              ),
              const SizedBox(height: 12),
              const _NotificationCard(
                content:
                'Lorem ipsum dolor sit amet consectetur. Odio risus in tortor fermentum habitasse. Sed fermentum aenean erat ipsum facilisis ultrices porttitor. Egestas pharetra morbi tristique consectetur blandit eu dolor. Tellus suscipit rhoncus scelerisque in gravida gravida massa.',
                timestamp: 'Today at 2:00AM',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String content;
  final String timestamp;

  const _NotificationCard({
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color(0x4D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A4A4A),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timestamp,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
