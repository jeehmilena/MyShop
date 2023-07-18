import 'package:flutter/material.dart';
import 'package:my_shop/models/product_list_model.dart';
import 'package:my_shop/models/product_model.dart';
import 'package:provider/provider.dart';

class FormProduct extends StatefulWidget {
  const FormProduct({Key? key}) : super(key: key);

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final priceFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final imageUrlFocus = FocusNode();
  final imageUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
    imageUrlFocus.removeListener(updateImage);
    imageUrlFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formData.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null) {
        final product = args as ProductModel;
        formData['id'] = product.id;
        formData['name'] = product.title;
        formData['price'] = product.price;
        formData['description'] = product.description;
        formData['imageUrl'] = product.imageUrl;

        imageUrlController.text = product.imageUrl;
      }
    }
  }

  void updateImage() {
    setState(() {});
  }

  void submitForm() {
    final isFormValidate = formKey.currentState?.validate() ?? false;

    if (!isFormValidate) {
      return;
    }

    formKey.currentState?.save();
    Provider.of<ProductListModel>(
      context,
      listen: false,
    ).saveProduct(formData);
    Navigator.of(context).pop();
  }

  bool isValidUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    return isValidUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: formData['name'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(descriptionFocus);
                  },
                  onSaved: (name) => formData['name'] = name ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: formData['description'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  focusNode: descriptionFocus,
                  maxLines: 3,
                  onSaved: (description) => formData['description'] = description ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: formData['price'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: priceFocus,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  onSaved: (price) => formData['price'] = double.parse(price ?? '0'),
                  validator: (price) {
                    final priceString = price ?? '';
                    final priceFinal = double.tryParse(priceString) ?? -1;

                    if (priceFinal <= 0) {
                      return 'Provide a valid price!';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                        focusNode: imageUrlFocus,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: imageUrlController,
                        onFieldSubmitted: (_) {
                          submitForm();
                        },
                        onSaved: (imageUrl) => formData['imageUrl'] = imageUrl ?? '',
                        validator: (url) {
                          final imageUrl = url ?? '';
                          if (!isValidUrl(imageUrl)) {
                            return 'Provide a valid URL!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(top: 20, left: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: imageUrlController.text.isEmpty
                            ? Text(
                                'Inform the URL image',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              )
                            : FittedBox(
                                child: Image.network(
                                  imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitForm,
        backgroundColor: Colors.pinkAccent,
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}
