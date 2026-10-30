import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}



class _UserTableState extends State<UserTable> {

late final List<PlutoColumn> columns;
late final List<PlutoRow> rows;

  @override
  void initState() {
    super.initState();

    
    columns = [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.number(),
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
    ];

    rows =[

     PlutoRow(
        cells: {
          'id': PlutoCell(value: 1),
          'name': PlutoCell(value: 'John Doe'),
          'email': PlutoCell(value: 'john.doe@example.com'),
          'role': PlutoCell(value: 'Admin'),
        },
      ),
      PlutoRow(
        cells: {
          'id': PlutoCell(value: 2),
          'name': PlutoCell(value: 'Jane Smith'),
          'email': PlutoCell(value: 'jane.smith@example.com'),
          'role': PlutoCell(value: 'Editor'),
        },

      ),
      PlutoRow(
        cells: {      
          'id': PlutoCell(value: 3),
          'name': PlutoCell(value: 'Bob Johnson'),
          'email': PlutoCell(value: 'bob.johnson@example.com'),
          'role': PlutoCell(value: 'User'),
        },
      ),

    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Table'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          configuration: const PlutoGridConfiguration(
           
            
          ),
        ),
      ),
    );
  }
}