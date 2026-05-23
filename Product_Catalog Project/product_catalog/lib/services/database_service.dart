import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/user.dart';

class DatabaseService {
  static Database? _database;

  // ─── SAMPLE USERS (10 users) ─────────────────────────────
  static final List<Map<String, dynamic>> _sampleUsers = [
    {'id': 1,  'name': 'M Kamran Haider', 'email': 'kamran@gmail.com',  'password': '123456'},
    {'id': 2,  'name': 'Ahmad Zia',        'email': 'ahmad@gmail.com',   'password': '123456'},
    {'id': 3,  'name': 'Ali Hassan',       'email': 'ali@gmail.com',     'password': '123456'},
    {'id': 4,  'name': 'Sara Khan',        'email': 'sara@gmail.com',    'password': '123456'},
    {'id': 5,  'name': 'Fatima Malik',     'email': 'fatima@gmail.com',  'password': '123456'},
    {'id': 6,  'name': 'Usman Tariq',      'email': 'usman@gmail.com',   'password': '123456'},
    {'id': 7,  'name': 'Zara Ahmed',       'email': 'zara@gmail.com',    'password': '123456'},
    {'id': 8,  'name': 'Bilal Raza',       'email': 'bilal@gmail.com',   'password': '123456'},
    {'id': 9,  'name': 'Hina Shahid',      'email': 'hina@gmail.com',    'password': '123456'},
    {'id': 10, 'name': 'Omar Farooq',      'email': 'omar@gmail.com',    'password': '123456'},
  ];

