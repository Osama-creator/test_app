// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart';
// import 'dart:io';
// import 'dart:math';

// void main() => runApp(SimulationApp());


// class SimulationScreen extends StatefulWidget {
//   @override
//   _SimulationScreenState createState() => _SimulationScreenState();
// }

// class _SimulationScreenState extends State<SimulationScreen> {
//   List<List<String>> arrivalData = [];
//   List<List<String>> serviceData = [];
//   List<Map<String, dynamic>> simulationTable = [];

//   Future<void> pickExcelFile(bool isArrival) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx', 'xls'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       var bytes = file.readAsBytesSync();
//       var excel = Excel.decodeBytes(bytes);

//       List<List<String>> tempData = [];
//       for (var table in excel.tables.keys) {
//         var sheet = excel.tables[table];
//         if (sheet != null) {
//           for (var row in sheet.rows) {
//             tempData
//                 .add(row.map((cell) => cell?.value.toString() ?? '').toList());
//           }
//         }
//       }

//       setState(() {
//         if (isArrival) {
//           arrivalData = tempData;
//         } else {
//           serviceData = tempData;
//         }
//       });
//     }
//   }

//   // Generate simulation table
//   void generateSimulationTable() {
//     if (arrivalData.isEmpty || serviceData.isEmpty) return;

//     simulationTable.clear();
//     int arrivalClock = 0;
//     int serverEndTime = 0;

//     for (int i = 0; i < 10; i++) {
//       int arrivalRand = Random().nextInt(1000);
//       int intervalTime = _mapRandomDigitToValue(arrivalRand, arrivalData);
//       arrivalClock += intervalTime;

//       int serviceRand = Random().nextInt(100);
//       int serviceDuration = _mapRandomDigitToValue(serviceRand, serviceData);

//       int startTime =
//           arrivalClock > serverEndTime ? arrivalClock : serverEndTime;
//       int endTime = startTime + serviceDuration;
//       int waitingTime = startTime - arrivalClock;
//       int idleTime =
//           arrivalClock > serverEndTime ? arrivalClock - serverEndTime : 0;
//       int spentTime = endTime - arrivalClock;

//       simulationTable.add({
//         'Customer': i + 1,
//         'ArrRand': arrivalRand,
//         'Interval': intervalTime,
//         'ArrivalClock': arrivalClock,
//         'ServRand': serviceRand,
//         'ServiceTime': serviceDuration,
//         'StartTime': startTime,
//         'EndTime': endTime,
//         'WaitingTime': waitingTime,
//         'IdleTime': idleTime,
//         'SpentTime': spentTime,
//       });

//       serverEndTime = endTime;
//     }

//     setState(() {});
//   }

//   // Map random value to table data
//   int _mapRandomDigitToValue(int rand, List<List<String>> tableData) {
//     for (int i = 1; i < tableData.length; i++) {
//       int from = int.tryParse(tableData[i][3]) ?? 0;
//       int to = int.tryParse(tableData[i][4]) ?? 0;
//       if (rand >= from && rand <= to) {
//         return int.tryParse(tableData[i][0]) ?? 0;
//       }
//     }
//     return 0;
//   }

