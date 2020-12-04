import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_shop/Models/CustomWidgets.dart';
import 'package:random_shop/Providers/DataProvider.dart';
import 'package:random_shop/Screens/FavoriteScreen.dart';

class HomeScreen extends StatefulWidget {
  var itemsDatabase;
  List<Map> product;

  HomeScreen({this.itemsDatabase, this.product});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var database = DataProvider();
  TextEditingController _searchController = TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   database.createDatabase().then((value) {
  //     if (value != null) itemsDatabase = value;
  //     database.getData(value).then((value) {
  //       setState(() {
  //         product = value;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Shop',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.add_circle,color: Colors.green,size: 35,), onPressed: () => addItem(context),),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(Icons.search,size: 30,color: Colors.grey,),
                            ),
                            Expanded(
                              child: customFormField(
                                  controller: _searchController,
                                  type: TextInputType.name,
                                  hint: 'Search',
                                  borderColor: Colors.transparent,
                                  changed: (String name) {
                                    database
                                        .searchItem(widget.itemsDatabase, name)
                                        .then((value) {
                                      setState(() {
                                        widget.product = value;
                                      });
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, i) => itemBuilder(widget.product[i]),
                    separatorBuilder: (ctx, i) => Divider(),
                    itemCount: widget.product?.length ?? 0),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () => addItem(context),
      // ),
    );
  }

  Widget itemBuilder(Map product) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${product['image']}'),fit: BoxFit.cover,
              ),
              border: Border.all(width: 1),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 80,
                    color: Colors.red,
                    child: Center(
                        child: Text(
                      '${product['discount']}% OFF',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${product['name']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'EGP ${product['price']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'EGP ${product['offer']}',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        child: IconButton(
                          icon: Icon(Icons.favorite,
                              color: product['favorite'] == 1
                                  ? Colors.red
                                  : Colors.grey),
                          onPressed: () {
                            database
                                .updateFavorite(
                                    database: widget.itemsDatabase,
                                    favorite: product['favorite'] == 0 ? 1 : 0,
                                    id: product['id'])
                                .then((value) {
                              setState(() {
                                database.getData(widget.itemsDatabase).then((value) {
                                  setState(() {
                                    widget.product = value;
                                  });
                                });
                              });
                            });
                          },
                        ),
                        backgroundColor: Colors.grey[200],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void addItem(BuildContext context) {
    final _form = GlobalKey<FormState>();
    TextEditingController imageController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController offerController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Center(child: Text('Add Item')),
        content: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: customFormField(
                        controller: imageController,
                        type: TextInputType.url,
                        hint: 'Item Image Url',
                        isPassword: false,
                        valid: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('jpeg')) {
                            return 'Please enter a valid image Form';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: customFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        hint: 'Item Name',
                        isPassword: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: customFormField(
                        controller: priceController,
                        type: TextInputType.number,
                        hint: 'Price',
                        isPassword: false,
                        valid: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a number';
                          }
                          if (value == null) {
                            return 'Please enter a valid number';
                          }
                          // if (value.length < 12) {
                          //   return 'Please enter a Complete phone number';
                          // }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: customFormField(
                        controller: offerController,
                        type: TextInputType.number,
                        hint: 'Offer',
                        isPassword: false,
                        valid: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a number';
                          }
                          if (value == null) {
                            return 'Please enter a valid number';
                          }
                          // if (value.length < 12) {
                          //   return 'Please enter a Complete phone number';
                          // }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.alternate_email,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: customFormField(
                        controller: discountController,
                        type: TextInputType.number,
                        hint: 'Discount %',
                        isPassword: false,
                        valid: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a Discount';
                          }
                          if (value == null) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                customButton(
                    text: 'Save',
                    function: () {
                      final isValid = _form.currentState.validate();
                      if (!isValid) {
                        return;
                      }
                      String image = imageController.text;
                      String name = nameController.text;
                      String price = priceController.text;
                      String offer = offerController.text;
                      String discount = discountController.text;
                      if (image.isEmpty ||
                          name.isEmpty ||
                          price.isEmpty ||
                          offer.isEmpty ||
                          discount.isEmpty) {
                        Fluttertoast.showToast(msg: 'please complete fields');
                        return;
                      }
                      database
                          .insertData(
                        database: widget.itemsDatabase,
                        image: image,
                        name: name,
                        price: int.parse(price),
                        offer: int.parse(offer),
                        discount: int.parse(discount),
                      )
                          .then((value) {
                        database.getData(widget.itemsDatabase).then((value) {
                          setState(() {
                            widget.product = value;
                          });
                        });
                        Fluttertoast.showToast(
                            msg: 'Contact Updated Successfully',
                            backgroundColor: Colors.green);
                        Navigator.pop(context);
                      });
                    }),
                SizedBox(
                  height: 10,
                ),
                customButton(
                  text: 'Cancel',
                  function: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
