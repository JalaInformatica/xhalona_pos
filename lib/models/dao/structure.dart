class MenuDAO {
  final String menuId;
  final String menuDesc;
  final List<SubMenuDAO> dataSubMenu;

  // Constructor with required named parameters
  MenuDAO({
    required this.menuId,
    required this.menuDesc,
    required this.dataSubMenu,
  });

  // Factory method to parse JSON
  factory MenuDAO.fromJson(Map<String, dynamic> json) {
    return MenuDAO(
      menuId: json['MENU_ID'] ?? "",
      menuDesc: json['MENU_DESC'] ?? "",
      dataSubMenu: (json['DATA_SUBMENU'] as List<dynamic>?)
              ?.map((subMenuJson) => SubMenuDAO.fromJson(subMenuJson))
              .toList() ??
          [],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'MENU_ID': menuId,
      'MENU_DESC': menuDesc,
      'DATA_SUBMENU': dataSubMenu.map((subMenu) => subMenu.toJson()).toList(),
    };
  }
}

class SubMenuDAO {
  final String subMenuId;
  final String subMenuDesc;
  final String pushParameter;
  final int rowId;
  final String componentId;
  final String subMenuRoot;
  final int isSelect;
  final int isInsert;
  final int isUpdate;
  final int isDelete;
  final int isCheck;
  final int isApprove;
  final int isExcel;
  final int isPdf;

  // Constructor with required named parameters
  SubMenuDAO({
    required this.subMenuId,
    required this.subMenuDesc,
    required this.pushParameter,
    required this.rowId,
    required this.componentId,
    required this.subMenuRoot,
    required this.isSelect,
    required this.isInsert,
    required this.isUpdate,
    required this.isDelete,
    required this.isCheck,
    required this.isApprove,
    required this.isExcel,
    required this.isPdf,
  });

  // Factory method to parse JSON
  factory SubMenuDAO.fromJson(Map<String, dynamic> json) {
    return SubMenuDAO(
      subMenuId: json['SubMenu_ID'] ?? "",
      subMenuDesc: json['SubMenuDesc'] ?? "",
      pushParameter: json['PushParameter'] ?? "",
      rowId: json['ROW_ID'] ?? 0,
      componentId: json['COMPONENT_ID'] ?? "",
      subMenuRoot: json['SUBMENU_ROOT'] ?? "",
      isSelect: json['IsSelect'] ?? 0,
      isInsert: json['IsInsert'] ?? 0,
      isUpdate: json['IsUpdate'] ?? 0,
      isDelete: json['IsDelete'] ?? 0,
      isCheck: json['IsCheck'] ?? 0,
      isApprove: json['IsApprove'] ?? 0,
      isExcel: json['IsExcel'] ?? 0,
      isPdf: json['IsPdf'] ?? 0,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'SubMenu_ID': subMenuId,
      'SubMenuDesc': subMenuDesc,
      'PushParameter': pushParameter,
      'ROW_ID': rowId,
      'COMPONENT_ID': componentId,
      'SUBMENU_ROOT': subMenuRoot,
      'IsSelect': isSelect,
      'IsInsert': isInsert,
      'IsUpdate': isUpdate,
      'IsDelete': isDelete,
      'IsCheck': isCheck,
      'IsApprove': isApprove,
      'IsExcel': isExcel,
      'IsPdf': isPdf,
    };
  }
}
