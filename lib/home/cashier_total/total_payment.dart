import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';
import '../../components/custom_total_payment_card.dart';
import '../../components/custom_cart_card.dart';

class TotalPaymentPage extends StatefulWidget {
  @override
  _TotalPaymentPageState createState() => _TotalPaymentPageState();
}

class _TotalPaymentPageState extends State<TotalPaymentPage> {
  late List<Product> _cart;

  @override
  void initState() {
    super.initState();
    _cart = List.from(
        Provider.of<ProductProvider>(context, listen: false).cart); // Load cart
  }

  void _removeFromCart(Product product) {
    Provider.of<ProductProvider>(context, listen: false).deleteFromCart(product);
    setState(() {
      _cart.removeWhere((item) => item.id == product.id); // Update local cart
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} removed from cart!')),
    );
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
    Provider.of<ProductProvider>(context, listen: false).saveCart(_cart);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment completed, cart cleared!')),
    );
    Navigator.pop(context, _cart);
  }

  void _confirmPayment() {
    showDialog(
      context: context,
      builder: (context) => CustomTotalPaymentCard(
        totalItems: _cart.length,
        totalPrice: _cart.fold(0.0, (sum, product) => sum + product.price),
        onComplete: () {
          _clearCart(); // Clear cart on completion
        },
      ),
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
        color: Colors.white,
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
                          onRemove: () => _removeFromCart(product), // Use updated method
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.blue[50],
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
                    onPressed: _confirmPayment, // Show custom confirmation dialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Complete Payment',
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
