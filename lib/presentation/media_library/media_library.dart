import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_media_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/media_grid_item_widget.dart';

class MediaLibrary extends StatefulWidget {
  const MediaLibrary({Key? key}) : super(key: key);

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

class _MediaLibraryState extends State<MediaLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  bool _isMultiSelectMode = false;
  String _selectedFilter = 'All';
  final List<String> _selectedItems = [];
  final ScrollController _scrollController = ScrollController();

  final List<String> _filterOptions = [
    'All',
    'Images',
    'Videos',
    'Backgrounds',
    'Educational Samples'
  ];

  final List<Map<String, dynamic>> _mediaItems = [
    {
      "id": "1",
      "title": "Virtual Background 1",
      "type": "background",
      "thumbnail":
          "https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": null,
      "size": "2.4 MB",
      "isEducational": false,
      "tags": ["office", "professional", "virtual"],
      "dateAdded": "2025-07-15",
    },
    {
      "id": "2",
      "title": "Sample Video Lecture",
      "type": "video",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/02/01/00/56/news-1172463_960_720.jpg",
      "duration": "05:32",
      "size": "45.2 MB",
      "isEducational": true,
      "tags": ["lecture", "educational", "cybersecurity"],
      "dateAdded": "2025-07-14",
    },
    {
      "id": "3",
      "title": "Profile Image",
      "type": "image",
      "thumbnail":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "duration": null,
      "size": "1.8 MB",
      "isEducational": false,
      "tags": ["profile", "avatar", "professional"],
      "dateAdded": "2025-07-16",
    },
    {
      "id": "4",
      "title": "Code Review Demo",
      "type": "video",
      "thumbnail":
          "https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?auto=compress&cs=tinysrgb&w=400",
      "duration": "12:45",
      "size": "89.7 MB",
      "isEducational": true,
      "tags": ["coding", "review", "educational", "flutter"],
      "dateAdded": "2025-07-13",
    },
    {
      "id": "5",
      "title": "Library Background",
      "type": "background",
      "thumbnail":
          "https://images.pixabay.com/photo/2015/07/17/22/43/student-849825_960_720.jpg",
      "duration": null,
      "size": "3.1 MB",
      "isEducational": false,
      "tags": ["library", "academic", "study"],
      "dateAdded": "2025-07-12",
    },
    {
      "id": "6",
      "title": "Security Testing Sample",
      "type": "image",
      "thumbnail":
          "https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=400&fit=crop",
      "duration": null,
      "size": "2.7 MB",
      "isEducational": true,
      "tags": ["security", "testing", "cybersecurity"],
      "dateAdded": "2025-07-11",
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    List<Map<String, dynamic>> filtered = _mediaItems;

    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Educational Samples') {
        filtered =
            filtered.where((item) => item['isEducational'] == true).toList();
      } else {
        String filterType = _selectedFilter.toLowerCase();
        if (filterType == 'images') filterType = 'image';
        if (filterType == 'videos') filterType = 'video';
        if (filterType == 'backgrounds') filterType = 'background';
        filtered =
            filtered.where((item) => item['type'] == filterType).toList();
      }
    }

