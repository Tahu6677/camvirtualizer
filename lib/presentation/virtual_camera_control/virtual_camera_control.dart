import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/advanced_controls_panel.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/control_panel_widget.dart';
import './widgets/media_injection_drawer.dart';
import './widgets/status_bar_widget.dart';

class VirtualCameraControl extends StatefulWidget {
  const VirtualCameraControl({Key? key}) : super(key: key);

  @override
  State<VirtualCameraControl> createState() => _VirtualCameraControlState();
}

class _VirtualCameraControlState extends State<VirtualCameraControl>
    with TickerProviderStateMixin {
  late AnimationController _drawerController;
  late AnimationController _panelController;
  late Animation<double> _drawerAnimation;
  late Animation<double> _panelAnimation;

  bool _isStreaming = false;
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _showAdvancedControls = false;
  bool _showMediaDrawer = false;
  double _zoomLevel = 1.0;
  String _currentFilter = 'None';
  String _streamQuality = 'HD 1080p';
  int _frameRate = 30;

  final List<Map<String, dynamic>> _availableFilters = [
    {'name': 'None', 'icon': 'filter_none'},
    {'name': 'Blur', 'icon': 'blur_on'},
    {'name': 'Vintage', 'icon': 'photo_filter'},
    {'name': 'Grayscale', 'icon': 'monochrome_photos'},
    {'name': 'Sepia', 'icon': 'palette'},
  ];

  final List<Map<String, dynamic>> _mediaLibrary = [
    {
      'id': 1,
      'type': 'image',
      'name': 'Virtual Background 1',
      'thumbnail':
          'https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&w=400',
      'url':
          'https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&w=1920',
    },
    {
      'id': 2,
      'type': 'image',
      'name': 'Office Background',
      'thumbnail':
          'https://images.pixabay.com/photo/2016/11/19/15/32/laptop-1840018_960_720.jpg',
      'url':
          'https://images.pixabay.com/photo/2016/11/19/15/32/laptop-1840018_1280.jpg',
    },
    {
      'id': 3,
      'type': 'video',
      'name': 'Nature Loop',
      'thumbnail':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80',
      'url':
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    },
    {
      'id': 4,
      'type': 'image',
      'name': 'Tech Setup',
      'thumbnail':
          'https://images.pexels.com/photos/2047905/pexels-photo-2047905.jpeg?auto=compress&cs=tinysrgb&w=400',
      'url':
          'https://images.pexels.com/photos/2047905/pexels-photo-2047905.jpeg?auto=compress&cs=tinysrgb&w=1920',
    },
  ];

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _panelController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _drawerAnimation = CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeInOut,
    );
    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  void _toggleStream() {
    setState(() {
      _isStreaming = !_isStreaming;
      if (_isStreaming) {
        _showProcessingOverlay();
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    HapticFeedback.lightImpact();
  }

  void _showProcessingOverlay() {
    setState(() {
      _isProcessing = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _toggleMediaDrawer() {
    setState(() {
      _showMediaDrawer = !_showMediaDrawer;
    });
    if (_showMediaDrawer) {
      _drawerController.forward();
    } else {
      _drawerController.reverse();
    }
  }

  void _toggleAdvancedControls() {
    setState(() {
      _showAdvancedControls = !_showAdvancedControls;
    });
    if (_showAdvancedControls) {
      _panelController.forward();
    } else {
      _panelController.reverse();
    }
  }

  void _injectMedia(Map<String, dynamic> media) {
    _showProcessingOverlay();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Injecting ${media['name']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
    _toggleMediaDrawer();
  }

  void _switchFilter(String filter) {
    setState(() {
      _currentFilter = filter;
    });
    _showProcessingOverlay();
  }

  void _onZoomChanged(double zoom) {
    setState(() {
      _zoomLevel = zoom;
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
    });
    HapticFeedback.selectionClick();
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Configuration?'),
          content: const Text(
              'Do you want to save your current camera settings before exiting?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Save configuration logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configuration saved')),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save & Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Main camera preview
            CameraPreviewWidget(
              zoomLevel: _zoomLevel,
              currentFilter: _currentFilter,
              onZoomChanged: _onZoomChanged,
              onDoubleTap: _resetZoom,
              onHorizontalSwipe: (direction) {
                final currentIndex = _availableFilters.indexWhere(
                  (filter) => filter['name'] == _currentFilter,
                );
                if (direction > 0 &&
                    currentIndex < _availableFilters.length - 1) {
                  _switchFilter(_availableFilters[currentIndex + 1]['name']);
                } else if (direction < 0 && currentIndex > 0) {
                  _switchFilter(_availableFilters[currentIndex - 1]['name']);
                }
              },
            ),

            // Status bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StatusBarWidget(
                isRecording: _isRecording,
                isStreaming: _isStreaming,
                streamQuality: _streamQuality,
                frameRate: _frameRate,
                onBackPressed: _showExitDialog,
              ),
            ),

            // Bottom control panel
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ControlPanelWidget(
                isStreaming: _isStreaming,
                isRecording: _isRecording,
                currentFilter: _currentFilter,
                onToggleStream: _toggleStream,
                onToggleRecording: _toggleRecording,
                onMediaInject: _toggleMediaDrawer,
                onSettings: () => Navigator.pushNamed(context, '/settings'),
                onAdvancedControls: _toggleAdvancedControls,
              ),
            ),

            // Advanced controls side panel
            AnimatedBuilder(
              animation: _panelAnimation,
              builder: (context, child) {
                return Positioned(
                  right: -80.w + (80.w * _panelAnimation.value),
                  top: 20.h,
                  bottom: 20.h,
                  child: AdvancedControlsPanel(
                    onClose: _toggleAdvancedControls,
                    onExposureChanged: (value) {
                      // Handle exposure change
                    },
                    onWhiteBalanceChanged: (value) {
                      // Handle white balance change
                    },
                    onFrameRateChanged: (value) {
                      setState(() {
                        _frameRate = value.round();
                      });
                    },
                  ),
                );
              },
            ),

            // Media injection drawer
            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: -60.h + (60.h * _drawerAnimation.value),
                  left: 0,
                  right: 0,
                  child: MediaInjectionDrawer(
                    mediaLibrary: _mediaLibrary,
                    onMediaSelected: _injectMedia,
                    onClose: _toggleMediaDrawer,
                  ),
                );
              },
            ),

            // Processing overlay
            if (_isProcessing)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Processing...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
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
