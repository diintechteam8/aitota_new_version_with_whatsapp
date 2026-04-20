import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../add_contact/controller/add_contact_controller.dart';

class EnterDetailsController extends GetxController {
  final AddContactController addContactController = Get.find<AddContactController>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final phoneInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // addContactController.addContact(
      //   nameController.text,
      //   phoneController.text,
      //   emailController.text.isEmpty ? '' : emailController.text,
      //   // company: companyController.text,
      //   // address: addressController.text,
      //   // dob: dobController.text,
      // );
      Get.back();
      Get.snackbar(
        'Success',
        'Contact added successfully',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    companyController.dispose();
    emailController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.onClose();
  }
}