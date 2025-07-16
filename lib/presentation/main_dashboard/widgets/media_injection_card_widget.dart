import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MediaInjectionCardWidget extends StatefulWidget {
  final VoidCallback onImageInjection;
  final VoidCallback onVideoInjection;

  const MediaInjectionCardWidget({
    super.key,
    required this.onImageInjection,
    required this.onVideoInjection,
  });

  @override
  State<MediaInjectionCardWidget> createState() =>
      _MediaInjectionCardWidgetState();
}

class _MediaInjectionCardWidgetState extends State<MediaInjectionCardWidget> {
  String _lastInjectedMedia = "None";
  bool _isInjectionActive = false;

  final List<Map<String, dynamic>> _recentMedia = [
    {
      "type": "image",
      "name": "sample_image.jpg",
      "thumbnail":
          "https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=300",
      "size": "2.4 MB"
    },
    {
      "type": "video",
      "name": "demo_video.mp4",
      "thumbnail":
          "https://images.pixabay.com/photo-2016/02/13/13/11/oldtimer-1197800_960_720.jpg?auto=compress&cs=tinysrgb&w=300",
      "size": "15.7 MB"
    },
    {
      "type": "image",
      "name": "test_pattern.png",
      "thumbnail":
          "https://images.unsplash.com/photo-1611532736597-de2d4265fba3?auto=compress&cs=tinysrgb&w=300",
      "size": "1.2 MB"
    },
  ];

  void _injectMedia(String type, String name) {
    setState(() {
      _lastInjectedMedia = name;
      _isInjectionActive = true;
    });

    // Simulate injection process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isInjectionActive = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      "Media Injection",
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ],
                ),
                if (_isInjectionActive)
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 2.h),

            // Status
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _isInjectionActive
                    ? AppTheme.getWarningColor(true).withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isInjectionActive
                      ? AppTheme.getWarningColor(true)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _isInjectionActive ? 'sync' : 'info',
                    color: _isInjectionActive
                        ? AppTheme.getWarningColor(true)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _isInjectionActive
                          ? "Injecting media into stream..."
                          : "Last injected: $_lastInjectedMedia",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _isInjectionActive
                            ? AppTheme.getWarningColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: 'image',
                    label: 'Inject Image',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    onTap: widget.onImageInjection,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: 'video_library',
                    label: 'Inject Video',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    onTap: widget.onVideoInjection,
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Recent Media
            Text(
              "Recent Media",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),

            SizedBox(
              height: 12.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recentMedia.length,
                itemBuilder: (context, index) {
                  final media = _recentMedia[index];
                  return Container(
                    width: 25.w,
                    margin: EdgeInsets.only(right: 3.w),
                    child: GestureDetector(
                      onTap: () => _injectMedia(media["type"], media["name"]),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                      child: CustomImageWidget(
                                        imageUrl: media["thumbnail"],
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (media["type"] == "video")
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.all(1.w),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: CustomIconWidget(
                                            iconName: 'play_arrow',
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(1.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    media["name"],
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    media["size"],
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // Advanced Options
            TextButton.icon(
              onPressed: () {
                _showAdvancedOptions();
              },
              icon: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text(
                "Advanced Injection Options",
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Text(
                "Advanced Injection Options",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  SwitchListTile(
                    title: const Text("Loop Video Injection"),
                    subtitle: const Text("Continuously loop injected videos"),
                    value: true,
                    onChanged: (bool value) {
                      // Handle loop setting
                    },
                  ),
                  SwitchListTile(
                    title: const Text("Maintain Aspect Ratio"),
                    subtitle: const Text("Preserve original media dimensions"),
                    value: false,
                    onChanged: (bool value) {
                      // Handle aspect ratio setting
                    },
                  ),
                  ListTile(
                    title: const Text("Injection Timing"),
                    subtitle: const Text("Immediate"),
                    trailing: CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.outline,
                      size: 16,
                    ),
                    onTap: () {
                      // Show timing options
                    },
                  ),
                  ListTile(
                    title: const Text("Quality Settings"),
                    subtitle: const Text("High Quality"),
                    trailing: CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.outline,
                      size: 16,
                    ),
                    onTap: () {
                      // Show quality options
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
