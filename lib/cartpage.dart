import 'package:flutter/material.dart';
class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({required this.id, required this.title, required this.price, required this.quantity});
}

class CartPage extends StatelessWidget {
  final List<CartItem> cartItems = [
    CartItem(id: '1', title: 'Route A to B', price: 10.0, quantity: 2),
    CartItem(id: '2', title: 'Route C to D', price: 15.0, quantity: 1),
    // Add more cart items here
  ];

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text('\$${cartItems[index].price}'),
                        ),
                      ),
                    ),
                    title: Text(cartItems[index].title),
                    subtitle: Text('Total: \$${(cartItems[index].price * cartItems[index].quantity)}'),
                    trailing: Text('${cartItems[index].quantity} x'),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text('\$$total', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.purple,
                  ),
                  TextButton(
                    onPressed: () {
                      // Proceed to payment logic
                    },
                    child: Text('ORDER NOW'),
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
