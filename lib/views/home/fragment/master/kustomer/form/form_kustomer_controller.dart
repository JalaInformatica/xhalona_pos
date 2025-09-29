import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';

class KustomerFormController extends GetxController {
  KustomerDAO? customer;
  KustomerFormController({KustomerDAO? formCustomer}) : customer = formCustomer;  
  final KustomerRepository _kustomerRepository = KustomerRepository();
  
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final telpController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final isPayable = false.obs;
  final isCompliment = false.obs;

  final errors = <String, String?>{}.obs;

  void loadInitialData(KustomerDAO? kustomer) {
    if (kustomer != null) {
      idController.text = kustomer.suplierId;
      nameController.text = kustomer.suplierName;
      telpController.text = kustomer.telp;
      emailController.text = kustomer.emailAdress;
      addressController.text = kustomer.address1;
      isPayable.value = kustomer.isPayable;
      isCompliment.value = kustomer.isCompliment;
    }
  }

  @override
  void onInit() {
    loadInitialData(customer);
    super.onInit();
  } 

  bool validateForm() {
    errors.clear();
    if (nameController.text.isEmpty) {
      errors['name'] = "Nama Wajib diisi";
    }
    if (telpController.text.isEmpty) {
      errors['telp'] = "No. Telp Wajib diisi";
    }
    return errors.isEmpty;
  }

  void handleAddEditKustomer() async {
    print("object");
    if (validateForm()) {
      await _kustomerRepository.addEditKustomer(
        suplierId: idController.text,
        suplierName: nameController.text,
        telp: telpController.text,
        emailAdress: emailController.text,
        adress1: addressController.text,
        isSuplier: "0",
        isPayable: isPayable.value ? "1" : "0",
        isCompliment: isCompliment.value ? "1" : "0",
      );
    }
  }

}
