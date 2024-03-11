import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/core/utils/app_color.dart';
import 'package:test_app/core/utils/navigation_function.dart';
import 'package:test_app/presentation/screens/widgets/product_card.dart';

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
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {});
                              },
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
                onPressed: () {}, icon: const Icon(Icons.qr_code_2_outlined)),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: GridView.builder(
              itemCount:
                  20, // Fixed number of items (replace with dynamic function if needed)
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 10.0, // Spacing between items
                mainAxisSpacing: 10.0,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return const ProductCardWidget();
              },
            ),
          ),
        ));
  }
}
