import 'package:e_commerce_app/providers/product_model.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const ROUTE_NAME = '/addProductScreen';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _imageURLNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  TextEditingController imgUrlController = TextEditingController();

  bool isLoading = false;

  Product _editedProduct = Product(
    description: '',
    imageUrl: '',
    price: 0,
    title: '',
    id: null,
  );

  var _initialData = {
    'title': '',
    'price': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    imgUrlController.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      if (_editedProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .editProduct(_editedProduct.id, _editedProduct);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(true);
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (e) {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('ERROR'),
                content: Text('An unexpected error just happened'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } finally {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        }
      }
    }
  }

  bool once = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (once) {
      final String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findItemById(productId);
        _initialData = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        imgUrlController.text = _editedProduct.imageUrl;
      }
    }
    once = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initialData['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Title',
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          //FocusScope.of(context).requestFocus(_priceFocusNode);
                          _priceFocusNode.requestFocus();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Title missing.';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct.title = value;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialData['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: 'Price',
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          //FocusScope.of(context).requestFocus(_descriptionFocusNode);
                          _descriptionFocusNode.requestFocus();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price missing';
                          } else if (double.tryParse(value) == null) {
                            return 'invalid number';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct.price = double.parse(value);
                        },
                      ),
                      TextFormField(
                        initialValue: _initialData['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Description',
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description missing!';
                          } else if (value.length < 10) {
                            return 'Description can\'t be less than 10 characters.';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct.description = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: imgUrlController.text.isEmpty
                                ? Center(
                                    child: Text('Enter URL'),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        AssetImage(imgUrlController.text),
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              focusNode: _imageURLNode,
                              controller: imgUrlController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your URL';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _editedProduct.imageUrl = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 10,
                        height: 50,
                        child: RaisedButton(
                          child: Text('Save'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: () {
                            _saveForm();
                          },
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
