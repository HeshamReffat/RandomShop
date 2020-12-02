import 'package:flutter/material.dart';
import 'package:random_shop/Providers/DataProvider.dart';

class FavoriteScreen extends StatefulWidget {
  var database = DataProvider();
  var itemDatabase;
  List<Map> product;

  FavoriteScreen({
    this.itemDatabase}
  );

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
        title: Text('Favorite'),
      ),
      body: ListView.separated(
          itemBuilder: (ctx, i) => itemBuilder(widget.product[i]),
          separatorBuilder: (ctx, i) => Divider(),
          itemCount: widget.product?.length ?? 0),
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
                image: NetworkImage('${product['image']}'),fit: BoxFit.cover,
              ),
              border: Border.all(),
            ),
          ),
          Padding(
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
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
