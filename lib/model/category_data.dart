class Category {
  final  int category_id;
  final String name;
  final String description;
 

  const Category({
    required this.category_id,
    required this.name,
    required this.description,
   
  });
  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      category_id:  int.parse(json['category_id'].toString()),
      name: json['name']?.toString()?? '',
      description: json['description']?.toString()?? '',
     

    );
  }

}