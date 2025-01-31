import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tescom_helpdesk/providers/request_provider.dart';
import 'package:tescom_helpdesk/providers/image_provider.dart';
import 'package:tescom_helpdesk/models/request_model.dart';

class StaffDashboard extends ConsumerWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  StaffDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestProvider);
    final requestService = ref.read(requestServiceProvider);
    final imageService = ref.read(imageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Dashboard'),
      ),
      body: Column(
        children: [
          Expanded(
            child: requestsAsync.when(
              data: (requests) {
                final staffRequests = requests
                    .where((request) => request.status != 'Declined')
                    .toList();
                return ListView.builder(
                  itemCount: staffRequests.length,
                  itemBuilder: (context, index) {
                    final request = staffRequests[index];
                    return ListTile(
                      title: Text(request.title),
                      subtitle: Text(request.description),
                      trailing: Text(request.status),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          Padding(
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
                    final imageFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (imageFile != null) {
                      final imageUrl =
                          await imageService.uploadImage(imageFile);
                      if (imageUrl != null) {
                        final request = Request(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _titleController.text,
                          description: _descriptionController.text,
                          imageUrl: imageUrl,
                          status: 'Pending',
                          createdAt: DateTime.now(),
                        );
                        await requestService.addRequest(request);
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
        ],
      ),
    );
  }
}
