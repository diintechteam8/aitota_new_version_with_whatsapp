import 'package:aitota_business/core/app-export.dart';
import 'controller/update_my_business_controller.dart';

class UpdateMyBusinessScreen extends GetView<UpdateMyBusinessController> {
  const UpdateMyBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        titleStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins),
        title: "Update MyBusiness",
        showBackButton: true,
        onTapBack: (){
          Get.back();
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Business Details',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontFamily: AppFonts.poppins,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Update the details of your business',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildFormSection(
                    title: 'Basic Information',
                    children: [
                      _buildModernTextField(
                        controller: controller.titleController,
                        label: 'Business Title',
                        isRequired: true,
                        hintText: 'Enter your business name',
                      ),
                      const SizedBox(height: 12),
                      _buildModernTextField(
                        controller: controller.categoryController,
                        label: 'Category',
                        isRequired: true,
                        hintText: 'Select business category',
                      ),
                      const SizedBox(height: 12),
                      _buildModernDropdown(
                        label: 'Business Type',
                        isRequired: true,
                      ),
                      const SizedBox(height: 12),
                      _buildModernTextField(
                        controller: controller.descriptionController,
                        label: 'Description',
                        isRequired: false,
                        hintText: 'Tell us about your business',
                        maxLines: 3,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildFormSection(
                    title: 'Pricing',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernTextField(
                              controller: controller.mrpController,
                              label: 'MRP',
                              isRequired: false,
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                              prefix: Text(
                                '₹',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildModernTextField(
                              controller: controller.offerPriceController,
                              label: 'Offer Price',
                              isRequired: false,
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                              prefix: Text(
                                '₹',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildFormSection(
                    title: 'Links',
                    children: [
                      _buildModernTextField(
                        controller: controller.videoLinkController,
                        label: 'Video Link',
                        isRequired: false,
                        hintText: 'https://example.com/video',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        controller: controller.linkController,
                        label: 'Website Link',
                        isRequired: false,
                        hintText: 'https://yourbusiness.com',
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormSection(
                    title: 'Media',
                    children: [
                      Obx(
                            () => controller.imageUrl.value.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Image',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                controller.imageUrl.value,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                            () => _buildFilePicker(
                          title: 'New Business Image (Optional)',
                          isRequired: false,
                          fileName:
                          controller.imageFile.value?.path.split('/').last,
                          onPressed: controller.pickImage,
                          buttonText: 'Select Image',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                            () => _buildFilePicker(
                          title: 'New Document (Optional)',
                          isRequired: false,
                          fileName:
                          controller.documentFile.value?.path.split('/').last,
                          onPressed: controller.pickDocument,
                          buttonText: 'Select Document',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.updateBusiness,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Update Business',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Obx(
                () => controller.isLoading.value
                ? Center(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required bool isRequired,
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green.shade600,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1.5,
              ),
            ),
            prefixIcon: prefix != null
                ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: prefix,
            )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: isRequired
              ? (value) {
            if (value == null || value.trim().isEmpty) {
              return '';
            }
            return null;
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildModernDropdown({
    required String label,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        Obx(
              () => DropdownButtonFormField<String>(
            value: controller.businessType.value.isEmpty
                ? null
                : controller.businessType.value,
            decoration: InputDecoration(
              hintText: 'Select business type',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.green.shade600,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            items: const [
              DropdownMenuItem<String>(
                value: 'product',
                child: Text('Product'),
              ),
              DropdownMenuItem<String>(
                value: 'service',
                child: Text('Service'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                controller.businessType.value = value;
                controller.typeController.text = value; // Sync for form validation
              }
            },
            validator: isRequired
                ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker({
    required String title,
    required bool isRequired,
    String? fileName,
    required VoidCallback onPressed,
    required String buttonText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fileName ?? 'No file selected',
                    style: TextStyle(
                      color: fileName != null
                          ? Colors.grey.shade800
                          : Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.shade100,
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (fileName == null && isRequired)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'This field is required',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}