import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MaterialApp(
    home: WalletPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late ScrollController _scrollController;
  bool _isScrolled = false;
  String? _selectedPaymentMethod;

  final List<dynamic> _services = [
    ['ارسال لصديق', Iconsax.export_1, Colors.blue],
    ['اضافة قيمة', Iconsax.import, Colors.pink],
    ['فواتير', Iconsax.wallet_3, Colors.orange],
  ];

  final List<dynamic> _transactions = [
    [
      'Libyana',
      'https://seeklogo.com/images/L/libyana-logo-A209AE50E7-seeklogo.com.png',
      '6:25pm',
      '8.90 د.ل'
    ],
    [
      'Almadar',
      'https://play-lh.googleusercontent.com/BHVcdZSbnCjZ6gNO2xX6iOyGwM5HvCb5hP-8T2OI7hdlDxOMC8UzquoZbOSNb07iiQ=s256-rw',
      '5:50pm',
      'د.ل200.00'
    ],
    [
      'Sadad',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNnrnhzr3Q6N-_TA2fzwRsKwgmc-QmoO_FMEc8O8GfvA&s',
      '2:22pm',
      '\$13.99'
    ],
  ];

  final List<dynamic> _paymentMethods = [
    [
      'Libyana',
      'https://seeklogo.com/images/L/libyana-logo-A209AE50E7-seeklogo.com.png',
    ],
    [
      'Almadar',
      'https://play-lh.googleusercontent.com/BHVcdZSbnCjZ6gNO2xX6iOyGwM5HvCb5hP-8T2OI7hdlDxOMC8UzquoZbOSNb07iiQ=s256-rw',
    ],
    [
      'Sadad',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNnrnhzr3Q6N-_TA2fzwRsKwgmc-QmoO_FMEc8O8GfvA&s',
    ],
  ];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);

    super.initState();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  // Function to show the add value dialog
  void _showAddValueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              title: const Text('اضافة قيمة'),
              titleTextStyle: TextStyle(
                fontFamily: 'HacenSamra',
                color: themeProvider
                        .themeData.dialogTheme.titleTextStyle?.color ??
                    Colors
                        .black, // Using dynamic theme color or fallback to black
                fontSize: 20,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'اختر طريقة الدفع',
                      labelStyle: TextStyle(
                        fontFamily: 'HacenSamra',
                        color: themeProvider
                                .themeData.textTheme.bodyMedium?.color ??
                            const Color.fromARGB(255, 255, 255,
                                255), // Using dynamic theme color or fallback to black
                      ),
                      suffixStyle: TextStyle(
                        fontFamily: 'HacenSamra',
                        color: themeProvider
                                .themeData.textTheme.bodyMedium?.color ??
                            const Color.fromARGB(255, 255, 255,
                                255), // Using dynamic theme color or fallback to black
                      ),
                    ),
                    value: _selectedPaymentMethod,
                    items:
                        _paymentMethods.map<DropdownMenuItem<String>>((method) {
                      return DropdownMenuItem<String>(
                        value: method[0] as String,
                        child: Row(
                          children: [
                            Image.network(
                              method[1] as String,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(method[0] as String),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'رقم البطاقة السري',
                      labelStyle: TextStyle(
                        fontFamily: 'HacenSamra',
                        // Using dynamic theme color or fallback to black
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Add value logic goes here
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'تأكيد',
                    style: TextStyle(
                      fontFamily: 'HacenSamra',
                      color: themeProvider
                              .themeData.textTheme.bodyMedium?.color ??
                          Colors
                              .black, // Using dynamic theme color or fallback to black
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'الغاء',
                    style: TextStyle(
                      fontFamily: 'HacenSamra',
                      color: themeProvider
                              .themeData.textTheme.bodyMedium?.color ??
                          Colors
                              .black, // Using dynamic theme color or fallback to black
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Added AppBar to match PlaygroundHomeScreen
            title: Text(
              'المحفظة',
              style: TextStyle(fontFamily: 'HacenSamra'),
            ),
          ),
          body: CustomScrollView(controller: _scrollController, slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              elevation: 0,
              pinned: true,
              stretch: true,
              toolbarHeight: 80,
              leading: null, // Set leading to null to remove the back icon
              actions: [
                IconButton(
                  icon: Icon(Icons.notification_add,
                      color: themeProvider.themeData.iconTheme.color),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more,
                      color: themeProvider.themeData.iconTheme.color),
                  onPressed: () {},
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              centerTitle: true,
              title: AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    const Text(
                      '\$ 1,840.00',
                      style: TextStyle(
                        // You can use themeProvider.themeData.colorScheme here
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: const EdgeInsets.only(left: 20, right: 20),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isScrolled ? 0.0 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'دل .',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 22,
                              fontFamily: 'HacenSamra',
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text(
                            '1,840.00',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onPressed: () {
                          _showAddValueDialog();
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'اضافة قيمة للمحفظة',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'HacenSamra',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 30,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 20,
                ),
                // Here start the section that I want to center
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    // Limiting the width of the container to prevent overflow
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              if (service[0] == 'ارسال لصديق') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ContactPage(),
                                  ),
                                );
                              } else if (service[0] == 'اضافة قيمة') {
                                _showAddValueDialog();
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      service[1],
                                      size: 25,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  service[0],
                                  style: TextStyle(
                                    fontFamily: 'HacenSamra',
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ]),
            ),
            SliverFillRemaining(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'اليوم',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'HacenSamra',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(' 1,840.00. دل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      _transactions[index][1],
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _transactions[index][0],
                                          style: TextStyle(
                                              color: Colors.grey.shade900,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _transactions[index][2],
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  _transactions[index][3],
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Iterable<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('جهات الاتصال'),
            titleTextStyle: TextStyle(
              fontFamily: 'HacenSamra',
              color: themeProvider
                      .themeData.appBarTheme.titleTextStyle?.color ??
                  Colors
                      .black, // Using dynamic theme color or fallback to black
              fontSize: 20,
            ),
          ),
          body: _contacts != null
              ? ListView.builder(
                  itemCount: _contacts!.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts!.elementAt(index);
                    return ListTile(
                      leading:
                          (contact.avatar != null && contact.avatar!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar!),
                                )
                              : CircleAvatar(child: Text(contact.initials())),
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text(
                        contact.phones!.isNotEmpty
                            ? contact.phones!.elementAt(0).value ??
                                'No phone number'
                            : 'No phone number',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                            Iconsax.card_send), // Removed hardcoded color
                        color: themeProvider.themeData.iconTheme
                            .color, // Using dynamic theme color
                        onPressed: () {
                          // Implement your transfer logic here
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
