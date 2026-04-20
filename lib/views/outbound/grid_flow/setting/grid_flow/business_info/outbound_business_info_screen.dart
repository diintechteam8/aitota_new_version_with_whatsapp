import '../../../../../../core/app-export.dart';
import 'controller/outbound_business_info_controller.dart';

class OutboundBusinessInfoScreen extends GetView<OutboundBusinessInfoController> {
  const OutboundBusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Information'),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.isEditing.value ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              controller.toggleEditing();
            },
          )),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator())
              else if (controller.errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          enabled: controller.isEditing.value,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: controller.isEditing.value
                                ? const OutlineInputBorder()
                                : InputBorder.none,
                            contentPadding: const EdgeInsets.all(8.0),
                          ),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16.0),
              if (controller.isEditing.value && controller.hasChanges.value)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateBusinessInfo();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      'Update Business Info',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }
}