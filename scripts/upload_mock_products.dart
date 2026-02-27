import 'dart:io';
import 'package:dio/dio.dart';

/// Script to upload mock products to WooCommerce
///
/// This script reads the mock products and uploads them to the WooCommerce store
/// Run with: dart run scripts/upload_mock_products.dart

/// Simple .env file parser
Map<String, String> loadEnvFile(String filePath) {
  final file = File(filePath);
  final Map<String, String> env = {};

  if (!file.existsSync()) {
    throw Exception('.env file not found at: $filePath');
  }

  final lines = file.readAsLinesSync();
  for (final line in lines) {
    final trimmedLine = line.trim();

    // Skip comments and empty lines
    if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
      continue;
    }

    // Parse key=value
    final parts = trimmedLine.split('=');
    if (parts.length >= 2) {
      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim();
      env[key] = value;
    }
  }

  return env;
}

class WooCommerceUploader {
  late final Dio _dio;
  final String storeUrl;
  final String consumerKey;
  final String consumerSecret;

  WooCommerceUploader({
    required this.storeUrl,
    required this.consumerKey,
    required this.consumerSecret,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: '$storeUrl/wp-json/wc/v3',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters.addAll({
            'consumer_key': consumerKey,
            'consumer_secret': consumerSecret,
          });
          print('📤 REQUEST[${options.method}] => ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
          print('Error: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Delete all existing products
  Future<void> deleteAllProducts() async {
    print('\n🗑️  Deleting all existing products...\n');

    try {
      // Get all products (paginated)
      var page = 1;
      var totalDeleted = 0;

      while (true) {
        final response = await _dio.get(
          '/products',
          queryParameters: {
            'per_page': 100,
            'page': page,
          },
        );

        if (response.data is! List || (response.data as List).isEmpty) {
          break;
        }

        final products = response.data as List;

        for (final product in products) {
          final productId = product['id'] as int;
          final productName = product['name'] as String;

          try {
            await _dio.delete(
              '/products/$productId',
              queryParameters: {'force': true}, // Permanently delete
            );
            print('✓ Deleted product: "$productName" (ID: $productId)');
            totalDeleted++;
          } catch (e) {
            print('❌ Failed to delete product "$productName": $e');
          }

          // Small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 200));
        }

        page++;
      }

      print('\n✅ Deleted $totalDeleted products\n');
    } catch (e) {
      print('❌ Error deleting products: $e');
    }
  }

  /// Delete all existing categories
  Future<void> deleteAllCategories() async {
    print('\n🗑️  Deleting all existing categories...\n');

    try {
      // Get all categories
      final response = await _dio.get(
        '/products/categories',
        queryParameters: {'per_page': 100},
      );

      if (response.data is! List) {
        print('❌ Invalid response format');
        return;
      }

      final categories = response.data as List;
      var totalDeleted = 0;

      for (final category in categories) {
        final categoryId = category['id'] as int;
        final categoryName = category['name'] as String;

        // Skip the "Uncategorized" default category (usually ID 15 or 1)
        if (categoryName.toLowerCase() == 'uncategorized' ||
            categoryName.toLowerCase() == 'fără categorie') {
          print('⏭️  Skipped default category: "$categoryName"');
          continue;
        }

        try {
          await _dio.delete(
            '/products/categories/$categoryId',
            queryParameters: {'force': true}, // Permanently delete
          );
          print('✓ Deleted category: "$categoryName" (ID: $categoryId)');
          totalDeleted++;
        } catch (e) {
          print('❌ Failed to delete category "$categoryName": $e');
        }

        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      }

      print('\n✅ Deleted $totalDeleted categories\n');
    } catch (e) {
      print('❌ Error deleting categories: $e');
    }
  }

  /// Create categories
  Future<Map<String, int>> createCategories() async {
    print('\n🏷️  Creating categories...\n');

    final categories = [
      {'name': 'Îmbrăcăminte', 'slug': 'imbracaminte'},
      {'name': 'Cărți', 'slug': 'carti'},
      {'name': 'Suveniruri', 'slug': 'suveniruri'},
      {'name': 'Decorațiuni', 'slug': 'decoratiuni'},
      {'name': 'Bijuterii', 'slug': 'bijuterii'},
      {'name': 'Instrumente', 'slug': 'instrumente'},
      {'name': 'Artă', 'slug': 'arta'},
      {'name': 'Papetărie', 'slug': 'papetarie'},
      {'name': 'Cadouri', 'slug': 'cadouri'},
    ];

    final categoryMap = <String, int>{};

    for (final category in categories) {
      try {
        // Create new category
        final createResponse = await _dio.post(
          '/products/categories',
          data: category,
        );
        final categoryId = createResponse.data['id'] as int;
        categoryMap[category['slug']!] = categoryId;
        print('✓ Created category "${category['name']}" (ID: $categoryId)');

        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print('❌ Error creating category "${category['name']}": $e');
      }
    }

    return categoryMap;
  }

  /// Upload a single product to WooCommerce
  Future<bool> uploadProduct(
    Map<String, dynamic> productData,
  ) async {
    try {
      // Transform mock product data to WooCommerce format
      final wooProduct = {
        'name': productData['name'],
        'type': productData['type'],
        'status': productData['status'],
        'featured': productData['featured'],
        'catalog_visibility': productData['catalog_visibility'],
        'description': productData['description'],
        'short_description': productData['short_description'],
        'sku': productData['sku'],
        'regular_price': productData['regular_price'],
        'sale_price': productData['sale_price'],
        'manage_stock': productData['manage_stock'],
        'stock_quantity': productData['stock_quantity'],
        'stock_status': productData['stock_status'],
        'virtual': productData['virtual'],
        'downloadable': productData['downloadable'],
        'categories': productData['categories'],
      };

      // Create the product
      final response = await _dio.post('/products', data: wooProduct);
      final productId = response.data['id'];
      print('✅ Created product "${productData['name']}" (ID: $productId, SKU: ${productData['sku']})');
      return true;
    } catch (e) {
      print('❌ Failed to upload "${productData['name']}": $e');
      return false;
    }
  }

  /// Get all mock products data
  List<Map<String, dynamic>> getMockProductsData() {
    return [
      // Îmbrăcăminte
      {
        'name': 'Tricou Logo R.L. 126 C.T.',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Tricou premium din bumbac 100% cu logo-ul R.L. 126 C.T. brodat pe piept. Material moale și respirant, perfect pentru purtare zilnică.',
        'short_description': 'Tricou din bumbac cu logo brodat',
        'sku': 'TRI-001',
        'regular_price': '89.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 50,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'imbracaminte'}],
      },
      {
        'name': 'Eșarfă Ceremonială Roșu-Auriu',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Eșarfă ceremonială elegantă în culorile tradiționale roșu și auriu. Material de calitate superioară, brodată cu simboluri specifice.',
        'short_description': 'Eșarfă ceremonială roșu-auriu',
        'sku': 'ESA-001',
        'regular_price': '179.99',
        'sale_price': '149.99',
        'manage_stock': true,
        'stock_quantity': 25,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'imbracaminte'}],
      },
      // Cărți
      {
        'name': 'Istoria Cavalerilor Templului',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'O lucrare comprehensivă despre istoria fascinantă a Cavalerilor Templului. 450 de pagini bogat ilustrate cu documente istorice și fotografii.',
        'short_description': 'Carte despre istoria Cavalerilor Templului',
        'sku': 'CAR-001',
        'regular_price': '79.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 100,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'carti'}],
      },
      {
        'name': 'Simboluri și Ritualuri Medievale',
        'type': 'simple',
        'status': 'publish',
        'featured': false,
        'catalog_visibility': 'visible',
        'description': 'Studiu aprofundat al simbolurilor și ritualurilor din perioada medievală. Include descrieri detaliate și interpretări moderne.',
        'short_description': 'Carte despre simboluri medievale',
        'sku': 'CAR-002',
        'regular_price': '65.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 75,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'carti'}],
      },
      // Suveniruri
      {
        'name': 'Breloc Cruce Templierii',
        'type': 'simple',
        'status': 'publish',
        'featured': false,
        'catalog_visibility': 'visible',
        'description': 'Breloc metalic în formă de cruce templiară. Finisaj auriu, rezistent la uzură. Dimensiuni: 5cm x 3cm.',
        'short_description': 'Breloc cruce templiară',
        'sku': 'SUV-001',
        'regular_price': '39.99',
        'sale_price': '29.99',
        'manage_stock': true,
        'stock_quantity': 200,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'suveniruri'}],
      },
      {
        'name': 'Magnet Frigider Logo R.L. 126',
        'type': 'simple',
        'status': 'publish',
        'featured': false,
        'catalog_visibility': 'visible',
        'description': 'Magnet decorativ pentru frigider cu logo-ul R.L. 126 C.T. Ceramică de calitate cu magnet puternic.',
        'short_description': 'Magnet decorativ cu logo',
        'sku': 'SUV-002',
        'regular_price': '19.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 150,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'suveniruri'}],
      },
      // Decorațiuni
      {
        'name': 'Placă Decorativă Stemă',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Placă decorativă din lemn masiv cu stemă gravată. Finisaj lustruit, dimensiuni: 30cm x 40cm. Ideală pentru birou sau casă.',
        'short_description': 'Placă decorativă din lemn cu stemă',
        'sku': 'DEC-001',
        'regular_price': '199.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 15,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'decoratiuni'}],
      },
      // Bijuterii
      {
        'name': 'Inel Crucea Templiară',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Inel din argint 925 cu crucea templiară gravată. Design elegant și rezistent. Disponibil în mai multe mărimi.',
        'short_description': 'Inel argint cu cruce templiară',
        'sku': 'BIJ-001',
        'regular_price': '299.99',
        'sale_price': '249.99',
        'manage_stock': true,
        'stock_quantity': 30,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'bijuterii'}],
      },
      {
        'name': 'Colier Pandantiv Scut',
        'type': 'simple',
        'status': 'publish',
        'featured': false,
        'catalog_visibility': 'visible',
        'description': 'Colier elegant cu pandantiv în formă de scut templar. Argint 925, lanț de 50cm inclus.',
        'short_description': 'Colier argint cu pandantiv scut',
        'sku': 'BIJ-002',
        'regular_price': '189.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 40,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'bijuterii'}],
      },
      // Instrumente
      {
        'name': 'Spadă Decorativă Replica',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Replică fidelă a spadei templare medievale. Doar pentru uz decorativ. Lungime 90cm, material: metal și lemn.',
        'short_description': 'Replică spadă templiară decorativă',
        'sku': 'INS-001',
        'regular_price': '449.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 8,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'instrumente'}],
      },
      // Artă
      {
        'name': 'Tablou Canvas Cruciada',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Reproducere de înaltă calitate pe canvas a unei scene din cruciade. Dimensiuni: 60cm x 80cm, cu ramă inclusă.',
        'short_description': 'Tablou canvas scenă cruciată',
        'sku': 'ART-001',
        'regular_price': '399.99',
        'sale_price': '329.99',
        'manage_stock': true,
        'stock_quantity': 12,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'arta'}],
      },
      // Papetărie
      {
        'name': 'Agendă Elegantă Logo Emblem',
        'type': 'simple',
        'status': 'publish',
        'featured': false,
        'catalog_visibility': 'visible',
        'description': 'Agendă cu copertă din piele ecologică și logo emblem. 365 de pagini, format A5.',
        'short_description': 'Agendă cu logo emblem',
        'sku': 'PAP-001',
        'regular_price': '59.99',
        'sale_price': '',
        'manage_stock': true,
        'stock_quantity': 80,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'papetarie'}],
      },
      // Cadouri
      {
        'name': 'Set Cadou Premium - Cavaleri',
        'type': 'simple',
        'status': 'publish',
        'featured': true,
        'catalog_visibility': 'visible',
        'description': 'Set cadou elegant ce include: tricou logo, breloc, agendă și carte despre istoria cavalerilor. Ambalaj premium inclus.',
        'short_description': 'Set cadou complet pentru pasionați',
        'sku': 'CAD-001',
        'regular_price': '380.00',
        'sale_price': '299.99',
        'manage_stock': true,
        'stock_quantity': 20,
        'stock_status': 'instock',
        'virtual': false,
        'downloadable': false,
        'categories': [{'id': 0, 'slug': 'cadouri'}],
      },
    ];
  }

  /// Main upload process
  Future<void> uploadAllProducts() async {
    print('\n🚀 Starting WooCommerce reset and product upload...\n');

    // Step 1: Delete all existing products
    await deleteAllProducts();

    // Step 2: Delete all existing categories
    await deleteAllCategories();

    // Step 3: Create fresh categories
    final categoryMap = await createCategories();

    if (categoryMap.isEmpty) {
      print('\n❌ Failed to create categories. Aborting.\n');
      return;
    }

    // Step 4: Upload products
    print('\n📦 Uploading products...\n');
    final products = getMockProductsData();

    var successCount = 0;
    var errorCount = 0;

    for (final product in products) {
      // Map category slug to ID
      final categorySlug = product['categories'][0]['slug'] as String;
      if (categoryMap.containsKey(categorySlug)) {
        product['categories'] = [
          {'id': categoryMap[categorySlug]}
        ];

        final success = await uploadProduct(product);
        if (success) {
          successCount++;
        } else {
          errorCount++;
        }
      } else {
        print('⚠️  Category "$categorySlug" not found for product "${product['name']}"');
        errorCount++;
      }

      // Small delay to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // Summary
    print('\n${'=' * 60}');
    print('📊 Upload Summary:');
    print('   ✅ Successfully created: $successCount products');
    print('   ❌ Errors: $errorCount products');
    print('   📦 Total processed: ${products.length} products');
    print('${'=' * 60}\n');
  }
}

void main() async {
  print('\n🔧 WooCommerce Product Uploader\n');

  try {
    // Load environment variables
    final env = loadEnvFile('.env');

    final storeUrl = env['WOOCOMMERCE_STORE_URL'];
    final consumerKey = env['WOOCOMMERCE_CONSUMER_KEY'];
    final consumerSecret = env['WOOCOMMERCE_CONSUMER_SECRET'];

    if (storeUrl == null || consumerKey == null || consumerSecret == null) {
      print('❌ Missing WooCommerce credentials in .env file');
      print('   Required: WOOCOMMERCE_STORE_URL, WOOCOMMERCE_CONSUMER_KEY, WOOCOMMERCE_CONSUMER_SECRET');
      exit(1);
    }

    print('🔗 Store: $storeUrl');
    print('🔑 Consumer Key: ${consumerKey.substring(0, 10)}...\n');

    // Create uploader and run
    final uploader = WooCommerceUploader(
      storeUrl: storeUrl,
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    await uploader.uploadAllProducts();

    print('✅ Upload process completed!\n');
  } catch (e, stackTrace) {
    print('\n❌ Error: $e');
    print('Stack trace: $stackTrace\n');
    exit(1);
  }
}
