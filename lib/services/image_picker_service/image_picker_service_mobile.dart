import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'image_picker_service.dart';

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<Uint8List?> pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (picked == null) return null;
    return await File(picked.path).readAsBytes();
  }
}
