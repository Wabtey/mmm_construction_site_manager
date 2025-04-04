enum RoleType { client, worker, siteSupervisor, siteManager }

class Role {
  final int id;
  final String name;
  final String phone;
  final RoleType type;

  Role({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Client')) {
      return Role(
        id: json['Client']['id'],
        name: json['Client']['name'],
        phone: json['Client']['phone'],
        type: RoleType.client,
      );
    } else if (json.containsKey('Worker')) {
      return Role(
        id: json['Worker']['id'],
        name: json['Worker']['name'],
        phone: "",
        type: RoleType.worker,
      );
    } else if (json.containsKey('SiteSupervisor')) {
      return Role(
        id: json['SiteSupervisor']['id'],
        name: json['SiteSupervisor']['name'],
        phone: "",
        type: RoleType.siteSupervisor,
      );
    } else if (json.containsKey('SiteManager')) {
      return Role(
        id: json['SiteManager']['id'],
        name: json['SiteManager']['name'],
        phone: "",
        type: RoleType.siteManager,
      );
    }
    throw Exception('Unknown role type');
  }

  Map<String, dynamic> toJson() {
    final roleKey = switch (type) {
      RoleType.client => 'Client',
      RoleType.worker => 'Worker',
      RoleType.siteSupervisor => 'SiteSupervisor',
      RoleType.siteManager => 'SiteManager',
    };

    return {
      roleKey: {
        'id': id,
        'name': name,
      }
    };
  }
}
