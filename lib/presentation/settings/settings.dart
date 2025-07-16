import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/settings_group_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Settings state variables
  bool _highResolution = true;
  double _frameRate = 30.0;
  String _codecPreference = 'H.264';
  double _qualityLevel = 0.8;
  bool _compressionEnabled = true;
  bool _dataSharingEnabled = false;
  bool _academicComplianceEnabled = true;
  bool _progressTrackingEnabled = true;
  bool _debugLoggingEnabled = false;
  bool _performanceMetricsEnabled = false;
  bool _voiceControlEnabled = false;
  bool _reducedMotionEnabled = false;
  double _textSizeMultiplier = 1.0;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Dr. Sarah Chen",
    "institution": "MIT Computer Science",
    "role": "Research Professor",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "usageStats": {
      "totalSessions": 47,
      "hoursUsed": 23.5,
      "modulesCompleted": 12,
      "certificatesEarned": 3
    }
  };

  final List<String> _codecOptions = ['H.264', 'H.265', 'VP9', 'AV1'];
  final List<String> _resolutionOptions = ['720p', '1080p', '4K'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showResetDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title completed successfully')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showCodecSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Codec',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ..._codecOptions
                  .map((codec) => ListTile(
                        title: Text(codec),
                        trailing: _codecPreference == codec
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _codecPreference = codec;
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _exportAcademicData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Academic Data'),
          content: const Text(
              'Your academic progress and usage data will be exported in CSV format for research documentation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Academic data exported successfully')),
                );
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getFilteredSettingsGroups() {
    final allGroups = [
      _buildCameraConfigurationGroup(),
      _buildMediaProcessingGroup(),
      _buildPrivacyControlsGroup(),
      _buildEducationalFeaturesGroup(),
      _buildAccessibilityGroup(),
      _buildAdvancedOptionsGroup(),
    ];

    if (_searchQuery.isEmpty) {
      return allGroups;
    }

    return allGroups.where((group) {
      // This is a simplified search - in a real app, you'd search within the group content
      return true; // For demo purposes, show all groups
    }).toList();
  }

  Widget _buildCameraConfigurationGroup() {
    return SettingsGroupWidget(
      title: 'Camera Configuration',
      icon: 'camera_alt',
      children: [
        SettingsItemWidget(
          title: 'High Resolution',
          subtitle: 'Enable 4K recording capability',
          trailing: Switch(
            value: _highResolution,
            onChanged: (value) {
              setState(() {
                _highResolution = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Frame Rate',
          subtitle: '${_frameRate.toInt()} FPS',
          trailing: SizedBox(
            width: 40.w,
            child: Slider(
              value: _frameRate,
              min: 15.0,
              max: 60.0,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _frameRate = value;
                });
              },
            ),
          ),
        ),
        SettingsItemWidget(
          title: 'Codec Preference',
          subtitle: _codecPreference,
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 16,
          ),
          onTap: _showCodecSelectionSheet,
        ),
      ],
    );
  }

  Widget _buildMediaProcessingGroup() {
    return SettingsGroupWidget(
      title: 'Media Processing',
      icon: 'video_settings',
      children: [
        SettingsItemWidget(
          title: 'Quality Level',
          subtitle: '${(_qualityLevel * 100).toInt()}% quality',
          trailing: SizedBox(
            width: 40.w,
            child: Slider(
              value: _qualityLevel,
              min: 0.1,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _qualityLevel = value;
                });
              },
            ),
          ),
        ),
        SettingsItemWidget(
          title: 'Compression',
          subtitle: 'Optimize file sizes',
          trailing: Switch(
            value: _compressionEnabled,
            onChanged: (value) {
              setState(() {
                _compressionEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          trailing: CustomIconWidget(
            iconName: 'delete_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 20,
          ),
          onTap: () => _showResetDialog(
            'Clear Cache',
            'This will remove all cached media files. This action cannot be undone.',
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyControlsGroup() {
    return SettingsGroupWidget(
      title: 'Privacy Controls',
      icon: 'security',
      children: [
        SettingsItemWidget(
          title: 'Data Sharing',
          subtitle: 'Share usage data for research',
          trailing: Switch(
            value: _dataSharingEnabled,
            onChanged: (value) {
              setState(() {
                _dataSharingEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Academic Compliance',
          subtitle: 'FERPA and institutional policies',
          trailing: Switch(
            value: _academicComplianceEnabled,
            onChanged: (value) {
              setState(() {
                _academicComplianceEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Data Retention',
          subtitle: 'Manage stored information',
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 16,
          ),
          onTap: () {
            // Navigate to data retention settings
          },
        ),
      ],
    );
  }

  Widget _buildEducationalFeaturesGroup() {
    return SettingsGroupWidget(
      title: 'Educational Features',
      icon: 'school',
      children: [
        SettingsItemWidget(
          title: 'Progress Tracking',
          subtitle: 'Monitor learning progress',
          trailing: Switch(
            value: _progressTrackingEnabled,
            onChanged: (value) {
              setState(() {
                _progressTrackingEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Export Academic Data',
          subtitle: 'Download progress reports',
          trailing: CustomIconWidget(
            iconName: 'download',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
          onTap: _exportAcademicData,
        ),
        SettingsItemWidget(
          title: 'Reset Progress',
          subtitle: 'Clear all educational data',
          trailing: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 20,
          ),
          onTap: () => _showResetDialog(
            'Reset Progress',
            'This will permanently delete all your educational progress and certificates. This action cannot be undone.',
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityGroup() {
    return SettingsGroupWidget(
      title: 'Accessibility',
      icon: 'accessibility',
      children: [
        SettingsItemWidget(
          title: 'Voice Control',
          subtitle: 'Enable voice commands',
          trailing: Switch(
            value: _voiceControlEnabled,
            onChanged: (value) {
              setState(() {
                _voiceControlEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Text Size',
          subtitle: '${(_textSizeMultiplier * 100).toInt()}%',
          trailing: SizedBox(
            width: 40.w,
            child: Slider(
              value: _textSizeMultiplier,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  _textSizeMultiplier = value;
                });
              },
            ),
          ),
        ),
        SettingsItemWidget(
          title: 'Reduced Motion',
          subtitle: 'Minimize animations',
          trailing: Switch(
            value: _reducedMotionEnabled,
            onChanged: (value) {
              setState(() {
                _reducedMotionEnabled = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedOptionsGroup() {
    return SettingsGroupWidget(
      title: 'Advanced Options',
      icon: 'settings',
      children: [
        SettingsItemWidget(
          title: 'Debug Logging',
          subtitle: 'Enable detailed logs',
          trailing: Switch(
            value: _debugLoggingEnabled,
            onChanged: (value) {
              setState(() {
                _debugLoggingEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Performance Metrics',
          subtitle: 'Show system performance',
          trailing: Switch(
            value: _performanceMetricsEnabled,
            onChanged: (value) {
              setState(() {
                _performanceMetricsEnabled = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Factory Reset',
          subtitle: 'Restore default settings',
          trailing: CustomIconWidget(
            iconName: 'restore',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 20,
          ),
          onTap: () => _showResetDialog(
            'Factory Reset',
            'This will restore all settings to their default values and clear all data. This action cannot be undone.',
            () {},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Settings',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      CustomIconWidget(
                        iconName: 'help_outline',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search settings...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                onTap: (index) {
                  final routes = [
                    '/permission-onboarding',
                    '/main-dashboard',
                    '/virtual-camera-control',
                    '/media-library',
                    '/obs-integration',
                    '/settings'
                  ];
                  if (index != 5) {
                    Navigator.pushNamed(context, routes[index]);
                  }
                },
                tabs: const [
                  Tab(text: 'Permissions'),
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Camera'),
                  Tab(text: 'Media'),
                  Tab(text: 'OBS'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Section
                    UserProfileWidget(userData: _userData),

                    SizedBox(height: 3.h),

                    // Settings Groups
                    ..._getFilteredSettingsGroups(),

                    SizedBox(height: 4.h),

                    // App Info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CamVirtualizer',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Version 1.0.0 (Build 2025.07.16)',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Educational proof-of-concept for media virtualization research',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // Show privacy policy
                                  },
                                  child: const Text('Privacy Policy'),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // Show terms of service
                                  },
                                  child: const Text('Terms of Service'),
                                ),
                              ),
                            ],
                          ),
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
}
