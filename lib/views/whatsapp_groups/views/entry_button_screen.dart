import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../binding/groups_binding.dart';
import 'groups_landing_screen.dart';

class GroupsEntryButtonScreen extends StatelessWidget {
  const GroupsEntryButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Theme Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.to(() => const GroupsLandingScreen(), binding: GroupsBinding()),
          child: const Text('Open Groups'),
        ),
      ),
    );
  }
}