//   // Build Data Table
//   Widget buildTable(String title, List<List<String>> data) {
//     if (data.isEmpty) return SizedBox.shrink();

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: data[0]
//                   .map((header) => DataColumn(
//                       label: Text(header,
//                           style: TextStyle(fontWeight: FontWeight.bold))))
//                   .toList(),
//               rows: data.skip(1).map((row) {
//                 return DataRow(
//                     cells: row.map((cell) => DataCell(Text(cell))).toList());
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildSimulationTable() {
//     if (simulationTable.isEmpty) return SizedBox.shrink();

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Simulation Table",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text("Cust")),
//                 DataColumn(label: Text("ArrRand")),
//                 DataColumn(label: Text("Interval")),
//                 DataColumn(label: Text("ArrClock")),
//                 DataColumn(label: Text("ServRand")),
//                 DataColumn(label: Text("ServiceTime")),
//                 DataColumn(label: Text("StartTime")),
//                 DataColumn(label: Text("EndTime")),
//                 DataColumn(label: Text("WaitTime")),
//                 DataColumn(label: Text("IdleTime")),
//                 DataColumn(label: Text("SpentTime")),
//               ],
//               rows: simulationTable.map((row) {
//                 return DataRow(cells: [
//                   DataCell(Text(row['Customer'].toString())),
//                   DataCell(Text(row['ArrRand'].toString())),
//                   DataCell(Text(row['Interval'].toString())),
//                   DataCell(Text(row['ArrivalClock'].toString())),
//                   DataCell(Text(row['ServRand'].toString())),
//                   DataCell(Text(row['ServiceTime'].toString())),
//                   DataCell(Text(row['StartTime'].toString())),
//                   DataCell(Text(row['EndTime'].toString())),
//                   DataCell(Text(row['WaitingTime'].toString())),
//                   DataCell(Text(row['IdleTime'].toString())),
//                   DataCell(Text(row['SpentTime'].toString())),
//                 ]);
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Simulation Module')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => pickExcelFile(true),
//                   child: Text("Upload Arrival Table"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => pickExcelFile(false),
//                   child: Text("Upload Service Table"),
//                 ),
//               ],
//             ),
//             buildTable("Arrival Probability Table", arrivalData),
//             buildTable("Service Probability Table", serviceData),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: generateSimulationTable,
//               child: Text("Generate Simulation Table"),
//             ),
//             buildSimulationTable(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SimulationApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Simulation App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//   final List<Widget> _views = [
//     SimulationScreen(),
//     SimulationScreen2(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Simulation App')),
//       body: _views[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.calculate), label: 'Simulation 1'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.dashboard), label: 'Simulation 2'),
//           // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'View 3'),
//         ],
//       ),
//     );
//   }
// }

// class PlaceholderView extends StatelessWidget {
//   final String title;
//   PlaceholderView(this.title);
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text(title, style: TextStyle(fontSize: 24)));
//   }
// }

// class SimulationScreen2 extends StatefulWidget {
//   @override
//   _SimulationScreen2State createState() => _SimulationScreen2State();
// }

// class _SimulationScreen2State extends State<SimulationScreen2> {
//   List<List<String>> newsdayData = [];
//   List<List<String>> demandData = [];
//   List<Map<String, dynamic>> simulationTable = [];

//   // Pick and parse Excel file
//   Future<void> pickExcelFile(bool isNewsday) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx', 'xls'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       var bytes = file.readAsBytesSync();
//       var excel = Excel.decodeBytes(bytes);

//       List<List<String>> tempData = [];
//       for (var table in excel.tables.keys) {
//         var sheet = excel.tables[table];
//         if (sheet != null) {
//           for (var row in sheet.rows) {
//             tempData
//                 .add(row.map((cell) => cell?.value.toString() ?? '').toList());
//           }
//         }
//       }

//       setState(() {
//         if (isNewsday) {
//           newsdayData = tempData;
//         } else {
//           demandData = tempData;
//         }
//       });
//     }
//   }

  
//   void generateSimulationTable() {
//     if (newsdayData.isEmpty || demandData.isEmpty) return;

//     simulationTable.clear();
//     const int newspaperStock = 80; // Daily stock of newspapers
//     const double pricePerNewspaper = 0.2; // Price for each newspaper
//     const double scrapPrice = 0.05; // Scrap price for unsold newspapers
//     const double lostProfitPerPaper = 0.1; // Lost profit for excess demand

//     for (int day = 1; day <= 12; day++) {
//       int newsdayRand = Random().nextInt(100) + 1;
//       String newsdayType = _mapRandomToNewsdayType(newsdayRand, newsdayData);

//       int demandRand = Random().nextInt(100) + 1;
//       int demand = _mapRandomToDemand(demandRand, newsdayType, demandData);

//       // Calculations
//       int soldPapers = min(demand, newspaperStock);
//       int remainingPapers = max(0, newspaperStock - soldPapers);
//       double revenueFromSales = soldPapers * pricePerNewspaper;
//       double salvageFromScrap = remainingPapers * scrapPrice;
//       double lostProfit = demand > newspaperStock
//           ? (demand - newspaperStock) * lostProfitPerPaper
//           : 0;

//       double dailyProfit = revenueFromSales + salvageFromScrap - lostProfit;
//       double netProfit = dailyProfit; // Same as daily profit here.
//       double trueLost = lostProfit; // True lost is the total lost profit.

//       simulationTable.add({
//         'Day': day,
//         'NewsdayRand': newsdayRand,
//         'NewsdayType': newsdayType,
//         'DemandRand': demandRand,
//         'Demand': demand,
//         'RevenueFromSales': revenueFromSales.toStringAsFixed(1),
//         'LostProfit': lostProfit.toStringAsFixed(1),
//         'Salvage': salvageFromScrap.toStringAsFixed(1),
//         'DailyProfit': dailyProfit.toStringAsFixed(1),
//         'NetProfit': netProfit.toStringAsFixed(1),
//         'TrueLost': trueLost.toStringAsFixed(1),
//         'RemainingPapers': remainingPapers,
//       });
//     }
//     setState(() {});
//   }

