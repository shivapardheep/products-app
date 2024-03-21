import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:test_app/core/data/models/products_serilize.dart';
import 'package:test_app/core/utils/app_color.dart';

import '../../core/utils/app_functions.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductSerialize product;

  const ProductDetailsScreen({super.key, required this.product});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  Future<void> _requestPermissions() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      debugPrint("~~~Permission Granted...");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // downloadQr() async {
  //   await _requestPermissions();
  //   var data =
  //       '{"name": ${widget.product.name},"productId": ${widget.product.productId}}';
  //
  //   /// start
  //   final qrPainter = QrPainter(
  //     data: data,
  //     version: QrVersions.auto,
  //     // size: 200.0,
  //     gapless: false,
  //     errorCorrectionLevel: QrErrorCorrectLevel.H,
  //   );
  //   final downloadDirectory = await getDownloadsDirectory();
  //
  //   final image = await qrPainter.toImage(200);
  //   final bytes = await image.toByteData(format: ImageByteFormat.png);
  //   String filename = '${DateTime.now().toString()}.png';
  //   final file = File('${downloadDirectory!.path}/$filename');
  //
  //   var res = await file.writeAsBytes(bytes!.buffer.asUint8List());
  //   print('~~~ path  ${file.path}');
  //
  //   print('QR Image saved to $res');
  //   AppFunctions().toastFun(data: "QR Image saved to ($res)", positive: true);
  // }

  // String qrCode = '{"name": "red shirt","productId": "sDXQLpMEsmFhF8gJKmPY"}';

  Future<void> _downloadQRCode() async {
    var jsonData = {
      "name": widget.product.name.toString(),
      "productId": widget.product.productId.toString()
    };
    debugPrint("~~~ : $jsonData");
    debugPrint("~~~ : ${jsonEncode(jsonData)}");
    String data = jsonEncode(jsonData);
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      // size: 200.0,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
    String? downloadDirectoryPath = await getDownloadDirectoryPath();

    final image = await qrPainter.toImage(200);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    String filename = removeSpaces(DateTime.now().toString());
    final file = File('$downloadDirectoryPath/$filename.png');
    var res = await file.writeAsBytes(bytes!.buffer.asUint8List());
    debugPrint("~~~ file: ${file}");
    AppFunctions().toastFun(data: "QR Image saved", positive: true);
  }

  // removing space and special symbols
  String removeSpaces(String text) {
    return text.replaceAll(RegExp(r"\s|-|:"), "");
  }

  @override
  Widget build(BuildContext context) {
    var data =
        '{"name": ${widget.product.name},"productId": ${widget.product.productId}}';

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColor.containerGrey,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Hero(
                          tag: widget.product.productId,
                          child: Image.network(widget.product.images)),
                    ),
                    Positioned(
                      top: 30,
                      left: 20,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColor.primaryColor.withOpacity(0.1),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColor.primaryColor,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.name.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Text(
                            "\$${widget.product.price}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColor.primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 30),
                          SizedBox(width: 5),
                          Text("4.5",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(width: 5),
                          Text("(20 reviews)",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const Text("QR Code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: QrImageView(
                              data: data,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.purple,
                            ),
                            // shiva12345
                            child: IconButton(
                                onPressed: () {
                                  // downloadQr();
                                  _downloadQRCode();
                                },
                                icon: const Icon(Icons.download)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'ORDER NOW',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
