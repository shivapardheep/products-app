import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/data/models/products_serilize.dart';
import 'package:test_app/core/utils/app_color.dart';
import 'package:test_app/core/utils/app_functions.dart';
import 'package:test_app/core/utils/navigation_function.dart';
import 'package:test_app/presentation/screens/widgets/product_card.dart';

import '../bloc/filter/filter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  logoutFun() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => NavigationFun().navToLogin(context));
    // NavigationFun().navToLogin(context);
  }

  bool searchEnabled = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FilterBloc>().add(FilterProducts("", false));
  }

  List<ProductSerialize> dataList = [];
  bool loading = false;

  String qrResponse = "";
  scanQRCode() async {
    String qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#00B9F1', // Border color
      'Cancel',
      true,
      ScanMode.QR,
    );
    qrResponse = qrCode;

    if (qrResponse.contains("productId")) {
      AppFunctions()
          .toastFun(data: "Qr response : $qrResponse", positive: true);

      Map<String, dynamic> response = jsonDecode(qrResponse);
      String id = response['productId'];

      context.read<FilterBloc>().add(
            FilterProducts(id, true),
          );
    } else {
      AppFunctions().toastFun(data: "Failed!, Scan again", positive: false);
    }

    // Navigator.pop(context, qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.deepOrange,
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          searchEnabled
              ? Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: AppColor.containerGrey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              searchEnabled = false;
                            });
                          },
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {});
                              context.read<FilterBloc>().add(
                                    FilterProducts(
                                        searchController.text, false),
                                  );
                            },
                            onSaved: (query) {},
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        searchController.clear();
                                        setState(() {
                                          searchEnabled = false;
                                        });
                                        context.read<FilterBloc>().add(
                                              FilterProducts(
                                                  searchController.text, false),
                                            );
                                      },
                                      icon: const Icon(Icons.clear),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searchEnabled = true;
                    });
                  },
                  icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                scanQRCode();
              },
              icon: const Icon(Icons.qr_code_2_outlined)),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            debugPrint("state called : $state");
            if (state is FilterLoading) {
              loading = true;
            }
            if (state is FilteredData) {
              loading = false;
              debugPrint("~~~ called...");
              dataList = state.data;
            }
            if (state is FilterError) {
              loading = false;
              debugPrint("~~~ Error is : ${state.error} ");
            }
            if (state is QrFilteredData) {
              loading = false;
              ProductSerialize product = state.data[0];
              NavigationFun().navToProductDetailsScreen(context, product);

              debugPrint("~~~ Scanned data is  : ${state.data} ");
            }
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: AppColor.primaryColor,
                    ))
                  : GridView.builder(
                      itemCount: dataList.length,
                      // Fixed number of items (replace with dynamic function if needed)
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two items per row
                        crossAxisSpacing: 10.0, // Spacing between items
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          product: dataList[index],
                        );
                      },
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          NavigationFun().navToAddProductScreen(context);
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}
