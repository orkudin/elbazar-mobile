import 'package:dio/dio.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

final selectedFilesProvider = StateProvider<List<PlatformFile>>((ref) => []);

class BecomeASellerScreen extends ConsumerWidget {
  const BecomeASellerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFiles = ref.watch(selectedFilesProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Seller'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: selectedFiles.isNotEmpty
                  ? ListView.builder(
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        return ListTile(
                          title: Text(file.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(selectedFilesProvider.notifier).state = [
                                ...selectedFiles.sublist(0, index),
                                ...selectedFiles.sublist(index + 1),
                              ];
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No files selected.'),
                    ),
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
                  allowMultiple: true,
                );

                if (result != null) {
                  ref.read(selectedFilesProvider.notifier).state = [
                    ...selectedFiles,
                    ...result.files,
                  ].take(2).toList();
                }
              },
              child: const Text('Select Documents (Max 2)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  selectedFiles.length == 2 // Ensure two files are selected
                      ? () async {
                          // Get the personal ID from the user (e.g., using a TextField)
                          String personalId =
                              'your_personal_id_here'; // Replace this with actual ID input

                          await _uploadFiles(context, ref, authState.token,
                              selectedFiles, personalId);
                        }
                      : null,
              child: const Text('Submit Documents'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadFiles(
    BuildContext context,
    WidgetRef ref,
    String jwtToken,
    List<PlatformFile> files,
    String personalId,
  ) async {
    var dio = Dio();
    var formData = FormData();

    try {
      // Add personal_id field to formData
      formData.fields.add(MapEntry('personal_id', personalId));

      // Add files to formData
      for (int i = 0; i < files.length; i++) {
        if (files[i].path != null) {
          String contentType = _getMimeType(files[i].name);
          formData.files.add(MapEntry(
            i == 0
                ? 'personal_id'
                : 'business_document', // Assign file names based on order
            await MultipartFile.fromFile(files[i].path!,
                filename: files[i].name,
                contentType: MediaType.parse(contentType)),
          ));
        } else if (files[i].bytes != null) {
          String contentType = _getMimeType(files[i].name);
          formData.files.add(MapEntry(
            i == 0 ? 'personal_id' : 'business_document',
            MultipartFile.fromBytes(files[i].bytes!,
                filename: files[i].name,
                contentType: MediaType.parse(contentType)),
          ));
        } else {
          throw Exception(
              'File path and bytes are both null for file: ${files[i].name}');
        }
      }

      // Send the request
      var response = await dio.request(
        'https://daurendan.ru/api/sales/upload-documents',
        options: Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );

      // Handle the response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documents submitted successfully!')),
        );
        ref.read(selectedFilesProvider.notifier).state =
            []; // Clear files after successful upload
      } else {
        print('Error uploading files: ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit documents!')),
        );
      }
    } catch (e) {
      // Handle any other errors that may occur
      if (e is DioException && e.response != null) {
        // Print the response data to get more details
        print('Error data: ${e.response?.data}');
      }
      print('Exception when uploading files: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception when submitting documents: $e')),
      );
    }
  }

  String _getMimeType(String fileName) {
    if (fileName.endsWith('.pdf')) {
      return 'application/pdf';
    } else if (fileName.endsWith('.png')) {
      return 'image/png';
    } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    // Add more file extensions and mime types as needed
    return 'application/octet-stream'; // Default if not recognized
  }
}