//   // Map random value to Newsday Type
//   String _mapRandomToNewsdayType(int rand, List<List<String>> table) {
//     for (int i = 1; i < table.length; i++) {
//       int from = int.tryParse(table[i][3]) ?? 0;
//       int to = int.tryParse(table[i][4]) ?? 0;
//       if (rand >= from && rand <= to) {
//         return table[i][0];
//       }
//     }
//     return 'Unknown';
//   }

//   // Map random value to Demand
//   int _mapRandomToDemand(
//       int rand, String newsdayType, List<List<String>> table) {
//     int columnIndex = {'Good': 1, 'Fair': 2, 'Poor': 3}[newsdayType] ?? 1;
//     for (int i = 1; i < table.length; i++) {
//       int from = int.tryParse(table[i][columnIndex + 2]) ?? 0;
//       int to = int.tryParse(table[i][columnIndex + 3]) ?? 0;
//       if (rand >= from && rand <= to) {
//         return int.tryParse(table[i][0]) ?? 0;
//       }
//     }
//     return 0;
//   }

//   Widget buildTable(String title, List<List<String>> data) {
//     if (data.isEmpty) return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: data[0]
//                   .map((header) => DataColumn(label: Text(header)))
//                   .toList(),
//               rows: data.skip(1).map((row) {
//                 return DataRow(
//                     cells: row.map((cell) => DataCell(Text(cell))).toList());
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildSimulationTable() {
//     if (simulationTable.isEmpty) return SizedBox.shrink();
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columns: [
//           DataColumn(label: Text('Day')),
//           DataColumn(label: Text('R.D. Type')),
//           DataColumn(label: Text('Type of Newsday')),
//           DataColumn(label: Text('R.D. Demand')),
//           DataColumn(label: Text('Demand')),
//           DataColumn(label: Text('Revenue From Sales')),
//           DataColumn(label: Text('Lost Profit')),
//           DataColumn(label: Text('Salvage From Scrap')),
//           DataColumn(label: Text('Daily Profit')),
//           DataColumn(label: Text('Net Profit')),
//           DataColumn(label: Text('True Lost')),
//           DataColumn(label: Text('Remaining Papers')),
//         ],
//         rows: simulationTable.map((row) {
//           return DataRow(cells: [
//             DataCell(Text(row['Day'].toString())),
//             DataCell(Text(row['NewsdayRand'].toString())),
//             DataCell(Text(row['NewsdayType'])),
//             DataCell(Text(row['DemandRand'].toString())),
//             DataCell(Text(row['Demand'].toString())),
//             DataCell(Text(row['RevenueFromSales'])),
//             DataCell(Text(row['LostProfit'])),
//             DataCell(Text(row['Salvage'])),
//             DataCell(Text(row['DailyProfit'])),
//             DataCell(Text(row['NetProfit'])),
//             DataCell(Text(row['TrueLost'])),
//             DataCell(Text(row['RemainingPapers'].toString())),
//           ]);
//         }).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Simulation Module')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => pickExcelFile(true),
//                   child: Text("Upload Newsday Table"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => pickExcelFile(false),
//                   child: Text("Upload Demand Table"),
//                 ),
//               ],
//             ),
//             buildTable("Newsday Table", newsdayData),
//             buildTable("Demand Table", demandData),
//             ElevatedButton(
//               onPressed: generateSimulationTable,
//               child: Text("Generate Simulation Table"),
//             ),
//             buildSimulationTable(),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'dart:math';

void main() => runApp(SimulationApp());

class SimulationApp extends StatefulWidget {
  @override
  _SimulationAppState createState() => _SimulationAppState();
}

class _SimulationAppState extends State<SimulationApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulation App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function onToggleTheme;
  final bool isDarkMode;

  const MainScreen({required this.onToggleTheme, required this.isDarkMode});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _views = [
    SimulationScreen2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulation App'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onToggleTheme(),
          ),
        ],
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Simulation 1'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Simulation 2'),
        ],
      ),
    );
  }
}

class SimulationScreen2 extends StatefulWidget {
  @override
  _SimulationScreen2State createState() => _SimulationScreen2State();
}

class _SimulationScreen2State extends State<SimulationScreen2> {
  List<List<String>> newsdayData = [];
  List<List<String>> demandData = [];
  List<Map<String, dynamic>> simulationTable = [];

