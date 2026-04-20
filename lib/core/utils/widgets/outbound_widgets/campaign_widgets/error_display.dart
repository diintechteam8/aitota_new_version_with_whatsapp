import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDisplay extends StatelessWidget {
  final String errorMessage;

  const ErrorDisplay({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.sp,
            color: Colors.red.shade600,
          ),
          SizedBox(height: 16.h),
          Text(
            errorMessage,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}