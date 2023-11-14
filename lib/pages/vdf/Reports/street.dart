import 'dart:convert';
import 'dart:math';

import 'package:dalmia/common/bottombar.dart';
import 'package:dalmia/components/reportappbar.dart';
import 'package:dalmia/components/reportpop.dart';
import 'package:dalmia/pages/vdf/Draft/draft.dart';
import 'package:http/http.dart' as http;

import 'package:dalmia/pages/vdf/Reports/hhidform.dart';
import 'package:dalmia/pages/vdf/Reports/home.dart';
import 'package:dalmia/pages/vdf/household/addhouse.dart';
import 'package:dalmia/pages/vdf/street/Addstreet.dart';
import 'package:dalmia/pages/vdf/vdfhome.dart';
import 'package:dalmia/theme.dart';
import 'package:flutter/material.dart';

class StreetReport extends StatefulWidget {
  const StreetReport({super.key});

  @override
  State<StreetReport> createState() => _StreetReportState();
}

class _StreetReportState extends State<StreetReport> {
  String? selectedPanchayat;
  String? selectedVillage;
  int _selectedpanchayatindex = 0;
  int _selectedvillagetindex = 0;
  int? selectedRadio;
  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (selectedIndex == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const VdfHome(),
        ),
      );
    } else if (selectedIndex == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyForm(),
        ),
      );
    } else if (selectedIndex == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddStreet(),
        ),
      );
    } else if (selectedIndex == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Draft(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPanchayatData(); // Call the method to fetch API data when the page initializes
  }

  List<Map<String, dynamic>> panchayatData = [];
  Future<void> fetchPanchayatData() async {
    try {
      final response = await http.get(
        Uri.parse('$base/report-panchayat-wise?vdfId=10001'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        setState(() {
          panchayatData = [
            for (var entry in jsonData['resp_body'].entries)
              {
                'panchayatName': entry.key,
                'incomeFollowUpDue': entry.value['incomeFollowUpDue'],
                'selectedHHWithoutIntervention':
                    entry.value['selectedHHWithoutIntervention'],
                'interventionStartedButNotCompleted':
                    entry.value['interventionStartedButNotCompleted'],
              }
          ];
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ReportAppBar(
          heading: 'Reports',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left_outlined,
                          color: Colors.black,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  viewotherbtn(context),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text(
                    'Cumulative Household Details',
                    style: TextStyle(
                        fontSize: CustomFontTheme.headingSize,
                        fontWeight: CustomFontTheme.labelwt),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    // child: () {
                    //   if (selectedPanchayat ==
                    //       _selectedpanchayatindex.toInt()) {
                    //     return villagetab(random);
                    //   } else if (selectedVillage ==
                    //           'Village ${_selectedvillagetindex + 1}' &&
                    //       selectedPanchayat == null) {
                    //     return streettab(random);
                    //   } else {
                    //     return
                    child: villagetab(random)
                    // }
                    // }()
                    ,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: SizedBox(
          height: 67,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomTabItem(
                imagePath: 'images/Dashboard_Outline.svg',
                label: "Dashboard",
                index: 0,
                selectedIndex: 5,
                onTabTapped: _onTabTapped,
              ),
              CustomTabItem(
                imagePath: 'images/Household_Outline.svg',
                label: "Add Household",
                index: 1,
                selectedIndex: 5,
                onTabTapped: _onTabTapped,
              ),
              CustomTabItem(
                imagePath: 'images/Street_Outline.svg',
                label: "Add Street",
                index: 2,
                selectedIndex: 5,
                onTabTapped: _onTabTapped,
              ),
              CustomTabItem(
                imagePath: 'images/Drafts_Outline.svg',
                label: "Drafts",
                index: 3,
                selectedIndex: 5,
                onTabTapped: _onTabTapped,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget villagetab(Random random) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(selectedPanchayat!,
              style: TextStyle(
                  fontSize: CustomFontTheme.textSize,
                  fontWeight: CustomFontTheme.labelwt)),
          const Text('Village wise report',
              style: TextStyle(
                  fontSize: CustomFontTheme.textSize,
                  fontWeight: CustomFontTheme.labelwt)),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: DataTable(
                decoration: const BoxDecoration(
                  color: Color(0xFF008CD3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                dividerThickness: 2,
                columnSpacing: 15,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Village Name',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Income follow up Overdue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Number of selected HHs without intervention',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'No. of Interventions started but not completed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  10,
                  (index) {
                    return DataRow(
                      color: MaterialStateColor.resolveWith((states) {
                        // Alternating row colors
                        return index.isOdd
                            ? Colors.lightBlue[50]!
                            : Colors.white;
                      }),
                      cells: <DataCell>[
                        DataCell(
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedVillage = 'Village ${index + 1}';
                                _selectedvillagetindex = index;
                                selectedPanchayat = '0';
                                // _selectedVillageindex = index;

                                // selectedVillage =
                                //     'Village ${_selectedVillageindex + 1}';
                              });
                            },
                            child: Text(
                              'Village ${index + 1}',
                              style: const TextStyle(
                                color: CustomColorTheme.iconColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(
                          '${random.nextInt(100)}',
                        )),
                        DataCell(Text('${random.nextInt(100)}')),
                        DataCell(Text('${random.nextInt(100)}')),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget streettab(Random random) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              'dgf'
              // selectedVillage!
              ,
              style: TextStyle(
                  fontSize: CustomFontTheme.textSize,
                  fontWeight: CustomFontTheme.labelwt)),
          const Text('Street wise report',
              style: TextStyle(
                  fontSize: CustomFontTheme.textSize,
                  fontWeight: CustomFontTheme.labelwt)),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: DataTable(
                decoration: const BoxDecoration(
                  color: Color(0xFF008CD3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                dividerThickness: 2,
                columnSpacing: 15,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Street Name',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Income follow up Overdue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Number of selected HHs without intervention',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'No. of Interventions started but not completed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  10,
                  (index) {
                    return DataRow(
                      color: MaterialStateColor.resolveWith((states) {
                        // Alternating row colors
                        return index.isOdd
                            ? Colors.lightBlue[50]!
                            : Colors.white;
                      }),
                      cells: <DataCell>[
                        DataCell(
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HhidForm(),
                                ),
                              );
                            },
                            child: Text(
                              'Street ${index + 1}',
                              style: const TextStyle(
                                color: CustomColorTheme.iconColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(
                          '${random.nextInt(100)}',
                        )),
                        DataCell(Text('${random.nextInt(100)}')),
                        DataCell(Text('${random.nextInt(100)}')),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}