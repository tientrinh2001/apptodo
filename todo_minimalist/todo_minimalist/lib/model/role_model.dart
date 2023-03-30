// ignore_for_file: public_member_api_docs, sort_constructors_first
class Role {
  final String code;
  final String name;
  Role({
    required this.code,
    required this.name,
  });

  static List<Role> getList() {
    var roleList = <Role>[];
    var management = Role(code: 'management', name: 'Management');
    var lead = Role(code: 'lead', name: 'Lead');
    var member = Role(code: 'member', name: 'Member');
    roleList.add(management);
    roleList.add(lead);
    roleList.add(member);
    return roleList;
  }
}
