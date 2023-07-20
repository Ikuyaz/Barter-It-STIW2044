class Cart {
  String? cartId;
  String? itemId;
  String? itemName;
  // String? catchStatus;
  String? itemType;
  String? itemDesc;
  String? userId;
  String? sellerId;
  String? cartDate;

  Cart(
      {this.cartId,
      this.itemId,
      this.itemName,
      // this.catchStatus,
      this.itemType,
      this.itemDesc,
      this.userId,
      this.sellerId,
      this.cartDate});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    // catchStatus = json['catch_status'];
    itemType = json['item_type'];
    itemDesc = json['item_desc'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    // data['catch_status'] = catchStatus;
    data['item_type'] = itemType;
    data['item_desc'] = itemDesc;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['cart_date'] = cartDate;
    return data;
  }
}
