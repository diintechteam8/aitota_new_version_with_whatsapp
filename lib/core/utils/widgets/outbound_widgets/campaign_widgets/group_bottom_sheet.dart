import '../../../../../core/app-export.dart';
import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';

class GroupBottomSheet extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  const GroupBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),

          child: Column(
            children: [
              /// ✔ Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Groups',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500, /// heading weight
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              /// ✔ Body
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (controller.availableGroups.isEmpty) {
                    return const Center(
                      child: Text(
                        'No groups available',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }

                  /// List of Groups
                  return ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: controller.availableGroups.length,
                    itemBuilder: (context, index) {
                      final group = controller.availableGroups[index];
                      final String groupId = group['sId'] as String;

                      return Obx(() {
                        final isChecked = controller.selectedGroups
                            .any((g) => g['sId'] == groupId);

                        return CheckboxListTile(
                          key: ValueKey(groupId),
                          activeColor: Colors.green,
                          value: isChecked,
                          controlAffinity: ListTileControlAffinity.trailing,

                          title: Text(
                            group['name'] ?? 'Unnamed Group',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500, /// heading weight
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),

                          subtitle: Text(
                            '${group['contacts'] ?? 0} contacts',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400, /// normal text
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),

                          onChanged: (value) {
                            if (value == true) {
                              if (!controller.selectedGroups
                                  .any((g) => g['sId'] == groupId)) {
                                controller.selectedGroups.add(group);
                              }
                            } else {
                              controller.selectedGroups
                                  .removeWhere((g) => g['sId'] == groupId);
                            }
                          },
                        );
                      });
                    },
                  );
                }),
              ),

              /// ✔ Confirm Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final isActionEnabled =
                        controller.selectedGroups.isNotEmpty;

                    return ElevatedButton(
                      onPressed: isActionEnabled
                          ? () async {
                              /// Close sheet successfully after updating
                              final groupIds = controller.selectedGroups
                                  .map((g) => g['sId'] as String)
                                  .toList();

                              if (controller.campaignId != null) {
                                await controller.addGroupsToCampaign(
                                  controller.campaignId!,
                                  groupIds,
                                );
                                if (context.mounted) Navigator.pop(context);
                              }
                            }
                          : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isActionEnabled ? Colors.green : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'Confirm Selection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500, /// semi-bold
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

