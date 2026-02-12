import 'package:co_ui/models/item_model.dart';
import 'package:co_ui/screens/checkout_page.dart';
import 'package:co_ui/widgets/cart_item.dart';
import 'package:co_ui/widgets/header_widget.dart';
import 'package:co_ui/widgets/promo_widget.dart';
import 'package:co_ui/widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Data Barang (Simulasi Database)
  List<CartItemModel> items = [
    CartItemModel(
      id: '1',
      title: 'Mie Goreng Spesial',
      imageUrl:
          'https://images.unsplash.com/photo-1552611052-33e04de081de?q=80&w=200&auto=format&fit=crop',
      time: '15-20 mnt',
      rating: 4.9,
      reviewCount: 12165,
      price: 25000, // Harga dalam Rupiah
      quantity: 1,
    ),
    CartItemModel(
      id: '2',
      title: 'Sate Ayam Madura',
      imageUrl:
          'https://images.unsplash.com/photo-1532550907401-a500c9a57435?q=80&w=200&auto=format&fit=crop',
      time: '15-20 mnt',
      rating: 4.8,
      reviewCount: 8500,
      price: 35000, // Harga dalam Rupiah
      quantity: 1,
    ),
  ];

  // Konstanta Biaya Lain
  final double discount = 10000;
  final double deliveryFee = 12000;
  final double taxFee = 5000;

  // Helper untuk Format Rupiah
  String formatRupiah(double number) {
    return "Rp ${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // Menghitung Total Harga Barang (Subtotal)
  double get orderAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Menghitung Total Akhir yang Harus Dibayar
  double get totalAmount {
    return orderAmount - discount + deliveryFee + taxFee;
  }

  void incrementQty(int index) {
    setState(() {
      items[index].quantity++;
    });
  }

  void decrementQty(int index) {
    setState(() {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Konten yang bisa discroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const HeaderSection(),
                    const SizedBox(height: 24),

                    // List Items (Looping dari data list)
                    ...List.generate(items.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CartItemWidget(
                          item: items[index],
                          onAdd: () => incrementQty(index),
                          onRemove: () => decrementQty(index),
                          formatCurrency: formatRupiah,
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // Bagian Kode Promo
                    const PromoSection(),

                    const SizedBox(height: 30),

                    // Ringkasan Pesanan
                    const Text(
                      "Ringkasan Pesanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Menampilkan Angka Dinamis
                    SummaryRow(
                      label: "Total Pesanan",
                      value: formatRupiah(orderAmount),
                    ),
                    SummaryRow(
                      label: "Kode Promo",
                      value: "-${formatRupiah(discount)}",
                      isDiscount: true,
                    ),
                    SummaryRow(
                      label: "Ongkir",
                      value: formatRupiah(deliveryFee),
                    ),
                    SummaryRow(label: "Pajak", value: formatRupiah(taxFee)),

                    const SizedBox(height: 16),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 20,
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formatRupiah(totalAmount),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEE7956),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ), // Memberi ruang di bawah agar tidak tertutup tombol
                  ],
                ),
              ),
            ),

            // Tombol Checkout (Fixed di bawah atau ikut scroll, di sini saya buat di luar scroll agar selalu terlihat)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          orderAmount: orderAmount,
                          discount: discount,
                          deliveryFee: deliveryFee,
                          taxFee: taxFee,
                          totalAmount: totalAmount,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Lanjut Pembayaran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
