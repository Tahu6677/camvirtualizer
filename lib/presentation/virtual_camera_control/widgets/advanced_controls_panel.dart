import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedControlsPanel extends StatefulWidget {
  final VoidCallback onClose;
  final Function(double) onExposureChanged;
  final Function(double) onWhiteBalanceChanged;
  final Function(double) onFrameRateChanged;

  const AdvancedControlsPanel({
    Key? key,
    required this.onClose,
    required this.onExposureChanged,
    required this.onWhiteBalanceChanged,
    required this.onFrameRateChanged,
  }) : super(key: key);

  @override
  State<AdvancedControlsPanel> createState() => _AdvancedControlsPanelState();
}

class _AdvancedControlsPanelState extends State<AdvancedControlsPanel> {
  double _exposure = 0.0;
  double _whiteBalance = 5000.0;
  double _frameRate = 30.0;
  bool _autoExposure = true;
  bool _autoWhiteBalance = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(4.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Advanced Controls',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exposure controls
                    _buildControlSection(
                      title: 'Exposure',
                      icon: 'brightness_6',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Auto',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Switch(
                                value: _autoExposure,
                                onChanged: (value) {
                                  setState(() {
                                    _autoExposure = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (!_autoExposure) ...[
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'brightness_low',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _exposure,
                                    min: -2.0,
                                    max: 2.0,
                                    divisions: 40,
                                    onChanged: (value) {
                                      setState(() {
                                        _exposure = value;
                                      });
                                      widget.onExposureChanged(value);
                                    },
                                  ),
                                ),
                                CustomIconWidget(
                                  iconName: 'brightness_high',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ],
                            ),
                            Text(
                              _exposure.toStringAsFixed(1),
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // White balance controls
                    _buildControlSection(
                      title: 'White Balance',
                      icon: 'wb_sunny',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Auto',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Switch(
                                value: _autoWhiteBalance,
                                onChanged: (value) {
                                  setState(() {
                                    _autoWhiteBalance = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (!_autoWhiteBalance) ...[
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'wb_incandescent',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _whiteBalance,
                                    min: 2000.0,
                                    max: 8000.0,
                                    divisions: 60,
                                    onChanged: (value) {
                                      setState(() {
                                        _whiteBalance = value;
                                      });
                                      widget.onWhiteBalanceChanged(value);
                                    },
                                  ),
                                ),
                                CustomIconWidget(
                                  iconName: 'wb_sunny',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ],
                            ),
                            Text(
                              '${_whiteBalance.round()}K',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Frame rate controls
                    _buildControlSection(
                      title: 'Frame Rate',
                      icon: 'speed',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '15 FPS',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                              Expanded(
                                child: Slider(
                                  value: _frameRate,
                                  min: 15.0,
                                  max: 60.0,
                                  divisions: 9,
                                  onChanged: (value) {
                                    setState(() {
                                      _frameRate = value;
                                    });
                                    widget.onFrameRateChanged(value);
                                  },
                                ),
                              ),
                              Text(
                                '60 FPS',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Text(
                            '${_frameRate.round()} FPS',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Quick presets
                    _buildControlSection(
                      title: 'Quick Presets',
                      icon: 'tune',
                      child: Column(
                        children: [
                          _buildPresetButton('Indoor', () {
                            setState(() {
                              _whiteBalance = 3200.0;
                              _exposure = 0.2;
                              _frameRate = 30.0;
                            });
                          }),
                          SizedBox(height: 1.h),
                          _buildPresetButton('Outdoor', () {
                            setState(() {
                              _whiteBalance = 5600.0;
                              _exposure = -0.3;
                              _frameRate = 30.0;
                            });
                          }),
                          SizedBox(height: 1.h),
                          _buildPresetButton('Low Light', () {
                            setState(() {
                              _whiteBalance = 4000.0;
                              _exposure = 1.0;
                              _frameRate = 24.0;
                            });
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlSection({
    required String title,
    required String icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          child,
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
