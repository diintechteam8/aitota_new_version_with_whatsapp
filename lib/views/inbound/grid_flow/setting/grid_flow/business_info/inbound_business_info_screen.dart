import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/business_info/controller/inbound_business_info_controller.dart';
import '../../../../../../core/app-export.dart';

class InboundBusinessInfoScreen extends GetView<InboundBusinessInfoController> {
  const InboundBusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Information'),
        backgroundColor: ColorConstants.appThemeColor,
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
        child: Obx(() => Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.isLoading.value &&
                    controller.isButtonLoading.value)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: controller.businessData.value == null
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        if (controller.businessData.value == null)
                          const Text(
                            'Add your business information',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (controller.businessData.value?.clientId != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Client ID: ${controller.businessData.value!.clientId}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: TextField(
                            controller: controller.textController,
                            enabled: controller.isEditing.value,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Enter business information',
                              border: controller.isEditing.value
                                  ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )
                                  : InputBorder.none,
                              contentPadding: const EdgeInsets.all(12.0),
                              filled: true,
                              fillColor: controller.isEditing.value
                                  ? Colors.white
                                  : Colors.grey[100],
                            ),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16.0),
                if (controller.isEditing.value)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: controller.isButtonLoading.value
                            ? null
                            : controller.businessData.value == null
                                ? () => controller.addBusinessInfo()
                                : controller.hasChanges.value
                                    ? () => controller.updateBusinessInfo()
                                    : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.businessData.value == null
                              ? Colors.green
                              : ColorConstants.appThemeColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: controller.isButtonLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text(
                                controller.businessData.value == null
                                    ? 'Add'
                                    : 'Update',
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}