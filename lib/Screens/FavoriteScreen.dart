import 'package:flutter/material.dart';
import 'package:random_shop/Providers/DataProvider.dart';
import 'package:random_shop/Screens/HomeScreen.dart';

class FavoriteScreen extends StatefulWidget {
  var database = DataProvider();
  var itemDatabase;
  List<Map> product;

  FavoriteScreen({this.itemDatabase});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.database.favoriteItem(widget.itemDatabase).then((value) {
      setState(() {
        widget.product = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Favorite',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (ctx, i) => itemBuilder(widget.product[i]),
            separatorBuilder: (ctx, i) => Divider(),
            itemCount: widget.product?.length ?? 0),
      ),
    );
  }

  Widget itemBuilder(Map product) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${product['image']}'),
                fit: BoxFit.cover,
              ),
              border: Border.all(),
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
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              child: AlertDialog(
                                title: Center(
                                  child: Text('Remove'),
                                ),
                                content: Text(
                                    'Remove ${product['name']} from Favorite'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      widget.database
                                          .updateFavorite(
                                          database: widget.itemDatabase,
                                          favorite: 0,
                                          id: product['id'])
                                          .then((value) {
                                        setState(() {
                                          widget.database
                                              .favoriteItem(widget.itemDatabase)
                                              .then((value) {
                                            setState(() {
                                              widget.product = value;
                                            });
                                          });
                                        });
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes'),
                                  ),
                                  FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('No')),
                                ],
                              ),
                            );
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
}
