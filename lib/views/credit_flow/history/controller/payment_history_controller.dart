import '../../../../core/app-export.dart';

class PaymentHistoryController extends GetxController {
  // Observable variables
  final selectedTabIndex = 0.obs;
  
  // Static data for payment history (will be replaced with API later)
  final List<Map<String, dynamic>> paymentHistoryData = [
    {
      'date': '15 Dec 2024',
      'orderId': 'ORD-001234',
      'transId': 'TXN-789456',
      'amount': '₹2,500',
      'credits': '500',
      'status': 'Success',
    },
    {
      'date': '12 Dec 2024',
      'orderId': 'ORD-001233',
      'transId': 'TXN-789455',
      'amount': '₹1,800',
      'credits': '360',
      'status': 'Success',
    },
    {
      'date': '10 Dec 2024',
      'orderId': 'ORD-001232',
      'transId': 'TXN-789454',
      'amount': '₹3,200',
      'credits': '640',
      'status': 'Success',
    },
  ];

  // Static data for credit usage (will be replaced with API later)
  final List<Map<String, dynamic>> creditUsageData = [
    {
      'mobile': '+91 98765 43210',
      'datetime': '15 Dec 2024, 2:30 PM',
      'creditUsed': '5',
      'transcript': 'नमस्ते, मैं आपकी कैसे मदद कर सकता हूँ? Hello, how can I help you?',
      'language': 'hi', // hi for Hindi, en for English
    },
    {
      'mobile': '+91 98765 43211',
      'datetime': '14 Dec 2024, 11:15 AM',
      'creditUsed': '3',
      'transcript': 'आपका ऑर्डर कब डिलीवर होगा? When will your order be delivered?',
      'language': 'hi',
    },
    {
      'mobile': '+91 98765 43212',
      'datetime': '13 Dec 2024, 4:45 PM',
      'creditUsed': '7',
      'transcript': 'Your payment has been processed successfully. Thank you for your business.',
      'language': 'en',
    },
  ];

  // Method to change tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // Method to show transcript bottom sheet
  void showTranscriptBottomSheet(String transcript, String language) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Transcript Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // Transcript content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTranscriptView(transcript, language),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Method to build transcript view with AI and User messages
  Widget _buildTranscriptView(String transcript, String language) {
    // Parse transcript and create conversation view
    // For now, showing as single message, will be enhanced later
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Message
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF5D822E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D822E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    transcript,
                    style: TextStyle(
                      fontFamily: language == 'hi' ? 'NotoSansDevanagari' : 'Poppins',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
