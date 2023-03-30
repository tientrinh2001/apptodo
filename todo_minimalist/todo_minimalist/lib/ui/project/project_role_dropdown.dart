import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/role_model.dart';

class RoleDropDown extends StatefulWidget {
  const RoleDropDown({Key? key}) : super(key: key);
  @override
  State<RoleDropDown> createState() => _RoleDropDownState();
}

class _RoleDropDownState extends State<RoleDropDown> {
  List<Role> roleList = [];
  late Role dropdownValue;
  @override
  void initState() {
    roleList.addAll(Role.getList());
    dropdownValue = roleList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      return SizedBox(
          width: double.infinity,
          child: DropdownButton<Role>(
            icon: const Visibility(
                visible: false, child: Icon(Icons.arrow_downward)),
            value: dropdownValue,
            underline: Container(height: 1),
            onChanged: (Role? value) {
              setState(() {
                dropdownValue = value!;
                // ref
                //     .read(reminderTypeControllerProvider(widget.todo).notifier)
                //     .changeType(dropdownValue);
              });
            },
            items: roleList.map<DropdownMenuItem<Role>>((Role value) {
              return DropdownMenuItem<Role>(
                value: value,
                child: Text(
                  value.name,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ));
    }));
  }
}
