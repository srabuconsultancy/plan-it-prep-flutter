import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class MembershipsList extends StatelessWidget {
  const MembershipsList({
    super.key,
  });
  Color _getStatusColor(bool active) {
    if (active) {
      return Colors.green; // Green for active memberships
    } else {
      return Colors.red; // Red for expired memberships
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Get.find();
    return Scaffold(
      appBar: AppBarWidget(
        height: 80,
        onTap: () {
          Get.back();
        },
        title: "My Memberships",
      ),
      body: Obx(
        () => userService.myMemberships.value.isEmpty
            ? SizedBox(
                height: Get.height * 0.8,
                width: Get.width,
                child: "No memberships purchased".text.make().centered(),
              )
            : ListView.builder(
                itemCount: userService.myMemberships.value.length,
                itemBuilder: (context, index) {
                  final membership = userService.myMemberships.value[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 1,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Membership: ${membership.membership}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration: ${membership.month} months',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Status: ${membership.active ? "Active" : "Expired"}',
                                style: TextStyle(
                                  color: _getStatusColor(membership.active),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // You can handle the "Show" action here

                              UserController userController = Get.find();
                              userController.openMembershipPopup(membership: membership);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Show',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
