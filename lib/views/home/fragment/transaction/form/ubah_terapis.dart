// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:xhalona_pos/core/theme/theme.dart';
// import 'package:xhalona_pos/models/response/karyawan.dart';
// import 'package:xhalona_pos/models/response/masterall.dart';
// import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
// import 'package:xhalona_pos/views/home/home_screen.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:xhalona_pos/widgets/app_input_formatter.dart';
// import 'package:xhalona_pos/globals/transaction/repositories/transaction_repository.dart';
// import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';
// import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
// import 'package:xhalona_pos/views/home/fragment/master/product/m_all/mAll_controller.dart';

// // ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_const_constructors_in_immutables, library_private_types_in_public_api
// // ignore_for_file: use_build_context_synchronously

// // ignore: must_be_immutable
// class UbahTerapis extends StatefulWidget {
//   List<TransactionDetailResponse>? trxDetail;
//   UbahTerapis({super.key, this.trxDetail});

//   @override
//   _UbahTerapisState createState() => _UbahTerapisState();
// }

// class _UbahTerapisState extends State<UbahTerapis> {
//   TransactionRepository _trxRepository = TransactionRepository();
//   final KaryawanController controllerKar = Get.put(KaryawanController());
//   final TransactionController controller = Get.put(TransactionController());
//   final MasAllController controllerMas = Get.put(MasAllController());

//   final _formKey = GlobalKey<FormState>();
//   final _partNameController = TextEditingController();
//   final _pPartNameController = TextEditingController();
//   bool _isLoading = true;

//   // Variabel untuk menampung field sesuai trxDetail dan bomData
//   List<Map<String, dynamic>> trxDetailControllers = [];

//   @override
//   void initState() {
//     super.initState();
//     Inisialisasi();
//   }

