import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/active_stream_card_widget.dart';
import './widgets/learning_modules_card_widget.dart';
import './widgets/media_injection_card_widget.dart';
import './widgets/obs_integration_card_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isVirtualCameraActive = false;
  bool _isRefreshing = false;
  String _currentStatus = "Virtual Camera Inactive";

  final List<Map<String, dynamic>> _tabData = [
    {"title": "Dashboard", "icon": "dashboard"},
    {"title": "Media Library", "icon": "video_library"},
    {"title": "Settings", "icon": "settings"},
    {"title": "Help", "icon": "help_outline"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabData.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      Navigator.pushNamed(context, '/media-library');
    } else if (_tabController.index == 2) {
      Navigator.pushNamed(context, '/settings');
    } else if (_tabController.index == 3) {
      _showHelpBottomSheet();
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _currentStatus = _isVirtualCameraActive
          ? "Virtual Camera Active - 1080p @ 30fps"
          : "Virtual Camera Inactive";
    });
  }

  void _toggleVirtualCamera() {
    setState(() {
      _isVirtualCameraActive = !_isVirtualCameraActive;
      _currentStatus = _isVirtualCameraActive
          ? "Virtual Camera Active - 1080p @ 30fps"
          : "Virtual Camera Inactive";
    });

    if (_isVirtualCameraActive) {
      Navigator.pushNamed(context, '/virtual-camera-control');
    }
  }

  void _showStreamSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStreamSourceBottomSheet(),
    );
  }

  void _showHelpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHelpBottomSheet(),
    );
  }

  Widget _buildStreamSourceBottomSheet() {
    final List<Map<String, dynamic>> streamSources = [
      {
        "name": "Default Camera",
        "thumbnail":
            "https://images.pexels.com/photos/442576/pexels-photo-442576.jpeg?auto=compress&cs=tinysrgb&w=300",
        "status": "Available",
        "resolution": "1080p"
      },
      {
        "name": "Pre-recorded Video 1",
        "thumbnail":
            "https://images.pixabay.com/photo-2016/02/13/13/11/oldtimer-1197800_960_720.jpg?auto=compress&cs=tinysrgb&w=300",
        "status": "Ready",
        "resolution": "720p"
      },
      {
        "name": "OBS Virtual Camera",
        "thumbnail":
            "https://images.unsplash.com/photo-1611532736597-de2d4265fba3?auto=compress&cs=tinysrgb&w=300",
        "status": "Connected",
        "resolution": "1080p"
      },
    ];

    return Container(
      height: 60.h,
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
              "Select Stream Source",
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: streamSources.length,
              itemBuilder: (context, index) {
                final source = streamSources[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: source["thumbnail"],
                        width: 15.w,
                        height: 8.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      source["name"],
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      "${source["status"]} • ${source["resolution"]}",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'check_circle',
                      color: source["status"] == "Connected"
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 24,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentStatus = "Switching to ${source["name"]}...";
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _currentStatus =
                              "Active - ${source["name"]} (${source["resolution"]})";
                        });
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpBottomSheet() {
    final List<Map<String, dynamic>> helpTopics = [
      {
        "title": "Getting Started",
        "description": "Learn the basics of virtual camera setup",
        "icon": "play_circle_outline"
      },
      {
        "title": "Media Injection Guide",
        "description": "How to inject images and videos into camera stream",
        "icon": "video_call"
      },
      {
        "title": "OBS Integration",
        "description": "Connect with OBS for advanced streaming",
        "icon": "cast"
      },
      {
        "title": "Privacy & Security",
        "description": "Understanding privacy implications and security",
        "icon": "security"
      },
      {
        "title": "Troubleshooting",
        "description": "Common issues and solutions",
        "icon": "build"
      },
    ];

    return Container(
      height: 70.h,
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
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'help_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Help & Documentation",
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: helpTopics.length,
              itemBuilder: (context, index) {
                final topic = helpTopics[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: ListTile(
                    leading: CustomIconWidget(
                      iconName: topic["icon"],
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      topic["title"],
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      topic["description"],
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.outline,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to specific help topic
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with status indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CamVirtualizer",
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Educational Media Virtualization",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: _isVirtualCameraActive
                              ? AppTheme.getSuccessColor(true)
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isVirtualCameraActive
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                color: _isVirtualCameraActive
                                    ? AppTheme.getSuccessColor(true)
                                    : AppTheme.lightTheme.colorScheme.outline,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _isVirtualCameraActive ? "ACTIVE" : "INACTIVE",
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _isVirtualCameraActive
                                    ? AppTheme.getSuccessColor(true)
                                    : AppTheme.lightTheme.colorScheme.outline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentStatus,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: _tabData
                    .map((tab) => Tab(
                          icon: CustomIconWidget(
                            iconName: tab["icon"],
                            size: 20,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          text: tab["title"],
                        ))
                    .toList(),
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.colorScheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      // Active Stream Card
                      ActiveStreamCardWidget(
                        isActive: _isVirtualCameraActive,
                        onToggle: _toggleVirtualCamera,
                        onSourceSwitch: _showStreamSourceBottomSheet,
                      ),

                      SizedBox(height: 3.h),

                      // Media Injection Card
                      MediaInjectionCardWidget(
                        onImageInjection: () {
                          Navigator.pushNamed(context, '/media-library');
                        },
                        onVideoInjection: () {
                          Navigator.pushNamed(context, '/media-library');
                        },
                      ),

                      SizedBox(height: 3.h),

                      // OBS Integration Card
                      ObsIntegrationCardWidget(
                        onToggle: () {
                          Navigator.pushNamed(context, '/obs-integration');
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Learning Modules Card
                      LearningModulesCardWidget(
                        onModuleSelect: (String moduleId) {
                          // Handle module selection
                        },
                      ),

                      SizedBox(height: 10.h), // Extra space for FAB
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleVirtualCamera,
        backgroundColor: _isVirtualCameraActive
            ? AppTheme.getWarningColor(true)
            : AppTheme.lightTheme.colorScheme.secondary,
        child: CustomIconWidget(
          iconName: _isVirtualCameraActive ? 'stop' : 'videocam',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