    if (_searchController.text.isNotEmpty) {
      String searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((item) {
        return (item['title'] as String).toLowerCase().contains(searchTerm) ||
            (item['tags'] as List)
                .any((tag) => tag.toLowerCase().contains(searchTerm));
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _showAddMediaBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddMediaBottomSheetWidget());
  }

  void _onItemTap(Map<String, dynamic> item) {
    if (_isMultiSelectMode) {
      _toggleItemSelection(item['id']);
    } else {
      // Navigate to full-screen preview
      _showFullScreenPreview(item);
    }
  }

  void _showFullScreenPreview(Map<String, dynamic> item) {
    showDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
            backgroundColor: Colors.black,
            child: Stack(children: [
              Center(
                  child: item['type'] == 'video'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              CustomImageWidget(
                                  imageUrl: item['thumbnail'],
                                  width: 80.w,
                                  height: 45.h,
                                  fit: BoxFit.contain),
                              SizedBox(height: 2.h),
                              CustomIconWidget(
                                  iconName: 'play_circle_filled',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 64),
                              SizedBox(height: 1.h),
                              Text('Duration: ${item['duration']}',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white)),
                            ])
                      : CustomImageWidget(
                          imageUrl: item['thumbnail'],
                          width: 90.w,
                          height: 70.h,
                          fit: BoxFit.contain)),
              Positioned(
                  top: 6.h,
                  right: 4.w,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                          iconName: 'close', color: Colors.white, size: 28))),
              Positioned(
                  bottom: 8.h,
                  left: 4.w,
                  right: 4.w,
                  child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item['title'],
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.white)),
                            SizedBox(height: 1.h),
                            Text(
                                'Size: ${item['size']} • Added: ${item['dateAdded']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white70)),
                            if (item['isEducational']) ...[
                              SizedBox(height: 1.h),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text('Educational Content',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.secondary))),
                            ],
                            SizedBox(height: 2.h),
                            Row(children: [
                              Expanded(
                                  child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Inject media logic here
                                      },
                                      icon: CustomIconWidget(
                                          iconName: 'play_arrow',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          size: 20),
                                      label: Text('Inject to Camera'))),
                              SizedBox(width: 2.w),
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Share logic here
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.white),
                                      foregroundColor: Colors.white),
                                  child: CustomIconWidget(
                                      iconName: 'share',
                                      color: Colors.white,
                                      size: 20)),
                            ]),
                          ]))),
            ])));
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Refresh logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(children: [
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
                    if (index != 3) {
                      Navigator.pushNamed(context, routes[index]);
                    }
                  },
                  tabs: [
                    Tab(text: 'Permissions'),
                    Tab(text: 'Dashboard'),
                    Tab(text: 'Camera'),
                    Tab(text: 'Media Library'),
                    Tab(text: 'OBS'),
                    Tab(text: 'Settings'),
                  ])),

          // Search Bar and View Toggle
          Container(
              padding: EdgeInsets.all(4.w),
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Row(children: [
                Expanded(
                    child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                            hintText: 'Search media files...',
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                    iconName: 'search',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20)),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: CustomIconWidget(
                                        iconName: 'clear',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 20))
                                : null))),
                SizedBox(width: 2.w),
                IconButton(
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                    icon: CustomIconWidget(
                        iconName: _isGridView ? 'view_list' : 'grid_view',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24)),
              ])),

          // Filter Chips
          Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  separatorBuilder: (context, index) => SizedBox(width: 2.w),
                  itemBuilder: (context, index) {
                    return FilterChipWidget(
                        label: _filterOptions[index],
                        isSelected: _selectedFilter == _filterOptions[index],
                        onTap: () => setState(
                            () => _selectedFilter = _filterOptions[index]));
                  })),

          // Multi-select toolbar
          if (_isMultiSelectMode)
            Container(
                padding: EdgeInsets.all(4.w),
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                child: Row(children: [
                  Text('${_selectedItems.length} selected',
                      style: AppTheme.lightTheme.textTheme.titleSmall),
                  Spacer(),
                  TextButton.icon(
                      onPressed: _selectedItems.isNotEmpty
                          ? () {
                              // Delete selected items
                              setState(() {
                                _selectedItems.clear();
                                _isMultiSelectMode = false;
                              });
                            }
                          : null,
                      icon: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 20),
                      label: Text('Delete')),
                  TextButton.icon(
                      onPressed: _selectedItems.isNotEmpty
                          ? () {
                              // Share selected items
                            }
                          : null,
                      icon: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20),
                      label: Text('Share')),
                ])),

          // Main Content
          Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child:
                          _isGridView ? _buildGridView() : _buildListView())),
        ])),
        floatingActionButton: FloatingActionButton(
            onPressed: _showAddMediaBottomSheet,
            child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 28)));
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomIconWidget(
          iconName: 'photo_library',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 80),
      SizedBox(height: 2.h),
      Text('No media files found',
          style: AppTheme.lightTheme.textTheme.headlineSmall),
      SizedBox(height: 1.h),
      Text('Add your first media file to get started',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center),
      SizedBox(height: 3.h),
      ElevatedButton.icon(
          onPressed: _showAddMediaBottomSheet,
          icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20),
          label: Text('Add Media')),
    ]));
  }

  Widget _buildGridView() {
    return GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 100.w > 600 ? 3 : 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 3.w,
            childAspectRatio: 0.8),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return MediaGridItemWidget(
              item: item,
              isSelected: _selectedItems.contains(item['id']),
              isMultiSelectMode: _isMultiSelectMode,
              onTap: () => _onItemTap(item),
              onLongPress: () {
                if (!_isMultiSelectMode) {
                  _toggleMultiSelect();
                }
                _toggleItemSelection(item['id']);
              });
        });
  }

  Widget _buildListView() {
    return ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(4.w),
        itemCount: _filteredItems.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return ListTile(
              leading: Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                        imageUrl: item['thumbnail'],
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover)),
                if (item['type'] == 'video')
                  Positioned.fill(
                      child: Center(
                          child: CustomIconWidget(
                              iconName: 'play_circle_filled',
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 24))),
              ]),
              title: Text(item['title'],
                  style: AppTheme.lightTheme.textTheme.titleSmall),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item['size']} • ${item['dateAdded']}',
                        style: AppTheme.lightTheme.textTheme.bodySmall),
                    if (item['isEducational'])
                      Container(
                          margin: EdgeInsets.only(top: 0.5.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text('Educational',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      fontSize: 10.sp))),
                  ]),
              trailing: _isMultiSelectMode
                  ? Checkbox(
                      value: _selectedItems.contains(item['id']),
                      onChanged: (value) => _toggleItemSelection(item['id']))
                  : PopupMenuButton(
                      icon: CustomIconWidget(
                          iconName: 'more_vert',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: Row(children: [
                              CustomIconWidget(
                                  iconName: 'play_arrow',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20),
                              SizedBox(width: 2.w),
                              Text('Inject'),
                            ])),
                            PopupMenuItem(
                                child: Row(children: [
                              CustomIconWidget(
                                  iconName: 'share',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20),
                              SizedBox(width: 2.w),
                              Text('Share'),
                            ])),
                            PopupMenuItem(
                                child: Row(children: [
                              CustomIconWidget(
                                  iconName: 'delete',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 20),
                              SizedBox(width: 2.w),
                              Text('Delete'),
                            ])),
                          ]),
              onTap: () => _onItemTap(item),
              onLongPress: () {
                if (!_isMultiSelectMode) {
                  _toggleMultiSelect();
                }
                _toggleItemSelection(item['id']);
              });
        });
  }
}
