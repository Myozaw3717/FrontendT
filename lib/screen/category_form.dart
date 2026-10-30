import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exe/model/create_category_model.dart';
import 'package:flutter_exe/screen/category_list.dart';
import 'package:flutter_exe/service/api_service.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  State<CategoryFormScreen> createState() => __CategoryFormScreenState();
}

class __CategoryFormScreenState extends State<CategoryFormScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ApiService _apiService = ApiService();

  bool _isSaving = false;

  @override
  void dispose(){
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

Future<void> _submitForm() async{
  if(!_formKey.currentState!.validate()){
    return;
  }

  setState((){
    _isSaving = true;
  });

  try{
    final newCategory = CreateCategoryData(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
     
    );

    await _apiService.createCategory(newCategory);
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category created successfully!'),
        backgroundColor: Color.fromARGB(255, 47, 122, 50),
      ),
    );
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=> const CategoryList()),
    );


    _formKey.currentState!.reset();
    _nameController.clear();
    _descriptionController.clear();

    setState((){
     
    });

  }catch(e){
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to create category: $e'),
        backgroundColor: const Color.fromARGB(255, 152, 18, 8),
      )
    );
   
  }finally {
    if(mounted){
      setState((){
        _isSaving = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefix: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty) {
                        return 'Name is required';
                        }
                      return null;
                    },
                  ),
                  const SizedBox(height : 16),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText :'Description',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                      validator:(value){
                        if(value == null || value.trim().isEmpty){
                          return 'Description is required';
                        }
                      
                      return null;
                     

                      },
                    ),
                   
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth:2,
                                color: Colors.white,
                              ),
                            )
                            :const Text(
                              'Save Category',
                              style: TextStyle(fontSize: 16),
                            ),
                      )

                    ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}