import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language/api/my_api.dart';
import 'package:language/models/product.dart';
import 'package:language/screens/customDialogue.dart';

class DetailProduct extends StatefulWidget {
  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  final _keyForm = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File imageCam;
  String imgBase64;
  final imagePicker = ImagePicker();

  uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      String extension = pickedImage.path.split('.').last;
      setState(() {
        imageCam = File(pickedImage.path);
        imgBase64 =
            "data:image/$extension;base64,${base64Encode(File(pickedImage.path).readAsBytesSync())}";
      });
    }
    print(imageCam);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void addEditProduct(bool added, int id) {
    if (added) {
      CallApi()
          .storeData(Product(
              name: _nameController.text,
              slug: _slugController.text,
              description: _descriptionController.text,
              price: int.parse(_priceController.text),
              image: imgBase64 ?? ""))
          .then((value) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialogue(
                title: "add product",
                message: value.message,
                cancel: false,
                icon: Icons.tag_faces_outlined,
                onClick: () => Navigator.pop(context),
              );
            });
      });
    } else {
      CallApi()
          .editData(Product(
              id: id,
              name: _nameController.text,
              slug: _slugController.text,
              description: _descriptionController.text,
              price: num.tryParse(_priceController.text).toInt(),
              image: imgBase64 ?? ""))
          .then((value) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialogue(
                title: "Edition produit",
                message: value.message,
                icon: Icons.tag_faces_outlined,
                cancel: false,
                onClick: () => Navigator.pop(context),
              );
            });
      });
    }

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context).settings.arguments as Map;
    final product = _arguments['product'];
    final mode = _arguments['mode'];
    _nameController.text = !mode ? product.name : null;
    _slugController.text = !mode ? product.slug : null;
    _descriptionController.text = !mode ? product.description : null;
    _priceController.text = !mode ? product.price.toString() : null;
    return Scaffold(
      appBar: AppBar(
        title: !mode ? Text("Editer produit") : Text('Nouveau produit'),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (_keyForm.currentState.validate()) {
                  addEditProduct(mode, mode ? null : product.id);
                }
              }),
        ],
        backgroundColor: Colors.lime,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ImageProduct(
                      mode: mode, product: product, imageCam: imageCam),
                  Positioned(
                    bottom: 5,
                    right: 2,
                    child: GestureDetector(
                      onTap: uploadImage,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white),
                        child: Icon(
                          Icons.camera,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _keyForm,
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Name product",
                        // errorText: "Please enter some text"
                        errorStyle: TextStyle(height: 0),
                      ),
                      controller: _nameController,
                      onChanged: (_) {
                        _slugController.text = _nameController.text
                            .trim()
                            .toLowerCase()
                            .replaceAll(" ", "-")
                            .replaceAll(".", "")
                            .replaceAll("'", "");
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Slug product",
                      ),
                      controller: _slugController,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Description product",
                      ),
                      maxLines: 8,
                      controller: _descriptionController,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please a valid number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "price product",
                        suffixText: "€"
                      ),
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_keyForm.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Processing Data ${_nameController.text}')));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// for test

class ImageProduct extends StatelessWidget {
  const ImageProduct({
    Key key,
    @required this.mode,
    @required this.product,
    @required this.imageCam,
  }) : super(key: key);

  final bool mode;
  final Product product;
  final File imageCam;

  @override
  Widget build(BuildContext context) {
    return imageCam != null
        ? Image.file(
            imageCam,
            height: 200,
            fit: BoxFit.fill,
          )
        : Image.network(
            !mode
                ? "http://192.168.1.33:8000/image/${product.image}"
                : "http://192.168.1.33:8000/image/55555.jpg",
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace stackTrace) {
              return  Image.asset(
                      "assets/images/Grace_Hopper.jpg",
                      height: 200,
                      fit: BoxFit.fill,
                    );

            },
          );
  }
}
