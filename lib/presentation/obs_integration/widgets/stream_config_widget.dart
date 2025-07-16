import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StreamConfigWidget extends StatefulWidget {
  const StreamConfigWidget({super.key});

  @override
  State<StreamConfigWidget> createState() => _StreamConfigWidgetState();
}

class _StreamConfigWidgetState extends State<StreamConfigWidget> {
  bool _resolutionMatching = true;
  bool _frameRateSync = true;
  bool _audioHandling = false;
  String _selectedResolution = '1920x1080';
  int _selectedFrameRate = 30;

  final List<String> _resolutions = [
    '1920x1080',
    '1280x720',
    '854x480',
    '640x360',
  ];

  final List<int> _frameRates = [24, 30, 60, 120, 144];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resolution Configuration
          _buildConfigSection(
            'Resolution Configuration',
            'video_settings',
            [
              _buildSwitchTile(
                'Resolution Matching',
                'Automatically match OBS source resolution',
                _resolutionMatching,
                (value) => setState(() => _resolutionMatching = value),
              ),
              if (!_resolutionMatching) ...[
                SizedBox(height: 2.h),
                _buildDropdownTile(
                  'Target Resolution',
                  _selectedResolution,
                  _resolutions,
                  (value) => setState(() => _selectedResolution = value!),
                ),
              ],
            ],
          ),

          SizedBox(height: 3.h),

          // Frame Rate Configuration
          _buildConfigSection(
            'Frame Rate Configuration',
            'speed',
            [
              _buildSwitchTile(
                'Frame Rate Synchronization',
                'Sync with OBS source frame rate',
                _frameRateSync,
                (value) => setState(() => _frameRateSync = value),
              ),
              if (!_frameRateSync) ...[
                SizedBox(height: 2.h),
                _buildFrameRateSelector(),
              ],
            ],
          ),

          SizedBox(height: 3.h),

          // Audio Configuration
          _buildConfigSection(
            'Audio Configuration',
            'volume_up',
            [
              _buildSwitchTile(
                'Audio Handling',
                'Include audio from OBS source',
                _audioHandling,
                (value) => setState(() => _audioHandling = value),
              ),
              if (_audioHandling) ...[
                SizedBox(height: 2.h),
                _buildSliderTile(
                  'Audio Volume',
                  0.8,
                  (value) {},
                ),
              ],
            ],
          ),

          SizedBox(height: 3.h),

          // Stream Quality
          _buildConfigSection(
            'Stream Quality',
            'high_quality',
            [
              _buildQualityPresets(),
            ],
          ),

          SizedBox(height: 3.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyConfiguration,
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
              child: const Text('Apply Configuration'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigSection(
      String title, String iconName, List<Widget> children) {
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
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownTile(String title, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrameRateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Frame Rate',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _frameRates.map((fps) {
            final isSelected = fps == _selectedFrameRate;
            return FilterChip(
              label: Text('${fps} FPS'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFrameRate = fps);
                }
              },
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSliderTile(
      String title, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Text(
              '${(value * 100).round()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0.0,
          max: 1.0,
          divisions: 10,
        ),
      ],
    );
  }

  Widget _buildQualityPresets() {
    final presets = [
      {'name': 'High Quality', 'description': '1080p, 60fps, High bitrate'},
      {'name': 'Balanced', 'description': '720p, 30fps, Medium bitrate'},
      {'name': 'Performance', 'description': '480p, 30fps, Low bitrate'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quality Presets',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        ...presets
            .map((preset) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: preset['name']!,
                      groupValue: 'Balanced',
                      onChanged: (value) {},
                    ),
                    title: Text(
                      preset['name']!,
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      preset['description']!,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  void _applyConfiguration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stream configuration applied successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
