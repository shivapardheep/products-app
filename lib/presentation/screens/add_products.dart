import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/utils/app_color.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({super.key});

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const HeadWidget(),
                      const SizedBox(height: 15),
                      BodyWidget(
                          productNameController: productNameController,
                          descriptionController: descriptionController,
                          priceController: priceController,
                          discountController: discountController),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  // top: 10,
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // loginFun();
                          // Handle login logic with email and password
                        }
                      },
                      child: const Text(
                        'ADD PRODUCT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({
    super.key,
    required this.productNameController,
    required this.descriptionController,
    required this.priceController,
    required this.discountController,
  });

  final TextEditingController productNameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController discountController;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    pickImageFun() async {
      var imageData =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageData != null) {
        setState(() {
          _image = File(imageData.path);
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          _image != null
              ? Image.file(
                  _image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : PicImageWidget(
                  onTap: () {
                    pickImageFun();
                  },
                ),
          _image != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  icon: const Icon(Icons.restart_alt))
              : Container(),
          const SizedBox(height: 20),
          TextFieldWidget(
            title: "Product name",
            subTitle: "Enter your product name",
            controller: widget.productNameController,
          ),
          const SizedBox(height: 20),
          TextFieldWidget(
            title: "Product description",
            subTitle: "Enter your product brief description",
            controller: widget.descriptionController,
            isAddress: true,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              // alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 10,
              children: [
                CustomContainerWidget(
                  title: "price",
                  subTitle: '00,000',
                  icon: Icons.price_change_outlined,
                  controller: widget.priceController,
                ),
                CustomContainerWidget(
                  title: "Discount",
                  subTitle: '0%',
                  icon: Icons.discount,
                  controller: widget.discountController,
                  iconColor: Colors.deepPurple,
                  isPrice: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          // const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class CustomContainerWidget extends StatefulWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final bool isPrice;
  final Color iconColor;
  final TextEditingController controller;

  const CustomContainerWidget(
      {super.key,
      required this.title,
      required this.icon,
      this.isPrice = true,
      required this.controller,
      required this.subTitle,
      this.iconColor = Colors.black});

  @override
  State<CustomContainerWidget> createState() => _CustomContainerWidgetState();
}

class _CustomContainerWidgetState extends State<CustomContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.borderColor)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("\t*",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold))
                ],
              ),
              Icon(widget.icon, color: widget.iconColor),
            ],
          ),
          Divider(
            color: AppColor.borderColor,
            thickness: 1,
          ),
          // const SizedBox(height: 20),
          Row(
            children: [
              widget.isPrice
                  ? const Text("R\$\t",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20))
                  : Container(),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: widget.controller,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: widget.subTitle,
                    hintStyle:
                        const TextStyle(fontSize: 20, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty && widget.isPrice) {
                      return "please enter ${widget.title}";
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final TextEditingController controller;
  final bool isNumber;
  final bool isAddress;

  const TextFieldWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.controller,
    this.isNumber = false,
    this.isAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text("\t*",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColor.secondGrey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            keyboardType: isAddress
                ? TextInputType.streetAddress
                : isNumber
                    ? TextInputType.number
                    : TextInputType.text,
            controller: controller,
            decoration: InputDecoration(
              hintText: subTitle,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "please enter $title";
              }
            },
          ),
        ),
      ],
    );
  }
}

class PicImageWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PicImageWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: DottedBorder(
          strokeWidth: 2.5, // Set the border width here

          dashPattern: const [10],
          color: AppColor.borderColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(5),
          // padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 150,
              width: double.infinity,
              color: AppColor.secondGrey,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Color(0xffD4C9D1),
                  ),
                  Text(
                    "Upload a product picture",
                    style: TextStyle(color: Color(0xffD4C9D1), fontSize: 20),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeadWidget extends StatelessWidget {
  const HeadWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
        const Expanded(
            flex: 4,
            child: Text(
              "NEW PRODUCTS",
              style: TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            )),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}