//   Future<void> Inisialisasi() async {
//     if (widget.trxDetail != null) {
//       for (var trx in widget.trxDetail!) {
//         _partNameController.text = trx.partName;
//         Map<String, dynamic> bomDataControllers = {};
//         if (trx.bomData != null) {
//           bomDataControllers = {
//             for (var bom in trx.bomData!)
//               bom.bomPartName!: {
//                 'rowController': TextEditingController(text: '${bom.rowId}'),
//                 'unitController': TextEditingController(),
//                 'qtyController': TextEditingController(text: '${bom.qty}'),
//                 'brandController': TextEditingController()
//               }
//           };
//         }
//         trxDetailControllers.add({
//           'partNameController': TextEditingController(text: trx.partId ?? ''),
//           'selectTherapis': TextEditingController(),
//           'bomData': bomDataControllers
//         });
//       }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     for (var trx in trxDetailControllers) {
//       trx['partNameController'].dispose();
//       trx['selectTherapis'].dispose();
//       trx['bomData'].forEach((key, value) {
//         value['rowController'].dispose();
//         value['unitController'].dispose();
//         value['qtyController'].dispose();
//         value['brandController'].dispose();
//       });
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     void handleUbahTerapis() async {
//       if (_formKey.currentState!.validate()) {
//         String result = await _trxRepository.ubahEmployeeTerapis(
//             salesId: widget.trxDetail![0].salesId,
//             rowId: widget.trxDetail![0].rowId,
//             trxDetailControllers: trxDetailControllers);

//         String result2 = await _trxRepository.ubahBomTerapis(
//             trxDetailControllers: trxDetailControllers);
//         bool isSuccess = result == "1" && result2 == "1";
//         if (isSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Data gagal disimpan!')),
//           );
//         } else {
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//             (route) => false,
//           );
//           controller.fetchTransactions();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Data berhasil disimpan!')),
//           );
//         }
//       }
//     }

//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//             (route) => false);
//         controller.updateTrxDetail('');
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Ubah Terapis",
//             style: AppTextStyle.textTitleStyle(color: Colors.white),
//           ),
//           backgroundColor: AppColor.secondaryColor,
//         ),
//         body: _isLoading
//             ? buildShimmerLoading()
//             : SingleChildScrollView(
//                 padding: EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (widget.trxDetail != null &&
//                           widget.trxDetail!.isNotEmpty)
//                         ...widget.trxDetail!.asMap().entries.map(
//                           (entry) {
//                             int index = entry.key;
//                             var trx = entry.value;
//                             return Card(
//                               elevation: 4,
//                               child: Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     buildTextField(trx.partName,
//                                         'Masukan input', _partNameController,
//                                         isEnabled: false),
//                                     buildTypeAheadFieldTerapis("Filter Terapis",
//                                         controllerKar.karyawanHeader, (value) {
//                                       setState(() {
//                                         trxDetailControllers[index]
//                                                 ['selectTherapis']
//                                             .text = value;
//                                       });
//                                     }, controllerKar.updateFilterValue),
//                                     ...trx.bomData!.map(
//                                       (bom) {
//                                         var bomController =
//                                             trxDetailControllers[index]
//                                                 ['bomData'][bom.bomPartName!];

//                                         _pPartNameController.text =
//                                             bom.bomPartName;
//                                         return Card(
//                                           elevation: 4,
//                                           child: Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 buildTextField(
//                                                     '',
//                                                     'Masukan input',
//                                                     _pPartNameController,
//                                                     isEnabled: false),
//                                                 buildTypeAheadField("Unit",
//                                                     controllerMas.masAllHeader,
//                                                     (value) {
//                                                   setState(() {
//                                                     bomController[
//                                                             'unitController']
//                                                         .text = value;
//                                                   });
//                                                 },
//                                                     controllerMas
//                                                         .updateFilterValue,
//                                                     'UNIT_ID'),
//                                                 SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 buildTextField(
//                                                   'Qty',
//                                                   'Masukan input',
//                                                   bomController[
//                                                       'qtyController'],
//                                                 ),
//                                                 buildTypeAheadField("Brand",
//                                                     controllerMas.masAllHeader,
//                                                     (value) {
//                                                   setState(() {
//                                                     bomController[
//                                                             'brandController']
//                                                         .text = value;
//                                                   });
//                                                 },
//                                                     controllerMas
//                                                         .updateFilterValue,
//                                                     'BRAND_ID'),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       SizedBox(height: 32),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           masterButton(handleUbahTerapis, "Simpan", Icons.add),
//                           masterButton(() {
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(
//                                     builder: (context) => HomeScreen()),
//                                 (route) => false);
//                           }, "Batal", Icons.refresh),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget buildTypeAheadFieldTerapis(
//     String label,
//     List<KaryawanDAO> items,
//     ValueChanged<String?> onChanged,
//     void Function(String newFilterValue) updateFilterValue,
//   ) {
//     TextEditingController controller = TextEditingController();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: AppTextStyle.textTitleStyle()),
//         SizedBox(height: 8),
//         TypeAheadField<KaryawanDAO>(
//           suggestionsCallback: (pattern) async {
//             updateFilterValue(pattern); // Update filter
//             return items
//                 .where((item) =>
//                     item.fullName.toLowerCase().contains(pattern.toLowerCase()))
//                 .toList(); // Pencarian berdasarkan nama
//           },
//           builder: (context, textEditingController, focusNode) {
//             controller = textEditingController;

//             return TextField(
//               controller: controller,
//               focusNode: focusNode,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Cari nama...",
//               ),
//               onChanged: (value) {
//                 // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
//               },
//             );
//           },
//           itemBuilder: (context, KaryawanDAO suggestion) {
//             return ListTile(
//               title: Text(suggestion.fullName
//                   .toString()), // Tampilkan ID sebagai info tambahan
//             );
//           },
//           onSelected: (KaryawanDAO suggestion) {
//             controller.text = suggestion.fullName
//                 .toString(); // Tampilkan nama produk di field
//             onChanged(suggestion.empId); // Simpan ID produk di _product
//           },
//         ),
//       ],
//     );
//   }

//   Widget buildTypeAheadField(
//     String label,
//     List<MasAllDAO> items,
//     ValueChanged<String?> onChanged,
//     void Function(String newFilterValue) updateFilterValue,
//     String group,
//   ) {
//     TextEditingController controller = TextEditingController();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: AppTextStyle.textTitleStyle()),
//         SizedBox(height: 8),
//         TypeAheadField<MasAllDAO>(
//           suggestionsCallback: (pattern) async {
//             updateFilterValue(pattern); // Update filter
//             controllerMas.updateGroupMasterId(group);
//             return items
//                 .where((item) =>
//                     item.masDesc.toLowerCase().contains(pattern.toLowerCase()))
//                 .toList(); // Pencarian berdasarkan nama
//           },
//           builder: (context, textEditingController, focusNode) {
//             controller = textEditingController;

//             return TextField(
//               controller: controller,
//               focusNode: focusNode,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Cari...",
//               ),
//               onChanged: (value) {
//                 // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
//               },
//             );
//           },
//           itemBuilder: (context, MasAllDAO suggestion) {
//             return ListTile(
//               title: Text(suggestion.masDesc
//                   .toString()), // Tampilkan ID sebagai info tambahan
//             );
//           },
//           onSelected: (MasAllDAO suggestion) {
//             controller.text =
//                 suggestion.masDesc.toString(); // Tampilkan nama produk di field
//             onChanged(suggestion.masterId); // Simpan ID produk di _product
//           },
//         ),
//       ],
//     );
//   }
// }
