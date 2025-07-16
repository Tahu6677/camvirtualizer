import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraPreviewWidget extends StatefulWidget {
  final double zoomLevel;
  final String currentFilter;
  final Function(double) onZoomChanged;
  final VoidCallback onDoubleTap;
  final Function(double) onHorizontalSwipe;

  const CameraPreviewWidget({
    Key? key,
    required this.zoomLevel,
    required this.currentFilter,
    required this.onZoomChanged,
    required this.onDoubleTap,
    required this.onHorizontalSwipe,
  }) : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  double _baseZoom = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseZoom = widget.zoomLevel;
      },
      onScaleUpdate: (details) {
        final newZoom = (_baseZoom * details.scale).clamp(1.0, 5.0);
        widget.onZoomChanged(newZoom);
      },
      onDoubleTap: widget.onDoubleTap,
      onPanUpdate: (details) {
        if (details.delta.dx.abs() > details.delta.dy.abs()) {
          widget.onHorizontalSwipe(details.delta.dx);
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.grey[800]!,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Simulated camera feed
            Center(
              child: Transform.scale(
                scale: widget.zoomLevel,
                child: Container(
                  width: 90.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.w),
                    child: CustomImageWidget(
                      imageUrl:
                          'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=1920',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Filter overlay
            if (widget.currentFilter != 'None')
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: _getFilterColor(widget.currentFilter),
                ),
              ),

            // Zoom indicator
            if (widget.zoomLevel > 1.0)
              Positioned(
                top: 15.h,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    '${widget.zoomLevel.toStringAsFixed(1)}x',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Filter indicator
            if (widget.currentFilter != 'None')
              Positioned(
                top: 15.h,
                left: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'photo_filter',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        widget.currentFilter,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Grid overlay for composition
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),

            // Gesture hints
            Positioned(
              bottom: 25.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    'Pinch to zoom • Double tap to reset • Swipe for filters',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getFilterColor(String filter) {
    switch (filter) {
      case 'Blur':
        return Colors.blue.withValues(alpha: 0.1);
      case 'Vintage':
        return Colors.orange.withValues(alpha: 0.2);
      case 'Grayscale':
        return Colors.grey.withValues(alpha: 0.3);
      case 'Sepia':
        return Colors.brown.withValues(alpha: 0.2);
      default:
        return null;
    }
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    // Draw rule of thirds grid
    final horizontalSpacing = size.height / 3;
    final verticalSpacing = size.width / 3;

    // Horizontal lines
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, horizontalSpacing * i),
        Offset(size.width, horizontalSpacing * i),
        paint,
      );
    }

    // Vertical lines
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(verticalSpacing * i, 0),
        Offset(verticalSpacing * i, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
