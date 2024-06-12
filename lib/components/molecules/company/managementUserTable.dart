import 'package:flutter/material.dart';
import 'package:front_end_gestor/components/atoms/company/userTableHeader.dart';
// import 'package:front_end_gestor/components/atoms/company/userTableRow.dart';

class ManagementUserTable extends StatelessWidget {
  final List<Map<String, dynamic>> listData;
  final List<Map<String, dynamic>> allPermissions;

  const ManagementUserTable({
    super.key,
    required this.listData,
    required this.allPermissions,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> formatListData(
      List<Map<String, dynamic>> allPermissions,
      List<Map<String, dynamic>> listData,
    ) {
      return listData.map((user) {
        final userPermissions = user['permission']?.toList() ?? [];

        final updatedPermissions = allPermissions.map((perm) {
          final existingPerm = userPermissions.firstWhere(
            (up) => up['id'] == perm['id'],
            orElse: () => null,
          );
          return {
            ...perm,
            'enabled': existingPerm != null,
          };
        }).toList();

        return {
          ...user,
          'permission': updatedPermissions,
        };
      }).toList();
    }

    final dataFormatted = formatListData(allPermissions, listData);

    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const UserTableHeader(),
            Divider(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataFormatted.length,
              itemBuilder: (context, index) {
                final item = dataFormatted[index];
                return UserTableRow(
                  userData: item,
                  onEdit: () {
                    print('aca enviamos ejecutamos MUTACION Edit');
                  },
                  onDelete: () {
                    print('aca enviamos una ejecutamos MUTACION Delete');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserTableRow extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEdit; // func qe trae una mutacion
  final VoidCallback onDelete; // func qe trae una mutacion
  dynamic updatedUserData;

  UserTableRow({
    super.key,
    required this.userData,
    required this.onEdit,
    required this.onDelete,
    this.updatedUserData,
  });

  @override
  _UserTableRowState createState() => _UserTableRowState();
}

class _UserTableRowState extends State<UserTableRow> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = Map<String, dynamic>.from(widget.userData);
  }

  void _updatePermission(int index, bool enabled) {
    setState(() {
      userData['permission'][index]['enabled'] = enabled;
    });
  }

  void _updateRole(String role) {
    setState(() {
      userData['role'] = role;
    });
  }

  void _showEditModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? name = userData['name'];
    String? email = userData['email'];
    String? role = userData['role'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  buildRoleDropdown('Rol', role, _updateRole),
                  // buildOptionsRow(
                  //   'Permisos',
                  //   userData['permission'],
                  //   _updatePermission,
                  // ),
                  Text('-------------------------------------------------'),
                  Text(name ?? 'nada'),
                  Text(email ?? 'nada'),
                  Text(role ?? 'nada'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Cancelando edición');
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  userData['name'] = name!;
                  userData['email'] = email!;
                  print('Guardando cambios para ${userData['name']}');
                  widget.onEdit();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Desactivar Usuario'),
          content: Text(
              '¿Estás seguro de que quieres Desactivar a ${userData['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: widget.onDelete,
              child: const Text('Desactivar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(userData['name']),
          ),
          Expanded(
            flex: 3,
            child: Text(userData['email']),
          ),
          Expanded(
            flex: 1,
            child: Text(userData['role']),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditModal(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(value),
        ),
      ],
    ),
  );
}

Widget buildRoleDropdown(
    String label, String? currentValue, Function(String) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButton(
            value: currentValue,
            isExpanded: true,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            items: ['WORKER', 'ADMIN', 'CLIENT'].map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text('Selecciona un rol'),
          ),
        ),
      ],
    ),
  );
}

Widget buildOptionsRow(
    String label, List<dynamic> values, Function(int, bool) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (values == null || values.isEmpty)
          Text('Sin opciones')
        else
          ...values.asMap().entries.map((entry) {
            int idx = entry.key;
            var value = entry.value;
            return Row(
              children: [
                Expanded(
                  child: Text(value['name'] ?? ''),
                ),
                Switch(
                  value: value['enabled'] ?? false,
                  onChanged: (bool newValue) {
                    onChanged(idx, newValue);
                  },
                ),
              ],
            );
          }).toList(),
      ],
    ),
  );
}
