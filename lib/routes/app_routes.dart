import 'package:flutter/material.dart';
import '../presentation/permission_onboarding/permission_onboarding.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/virtual_camera_control/virtual_camera_control.dart';
import '../presentation/media_library/media_library.dart';
import '../presentation/obs_integration/obs_integration.dart';
import '../presentation/settings/settings.dart';

class AppRoutes {
  static const String initial = '/permission-onboarding';
  static const String permissionOnboarding = '/permission-onboarding';
  static const String mainDashboard = '/main-dashboard';
  static const String virtualCameraControl = '/virtual-camera-control';
  static const String mediaLibrary = '/media-library';
  static const String obsIntegration = '/obs-integration';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    permissionOnboarding: (context) => const PermissionOnboarding(),
    mainDashboard: (context) => const MainDashboard(),
    virtualCameraControl: (context) => const VirtualCameraControl(),
    mediaLibrary: (context) => const MediaLibrary(),
    obsIntegration: (context) => const ObsIntegration(),
    settings: (context) => const Settings(),
  };
}
