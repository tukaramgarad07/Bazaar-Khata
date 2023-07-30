class Note {
  // ignore: prefer_typing_uninitialized_variables
  var _id;
  // ignore: prefer_typing_uninitialized_variables
  var _shopName;
  // ignore: prefer_typing_uninitialized_variables
  var _shopId;
  // ignore: prefer_typing_uninitialized_variables
  var _customerName;
  // ignore: prefer_typing_uninitialized_variables
  var _customerId;
  // ignore: prefer_typing_uninitialized_variables
  var _bill;
  // ignore: prefer_typing_uninitialized_variables
  var _amount;
  // ignore: prefer_typing_uninitialized_variables
  var _method;
  // ignore: prefer_typing_uninitialized_variables
  var _description;
  // ignore: prefer_typing_uninitialized_variables
  var _date;
  // ignore: prefer_typing_uninitialized_variables
  var _dateTime;
  // ignore: prefer_typing_uninitialized_variables

  Note(
      this._shopName,
      this._shopId,
      this._customerName,
      this._customerId,
      this._bill,
      this._description,
      this._amount,
      this._method,
      this._date,
      this._dateTime);

  // Note.withId(this._id, this._title, this._date, this._priority,
  //     [this._description]);

  int get id => _id;
  String get description => _description;
  date() => _date;
  get shopName => _shopName;
  get shopId => _shopId;
  get customerName => _customerName;
  get customerId => _customerId;
  get bill => _bill;
  get amount => _amount;
  get method => _method;
  get dateTime => _dateTime;

  set description(String newTitle) {
    _description = newTitle;
  }

  Map<String, dynamic> toMap() {
    // ignore: prefer_collection_literals
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['description'] = _description;
    map['date'] = _date;
    map['shopName'] = _shopName;
    map['shopId'] = _shopId;
    map['customerName'] = _customerName;
    map['customerId'] = _customerId;
    map['bill'] = _bill;
    map['amount'] = _amount;
    map['method'] = _method;
    map['dateTime'] = _dateTime;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _description = map['description'];
    _date = map['date'];
    _shopName = map['shopName'];
    _shopId = map['shopId'];
    _customerName = map['customerName'];
    _customerId = map['customerId'];
    _bill = map['bill'];
    _amount = map['amount'];
    _method = map['method'];
    _dateTime = map['dateTime'];
  }
}

class Items {
  // ignore: prefer_typing_uninitialized_variables
  var _itemId;
  // ignore: prefer_typing_uninitialized_variables
  var _itemName;
  // ignore: prefer_typing_uninitialized_variables
  var _itemQuantity;
  // ignore: prefer_typing_uninitialized_variables
  var _itemStep;
  // ignore: prefer_typing_uninitialized_variables
  var _itemPrice;
  // ignore: prefer_typing_uninitialized_variables
  var _shopId;

  Items(this._shopId, this._itemName, this._itemQuantity, this._itemStep,
      this._itemPrice);

  int get itemId => _itemId;
  get shopId => _shopId;
  get itemName => _itemName;
  get itemQuantity => _itemQuantity;
  get itemStep => _itemStep;
  get itemPrice => _itemPrice;

  Map<String, dynamic> toMap() {
    // ignore: prefer_collection_literals
    var map = Map<String, dynamic>();

    map['itemId'] = _itemId;
    map['shopId'] = _shopId;
    map['itemName'] = _itemName;
    map['itemQuantity'] = _itemQuantity;
    map['itemStep'] = _itemStep;
    map['itemPrice'] = _itemPrice;

    return map;
  }

  Items.fromMapObject(Map<String, dynamic> map) {
    _itemId = map['itemId'];
    _shopId = map['shopId'];
    _itemName = map['itemName'];
    _itemQuantity = map['itemQuantity'];
    _itemStep = map['itemStep'];
    _itemPrice = map['itemPrice'];
  }
}

class Activity {
  // ignore: prefer_typing_uninitialized_variables
  var _activityId;
  // ignore: prefer_typing_uninitialized_variables
  var _shopId;
  // ignore: prefer_typing_uninitialized_variables
  var _activityContent;
  // ignore: prefer_typing_uninitialized_variables
  var _activityMethod;
  // ignore: prefer_typing_uninitialized_variables
  var _activityDate;

  Activity(this._shopId, this._activityContent, this._activityMethod,
      this._activityDate);

  int get activityId => _activityId;
  get shopId => _shopId;
  get activityContent => _activityContent;
  get activityMethod => _activityMethod;
  get activityDate => _activityDate;

  Map<String, dynamic> toMap() {
    // ignore: prefer_collection_literals
    var map = Map<String, dynamic>();

    map['activityId'] = _activityId;
    map['shopId'] = _shopId;
    map['activityContent'] = _activityContent;
    map['activityMethod'] = _activityMethod;
    map['activityDate'] = _activityDate;

    return map;
  }

  Activity.fromMapObject(Map<String, dynamic> map) {
    _activityId = map['activityId'];
    _shopId = map['shopId'];
    _activityContent = map['activityContent'];
    _activityMethod = map['activityMethod'];
    _activityDate = map['activityDate'];
  }
}
