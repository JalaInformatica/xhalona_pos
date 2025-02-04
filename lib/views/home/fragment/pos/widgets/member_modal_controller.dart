import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';

class MemberModalController extends GetxController{
  final KustomerRepository _customerRepository = KustomerRepository();
  var members = <KustomerDAO>[].obs;
  var isAddMember = false.obs;

  Future<void> fetchMembers({String? filter}) async {
    members.value = await _customerRepository.getKustomer(filterValue: filter);
  }

  Future<void> addMember(KustomerDAO member) async {
    await _customerRepository.addEditKustomer(
      actionId: '0',
      suplierId: member.suplierId,
      suplierName: member.suplierName,
      adress1: member.address1,
      adress2: member.address2,
      telp: member.telp,
      emailAdress: member.emailAdress,
    );
  }
}