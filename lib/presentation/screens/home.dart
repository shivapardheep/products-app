import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/data/models/products_serilize.dart';
import 'package:test_app/core/utils/app_color.dart';
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

  scanner() async {
    return AiBarcodeScanner(
      onScan: (String value) {
        debugPrint(value);
      },
      onDetect: (BarcodeCapture barcodeCapture) {
        debugPrint(barcodeCapture as String?);
      },
    );
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AiBarcodeScanner(
                              onScan: (String value) {
                                debugPrint(value);
                              },
                              onDetect: (BarcodeCapture barcodeCapture) {
                                debugPrint(barcodeCapture as String?);
                              },
                            )));
                // context.read<FilterBloc>().add(FilterProducts("", false));
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
