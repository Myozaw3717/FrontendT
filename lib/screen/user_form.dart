
import 'package:flutter/material.dart';
import 'package:flutter_exe/model/create_user_model.dart';
import 'package:flutter_exe/model/get_user.dart';
import 'package:flutter_exe/model/update_user_model.dart';
import 'package:flutter_exe/screen/user_table_with_api.dart';
import 'package:flutter_exe/service/api_service.dart';

class UserForm extends StatefulWidget {
  final User? user;
  const UserForm({
    super.key,
    this.user,
    });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();

  String _role = 'Author';
  bool _obscurePassword = true;
  bool _isSaving = false;
  bool get _isEditing => widget.user != null;
String _normalizeRole(String? role) {
  switch (role?.trim().toLowerCase()) {
    case 'admin':
      return'Admin';
    case 'editor':
      return 'Editor';
    case 'author':
      return 'Author';
    default:
      return 'Author';

  }
}

@override
  void initState(){
    super.initState();
  
  final user = widget.user;
  if(user != null){
    _nameController.text = user.name;
    _emailController.text = user.email;
    _role = _normalizeRole(user.role);
  }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {

    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    

    try {

      if(_isEditing){
        await _apiService.updateUser(
          user_id:widget.user!.user_id,
          user:UpdateUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            role: _role,
            password: _passwordController.text.isEmpty
             ?null
             : _passwordController.text,
          ),
        );
      }else{
      final newUser = CreateUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _role,
      );

      await _apiService.createUser(newUser);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            _isEditing
              ? 'User updated successfully!'
              :'User created successfully!'
             ),
          backgroundColor: Color.fromARGB(255, 47, 122, 50),
        ),
      );

      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => const UserTableWithApi()),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      setState(() {
        _role = 'Author';
        _obscurePassword = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_isEditing ? 'Update' : 'Create'} Failed : $e',
            ),
          backgroundColor: const Color.fromARGB(255, 152, 18, 8),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          _isEditing ? 'Edit User':'Create User',
          ),
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
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }

                      final email = value.trim();

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email)) {
                        return 'Enter a valid email';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: _isEditing
                      ? 'New Password (Optimal)'
                      : 'Password',
                      helperText: _isEditing
                      ? 'Leave blank to keep the current password'
                      :'At least 8 characters',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (_isEditing &&
                      (value == null || value.isEmpty)){
                        return null;
                      }
                       if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }

                      if (value.length < 8) {
                        return 'Use at least 8 characters';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Role dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      prefixIcon: Icon(Icons.admin_panel_settings),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Admin',
                        child: Text('Admin'),
                      ),
                      DropdownMenuItem(
                        value: 'Editor',
                        child: Text('Editor'),
                      ),
                      DropdownMenuItem(
                        value: 'Author',
                        child: Text('Author'),
                      ),
                    ],
                    onChanged: _isSaving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _role = value;
                              });
                            }
                          },
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          :  Text(
                            _isEditing
                              ?'Update User'
                              :'Save User',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
