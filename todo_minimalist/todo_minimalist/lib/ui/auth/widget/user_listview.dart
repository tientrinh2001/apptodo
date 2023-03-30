import 'package:flutter/material.dart';
import 'user_item.dart';
import '../../../model/user_model.dart';

class UserListView extends StatelessWidget {
  const UserListView({
    required this.userList,
    Key? key,
  }) : super(key: key);
  final List<User> userList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: ((context, index) {
          return UserItem(
            userList: userList,
            index: index,
          );
        }),
      ),
    );
  }
}
