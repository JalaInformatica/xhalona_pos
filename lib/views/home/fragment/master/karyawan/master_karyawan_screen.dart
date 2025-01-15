import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class MasterKaryawanScreen extends StatefulWidget {
  const MasterKaryawanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<MasterKaryawanScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _data = [];
  List<Map<String, String>> _filteredData = [];

  int _currentPage = 1;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _data = List.generate(
      50,
      (index) => {
        "ID": "${index + 1}",
        "Name": "Name ${index + 1}",
        "Age": "${20 + (index % 10)}",
        "City": "City ${index % 5}"
      },
    );

    _filteredData = List.from(_data);
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      _filteredData = List.from(_data);
    } else {
      _filteredData = _data
          .where((row) => row.values.any(
              (value) => value.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }
    _currentPage = 1;
    setState(() {});
  }

  List<Map<String, String>> _getPaginatedData() {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredData.sublist(
      startIndex,
      endIndex > _filteredData.length ? _filteredData.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Master Karywan"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterData,
            ),
          ),
          Expanded(
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 50,
              rightHandSideColumnWidth: 1600,
              isFixedHeader: true,
              headerWidgets: _buildTableHeader(),
              leftSideItemBuilder: _buildLeftSideColumnRow,
              rightSideItemBuilder: _buildRightSideColumnRow,
              itemCount: _getPaginatedData().length,
              rowSeparatorWidget: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  List<Widget> _buildTableHeader() {
    return [
      _buildHeaderCell("NO", 50),
      _buildHeaderCell("IMAGE", 200),
      _buildHeaderCell("PRODUK", 100),
      _buildHeaderCell("KATEGORI", 100),
      _buildHeaderCell("KET.", 100),
      _buildHeaderCell("SATUAN", 100),
      _buildHeaderCell("QTY", 100),
      _buildHeaderCell("HARGA", 100),
      _buildHeaderCell("DISC %", 100),
      _buildHeaderCell("DISC (RP)", 100),
      _buildHeaderCell("TETAP", 100),
      _buildHeaderCell("TERJUAL FEE %", 100),
      _buildHeaderCell("FEE (RP)", 100),
      _buildHeaderCell("UBH. HARGA", 100),
      _buildHeaderCell("FREE", 100),
      _buildHeaderCell("AKSI", 100),
    ];
  }

  Widget _buildHeaderCell(String title, double width) {
    return Container(
      width: width,
      height: 56,
      alignment: Alignment.center,
      color: Colors.blue,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLeftSideColumnRow(BuildContext context, int index) {
    final paginatedData = _getPaginatedData();
    return Container(
      width: 50,
      height: 56,
      alignment: Alignment.center,
      child: Text(paginatedData[index]["ID"]!),
    );
  }

  Widget _buildRightSideColumnRow(BuildContext context, int index) {
    final paginatedData = _getPaginatedData();
    return Row(
      children: [
        _buildDataCell(paginatedData[index]["Name"]!, 200),
        _buildDataCell(paginatedData[index]["Age"]!, 100),
        _buildDataCell(paginatedData[index]["City"]!, 100),
        _buildDataCell(paginatedData[index]["Name"]!, 100),
        _buildDataCell(paginatedData[index]["Age"]!, 100),
        _buildDataCell(paginatedData[index]["City"]!, 100),
        _buildDataCell(paginatedData[index]["Name"]!, 100),
        _buildDataCell(paginatedData[index]["Age"]!, 100),
        _buildDataCell(paginatedData[index]["City"]!, 100),
        _buildDataCell(paginatedData[index]["Name"]!, 100),
        _buildDataCell(paginatedData[index]["Age"]!, 100),
        _buildDataCell(paginatedData[index]["Age"]!, 100),
        _buildDataCell(paginatedData[index]["City"]!, 100),
        _buildDataCell(paginatedData[index]["Name"]!, 100),
        _buildDataCell(paginatedData[index]["Age"]!, 100),
      ],
    );
  }

  Widget _buildDataCell(String value, double width) {
    return Container(
      width: width,
      height: 56,
      alignment: Alignment.center,
      child: Text(value),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (_filteredData.length / _rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text("Page $_currentPage of $totalPages"),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: _currentPage < totalPages
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
