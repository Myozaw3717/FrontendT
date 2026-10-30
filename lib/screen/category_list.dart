import 'package:flutter/material.dart';
import 'package:flutter_exe/model/category_data.dart';
import 'package:flutter_exe/service/api_service.dart';

import 'package:pluto_grid/pluto_grid.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

late final List<PlutoColumn> columns;

  List<PlutoRow> rows = [];

  bool isLoading = true;
  String? errorMessage;
  final Set<int> _deletingIds = {};
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: 'CategoryId',
        field: 'category_id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Description',
        field: 'description',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
  title: 'Action',
  field: 'action',
  type: PlutoColumnType.text(),
  width: 100,
  enableEditingMode: false,
  enableSorting: false,
  enableFilterMenuItem: false,
  renderer: (rendererContext) {
    final categoryId = int.tryParse(
      rendererContext.row.cells['category_id']!.value.toString(),
    );

    final name =
        rendererContext.row.cells['name']!.value.toString();

    if (categoryId == null) {
      return const Icon(Icons.error_outline);
    }
        final isDeleting = _deletingIds.contains(categoryId);
    
    return IconButton(
      tooltip: 'Delete Category',
      onPressed: isDeleting
          ? null
          : () async {
              await confirmDeleteCategory(categoryId, name);
            },
      icon: isDeleting
          ? const SizedBox(
              width: 30,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
    );//IconButton
  }
),
  ];
  loadCategory();
  }

  Future<void> loadCategory() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final List<Category> category = await _apiService.fetchCategory();

      final loadedRows = category.map((category) {
        return PlutoRow(
          cells: {
            'category_id': PlutoCell(value: category.category_id),
            'name': PlutoCell(value: category.name),
            'description': PlutoCell(value: category.description),
            'action':PlutoCell(value: ''),
          },
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        rows = loadedRows;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> confirmDeleteCategory(int category_id, String name) async {
    final confirmed = await showDialog<bool>(
      context : context,
      builder : (dialogContext){
        return AlertDialog(
          title: const Text('Delete Category!'),
          content: Text('Are you sure you want to delete "$name"?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancle'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: (){
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        );
      }
    );
    if(confirmed==true){
      await deleteCategory(category_id);
    }
  }
  Future<void> deleteCategory(int categoryId) async {
    if(_deletingIds.contains(categoryId)) return;

    setState((){
      _deletingIds.add(categoryId);
    });

    try{
      await _apiService.deleteCategory(categoryId);

      if(!mounted) return;

      setState((){
        rows.removeWhere(
          (row) => int.tryParse(row.cells['category_id']!.value.toString()) == categoryId,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted successfully!'),
          backgroundColor: Colors.green,
        ),
        );

    }catch(e){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }finally {
      if(mounted){
        setState((){
          _deletingIds.remove(categoryId);
        });
      }
    }

  }



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Category',
            onPressed: isLoading ? null : loadCategory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(),
      ),
    );
  }
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: loadCategory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_outline,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text('No users found'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loadCategory,
              child: const Text('Reload'),
            ),
          ],
        ),
      );
    }

    return PlutoGrid(
      columns: columns,
      rows: rows,
      configuration: const PlutoGridConfiguration(),
    );
  }
}