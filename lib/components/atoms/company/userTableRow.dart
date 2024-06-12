// import 'package:flutter/material.dart';

// class UserTableRow extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const UserTableRow({
//     required this.userData,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   _UserTableRowState createState() => _UserTableRowState();
// }

// class _UserTableRowState extends State<UserTableRow> {
//   late Map<String, dynamic> userData;

//   @override
//   void initState() {
//     super.initState();
//     userData = Map<String, dynamic>.from(widget.userData);
//   }

//   void _updatePermission(int index, bool enabled) {
//     setState(() {
//       userData['permission'][index]['enabled'] = enabled;
//     });
//   }

//   void _updateRole(String role) {
//     setState(() {
//       userData['role'] = role;
//     });
//   }

//   void _showEditModal(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Editar Usuario'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildRow('Nombre', userData['name']),
//                 buildRow('Email', userData['email']),
//                 buildRoleDropdown('Rol', userData['role'], _updateRole),
//                 buildRow('Activo', userData['enabled']),
//                 buildOptionsRow(
//                     'Options', userData['permission'], _updatePermission),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancelar'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _saveChanges(context);
//               },
//               child: Text('Guardar'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _saveChanges(BuildContext context) {
//     print('Guardando cambios para ${userData['name']}');
//     Navigator.of(context).pop();
//   }

//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Desactivar Usuario'),
//           content: Text(
//               '¿Estás seguro de que quieres Desactivar a ${userData['name']}?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancelar'),
//             ),
//             TextButton(
//               onPressed: widget.onDelete,
//               child: const Text('Desactivar'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(userData['name']),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(userData['email']),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(userData['role']),
//           ),
//           Expanded(
//             flex: 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () => _showEditModal(context),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () => _confirmDelete(context),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget buildRow(String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 100,
//           child: Text(
//             '$label:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Text(value),
//         ),
//       ],
//     ),
//   );
// }

// Widget buildRoleDropdown(
//     String label, String? currentValue, Function(String) onChanged) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 100,
//           child: Text(
//             '$label:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: DropdownButton(
//             value: currentValue,
//             isExpanded: true,
//             onChanged: (newValue) {
//               if (newValue != null) {
//                 onChanged(newValue);
//               }
//             },
//             items: ['WORKER', 'ADMIN', 'CLIENT'].map((value) {
//               return DropdownMenuItem(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             hint: Text('Selecciona un rol'),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget buildOptionsRow(
//     String label, List<dynamic> values, Function(int, bool) onChanged) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$label:',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         if (values == null || values.isEmpty)
//           Text('Sin opciones')
//         else
//           ...values.asMap().entries.map((entry) {
//             int idx = entry.key;
//             var value = entry.value;
//             return Row(
//               children: [
//                 Expanded(
//                   child: Text(value['name'] ?? ''),
//                 ),
//                 Switch(
//                   value: value['enabled'] ?? false,
//                   onChanged: (bool newValue) {
//                     onChanged(idx, newValue);
//                   },
//                 ),
//               ],
//             );
//           }).toList(),
//       ],
//     ),
//   );
// }
