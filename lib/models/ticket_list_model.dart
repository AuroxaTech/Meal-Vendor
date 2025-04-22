class Ticket {
  final int id;
  final String title;
  final User user;
  final String orderNumber;
  final List<Message> messages;
  final bool isClosed;
  final List<Item> items;  // Existing field to hold the list of items
  final double total;      // Existing field to hold the total
  final DateTime? updatedAt; // Make this field nullable

  Ticket({
    required this.id,
    required this.title,
    required this.user,
    required this.orderNumber,
    required this.messages,
    required this.isClosed,
    required this.items,    // Initialize in constructor
    required this.total,    // Initialize in constructor
    this.updatedAt,          // Initialize in constructor as nullable
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),  // Ensure 'id' is an int
      title: json['title'] ?? 'No Title',
      user: User.fromJson(json['user']),  // Parse the user object using the User model
      orderNumber: json['order']['code'] ?? 'No Order Number',
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      isClosed: json['is_closed'] ?? false,
      items: (json['items'] as List)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),  // Parse the items
      total: json['order']['total']?.toDouble() ?? 0.0, // Parse the total from the order
      updatedAt: json['order']['updated_at'] != null
          ? DateTime.parse(json['order']['updated_at'])
          : null, // Parse the updated_at timestamp or set it as null
    );
  }
}


class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
    );
  }
}

class Product {
  final int id;
  final String name;

  Product({
    required this.id,
    required this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? 'Unknown Product',
    );
  }
}

class Item {
  final int id;
  final int quantity;
  final Product product;

  Item({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      quantity: json['quantity'] ?? 1,
      product: Product.fromJson(json['product']),
    );
  }
}

class Message {
  final int id;
  final int ticketId;
  final String message;
  final bool isUser;
  final bool isAdmin;
  final bool isVendor;
  final DateTime createdAt;
  final String? photo;

  Message({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.isUser,
    required this.isAdmin,
    required this.isVendor,
    required this.createdAt,
    this.photo,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),  // Ensure 'id' is an int
      ticketId: json['ticket_id'] is int ? json['ticket_id'] : int.parse(json['ticket_id']),
      message: json['message'] ?? '',
      isUser: json['is_user'] == 1,
      isAdmin: json['is_admin'] == 1,
      isVendor: json['is_vendor'] == 1,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      photo: json['photo']?.toString(),
    );
  }
}
