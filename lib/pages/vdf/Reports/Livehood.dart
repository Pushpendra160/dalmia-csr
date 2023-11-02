import 'package:dalmia/components/reportappbar.dart';
import 'package:dalmia/components/reportpop.dart';

import 'package:dalmia/pages/vdf/household/addhouse.dart';
import 'package:dalmia/pages/vdf/street/Addstreet.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LivehoodPlan extends StatefulWidget {
  const LivehoodPlan({Key? key}) : super(key: key);

  @override
  State<LivehoodPlan> createState() => _LivehoodPlanState();
}

class _LivehoodPlanState extends State<LivehoodPlan> {
  int? selectedRadio;
  int _selectedIndex = 0; // Track the currently selected tab index

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    // final List<int> householdList =
    //     List.generate(10, (index) => random.nextInt(100));
    // final List<int> populationList =
    //     List.generate(10, (index) => random.nextInt(100));
    // final List<int> incomeList =
    //     List.generate(10, (index) => random.nextInt(100));
    // ;
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: reportappbar(
              heading: 'Report',
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 85, 164, 228),
                            foregroundColor: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ReportPopupWidget(context);
                            },
                          );
                        },
                        icon: const Icon(Icons.folder_outlined),
                        label: const Text(
                          'View other Reports',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(' Livelihood Funds Utilization'),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 0.0,
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Sno.')),
                            DataColumn(label: Text('Business Plan Titles')),
                          ],
                          rows: List<DataRow>.generate(
                            3,
                            (index) {
                              return DataRow(
                                color: MaterialStateColor.resolveWith(
                                  (states) {
                                    // Alternating row colors
                                    return index.isOdd
                                        ? Colors.lightBlue[50] as Color
                                        : Colors.white as Color;
                                  },
                                ),
                                cells: const <DataCell>[
                                  DataCell(Text('Allocated(Rs.)')),
                                  DataCell(Text('5000')),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const Text('Last updated on:12/07/23')
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTabItem(Icons.dashboard_customize_outlined, "Dashboard", 0),
              buildTabItem(Icons.home_sharp, "Add Household", 1),
              buildTabItem(Icons.streetview_outlined, "Add Street", 2),
              buildTabItem(Icons.drafts_outlined, "Drafts", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabItem(IconData icon, String label, int index) {
    final isSelected = index == 0;
    final color = isSelected ? Colors.blue : Colors.black;

    return InkWell(
      onTap: () {
        _onTabTapped(index);
        if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyForm(),
            ),
          );
        }
        if (index == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddStreet(),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
