import 'package:flutter/material.dart';
import 'package:flutter_final_1/model/Transactions.dart';
import 'package:flutter_final_1/providers/transaction_provider.dart';
import 'package:flutter_final_1/screens/form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_final_1/screens/transaction_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return TransactionProvider();
        })
      ],
      child: MaterialApp(
        title: 'MANGA PLUS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.tealAccent,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://mangaplus.shueisha.co.jp/icn/app_icon_192.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            const Text(
              'แอพบันทึกข้อมูลนักศึกษา',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormScreen();
              }));
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, TransactionProvider provider, Widget) {
          var count = provider.transactions.length;
          if (count <= 0) {
            return Center(
              child: Text(
                "ไม่พบข้อมูล",
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, int index) {
                Transactions data = provider.transactions[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TransactionDetailScreen(transaction: data);
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(''),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.9,
                        child: ListTile(
                          // ignore: unnecessary_null_comparison
                          leading: data.imageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // ปรับขนาดของมุมเป็นสี่เหลี่ยมโค้ง
                                  child: Image.memory(
                                    data.imageBytes,
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 20,
                                  child: FittedBox(
                                    child: Text(data.amount.toString()),
                                  ),
                                ),
                          title: Text(
                            "ชื่อ : " + data.title,
                            style: TextStyle(
                                fontSize: 18, color: Colors.deepOrange),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "เพศ : " + data.gender,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 7, 7, 7)),
                              ),
                              Text(
                                "สาขาวิชา : " + data.type,
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 12, 12, 12)),
                              ),
                              Text(
                                "วันเดือนปีเกิด : " +
                                    DateFormat("dd/MM/yyyy").format(data.date),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              Text(
                                "รหัสนักศึกษา : " + data.amount.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      // เพิ่ม Widget ที่ต้องการแสดงในแท็บที่สอง
    );
  }
}
