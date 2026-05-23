import 'package:flutter/material.dart';

class ProductIcon extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;

  const ProductIcon({
    super.key,
    required this.iconName,
    this.size = 60,
    this.color,
  });

  // Map icon name string → Flutter IconData
  static IconData _getIcon(String name) {
    switch (name) {
      // Electronics
      case 'smartphone':   return Icons.smartphone;
      case 'laptop':       return Icons.laptop;
      case 'headphones':   return Icons.headphones;
      case 'tablet':       return Icons.tablet;
      case 'camera':       return Icons.camera_alt;
      case 'watch':        return Icons.watch;
      // Clothing
      case 'shirt':        return Icons.dry_cleaning;
      case 'dress':        return Icons.checkroom;
      case 'jeans':        return Icons.straighten;
      case 'jacket':       return Icons.ac_unit;
      case 'hoodie':       return Icons.wb_cloudy;
      case 'shorts':       return Icons.sports_soccer;
      // Footwear
      case 'sneakers':     return Icons.directions_run;
      case 'running_shoes':return Icons.directions_walk;
      case 'heels':        return Icons.favorite;
      case 'formal_shoes': return Icons.business_center;
      // Accessories
      case 'wallet':       return Icons.account_balance_wallet;
      case 'sunglasses':   return Icons.wb_sunny;
      case 'necklace':     return Icons.circle;
      case 'backpack':     return Icons.backpack;
      // Home & Kitchen
      case 'coffee':       return Icons.coffee;
      case 'air_fryer':    return Icons.microwave;
      case 'cookware':     return Icons.set_meal;
      case 'vacuum':       return Icons.cleaning_services;
      // Sports
      case 'yoga':         return Icons.self_improvement;
      case 'dumbbell':     return Icons.fitness_center;
      case 'helmet':       return Icons.sports_motorsports;
      case 'basketball':   return Icons.sports_basketball;
      default:             return Icons.inventory_2;
    }
  }

  // Map category → background color
  static Color _getCategoryColor(String iconName) {
    const electronics = ['smartphone','laptop','headphones','tablet','camera','watch'];
    const clothing    = ['shirt','dress','jeans','jacket','hoodie','shorts'];
    const footwear    = ['sneakers','running_shoes','heels','formal_shoes'];
    const accessories = ['wallet','sunglasses','necklace','backpack'];
    const kitchen     = ['coffee','air_fryer','cookware','vacuum'];
    const sports      = ['yoga','dumbbell','helmet','basketball'];

    if (electronics.contains(iconName)) return const Color(0xFFE8F4FD);
    if (clothing.contains(iconName))    return const Color(0xFFFCE4EC);
    if (footwear.contains(iconName))    return const Color(0xFFF3E5F5);
    if (accessories.contains(iconName)) return const Color(0xFFFFF8E1);
    if (kitchen.contains(iconName))     return const Color(0xFFE8F5E9);
    if (sports.contains(iconName))      return const Color(0xFFFFEBEE);
    return const Color(0xFFF5F5F5);
  }

  static Color _getIconColor(String iconName) {
    const electronics = ['smartphone','laptop','headphones','tablet','camera','watch'];
    const clothing    = ['shirt','dress','jeans','jacket','hoodie','shorts'];
    const footwear    = ['sneakers','running_shoes','heels','formal_shoes'];
    const accessories = ['wallet','sunglasses','necklace','backpack'];
    const kitchen     = ['coffee','air_fryer','cookware','vacuum'];
    const sports      = ['yoga','dumbbell','helmet','basketball'];

    if (electronics.contains(iconName)) return const Color(0xFF1565C0);
    if (clothing.contains(iconName))    return const Color(0xFFC2185B);
    if (footwear.contains(iconName))    return const Color(0xFF6A1B9A);
    if (accessories.contains(iconName)) return const Color(0xFFF57F17);
    if (kitchen.contains(iconName))     return const Color(0xFF2E7D32);
    if (sports.contains(iconName))      return const Color(0xFFB71C1C);
    return const Color(0xFF6C63FF);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getCategoryColor(iconName),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIcon(iconName),
        size: size,
        color: color ?? _getIconColor(iconName),
      ),
    );
  }
}
