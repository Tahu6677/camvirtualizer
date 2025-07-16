import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PreviewWindowWidget extends StatefulWidget {
  final String selectedSourceId;
  final List<Map<String, dynamic>> sources;

  const PreviewWindowWidget({
    super.key,
    required this.selectedSourceId,
    required this.sources,
  });

  @override
  State<PreviewWindowWidget> createState() => _PreviewWindowWidgetState();
}

class _PreviewWindowWidgetState extends State<PreviewWindowWidget> {
  bool _isFullscreen = false;
  bool _showOverlayControls = true;
  double _volume = 0.8;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    final selectedSource = widget.sources.firstWhere(
      (source) => source["id"] == widget.selectedSourceId,
      orElse: () => <String, dynamic>{},
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Window
          _buildPreviewWindow(selectedSource),

          SizedBox(height: 3.h),

          // Control Panel
          _buildControlPanel(selectedSource),

          SizedBox(height: 3.h),

          // Injection Controls
          _buildInjectionControls(),
        ],
      ),
    );
  }

  Widget _buildPreviewWindow(Map<String, dynamic> source) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Container(
        width: double.infinity,
        height: 30.h,
        child: source.isEmpty
            ? _buildNoSourceSelected()
            : _buildSourcePreview(source),
      ),
    );
  }

  Widget _buildNoSourceSelected() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'videocam_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Source Selected',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select an OBS source to preview',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcePreview(Map<String, dynamic> source) {
    return Stack(
      children: [
        // Preview Image
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: source["thumbnail"],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Live Indicator
        Positioned(
          top: 2.h,
          left: 3.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  'LIVE',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Source Info
        Positioned(
          top: 2.h,
          right: 3.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              source["name"],
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Overlay Controls
        if (_showOverlayControls) _buildOverlayControls(),

        // Fullscreen Toggle
        Positioned(
          bottom: 2.h,
          right: 3.w,
          child: GestureDetector(
            onTap: () => setState(() => _isFullscreen = !_isFullscreen),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _isFullscreen ? 'fullscreen_exit' : 'fullscreen',
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayControls() {
    return Positioned(
      bottom: 2.h,
      left: 3.w,
      child: Row(
        children: [
          // Play/Pause
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'pause',
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // Volume Control
          GestureDetector(
            onTap: () => setState(() => _isMuted = !_isMuted),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _isMuted ? 'volume_off' : 'volume_up',
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(Map<String, dynamic> source) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'control_camera',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Preview Controls',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Volume Control
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'volume_up',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Slider(
                    value: _volume,
                    onChanged: (value) => setState(() => _volume = value),
                    min: 0.0,
                    max: 1.0,
                  ),
                ),
                Text(
                  '${(_volume * 100).round()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(
                        () => _showOverlayControls = !_showOverlayControls),
                    icon: CustomIconWidget(
                      iconName: _showOverlayControls
                          ? 'visibility_off'
                          : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    label: Text(_showOverlayControls
                        ? 'Hide Controls'
                        : 'Show Controls'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(
                      iconName: 'screenshot',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    label: const Text('Screenshot'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInjectionControls() {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'input',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Injection Controls',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            Text(
              'Inject this OBS source into virtual camera feed',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),

            SizedBox(height: 2.h),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        widget.selectedSourceId.isEmpty ? null : _injectSource,
                    icon: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: widget.selectedSourceId.isEmpty
                          ? AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 18,
                    ),
                    label: const Text('Start Injection'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(
                      iconName: 'stop',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    label: const Text('Stop Injection'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Quick Actions
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                ActionChip(
                  avatar: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: const Text('Virtual Camera'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/virtual-camera-control'),
                ),
                ActionChip(
                  avatar: CustomIconWidget(
                    iconName: 'video_library',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: const Text('Media Library'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/media-library'),
                ),
                ActionChip(
                  avatar: CustomIconWidget(
                    iconName: 'dashboard',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: const Text('Dashboard'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/main-dashboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _injectSource() {
    final selectedSource = widget.sources.firstWhere(
      (source) => source["id"] == widget.selectedSourceId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Injecting "${selectedSource["name"]}" into virtual camera feed'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
          onPressed: () =>
              Navigator.pushNamed(context, '/virtual-camera-control'),
        ),
      ),
    );
  }
}
