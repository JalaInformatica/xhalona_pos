import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/repositories/kategori_repository.dart';

class KategoriModalController extends GetxController{
  final KategoriRepository _kategoriRepository = KategoriRepository();
  var categories = <KategoriDAO>[].obs;

  Future<void> fetchCategories({String? filter}) async {
    categories.add(KategoriDAO(analisaId: "", ketAnalisa: "Semua"));
    categories.addAll(await _kategoriRepository.getKategori(filterValue: filter));
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}