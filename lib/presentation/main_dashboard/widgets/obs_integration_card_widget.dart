import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ObsIntegrationCardWidget extends StatefulWidget {
  final VoidCallback onToggle;

  const ObsIntegrationCardWidget({
    super.key,
    required this.onToggle,
  });

  @override
  State<ObsIntegrationCardWidget> createState() =>
      _ObsIntegrationCardWidgetState();
}

class _ObsIntegrationCardWidgetState extends State<ObsIntegrationCardWidget> {
  bool _isConnected = false;
  bool _isConnecting = false;
  String _connectionStatus = "Disconnected";
  String _obsVersion = "OBS Studio 29.1.3";
  String _serverAddress = "localhost:4444";

  final List<Map<String, dynamic>> _obsScenes = [
    {
      "name": "Main Scene",
      "isActive": true,
      "sources": 3,
    },
    {
      "name": "Camera Only",
      "isActive": false,
      "sources": 1,
    },
    {
      "name": "Screen Share",
      "isActive": false,
      "sources": 2,
    },
  ];

  void _toggleConnection() {
    if (_isConnected) {
      _disconnect();
    } else {
      _connect();
    }
  }

  void _connect() {
    setState(() {
      _isConnecting = true;
      _connectionStatus = "Connecting...";
    });

    // Simulate connection process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
          _isConnecting = false;
          _connectionStatus = "Connected to $_obsVersion";
        });
      }
    });
  }

  void _disconnect() {
    setState(() {
      _isConnected = false;
      _isConnecting = false;
      _connectionStatus = "Disconnected";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      iconName: 'cast',
                      color: _isConnected
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      "OBS Integration",
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ],
                ),
                Switch(
                  value: _isConnected,
                  onChanged: _isConnecting
                      ? null
                      : (bool value) {
                          _toggleConnection();
                        },
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Connection Status
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _isConnected
                    ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                    : _isConnecting
                        ? AppTheme.getWarningColor(true).withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isConnected
                      ? AppTheme.getSuccessColor(true)
                      : _isConnecting
                          ? AppTheme.getWarningColor(true)
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  if (_isConnecting)
                    SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.getWarningColor(true),
                        ),
                      ),
                    )
                  else
                    CustomIconWidget(
                      iconName: _isConnected ? 'check_circle' : 'error',
                      color: _isConnected
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 16,
                    ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _connectionStatus,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _isConnected
                            ? AppTheme.getSuccessColor(true)
                            : _isConnecting
                                ? AppTheme.getWarningColor(true)
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Connection Details
            if (_isConnected) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem("Server", _serverAddress),
                  _buildInfoItem("Status", "Active"),
                ],
              ),

              SizedBox(height: 3.h),

              // OBS Scenes
              Text(
                "Available Scenes",
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),

              ...(_obsScenes.map((scene) => _buildSceneItem(scene)).toList()),

              SizedBox(height: 2.h),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: 'refresh',
                      label: 'Refresh Scenes',
                      onTap: () {
                        // Refresh scenes
                      },
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildActionButton(
                      icon: 'settings',
                      label: 'OBS Settings',
                      onTap: widget.onToggle,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Connection Setup
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Connection Setup",
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    initialValue: _serverAddress,
                    decoration: const InputDecoration(
                      labelText: "Server Address",
                      hintText: "localhost:4444",
                    ),
                    onChanged: (value) {
                      _serverAddress = value;
                    },
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Password (Optional)",
                      hintText: "Enter OBS WebSocket password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isConnecting ? null : _connect,
                          icon: CustomIconWidget(
                            iconName: 'link',
                            color: Colors.white,
                            size: 16,
                          ),
                          label: Text(_isConnecting
                              ? 'Connecting...'
                              : 'Connect to OBS'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],

            SizedBox(height: 2.h),

            // Help Link
            TextButton.icon(
              onPressed: () {
                _showObsHelp();
              },
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text(
                "OBS Setup Guide",
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSceneItem(Map<String, dynamic> scene) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: scene["isActive"]
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scene["isActive"]
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: scene["isActive"]
                ? 'radio_button_checked'
                : 'radio_button_unchecked',
            color: scene["isActive"]
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scene["name"],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        scene["isActive"] ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                Text(
                  "${scene["sources"]} sources",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!scene["isActive"])
            GestureDetector(
              onTap: () {
                setState(() {
                  for (var s in _obsScenes) {
                    s["isActive"] = false;
                  }
                  scene["isActive"] = true;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Switch",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showObsHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("OBS Setup Guide"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("To connect CamVirtualizer with OBS Studio:"),
              SizedBox(height: 2.h),
              const Text("1. Install OBS WebSocket plugin"),
              const Text("2. Enable WebSocket server in OBS"),
              const Text(
                  "3. Configure server address (default: localhost:4444)"),
              const Text("4. Set password if required"),
              const Text("5. Click Connect in CamVirtualizer"),
              SizedBox(height: 2.h),
              const Text(
                "Note: This is for educational purposes only. Ensure you have proper permissions before using virtual camera features.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }
}
