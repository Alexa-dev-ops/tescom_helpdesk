import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tescom_helpdesk/providers/image_provider.dart';
import 'package:tescom_helpdesk/models/request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class CreateRequestScreen extends ConsumerWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            ElevatedButton(
              onPressed: () async {
                final imageFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (imageFile != null) {
                  final imageUrl = await imageService.uploadImage(imageFile);
                  if (imageUrl != null) {
                    final request = Request(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      description: _descriptionController.text,
                      imageUrl: imageUrl,
                      status: 'Pending',
                      createdAt: DateTime.now(),
                    );
                    await FirebaseFirestore.instance
                        .collection('requests')
                        .doc(request.id)
                        .set(request.toJson());
                    _titleController.clear();
                    _descriptionController.clear();
                  }
                }
              },
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
