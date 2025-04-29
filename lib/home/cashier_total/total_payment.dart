import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../components/custom_total_payment_card.dart';
import '../../components/custom_cart_card.dart';

class TotalPaymentPage extends StatefulWidget {
  final List<Product> cart;

  const TotalPaymentPage({required this.cart});

  @override
  _TotalPaymentPageState createState() => _TotalPaymentPageState();
}

class _TotalPaymentPageState extends State<TotalPaymentPage> {
  late List<Product> _cart;

  @override
  void initState() {
    super.initState();
    _cart = List.from(widget.cart); // Copy the cart to allow modifications
  }

  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  void _showTotalPaymentDialog() {
    final total = _cart.fold(0.0, (sum, product) => sum + product.price);

    showDialog(
      context: context,
      builder: (context) {
        return CustomTotalPaymentCard(
          totalItems: _cart.length,
          totalPrice: total,
          onComplete: _clearCart,
        );
      },
    );
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment completed, cart cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _cart.fold(0.0, (sum, product) => sum + product.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white, // Latar belakang putih
        child: Column(
          children: [
            Expanded(
              child: _cart.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _cart.length,
                      itemBuilder: (context, index) {
                        final product = _cart[index];
                        return CustomCartCard(
                          title: product.title,
                          subtitle: '\$${product.price.toStringAsFixed(2)}',
                          imageUrl: product.image,
                          onRemove: () => _removeFromCart(index),
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.blue[50], // Latar belakang putih kebiruan untuk section total
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showTotalPaymentDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Show Total Payment',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
