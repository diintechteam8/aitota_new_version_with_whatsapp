import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/widgets/analytics_widgets/call_history_item.dart';
import 'package:intl/intl.dart';
import '../../../../../../data/model/myDial/analytics_model/call_history_model.dart';
import '../controller/call_analytics_controller.dart';
import 'controller/incoming_calls_controller.dart';

class IncomingCallsScreen extends GetView<IncomingCallsController> {
  const IncomingCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ──────────────────────── ARGUMENT HANDLING ────────────────────────
    final args = Get.arguments as AnalyticsNavigationData;

    // Use the title passed from Analytics screen
    final String screenTitle = args.title;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: screenTitle,
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorConstants.appThemeColor),
              ),
            );
          }

          if (controller.filteredCalls.isEmpty) {
            return Center(
              child: Text(
                'No $screenTitle found',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: controller.filteredCalls.length,
            separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
            itemBuilder: (context, index) {
              final call = controller.filteredCalls[index];

              // Safely extract duration
              final duration = _formatDuration(call.durationSeconds);

              // Convert model to UI object
              final callHistoryItem = CallHistoryItem(
                id: call.id ?? '',
                name: call.contact?.name ?? 'Unknown',
                phoneNumber: call.phoneNumber,
                date: _formatDate(call.startedAt),
                time: _formatTime(call.startedAt),
                duration: duration,
                callType: _mapToCallType(call.direction),
              );

              return CallHistoryListItem(callItem: callHistoryItem);
            },
          );
        }),
      ),
    );
  }

  // ──────────────────────────── HELPERS ────────────────────────────

  String _formatDate(String startedAt) {
    try {
      final dateTime = DateTime.parse(startedAt);
      return DateFormat('dd MMM').format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String _formatTime(String startedAt) {
    try {
      final dateTime = DateTime.parse(startedAt);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String _formatDuration(dynamic duration) {
    if (duration == null) return '0s';
    if (duration is int) {
      final minutes = duration ~/ 60;
      final seconds = duration % 60;
      if (minutes > 0) return '${minutes}m ${seconds}s';
      return '${seconds}s';
    }
    return duration.toString();
  }

  CallType _mapToCallType(String direction) {
    switch (direction.toLowerCase()) {
      case 'incoming':
        return CallType.incoming;
      case 'outgoing':
        return CallType.outgoing;
      case 'missed':
        return CallType.missed;
      case 'rejected':
        return CallType.rejected;
      default:
        return CallType.incoming;
    }
  }
}