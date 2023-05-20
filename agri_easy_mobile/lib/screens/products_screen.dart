import 'dart:convert';
import 'package:agri_easy/model/products_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color.fromARGB(255, 0, 100, 3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          "Products",
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 40,
                letterSpacing: 1),
          ),
        ),
      ),
      body: FutureBuilder(
        future: readJsonData(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            var items = data.data as List<ProductDataModel>;
            return Center(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      color: const Color.fromARGB(255, 219, 245, 219),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        items[index].name.toString(),
                                        style: GoogleFonts.dosis(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 30,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: items[index]
                                                      .category
                                                      .toString() ==
                                                  "Fertilizer"
                                              ? const Color.fromARGB(
                                                  255, 1, 150, 6)
                                              : items[index]
                                                          .category
                                                          .toString() ==
                                                      "Pesticide"
                                                  ? Colors.red
                                                  : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(
                                          items[index].category.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 94, 94, 94),
                                        width: 3,
                                      ),
                                    ),
                                    child: SizedBox(
                                      width: 180,
                                      height: 180,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          items[index].imageURL.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].type.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  items[index].desc.toString(),
                                  style: GoogleFonts.dosis(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Link(
                                  uri: Uri.parse(items[index].l!),
                                  target: LinkTarget.self,
                                  builder: (context, followLink) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        // ignore: deprecated_member_use
                                        if (await canLaunch(items[index].l!)) {
                                          followLink?.call();
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Could not launch link'),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                          horizontal: 35,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Buy',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<List<ProductDataModel>> readJsonData() async {
  final jsondata = await rootBundle.loadString('jsonfile/productlist.json');
  final list = json.decode(jsondata) as List<dynamic>;
  return list.map((e) => ProductDataModel.fromJson(e)).toList();
}
