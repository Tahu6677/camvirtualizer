import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControlPanelWidget extends StatelessWidget {
  final bool isStreaming;
  final bool isRecording;
  final String currentFilter;
  final VoidCallback onToggleStream;
  final VoidCallback onToggleRecording;
  final VoidCallback onMediaInject;
  final VoidCallback onSettings;
  final VoidCallback onAdvancedControls;

  const ControlPanelWidget({
    Key? key,
    required this.isStreaming,
    required this.isRecording,
    required this.currentFilter,
    required this.onToggleStream,
    required this.onToggleRecording,
    required this.onMediaInject,
    required this.onSettings,
    required this.onAdvancedControls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
            Colors.black,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Primary controls row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: isStreaming ? 'stop' : 'play_arrow',
                    label: isStreaming ? 'Stop Stream' : 'Start Stream',
                    color: isStreaming
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.secondary,
                    onPressed: onToggleStream,
                    isActive: isStreaming,
                  ),
                  _buildControlButton(
                    icon: 'video_library',
                    label: 'Media Inject',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    onPressed: onMediaInject,
                  ),
                  _buildControlButton(
                    icon: isRecording ? 'stop_circle' : 'fiber_manual_record',
                    label: isRecording ? 'Stop Rec' : 'Record',
                    color: isRecording
                        ? AppTheme.lightTheme.colorScheme.error
                        : Colors.red,
                    onPressed: onToggleRecording,
                    isActive: isRecording,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Secondary controls row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSecondaryButton(
                    icon: 'tune',
                    label: 'Advanced',
                    onPressed: onAdvancedControls,
                  ),
                  _buildSecondaryButton(
                    icon: 'swap_horiz',
                    label: 'Source',
                    onPressed: () {
                      // Handle source switch
                    },
                  ),
                  _buildSecondaryButton(
                    icon: 'settings',
                    label: 'Settings',
                    onPressed: onSettings,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 20.w,
        height: 8.h,
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isActive ? color : Colors.white.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive ? color : Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isActive ? color : Colors.white,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white.withValues(alpha: 0.8),
              size: 18,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
