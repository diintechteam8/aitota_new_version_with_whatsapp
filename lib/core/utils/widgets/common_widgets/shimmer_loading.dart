import 'package:shimmer/shimmer.dart';
import '../../../app-export.dart';

class BaseShimmer extends StatelessWidget {
  final Widget child;
  const BaseShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius.r)
            : null,
      ),
    );
  }
}

class LeadCardShimmer extends StatelessWidget {
  const LeadCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerPlaceholder(width: 22.w, height: 22.w, shape: BoxShape.circle),
              SizedBox(width: 8.w),
              ShimmerPlaceholder(width: 100.w, height: 16.h),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: ShimmerPlaceholder(width: 60.w, height: 40.h),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ShimmerPlaceholder(width: 20.w, height: 20.w, shape: BoxShape.circle),
              SizedBox(width: 8.w),
              ShimmerPlaceholder(width: 20.w, height: 20.w, shape: BoxShape.circle),
            ],
          ),
        ],
      ),
    );
  }
}

class GridItemShimmer extends StatelessWidget {
  const GridItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.15)),
      ),
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerPlaceholder(width: 20.w, height: 20.w, shape: BoxShape.circle),
          SizedBox(height: 8.h),
          ShimmerPlaceholder(width: 40.w, height: 18.h),
          SizedBox(height: 4.h),
          ShimmerPlaceholder(width: 60.w, height: 12.h),
        ],
      ),
    );
  }
}

class CampaignCardShimmer extends StatelessWidget {
  const CampaignCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerPlaceholder(width: 40.w, height: 40.w, borderRadius: 8),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(width: 140.w, height: 16.h),
                    SizedBox(height: 4.h),
                    ShimmerPlaceholder(width: 80.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder(width: 60.w, height: 14.h),
              ShimmerPlaceholder(width: 80.w, height: 24.h, borderRadius: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class ConversationCardShimmer extends StatelessWidget {
  const ConversationCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder(width: 150.w, height: 18.h),
              ShimmerPlaceholder(width: 60.w, height: 20.h, borderRadius: 6),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              ShimmerPlaceholder(width: 20.w, height: 20.w, shape: BoxShape.circle),
              SizedBox(width: 8.w),
              ShimmerPlaceholder(width: 120.w, height: 14.h),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerPlaceholder(width: 18.w, height: 18.w, shape: BoxShape.circle),
                  SizedBox(width: 8.w),
                  ShimmerPlaceholder(width: 80.w, height: 12.h),
                ],
              ),
              Row(
                children: [
                  ShimmerPlaceholder(width: 18.w, height: 18.w, shape: BoxShape.circle),
                  SizedBox(width: 4.w),
                  ShimmerPlaceholder(width: 60.w, height: 12.h),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GroupCardShimmer extends StatelessWidget {
  const GroupCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 12.w, right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          ShimmerPlaceholder(width: 50.w, height: 50.w, shape: BoxShape.circle),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerPlaceholder(width: 120.w, height: 16.h),
                SizedBox(height: 6.h),
                ShimmerPlaceholder(width: 80.w, height: 12.h),
              ],
            ),
          ),
          ShimmerPlaceholder(width: 24.w, height: 24.w, shape: BoxShape.circle),
          SizedBox(width: 8.w),
          ShimmerPlaceholder(width: 24.w, height: 24.w, shape: BoxShape.circle),
        ],
      ),
    );
  }
}

class LandingStatsShimmer extends StatelessWidget {
  const LandingStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItemShimmer(),
              _verticalDivider(),
              _buildStatItemShimmer(),
            ],
          ),
          Divider(height: 32.h, color: Colors.grey.shade100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItemShimmer(),
              _verticalDivider(),
              _buildStatItemShimmer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItemShimmer() {
    return Expanded(
      child: Column(
        children: [
          ShimmerPlaceholder(width: 24.w, height: 24.w, shape: BoxShape.circle),
          SizedBox(height: 8.h),
          ShimmerPlaceholder(width: 60.w, height: 18.h),
          SizedBox(height: 4.h),
          ShimmerPlaceholder(width: 80.w, height: 12.h),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(height: 40.h, width: 1, color: Colors.grey.shade100);
  }
}

class ActionCardShimmer extends StatelessWidget {
  const ActionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerPlaceholder(width: 36.w, height: 36.w, shape: BoxShape.circle),
          SizedBox(height: 12.h),
          ShimmerPlaceholder(width: 80.w, height: 14.h),
        ],
      ),
    );
  }
}

class TemplateCardShimmer extends StatelessWidget {
  const TemplateCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder(width: 180.w, height: 18.h),
              ShimmerPlaceholder(width: 70.w, height: 22.h, borderRadius: 20),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ShimmerPlaceholder(width: 60.w, height: 18.h, borderRadius: 8),
              SizedBox(width: 8.w),
              ShimmerPlaceholder(width: 40.w, height: 18.h, borderRadius: 8),
            ],
          ),
          SizedBox(height: 16.h),
          ShimmerPlaceholder(width: double.infinity, height: 12.h),
          SizedBox(height: 6.h),
          ShimmerPlaceholder(width: 200.w, height: 12.h),
        ],
      ),
    );
  }
}

class ChatTileShimmer extends StatelessWidget {
  const ChatTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          ShimmerPlaceholder(width: 56.w, height: 56.w, shape: BoxShape.circle),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerPlaceholder(width: 120.w, height: 16.h),
                    ShimmerPlaceholder(width: 40.w, height: 12.h),
                  ],
                ),
                SizedBox(height: 8.h),
                ShimmerPlaceholder(width: 200.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