  // ─── LOCAL PRODUCTS (50 products) ────────────────────────
  static final List<Map<String, dynamic>> _localProducts = [
    // Electronics (8)
    {'id': 1,  'title': 'Samsung Galaxy S24 Ultra',    'description': 'Latest Samsung flagship with 200MP camera, Snapdragon 8 Gen 3 and 5000mAh battery.',         'category': 'Electronics',   'image': 'smartphone',    'price': 1299.99, 'isFavorite': 0},
    {'id': 2,  'title': 'Apple MacBook Pro 16"',       'description': 'Powerful laptop with M3 Pro chip, 18GB RAM, 512GB SSD and 22-hour battery life.',             'category': 'Electronics',   'image': 'laptop',        'price': 2499.99, 'isFavorite': 0},
    {'id': 3,  'title': 'Sony WH-1000XM5',             'description': 'Industry-leading noise canceling headphones with 30-hour battery and multipoint connection.',  'category': 'Electronics',   'image': 'headphones',    'price': 349.99,  'isFavorite': 0},
    {'id': 4,  'title': 'iPad Pro 12.9"',              'description': 'Apple iPad Pro with M2 chip, Liquid Retina XDR display and ProRes video support.',            'category': 'Electronics',   'image': 'tablet',        'price': 1099.99, 'isFavorite': 0},
    {'id': 5,  'title': 'Canon EOS R6 Mark II',        'description': 'Full-frame mirrorless camera with 40fps shooting, 4K video and dual card slots.',             'category': 'Electronics',   'image': 'camera',        'price': 2499.00, 'isFavorite': 0},
    {'id': 6,  'title': 'Apple Watch Series 9',        'description': 'Smartwatch with Double Tap gesture, always-on display, ECG app and 18-hour battery.',         'category': 'Electronics',   'image': 'watch',         'price': 399.99,  'isFavorite': 0},
    {'id': 7,  'title': 'Samsung 4K Smart TV 55"',     'description': '55-inch QLED 4K Smart TV with Quantum HDR, built-in Alexa and 120Hz refresh rate.',          'category': 'Electronics',   'image': 'tablet',        'price': 799.99,  'isFavorite': 0},
    {'id': 8,  'title': 'Google Pixel 8 Pro',          'description': 'Google flagship phone with Tensor G3 chip, 50MP camera and 7-year OS update guarantee.',      'category': 'Electronics',   'image': 'smartphone',    'price': 999.99,  'isFavorite': 0},
    // Clothing (8)
    {'id': 9,  'title': "Men's Classic Fit Shirt",     'description': 'Premium 100% cotton classic fit shirt. Perfect for formal and semi-formal occasions.',         'category': 'Clothing',      'image': 'shirt',         'price': 49.99,   'isFavorite': 0},
    {'id': 10, 'title': "Women's Floral Summer Dress", 'description': 'Lightweight floral print summer dress with A-line silhouette and adjustable straps.',          'category': 'Clothing',      'image': 'dress',         'price': 59.99,   'isFavorite': 0},
    {'id': 11, 'title': "Men's Slim Fit Jeans",        'description': 'Premium stretch denim slim fit jeans with 5-pocket design for everyday wear.',                 'category': 'Clothing',      'image': 'jeans',         'price': 79.99,   'isFavorite': 0},
    {'id': 12, 'title': "Women's Leather Jacket",      'description': 'Genuine leather biker jacket with quilted shoulders, zip pockets and adjustable belt.',        'category': 'Clothing',      'image': 'jacket',        'price': 199.99,  'isFavorite': 0},
    {'id': 13, 'title': 'Unisex Hooded Sweatshirt',    'description': 'Cozy fleece-lined hoodie with kangaroo pocket and adjustable drawstring.',                     'category': 'Clothing',      'image': 'hoodie',        'price': 44.99,   'isFavorite': 0},
    {'id': 14, 'title': "Men's Running Shorts",        'description': 'Lightweight moisture-wicking running shorts with built-in liner and zip pocket.',              'category': 'Clothing',      'image': 'shorts',        'price': 34.99,   'isFavorite': 0},
    {'id': 15, 'title': "Women's Yoga Leggings",       'description': 'High-waist compression leggings with 4-way stretch fabric and hidden waistband pocket.',      'category': 'Clothing',      'image': 'shorts',        'price': 54.99,   'isFavorite': 0},
    {'id': 16, 'title': "Men's Formal Suit",           'description': 'Two-piece slim fit suit in premium wool blend. Perfect for business and formal events.',       'category': 'Clothing',      'image': 'shirt',         'price': 299.99,  'isFavorite': 0},
    // Footwear (8)
    {'id': 17, 'title': 'Nike Air Max 270',            'description': 'Iconic Nike sneakers with the largest Air unit heel for all-day comfort.',                     'category': 'Footwear',      'image': 'sneakers',      'price': 149.99,  'isFavorite': 0},
    {'id': 18, 'title': 'Adidas Ultraboost 23',        'description': 'Premium running shoes with energy-returning Boost midsole and Primeknit+ upper.',             'category': 'Footwear',      'image': 'running_shoes', 'price': 189.99,  'isFavorite': 0},
    {'id': 19, 'title': "Women's Heel Sandals",        'description': 'Elegant block heel sandals with adjustable ankle strap and cushioned footbed.',                'category': 'Footwear',      'image': 'heels',         'price': 89.99,   'isFavorite': 0},
    {'id': 20, 'title': "Men's Oxford Shoes",          'description': 'Classic leather Oxford shoes with Goodyear welt construction and cap-toe design.',            'category': 'Footwear',      'image': 'formal_shoes',  'price': 129.99,  'isFavorite': 0},
    {'id': 21, 'title': 'Puma RS-X Sneakers',          'description': 'Chunky retro-inspired sneakers with RS cushioning system and breathable mesh upper.',         'category': 'Footwear',      'image': 'sneakers',      'price': 119.99,  'isFavorite': 0},
    {'id': 22, 'title': 'New Balance 990v6',           'description': 'Made in USA premium running shoe with dual-density collar foam and blown rubber outsole.',     'category': 'Footwear',      'image': 'running_shoes', 'price': 184.99,  'isFavorite': 0},
    {'id': 23, 'title': "Women's Ballet Flats",        'description': 'Comfortable leather ballet flats with cushioned insole. Slip-on design for easy wear.',       'category': 'Footwear',      'image': 'heels',         'price': 69.99,   'isFavorite': 0},
    {'id': 24, 'title': 'Timberland Boots',            'description': 'Waterproof leather work boots with anti-fatigue footbed and rubber lug outsole.',             'category': 'Footwear',      'image': 'formal_shoes',  'price': 219.99,  'isFavorite': 0},
    // Accessories (7)
    {'id': 25, 'title': 'Leather Wallet',              'description': 'Slim genuine leather bifold wallet with 6 card slots and RFID blocking technology.',          'category': 'Accessories',   'image': 'wallet',        'price': 39.99,   'isFavorite': 0},
    {'id': 26, 'title': 'Aviator Sunglasses',          'description': 'Classic aviator sunglasses with UV400 protection and polarized lenses.',                      'category': 'Accessories',   'image': 'sunglasses',    'price': 29.99,   'isFavorite': 0},
    {'id': 27, 'title': 'Gold Chain Necklace',         'description': '18K gold plated 20-inch chain necklace with lobster clasp and tarnish-resistant coating.',    'category': 'Accessories',   'image': 'necklace',      'price': 24.99,   'isFavorite': 0},
    {'id': 28, 'title': 'Travel Backpack 40L',         'description': 'Water-resistant travel backpack with laptop compartment and USB charging port.',               'category': 'Accessories',   'image': 'backpack',      'price': 79.99,   'isFavorite': 0},
    {'id': 29, 'title': 'Leather Belt',                'description': 'Genuine leather dress belt with brushed nickel buckle. Available in black and brown.',         'category': 'Accessories',   'image': 'wallet',        'price': 34.99,   'isFavorite': 0},
    {'id': 30, 'title': 'Baseball Cap',                'description': 'Adjustable structured baseball cap with embroidered logo. 100% cotton for breathability.',     'category': 'Accessories',   'image': 'backpack',      'price': 24.99,   'isFavorite': 0},
    {'id': 31, 'title': 'Silver Bracelet',             'description': '925 sterling silver chain bracelet with magnetic clasp. Hypoallergenic and durable.',         'category': 'Accessories',   'image': 'necklace',      'price': 19.99,   'isFavorite': 0},
    // Home & Kitchen (7)
    {'id': 32, 'title': 'Nespresso Coffee Machine',   'description': 'Compact espresso machine with 19-bar pressure. Makes espresso in under 30 seconds.',          'category': 'Home & Kitchen','image': 'coffee',        'price': 149.99,  'isFavorite': 0},
    {'id': 33, 'title': 'Air Fryer 5.8 Quart',        'description': 'Digital air fryer with 8 cooking presets and 75% less fat than traditional frying.',          'category': 'Home & Kitchen','image': 'air_fryer',     'price': 89.99,   'isFavorite': 0},
    {'id': 34, 'title': 'Non-Stick Cookware Set',      'description': '10-piece PFOA-free cookware set compatible with all stovetops including induction.',          'category': 'Home & Kitchen','image': 'cookware',      'price': 119.99,  'isFavorite': 0},
    {'id': 35, 'title': 'Robot Vacuum Cleaner',        'description': 'Smart robot vacuum with laser navigation, 3000Pa suction and auto-emptying base.',            'category': 'Home & Kitchen','image': 'vacuum',        'price': 349.99,  'isFavorite': 0},
    {'id': 36, 'title': 'Instant Pot Duo 7-in-1',     'description': 'Pressure cooker, slow cooker, rice cooker, steamer, saute, yogurt maker and warmer in one.', 'category': 'Home & Kitchen','image': 'cookware',      'price': 99.99,   'isFavorite': 0},
    {'id': 37, 'title': 'KitchenAid Stand Mixer',     'description': '5-quart stand mixer with 10 speeds and tilt-head design with multiple attachment options.',   'category': 'Home & Kitchen','image': 'air_fryer',     'price': 449.99,  'isFavorite': 0},
    {'id': 38, 'title': 'Dyson V15 Vacuum',           'description': 'Cordless vacuum with laser dust detection, HEPA filtration and 60-minute battery run time.',   'category': 'Home & Kitchen','image': 'vacuum',        'price': 749.99,  'isFavorite': 0},
    // Sports (7)
    {'id': 39, 'title': 'Yoga Mat Premium',            'description': 'Extra thick 6mm non-slip yoga mat with alignment lines and eco-friendly TPE material.',       'category': 'Sports',        'image': 'yoga',          'price': 39.99,   'isFavorite': 0},
    {'id': 40, 'title': 'Adjustable Dumbbell Set',     'description': 'Space-saving dumbbells from 5 to 52.5 lbs with quick-change weight selector dial.',           'category': 'Sports',        'image': 'dumbbell',      'price': 299.99,  'isFavorite': 0},
    {'id': 41, 'title': 'Cycling Helmet',              'description': 'Lightweight aerodynamic helmet with MIPS technology and 18 ventilation channels.',            'category': 'Sports',        'image': 'helmet',        'price': 69.99,   'isFavorite': 0},
    {'id': 42, 'title': 'Basketball Official Size',    'description': 'Official size 7 basketball with deep channel design for better grip and control.',             'category': 'Sports',        'image': 'basketball',    'price': 29.99,   'isFavorite': 0},
    {'id': 43, 'title': 'Resistance Bands Set',        'description': '5-piece resistance band set with handles, ankle straps and door anchor for full body workout.','category': 'Sports',        'image': 'dumbbell',      'price': 24.99,   'isFavorite': 0},
    {'id': 44, 'title': 'Jump Rope Speed',             'description': 'Lightweight speed jump rope with ball bearings for smooth rotation. Adjustable length.',      'category': 'Sports',        'image': 'yoga',          'price': 19.99,   'isFavorite': 0},
    {'id': 45, 'title': 'Adidas Football',             'description': 'FIFA-approved match football with thermally bonded seamless design for consistent flight.',    'category': 'Sports',        'image': 'basketball',    'price': 39.99,   'isFavorite': 0},
    // Books (5)
    {'id': 46, 'title': 'Clean Code',                  'description': 'A handbook of agile software craftsmanship by Robert C. Martin. Essential for every developer.','category': 'Books',        'image': 'backpack',      'price': 34.99,   'isFavorite': 0},
    {'id': 47, 'title': 'Atomic Habits',               'description': 'James Clear guide to building good habits and breaking bad ones with tiny changes.',           'category': 'Books',         'image': 'backpack',      'price': 16.99,   'isFavorite': 0},
    {'id': 48, 'title': 'The Pragmatic Programmer',    'description': 'Your journey to mastery. A must-read guide to software development best practices.',           'category': 'Books',         'image': 'backpack',      'price': 44.99,   'isFavorite': 0},
    {'id': 49, 'title': 'Deep Work',                   'description': 'Cal Newport rules for focused success in a distracted world. Essential productivity guide.',   'category': 'Books',         'image': 'backpack',      'price': 14.99,   'isFavorite': 0},
    {'id': 50, 'title': 'Flutter in Action',           'description': 'Complete guide to building beautiful cross-platform apps with Flutter and Dart.',              'category': 'Books',         'image': 'tablet',        'price': 49.99,   'isFavorite': 0},
  ];

