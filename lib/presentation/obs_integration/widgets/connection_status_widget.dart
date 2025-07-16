import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final bool connectionFailed;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
    required this.isConnecting,
    required this.connectionFailed,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    String iconName;

    if (isConnecting) {
      statusColor = AppTheme.warningLight;
      statusText = 'Connecting...';
      iconName = 'sync';
    } else if (isConnected) {
      statusColor = AppTheme.successLight;
      statusText = 'Connected to OBS';
      iconName = 'check_circle';
    } else if (connectionFailed) {
      statusColor = AppTheme.lightTheme.colorScheme.error;
      statusText = 'Connection Failed';
      iconName = 'error';
    } else {
      statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      statusText = 'Not Connected';
      iconName = 'radio_button_unchecked';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          isConnecting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                )
              : CustomIconWidget(
                  iconName: iconName,
                  color: statusColor,
                  size: 20,
                ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isConnected) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Real-time streaming active',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isConnected) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'signal_cellular_4_bar',
                    color: Colors.white,
                    size: 12,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Excellent',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
