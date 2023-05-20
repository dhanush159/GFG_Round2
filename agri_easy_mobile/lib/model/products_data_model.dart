class ProductDataModel {
  int? id;
  String? name;
  String? category;
  String? imageURL;
  String? type;
  String? desc;
  String? l;

  ProductDataModel(
      {this.id,
      this.name,
      this.category,
      this.imageURL,
      this.type,
      this.desc,
      this.l});

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    imageURL = json['imageUrl'];
    type = json['type'];
    desc = json['desc'];
    l = json['l'];
  }

  get link => null;
}
