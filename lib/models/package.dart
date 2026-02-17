class Package {
  final int? id;
  final String? title;
  final String? description;
  final double? price;
  final double? discountedPrice;
  final String? image;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Package({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountedPrice,
    this.image,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a Package instance from a JSON map
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: int.parse(json['id'].toString()),
      title: json['title'] as String? ?? "",
      description: json['description'] as String? ?? "",
      price: double.parse((json['price'] ?? 0).toString()),
      discountedPrice: double.parse((json['discounted_price'] ?? 0).toString()),
      image: json['image'] as String? ?? "",
      active: json['active'] == 1,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Method to convert a Package instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title ?? "",
      'description': description ?? "",
      'price': price ?? 0,
      'discounted_price': discountedPrice ?? 0,
      'image': image ?? "",
      'active': active == true ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class PackageFeature {
  final int? id;
  final String? title;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PackageFeature({
    this.id,
    this.title,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a Package instance from a JSON map
  factory PackageFeature.fromJson(Map<String, dynamic> json) {
    return PackageFeature(
      id: json['id'] as int?,
      title: json['title'] as String? ?? "",
      active: json['active'] == 1,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Method to convert a Package instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title ?? "",
      'active': active == true ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
