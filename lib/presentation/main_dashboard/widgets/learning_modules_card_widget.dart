import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class LearningModulesCardWidget extends StatefulWidget {
  final Function(String) onModuleSelect;

  const LearningModulesCardWidget({
    super.key,
    required this.onModuleSelect,
  });

  @override
  State<LearningModulesCardWidget> createState() =>
      _LearningModulesCardWidgetState();
}

class _LearningModulesCardWidgetState extends State<LearningModulesCardWidget> {
  final List<Map<String, dynamic>> _learningModules = [
    {
      "id": "camera-basics",
      "title": "Camera API Fundamentals",
      "description":
          "Learn the basics of Android Camera2 API and virtual camera implementation",
      "duration": "15 min",
      "difficulty": "Beginner",
      "progress": 0.0,
      "icon": "camera_alt",
      "color": Colors.blue,
      "isCompleted": false,
      "topics": ["Camera2 API", "Permissions", "Preview Setup"]
    },
    {
      "id": "media-manipulation",
      "title": "Media Stream Manipulation",
      "description":
          "Understanding how to inject and manipulate media streams in real-time",
      "duration": "25 min",
      "difficulty": "Intermediate",
      "progress": 0.3,
      "icon": "video_settings",
      "color": Colors.orange,
      "isCompleted": false,
      "topics": ["Stream Processing", "Frame Manipulation", "Real-time Effects"]
    },
    {
      "id": "privacy-security",
      "title": "Privacy & Security Implications",
      "description":
          "Explore the privacy and security aspects of virtual camera technology",
      "duration": "20 min",
      "difficulty": "Advanced",
      "progress": 1.0,
      "icon": "security",
      "color": Colors.red,
      "isCompleted": true,
      "topics": ["Privacy Risks", "Security Testing", "Ethical Considerations"]
    },
    {
      "id": "obs-integration",
      "title": "OBS Studio Integration",
      "description":
          "Learn how to integrate with OBS Studio for advanced streaming capabilities",
      "duration": "30 min",
      "difficulty": "Intermediate",
      "progress": 0.0,
      "icon": "cast",
      "color": Colors.purple,
      "isCompleted": false,
      "topics": ["WebSocket API", "Scene Management", "Virtual Camera Setup"]
    },
  ];

  String _selectedDifficulty = "All";
  final List<String> _difficultyFilters = [
    "All",
    "Beginner",
    "Intermediate",
    "Advanced"
  ];

  List<Map<String, dynamic>> get _filteredModules {
    if (_selectedDifficulty == "All") {
      return _learningModules;
    }
    return _learningModules
        .where((module) => module["difficulty"] == _selectedDifficulty)
        .toList();
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
                      iconName: 'school',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      "Learning Modules",
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${_learningModules.where((m) => m["isCompleted"]).length}/${_learningModules.length}",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Progress Overview
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Overall Progress",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "25%",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: 0.25,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Difficulty Filter
            Row(
              children: [
                Text(
                  "Filter by difficulty:",
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: SizedBox(
                    height: 4.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _difficultyFilters.length,
                      itemBuilder: (context, index) {
                        final filter = _difficultyFilters[index];
                        final isSelected = filter == _selectedDifficulty;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDifficulty = filter;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 2.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              filter,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Modules List
            ...(_filteredModules
                .map((module) => _buildModuleItem(module))
                .toList()),

            SizedBox(height: 2.h),

            // View All Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  _showAllModules();
                },
                icon: CustomIconWidget(
                  iconName: 'library_books',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text(
                  "View All Learning Resources",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleItem(Map<String, dynamic> module) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: () => widget.onModuleSelect(module["id"]),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color:
                            (module["color"] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: module["icon"],
                        color: module["color"],
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  module["title"],
                                  style:
                                      AppTheme.lightTheme.textTheme.titleMedium,
                                ),
                              ),
                              if (module["isCompleted"])
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.getSuccessColor(true),
                                  size: 16,
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildDifficultyChip(module["difficulty"]),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                module["duration"],
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                Text(
                  module["description"],
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Topics
                Wrap(
                  spacing: 1.w,
                  children:
                      (module["topics"] as List<String>).take(3).map((topic) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        topic,
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    );
                  }).toList(),
                ),

                if (module["progress"] > 0) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: module["progress"],
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            module["color"],
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "${(module["progress"] * 100).toInt()}%",
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: module["color"],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty) {
      case "Beginner":
        chipColor = AppTheme.getSuccessColor(true);
        break;
      case "Intermediate":
        chipColor = AppTheme.getWarningColor(true);
        break;
      case "Advanced":
        chipColor = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        chipColor = AppTheme.lightTheme.colorScheme.outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        difficulty,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showAllModules() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
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
                    iconName: 'library_books',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "All Learning Modules",
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _learningModules.length,
                itemBuilder: (context, index) {
                  final module = _learningModules[index];
                  return _buildModuleItem(module);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