  // ─── DATABASE SETUP ───────────────────────────────────────

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'product_catalog.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create users table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');

        // Create products table
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            category TEXT NOT NULL,
            image TEXT,
            price REAL,
            isFavorite INTEGER DEFAULT 0
          )
        ''');

        // Index for fast category filtering
        await db.execute('CREATE INDEX idx_category ON products(category)');

        // Insert users in one fast batch
        final userBatch = db.batch();
        for (final user in _sampleUsers) {
          userBatch.insert('users', user);
        }
        await userBatch.commit(noResult: true);

        // Insert products in one fast batch
        final productBatch = db.batch();
        for (final product in _localProducts) {
          productBatch.insert('products', product);
        }
        await productBatch.commit(noResult: true);
      },
    );
  }

  // ─── USER OPERATIONS ─────────────────────────────────────

  static Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['name', 'email', 'password'],
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1,
    );
    if (result.isEmpty) return null;
    final map = result.first;
    return User(name: map['name'] as String, email: map['email'] as String, password: map['password'] as String);
  }

  static Future<bool> signupUser(User user) async {
    final db = await database;
    try {
      await db.insert('users', {
        'name': user.name,
        'email': user.email.trim().toLowerCase(),
        'password': user.password,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email.trim().toLowerCase()], limit: 1);
    if (result.isEmpty) return null;
    final map = result.first;
    return User(name: map['name'] as String, email: map['email'] as String, password: map['password'] as String);
  }

  // ─── PRODUCT OPERATIONS ──────────────────────────────────

  static Future<List<Product>> getProducts() async {
    final db = await database;
    final maps = await db.query('products', orderBy: 'category ASC, id ASC');
    return maps.map((map) => Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      iconName: map['image'] as String,
      price: map['price'] as double,
      isFavorite: (map['isFavorite'] as int) == 1,
    )).toList();
  }

  static Future<void> updateFavorite(int id, bool isFavorite) async {
    final db = await database;
    await db.update('products', {'isFavorite': isFavorite ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }
}