  Future<void> pickExcelFile(bool isNewsday) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;

      if (fileBytes != null) {
        var excel = Excel.decodeBytes(fileBytes);

        List<List<String>> tempData = [];
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet != null) {
            for (var row in sheet.rows) {
              tempData
                  .add(row.map((cell) => cell?.value.toString() ?? '').toList());
            }
          }
        }

        setState(() {
          if (isNewsday) {
            newsdayData = tempData;
          } else {
            demandData = tempData;
          }
        });
      }
    }
  }

  void generateSimulationTable() {
    if (newsdayData.isEmpty || demandData.isEmpty) return;

    simulationTable.clear();
    const int newspaperStock = 80;
    const double pricePerNewspaper = 0.2;
    const double scrapPrice = 0.05;
    const double lostProfitPerPaper = 0.1;

    for (int day = 1; day <= 12; day++) {
      int newsdayRand = Random().nextInt(100) + 1;
      String newsdayType = _mapRandomToNewsdayType(newsdayRand, newsdayData);

      int demandRand = Random().nextInt(100) + 1;
      int demand = _mapRandomToDemand(demandRand, newsdayType, demandData);

      int soldPapers = min(demand, newspaperStock);
      int remainingPapers = max(0, newspaperStock - soldPapers);
      double revenueFromSales = soldPapers * pricePerNewspaper;
      double salvageFromScrap = remainingPapers * scrapPrice;
      double lostProfit = demand > newspaperStock
          ? (demand - newspaperStock) * lostProfitPerPaper
          : 0;

      double dailyProfit = revenueFromSales + salvageFromScrap - lostProfit;

      simulationTable.add({
        'Day': day,
        'NewsdayRand': newsdayRand,
        'NewsdayType': newsdayType,
        'DemandRand': demandRand,
        'Demand': demand,
        'RevenueFromSales': revenueFromSales.toStringAsFixed(1),
        'LostProfit': lostProfit.toStringAsFixed(1),
        'Salvage': salvageFromScrap.toStringAsFixed(1),
        'DailyProfit': dailyProfit.toStringAsFixed(1),
        'RemainingPapers': remainingPapers,
      });
    }
    setState(() {});
  }

  String _mapRandomToNewsdayType(int rand, List<List<String>> table) {
    for (int i = 1; i < table.length; i++) {
      int from = int.tryParse(table[i][3]) ?? 0;
      int to = int.tryParse(table[i][4]) ?? 0;
      if (rand >= from && rand <= to) {
        return table[i][0];
      }
    }
    return 'Unknown';
  }

  int _mapRandomToDemand(
      int rand, String newsdayType, List<List<String>> table) {
    int columnIndex = {'Good': 1, 'Fair': 2, 'Poor': 3}[newsdayType] ?? 1;
    for (int i = 1; i < table.length; i++) {
      int from = int.tryParse(table[i][columnIndex + 2]) ?? 0;
      int to = int.tryParse(table[i][columnIndex + 3]) ?? 0;
      if (rand >= from && rand <= to) {
        return int.tryParse(table[i][0]) ?? 0;
      }
    }
    return 0;
  }

  Widget buildTable(String title, List<List<String>> data) {
    if (data.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blueGrey),
              columns: data[0]
                  .map((header) => DataColumn(
                      label: Text(header,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white))))
                  .toList(),
              rows: data.skip(1).map((row) {
                return DataRow(cells: row.map((cell) {
                  return DataCell(
                    Text(cell),
                    showEditIcon: false,
                    placeholder: false,
                  );
                }).toList());
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSimulationTable() {
    if (simulationTable.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.blueGrey),
          columns: [
            DataColumn(label: Text('Day', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('R.D. Type', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Type of Newsday', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('R.D. Demand', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Demand', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Revenue From Sales', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Lost Profit', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Salvage', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Daily Profit', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Remaining Papers', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: simulationTable.map((row) {
            return DataRow(
              cells: row.entries.map((entry) {
                return DataCell(Text(entry.value.toString()));
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulation 2')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => pickExcelFile(true),
              child: Text('Upload Newsday Data'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => pickExcelFile(false),
              child: Text('Upload Demand Data'),
            ),SizedBox(height: 20,),
            ElevatedButton(
              onPressed: generateSimulationTable,
              child: Text('Generate Simulation'),
            ),
            buildTable('Newsday Data', newsdayData),
            buildTable('Demand Data', demandData),
            buildSimulationTable(),
          ],
        ),
      ),
    );
  }
}

