import 'package:aitota_business/core/utils/snack_bar.dart';
import '../../../../../../core/app-export.dart';
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class MyProductController extends GetxController {
  final RxList<Map<String, dynamic>> productItems = <Map<String, dynamic>>[].obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyProducts();
  }

  Future<void> fetchMyProducts() async {
    try {
      isLoading.value = true;
      final response = await apiService.getMyBusinesses();
      if (response.success == true && response.data != null) {
        productItems.clear();
        productItems.addAll(response.data!.where((item) => item.type == 'product').map((business) {
          return {
            'id': business.sId ?? '',
            'title': business.title ?? 'Untitled Product',
            'category': business.category ?? '',
            'type': business.type ?? '',
            'description': business.description ?? '',
            'videoLink': business.videoLink ?? '',
            'link': business.link ?? '',
            'sharelink': business.sharelink ?? '',
            'imageUrl': business.image?.url ?? ImageConstant.onboarding1,
            'mrp': business.mrp, // Keep as int? to match model
            'offerPrice': business.offerPrice, // Keep as int? to match model
          };
        }).toList());
      } else {
        customSnackBar(message: "Failed to fetch products", type: "E");
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMyBusiness(String businessId) async {
    try {
      isLoading.value = true;
      final response = await apiService.deleteMyBusiness(businessId);
      if (response.success == true) {
        productItems.removeWhere((item) => item['id'] == businessId);
      } else {
        customSnackBar(message: "Failed to delete business", type: "E");
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}