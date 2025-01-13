class UserDAO {
  String userId;
  String userName;
  String emailAddress;
  String phoneNumber1;
  int levelId;
  String jointDate;
  String? profilePic;
  String? profileBirthDate;
  String? profileSex;
  String? profileAddress;
  String? profileCity;
  String? profileAddressPoint;
  String? profileKelurahan;
  String? profileKecamatan;
  String? profileProvinsi;
  String? profilePostalCode;

  UserDAO({
    this.userId = "",
    this.userName = "",
    this.emailAddress = "",
    this.phoneNumber1 = "",
    this.levelId = 0,
    this.jointDate = "",
    this.profilePic,
    this.profileBirthDate,
    this.profileSex,
    this.profileAddress,
    this.profileCity,
    this.profileAddressPoint,
    this.profileKelurahan,
    this.profileKecamatan,
    this.profileProvinsi,
    this.profilePostalCode,
  });

  UserDAO.fromJson(Map<String, dynamic> json)
      : userId = json['User_ID'] ?? "",
        userName = json['UserName'] ?? "",
        emailAddress = json['EmailAddress'] ?? "",
        phoneNumber1 = json['PhoneNumber1'] ?? "",
        levelId = json['LevelID'] ?? 0,
        jointDate = json['JOINT_DATE'] ?? "",
        profilePic = json['PROFILE_PIC'],
        profileBirthDate = json['PROFILE_BIRTH_DATE'],
        profileSex = json['PROFILE_SEX'],
        profileAddress = json['PROFILE_ADDRESS'],
        profileCity = json['PROFILE_CITY'],
        profileAddressPoint = json['PROFILE_ADDRESS_POINT'],
        profileKelurahan = json['PROFILE_KELURAHAN'],
        profileKecamatan = json['PROFILE_KECAMATAN'],
        profileProvinsi = json['PROFILE_PROVINSI'],
        profilePostalCode = json['PROFILE_POSTAL_CODE'];

  Map<String, dynamic> toJson() {
    return {
      'User_ID': userId,
      'UserName': userName,
      'EmailAddress': emailAddress,
      'PhoneNumber1': phoneNumber1,
      'LevelID': levelId,
      'JOINT_DATE': jointDate,
      'PROFILE_PIC': profilePic,
      'PROFILE_BIRTH_DATE': profileBirthDate,
      'PROFILE_SEX': profileSex,
      'PROFILE_ADDRESS': profileAddress,
      'PROFILE_CITY': profileCity,
      'PROFILE_ADDRESS_POINT': profileAddressPoint,
      'PROFILE_KELURAHAN': profileKelurahan,
      'PROFILE_KECAMATAN': profileKecamatan,
      'PROFILE_PROVINSI': profileProvinsi,
      'PROFILE_POSTAL_CODE': profilePostalCode,
    };
  }
}
