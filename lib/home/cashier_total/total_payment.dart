import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';
import '../../components/custom_total_payment_card.dart';
import '../../components/custom_cart_card.dart';
import '../../components/notification_helper.dart'; // Tambahkan import

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
    NotificationHelper.showNotification(
      context,
      '${product.title} removed from cart!',
      isError: false,
    );
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
    Provider.of<ProductProvider>(context, listen: false).saveCart(_cart);
    NotificationHelper.showNotification(
      context,
      'Payment completed, cart cleared!',
      isError: false,
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
        title: Text(
          'Cart',
          style: TextStyle(
            fontFamily: 'Poppins', // Apply Poppins font
            fontWeight: FontWeight.w300, // Light weight
          ),
        ),
        backgroundColor: Colors.blueGrey, // Match theme
      ),
      body: Container(
        color: const Color(0xFFB9C5C5), // Match theme background color
        child: Column(
          children: [
            Expanded(
              child: _cart.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins', // Apply Poppins font
                          fontWeight: FontWeight.w300, // Light weight
                          color: Colors.blueGrey, // Match theme color
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
                          onRemove: () => _removeFromCart(product),
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.blueGrey[100], // Match theme background
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Colors.blueGrey[800], // Slightly darker text color
                      fontFamily: 'Poppins', // Apply Poppins font
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey, // Match theme color
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Square corners
                      ),
                    ),
                    child: Text(
                      'Complete Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins', // Apply Poppins font
                      ),
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
