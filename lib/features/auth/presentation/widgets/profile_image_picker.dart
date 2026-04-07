import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    this.selectedImage,
    required this.onImageSelected,
  });

  final XFile? selectedImage;
  final ValueChanged<XFile?> onImageSelected;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.8),
              border: Border.all(
                color: AppColors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: selectedImage != null
                  ? Image.file(
                      File(selectedImage!.path),
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person_outline_rounded,
                      size: 60,
                      color: AppColors.mutedText.withValues(alpha: 0.5),
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.deepOrange,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
