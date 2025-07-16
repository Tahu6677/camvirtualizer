import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/connection_status_widget.dart';
import './widgets/obs_source_card_widget.dart';
import './widgets/preview_window_widget.dart';
import './widgets/stream_config_widget.dart';

class ObsIntegration extends StatefulWidget {
  const ObsIntegration({super.key});

  @override
  State<ObsIntegration> createState() => _ObsIntegrationState();
}

class _ObsIntegrationState extends State<ObsIntegration>
    with TickerProviderStateMixin {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isConnecting = false;
  bool _isConnected = false;
  bool _connectionFailed = false;
  String _selectedSourceId = '';
  bool _showAdvancedSettings = false;
  bool _educationalMode = false;

  late TabController _tabController;

  // Mock OBS sources data
  final List<Map<String, dynamic>> _obsSources = [
    {
      "id": "source_1",
      "name": "Desktop Capture",
      "type": "display_capture",
      "thumbnail":
          "https://images.pexels.com/photos/1714208/pexels-photo-1714208.jpeg?auto=compress&cs=tinysrgb&w=400",
      "active": false,
      "resolution": "1920x1080",
      "fps": 60,
    },
    {
      "id": "source_2",
      "name": "Webcam Feed",
      "type": "video_capture",
      "thumbnail":
          "https://images.pixabay.com/photo-2016/11/29/06/15/plans-1867745_640.jpg",
      "active": true,
      "resolution": "1280x720",
      "fps": 30,
    },
    {
      "id": "source_3",
      "name": "Game Capture",
      "type": "game_capture",
      "thumbnail":
          "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=400&q=60",
      "active": false,
      "resolution": "1920x1080",
      "fps": 144,
    },
    {
      "id": "source_4",
      "name": "Browser Source",
      "type": "browser_source",
      "thumbnail":
          "https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?auto=compress&cs=tinysrgb&w=400",
      "active": false,
      "resolution": "1920x1080",
      "fps": 30,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _ipController.text = "192.168.1.100";
    _portController.text = "4444";
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _connectToOBS() async {
    if (_ipController.text.isEmpty || _portController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in IP address and port')),
      );
      return;
    }

    setState(() {
      _isConnecting = true;
      _connectionFailed = false;
    });

    // Simulate connection attempt
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isConnecting = false;
      // Mock connection success/failure
      if (_ipController.text == "192.168.1.100" &&
          _portController.text == "4444") {
        _isConnected = true;
        _connectionFailed = false;
      } else {
        _isConnected = false;
        _connectionFailed = true;
      }
    });

    if (_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully connected to OBS!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to connect to OBS. Check your settings.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectSource(String sourceId) {
    setState(() {
      _selectedSourceId = sourceId;
      // Update active status
      for (var source in _obsSources) {
        source["active"] = source["id"] == sourceId;
      }
    });
  }

  void _toggleEducationalMode() {
    setState(() {
      _educationalMode = !_educationalMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'OBS Integration',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleEducationalMode,
            icon: CustomIconWidget(
              iconName: _educationalMode ? 'school' : 'help_outline',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Connection Status Header
            ConnectionStatusWidget(
              isConnected: _isConnected,
              isConnecting: _isConnecting,
              connectionFailed: _connectionFailed,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Educational Mode Banner
                    _educationalMode
                        ? _buildEducationalBanner()
                        : const SizedBox.shrink(),

                    SizedBox(height: 2.h),

                    // Connection Setup Card
                    _buildConnectionSetupCard(),

                    SizedBox(height: 3.h),

                    // Tab Navigation
                    _isConnected
                        ? _buildTabNavigation()
                        : const SizedBox.shrink(),

                    SizedBox(height: 2.h),

                    // Tab Content
                    _isConnected
                        ? _buildTabContent()
                        : _buildTroubleshootingTips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'school',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Educational Mode Active',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Step-by-step guidance for academic demonstrations',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionSetupCard() {
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
                CustomImageWidget(
                  imageUrl:
                      "https://images.pexels.com/photos/4348401/pexels-photo-4348401.jpeg?auto=compress&cs=tinysrgb&w=60&h=60&fit=crop",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OBS Studio Connection',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      Text(
                        'Connect to external streaming source',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // IP Address Input
            TextFormField(
              controller: _ipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'IP Address',
                hintText: '192.168.1.100',
                prefixIcon: Icon(Icons.computer),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),

            SizedBox(height: 2.h),

            // Port Input
            TextFormField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '4444',
                prefixIcon: Icon(Icons.settings_ethernet),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),

            SizedBox(height: 2.h),

            // Password Input
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password (Optional)',
                hintText: 'Enter OBS WebSocket password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            SizedBox(height: 3.h),

            // Connect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isConnecting ? null : _connectToOBS,
                style: AppTheme.lightTheme.elevatedButtonTheme.style,
                child: _isConnecting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          const Text('Connecting...'),
                        ],
                      )
                    : Text(_isConnected ? 'Connected' : 'Connect to OBS'),
              ),
            ),

            // Advanced Settings
            SizedBox(height: 2.h),

            TextButton(
              onPressed: () {
                setState(() {
                  _showAdvancedSettings = !_showAdvancedSettings;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Advanced Settings'),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName:
                        _showAdvancedSettings ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),

            _showAdvancedSettings
                ? _buildAdvancedSettings()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Network Configuration',
            style: AppTheme.lightTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '5000',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Timeout (ms)',
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  initialValue: '3',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Retry Attempts',
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: '1024',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Buffer Size (KB)',
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Sources'),
          Tab(text: 'Stream Config'),
          Tab(text: 'Preview'),
        ],
        labelColor: AppTheme.lightTheme.tabBarTheme.labelColor,
        unselectedLabelColor:
            AppTheme.lightTheme.tabBarTheme.unselectedLabelColor,
        indicatorColor: AppTheme.lightTheme.tabBarTheme.indicatorColor,
        labelStyle: AppTheme.lightTheme.tabBarTheme.labelStyle,
        unselectedLabelStyle:
            AppTheme.lightTheme.tabBarTheme.unselectedLabelStyle,
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 50.h,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildSourcesList(),
          StreamConfigWidget(),
          PreviewWindowWidget(
            selectedSourceId: _selectedSourceId,
            sources: _obsSources,
          ),
        ],
      ),
    );
  }

  Widget _buildSourcesList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: _obsSources.length,
      itemBuilder: (context, index) {
        final source = _obsSources[index];
        return ObsSourceCardWidget(
          source: source,
          isSelected: source["id"] == _selectedSourceId,
          onTap: () => _selectSource(source["id"]),
          onSwipeRight: () => _activateSource(source["id"]),
          onSwipeLeft: () => _showSourceSettings(source),
        );
      },
    );
  }

  void _activateSource(String sourceId) {
    setState(() {
      _selectedSourceId = sourceId;
      for (var source in _obsSources) {
        source["active"] = source["id"] == sourceId;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Source activated: ${_obsSources.firstWhere((s) => s["id"] == sourceId)["name"]}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showSourceSettings(Map<String, dynamic> source) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Source Settings: ${source["name"]}',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'video_settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Resolution'),
              subtitle: Text(source["resolution"]),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 16,
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'speed',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Frame Rate'),
              subtitle: Text('${source["fps"]} FPS'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 16,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _selectSource(source["id"]);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingTips() {
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
                  iconName: 'help_outline',
                  color: AppTheme.warningLight,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Troubleshooting Tips',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.warningLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildTroubleshootingItem(
              'Check OBS WebSocket Plugin',
              'Ensure OBS WebSocket plugin is installed and enabled',
              'extension',
            ),
            _buildTroubleshootingItem(
              'Verify Network Connection',
              'Make sure both devices are on the same network',
              'wifi',
            ),
            _buildTroubleshootingItem(
              'Firewall Settings',
              'Check if firewall is blocking the connection',
              'security',
            ),
            _buildTroubleshootingItem(
              'Port Configuration',
              'Default WebSocket port is 4444, verify in OBS settings',
              'settings_ethernet',
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _connectToOBS,
                child: const Text('Retry Connection'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingItem(
      String title, String description, String iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 3.w),
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
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
