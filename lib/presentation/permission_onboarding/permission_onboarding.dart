import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/educational_disclaimer_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/permission_progress_widget.dart';

class PermissionOnboarding extends StatefulWidget {
  const PermissionOnboarding({Key? key}) : super(key: key);

  @override
  State<PermissionOnboarding> createState() => _PermissionOnboardingState();
}

class _PermissionOnboardingState extends State<PermissionOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _permissions = [
    {
      "id": "camera",
      "title": "Camera Access",
      "description":
          "Required for virtual stream creation and camera feed manipulation",
      "icon": "camera_alt",
      "isGranted": false,
      "isEssential": true,
      "whyNeeded":
          "Camera access allows CamVirtualizer to capture your device's camera feed and apply virtual modifications, enabling you to test media manipulation techniques and privacy scenarios in a controlled educational environment.",
      "expanded": false,
    },
    {
      "id": "storage",
      "title": "Storage Access",
      "description":
          "Needed for media file injection and pre-recorded content management",
      "icon": "folder",
      "isGranted": false,
      "isEssential": true,
      "whyNeeded":
          "Storage permissions enable the app to access your media files for injection into virtual camera streams, allowing you to replace live feeds with pre-recorded content for academic research and testing purposes.",
      "expanded": false,
    },
    {
      "id": "network",
      "title": "Network Permissions",
      "description":
          "Required for OBS integration and external streaming sources",
      "icon": "wifi",
      "isGranted": false,
      "isEssential": false,
      "whyNeeded":
          "Network access enables integration with OBS Studio and other streaming platforms, allowing you to test virtual camera functionality across different applications and streaming scenarios.",
      "expanded": false,
    },
  ];

  bool _isGrantingPermissions = false;
  bool _showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePermissionExpansion(String permissionId) {
    setState(() {
      final index = _permissions.indexWhere((p) => p["id"] == permissionId);
      if (index != -1) {
        _permissions[index]["expanded"] = !_permissions[index]["expanded"];
      }
    });
  }

  Future<void> _grantPermissions() async {
    setState(() {
      _isGrantingPermissions = true;
    });

    // Simulate permission granting process
    for (int i = 0; i < _permissions.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _permissions[i]["isGranted"] = true;
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _showSuccessAnimation = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    }
  }

  void _showPrivacyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Privacy Policy & Data Handling",
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Educational Use Only",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.getSuccessColor(true),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "CamVirtualizer is designed exclusively for academic research and educational purposes. All data processing occurs locally on your device.",
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Data Collection",
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "• No personal data is transmitted to external servers\n• Camera feeds are processed locally for virtualization\n• Media files remain on your device\n• No usage analytics or tracking",
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Permission Usage",
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "• Camera: Virtual stream creation only\n• Storage: Media file access for injection\n• Network: OBS integration (optional)",
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Understood"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit CamVirtualizer?"),
            content: const Text(
                "Permissions are required to use the app. Are you sure you want to exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Exit"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _showSuccessAnimation
                      ? _buildSuccessView()
                      : _buildMainContent(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.getSuccessColor(true),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'check',
              color: Colors.white,
              size: 10.w,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Permissions Granted!",
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.getSuccessColor(true),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Welcome to CamVirtualizer",
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  "Required Permissions",
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  "CamVirtualizer needs these permissions to demonstrate media virtualization techniques for educational purposes.",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 3.h),
                ..._permissions.map((permission) => Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: PermissionCardWidget(
                        permission: permission,
                        onToggleExpansion: _togglePermissionExpansion,
                      ),
                    )),
                SizedBox(height: 2.h),
                PermissionProgressWidget(permissions: _permissions),
                SizedBox(height: 3.h),
                EducationalDisclaimerWidget(),
                SizedBox(height: 4.h),
                _buildActionButtons(),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'videocam',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CamVirtualizer",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    "Educational Use Only",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.getSuccessColor(true),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isGrantingPermissions ? null : _grantPermissions,
            child: _isGrantingPermissions
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      const Text("Granting Permissions..."),
                    ],
                  )
                : const Text("Grant Permissions"),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton(
            onPressed: _showPrivacyBottomSheet,
            child: const Text("Learn More"),
          ),
        ),
      ],
    );
  }
}
