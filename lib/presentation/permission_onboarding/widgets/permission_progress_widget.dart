import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionProgressWidget extends StatelessWidget {
  final List<Map<String, dynamic>> permissions;

  const PermissionProgressWidget({
    Key? key,
    required this.permissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int grantedCount =
        permissions.where((p) => p["isGranted"] == true).length;
    final int totalCount = permissions.length;
    final double progress = totalCount > 0 ? grantedCount / totalCount : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Permission Status",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$grantedCount / $totalCount",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: grantedCount == totalCount
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(0.5.h),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: grantedCount == totalCount
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: permissions.map((permission) {
              final bool isGranted = permission["isGranted"] ?? false;
              final bool isEssential = permission["isEssential"] ?? false;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: isGranted
                              ? AppTheme.getSuccessColor(true)
                              : (isEssential
                                  ? AppTheme.getWarningColor(true)
                                      .withValues(alpha: 0.3)
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3)),
                          shape: BoxShape.circle,
                        ),
                        child: isGranted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 2.5.w,
                              )
                            : null,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          permission["title"] ?? "",
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isGranted
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isGranted ? FontWeight.w600 : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (grantedCount == totalCount) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.getSuccessColor(true),
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      "All permissions granted! Ready to proceed.",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.getSuccessColor(true),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
