import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddMediaBottomSheetWidget extends StatelessWidget {
  const AddMediaBottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Add Media',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
          ),

          // Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                _buildOptionTile(
                  context,
                  icon: 'camera_alt',
                  title: 'Camera Capture',
                  subtitle: 'Take a photo or record video',
                  onTap: () {
                    Navigator.pop(context);
                    _handleCameraCapture(context);
                  },
                ),
                _buildOptionTile(
                  context,
                  icon: 'photo_library',
                  title: 'Gallery Import',
                  subtitle: 'Choose from device gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _handleGalleryImport(context);
                  },
                ),
                _buildOptionTile(
                  context,
                  icon: 'download',
                  title: 'Download Educational Content',
                  subtitle: 'Access curated academic samples',
                  onTap: () {
                    Navigator.pop(context);
                    _handleEducationalDownload(context);
                  },
                ),
                _buildOptionTile(
                  context,
                  icon: 'link',
                  title: 'Import from URL',
                  subtitle: 'Add media from web link',
                  onTap: () {
                    Navigator.pop(context);
                    _handleUrlImport(context);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _handleCameraCapture(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Capture'),
        content: Text(
            'Camera functionality would be implemented here with proper permissions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleGalleryImport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Gallery Import'),
        content: Text(
            'Gallery picker would be implemented here with proper permissions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleEducationalDownload(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Educational Content'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available educational samples:'),
            SizedBox(height: 1.h),
            Text('• Cybersecurity demonstrations'),
            Text('• Mobile app testing scenarios'),
            Text('• Academic presentation backgrounds'),
            Text('• Code review examples'),
            SizedBox(height: 1.h),
            Text(
              'Note: Educational content includes usage guidelines and attribution requirements.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Download logic here
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  void _handleUrlImport(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Import from URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Media URL',
                hintText: 'https://example.com/media.jpg',
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Supported formats: JPG, PNG, MP4, MOV',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                Navigator.pop(context);
                // URL import logic here
              }
            },
            child: Text('Import'),
          ),
        ],
      ),
    );
  }
}
