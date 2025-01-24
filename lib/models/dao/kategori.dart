class KategoriDAO {
  String analisaId;
  String ketAnalisa;
  String groupAnalisaId;
  String thumbImage;
  String companyId;
  bool? isActive;

  KategoriDAO({
    this.analisaId = "",
    this.ketAnalisa = "",
    this.groupAnalisaId = "",
    this.thumbImage = "",
    this.companyId = "",
    this.isActive,
  });

  KategoriDAO.fromJson(Map<String, dynamic> json)
      : analisaId = json['ANALISA_ID'] ?? "",
        ketAnalisa = json['KET_ANALISA'] ?? "",
        groupAnalisaId = json['GROUP_ANALISA_ID'] ?? "",
        thumbImage = json['THUMB_IMAGE'] ?? "",
        companyId = json['COMPANYID'] ?? "",
        isActive = json['ISACTIVE'];

  Map<String, dynamic> toJson() {
    return {
      'ANALISA_ID': analisaId,
      'KET_ANALISA': ketAnalisa,
      'GROUP_ANALISA_ID': groupAnalisaId,
      'THUMB_IMAGE': thumbImage,
      'COMPANYID': companyId,
      'ISACTIVE': isActive,
    };
  }
}
