import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tescom_helpdesk/providers/request_provider.dart';


class ICTDashboard extends ConsumerWidget {
  const ICTDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestProvider);
    final requestService = ref.read(requestServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ICT Dashboard'),
      ),
      body: requestsAsync.when(
        data: (requests) {
          final approvedRequests = requests
              .where((request) => request.status == 'Approved')
              .toList();
          return ListView.builder(
            itemCount: approvedRequests.length,
            itemBuilder: (context, index) {
              final request = approvedRequests[index];
              return ListTile(
                title: Text(request.title),
                subtitle: Text(request.description),
                trailing: DropdownButton<String>(
                  value: request.status,
                  onChanged: (newStatus) async {
                    await requestService.updateRequestStatus(
                        request.id, newStatus!);
                  },
                  items: ['Approved', 'In Progress', 'Resolved']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
