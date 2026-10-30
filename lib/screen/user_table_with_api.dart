
import 'package:flutter/material.dart';
import 'package:flutter_exe/model/get_user.dart';
import 'package:flutter_exe/screen/user_form.dart';
import 'package:flutter_exe/service/api_service.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserTableWithApi extends StatefulWidget {
  const UserTableWithApi({super.key});

  @override
  State<UserTableWithApi> createState() => _UserTableWithApiState();
}

class _UserTableWithApiState extends State<UserTableWithApi> {
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
        title: 'ID',
        field: 'user_id',
        type: PlutoColumnType.number(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Email',
        field: 'email',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Role',
        field: 'role',
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
          final row = rendererContext.row;

          final userId =
              int.parse(row.cells['user_id']!.value.toString());

          final userName = row.cells['name']!.value.toString();
          final isDeleting = _deletingIds.contains(userId);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              IconButton(
                tooltip:'Edit User',
                icon: const Icon(
                  Icons.edit_outlined,
                  color:Colors.blue,
                  ),
                  onPressed: () {
                    editUser(userId);
                  },
                  ),
              IconButton(
                tooltip: 'Delete User',
                icon: isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                onPressed: isDeleting
                    ? null
                    : () => confirmDeleteUser(userId, userName),
              ),
            ],
          );
        },
      ),
    ];

    loadUsers();
  }

  Future<void> loadUsers() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final List<User> users = await _apiService.fetchUsers();

      final loadedRows = users.map((user) {
        return PlutoRow(
          cells: {
            'user_id': PlutoCell(value: user.user_id),
            'name': PlutoCell(value: user.name),
            'email': PlutoCell(value: user.email),
            'password': PlutoCell(value: user.password),
            'role': PlutoCell(value: user.role),
            'action': PlutoCell(value: ''),
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

  Future<void>editUser(int user_id) async {
    try {
      final users = await _apiService.fetchUsers();
      final matchingUsers = users.where(
        (user) => user.user_id ==user_id,
        );
        if(matchingUsers.isEmpty){
          if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content:Text('User not found'),
           backgroundColor: Colors.red,
           )
          );
          return;
        }
        final selectedUser = matchingUsers.first;
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserForm(
            user: selectedUser,
          ),
        ),
      );
      if(!mounted) return;
      await loadUsers();

    } catch (e){
      if(!mounted)return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open user:$e'),
        backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> confirmDeleteUser(int userId, String userName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text(
            'Are you sure you want to delete "$userName"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteUser(userId);
    }
  }

  Future<void> deleteUser(int userId) async {
    if (_deletingIds.contains(userId)) return;

    setState(() {
      _deletingIds.add(userId);
    });

    try {
      await _apiService.deleteUser(userId);

      if (!mounted) return;

      setState(() {
        rows.removeWhere(
          (row) =>
              int.parse(
                row.cells['user_id']!.value.toString(),
              ) ==
              userId,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deletingIds.remove(userId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            onPressed: isLoading ? null : loadUsers,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh users',
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
        child: SingleChildScrollView(
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
                'Failed to load users',
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
                onPressed: loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
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
            ElevatedButton.icon(
              onPressed: loadUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
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
