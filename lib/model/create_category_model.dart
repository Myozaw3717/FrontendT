class CreateCategoryData{
  final String name;
  final String description;
 
  const CreateCategoryData({
    required this.name,
    required this.description,
    
  });

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'description': description,
    };
  }

}