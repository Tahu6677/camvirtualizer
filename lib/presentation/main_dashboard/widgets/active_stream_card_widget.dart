import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActiveStreamCardWidget extends StatefulWidget {
  final bool isActive;
  final VoidCallback onToggle;
  final VoidCallback onSourceSwitch;

  const ActiveStreamCardWidget({
    super.key,
    required this.isActive,
    required this.onToggle,
    required this.onSourceSwitch,
  });

  @override
  State<ActiveStreamCardWidget> createState() => _ActiveStreamCardWidgetState();
}

class _ActiveStreamCardWidgetState extends State<ActiveStreamCardWidget>
    with SingleTickerProviderStateMixin {
  bool _showAdvancedControls = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAdvancedControls() {
    setState(() {
      _showAdvancedControls = !_showAdvancedControls;
    });

    if (_showAdvancedControls) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _toggleAdvancedControls();
        }
      },
      onLongPress: () {
        _showContextMenu();
      },
      child: Card(
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
                        iconName: 'videocam',
                        color: widget.isActive
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.lightTheme.colorScheme.outline,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        "Active Stream",
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (_showAdvancedControls)
                        GestureDetector(
                          onTap: _toggleAdvancedControls,
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.outline,
                            size: 20,
                          ),
                        ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: widget.onSourceSwitch,
                        child: CustomIconWidget(
                          iconName: 'swap_horiz',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Camera Preview
              Container(
                width: double.infinity,
                height: 25.h,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? Colors.black
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: widget.isActive
                    ? Stack(
                        children: [
                          // Simulated camera feed
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.withValues(alpha: 0.3),
                                  Colors.purple.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                          // Live indicator
                          Positioned(
                            top: 2.h,
                            left: 3.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "LIVE",
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Resolution indicator
                          Positioned(
                            bottom: 2.h,
                            right: 3.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "1080p • 30fps",
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'videocam_off',
                              color: AppTheme.lightTheme.colorScheme.outline,
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Camera Inactive",
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              SizedBox(height: 3.h),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: widget.isActive ? 'pause' : 'play_arrow',
                    label: widget.isActive ? 'Pause' : 'Start',
                    onTap: widget.onToggle,
                    isPrimary: true,
                  ),
                  _buildControlButton(
                    icon: 'settings',
                    label: 'Settings',
                    onTap: _toggleAdvancedControls,
                  ),
                  _buildControlButton(
                    icon: 'fullscreen',
                    label: 'Fullscreen',
                    onTap: () {
                      // Handle fullscreen
                    },
                  ),
                ],
              ),

              // Advanced Controls (Animated)
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return SizeTransition(
                    sizeFactor: _slideAnimation,
                    child: child,
                  );
                },
                child: _showAdvancedControls
                    ? _buildAdvancedControls()
                    : const SizedBox.shrink(),
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
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isPrimary
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isPrimary
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedControls() {
    return Container(
      margin: EdgeInsets.only(top: 3.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Advanced Controls",
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          // Resolution Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Resolution",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              DropdownButton<String>(
                value: "1080p",
                items: ["720p", "1080p", "4K"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle resolution change
                },
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Frame Rate Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Frame Rate",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              DropdownButton<String>(
                value: "30fps",
                items: ["24fps", "30fps", "60fps"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle frame rate change
                },
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Filter Options
          Text(
            "Filters",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            children: ["None", "Blur", "Vintage", "B&W"].map((filter) {
              return FilterChip(
                label: Text(filter),
                selected: filter == "None",
                onSelected: (bool selected) {
                  // Handle filter selection
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text("Stream Settings"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to stream settings
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'save',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text("Save Configuration"),
              onTap: () {
                Navigator.pop(context);
                // Save current configuration
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text("Reset to Default"),
              onTap: () {
                Navigator.pop(context);
                // Reset to default settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
