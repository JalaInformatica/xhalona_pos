class CoaDAO {
  String companyId;
  String pAcountId;
  String namaRekening;
  String jenisRek;
  String acId;
  String flagDk;
  String? flagTm;
  bool? isActive;

  CoaDAO({
    this.companyId = "",
    this.pAcountId = "",
    this.namaRekening = "",
    this.jenisRek = "",
    this.acId = "",
    this.flagDk = "",
    this.flagTm,
    this.isActive,
  });

  CoaDAO.fromJson(Map<String, dynamic> json)
      : companyId = json['COMPANY_ID'] ?? "",
        pAcountId = json['PARENT_ACCOUNT_ID'] ?? "",
        namaRekening = json['NAMA_REKENING'] ?? "",
        jenisRek = json['JENIS_REKENING'] ?? "",
        acId = json['ACCOUNT_ID'] ?? "",
        flagDk = json['FLAG_DK'] ?? "",
        flagTm = json['FLAG_TM'],
        isActive = json['ISACTIVE'];

  Map<String, dynamic> toJson() {
    return {
      'COMPANY_ID': companyId,
      'PARENT_ACCOUNT_ID': pAcountId,
      'NAMA_REKENING': namaRekening,
      'JENIS_REKENING': jenisRek,
      'ACCOUNT_ID': acId,
      'FLAG_DK': flagDk,
      'FLAG_TM': flagTm,
      'ISACTIVE': isActive,
    };
  }
}
