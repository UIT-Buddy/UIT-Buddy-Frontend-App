import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';

class EditYourInfoScreen extends StatefulWidget {
  const EditYourInfoScreen({super.key, required this.info});

  final YourInfoEntity info;

  @override
  State<EditYourInfoScreen> createState() => _EditYourInfoScreenState();
}

class _EditYourInfoScreenState extends State<EditYourInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;

  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _pickedAvatarBytes;
  String? _pickedAvatarPath;
  Uint8List? _pickedCoverBytes;
  String? _pickedCoverPath;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.info.fullName);
    _emailCtrl = TextEditingController(text: widget.info.email);
    _bioCtrl = TextEditingController(text: widget.info.bio);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, {required bool isCover}) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: isCover ? 90 : 85,
      maxWidth: isCover ? 1920 : 1024,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    if (!mounted) return;
    setState(() {
      if (isCover) {
        _pickedCoverBytes = bytes;
        _pickedCoverPath = picked.path;
      } else {
        _pickedAvatarBytes = bytes;
        _pickedAvatarPath = picked.path;
      }
    });
  }

  Future<void> _openImagePickerSheet({required bool isCover}) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera, isCover: isCover);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from library'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.gallery, isCover: isCover);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAvatarPickerSheet() async {
    await _openImagePickerSheet(isCover: false);
  }

  Future<void> _openCoverPickerSheet() async {
    await _openImagePickerSheet(isCover: true);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final updated = YourInfoEntity(
      mssv: widget.info.mssv, // read-only
      fullName: _fullNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      avatarUrl: _pickedAvatarBytes != null
          ? 'data:image/jpeg;base64,${base64Encode(_pickedAvatarBytes!)}'
          : widget.info.avatarUrl,
      coverUrl: _pickedCoverBytes != null
          ? 'data:image/jpeg;base64,${base64Encode(_pickedCoverBytes!)}'
          : widget.info.coverUrl,
      bio: _bioCtrl.text.trim(),
      homeClassCode: widget.info.homeClassCode,
      friendStatus: widget.info.friendStatus,
      accumulatedGpa: widget.info.accumulatedGpa,
      accumulatedCredits: widget.info.accumulatedCredits,
      postCount: widget.info.postCount,
    );
    context.pop(updated);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColor.primaryText),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              'Edit Info',
              textAlign: TextAlign.center,
              style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
            ),
          ),
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReadOnlyField(label: 'MSSV', value: widget.info.mssv),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _fullNameCtrl,
              label: 'Full Name',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailCtrl,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(controller: _bioCtrl, label: 'Bio'),
            const SizedBox(height: 16),
            _buildAvatarPickerField(),
            const SizedBox(height: 16),
            _buildCoverPickerField(),
            const SizedBox(height: 16),
            _ReadOnlyField(
              label: 'Home Class Code',
              value: widget.info.homeClassCode,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: AppColor.pureWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Changes',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.pureWhite,
                    fontWeight: AppTextStyle.medium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1, color: AppColor.dividerGrey),
            Expanded(child: _buildFormBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: AppTextStyle.medium,
            color: AppColor.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyle.bodySmall,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.dividerGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.dividerGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryBlue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.alertRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.alertRed),
            ),
            filled: true,
            fillColor: AppColor.veryLightGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPickerField() {
    final currentAvatarUrl = _pickedAvatarPath ?? widget.info.avatarUrl;

    return _buildImagePickerField(
      label: 'Avatar URL',
      imageBytes: _pickedAvatarBytes,
      imageUrl: currentAvatarUrl,
      onTap: _openAvatarPickerSheet,
      emptyHint: 'Tap to select avatar image',
    );
  }

  Widget _buildCoverPickerField() {
    final currentCoverUrl = _pickedCoverPath ?? widget.info.coverUrl;

    return _buildImagePickerField(
      label: 'Cover Photo',
      imageBytes: _pickedCoverBytes,
      imageUrl: currentCoverUrl,
      onTap: _openCoverPickerSheet,
      emptyHint: 'Tap to select cover image',
      previewWidth: 96,
      previewHeight: 56,
      fallbackAsset: 'assets/images/placeholder/bg-placeholder-transparent.png',
    );
  }

  Widget _buildImagePickerField({
    required String label,
    required Uint8List? imageBytes,
    required String imageUrl,
    required VoidCallback onTap,
    required String emptyHint,
    double previewWidth = 56,
    double previewHeight = 56,
    String fallbackAsset = 'assets/images/placeholder/user-icon.png',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: AppTextStyle.medium,
            color: AppColor.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.veryLightGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.dividerGrey),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _AvatarPreview(
                    imageBytes: imageBytes,
                    imageUrl: imageUrl,
                    width: previewWidth,
                    height: previewHeight,
                    fallbackAsset: fallbackAsset,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    imageUrl.isEmpty ? emptyHint : imageUrl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColor.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.imageBytes,
    required this.imageUrl,
    this.width = 56,
    this.height = 56,
    this.fallbackAsset = 'assets/images/placeholder/user-icon.png',
  });

  final Uint8List? imageBytes;
  final String imageUrl;
  final double width;
  final double height;
  final String fallbackAsset;

  bool get _isNetworkUrl =>
      imageUrl.startsWith('http://') ||
      imageUrl.startsWith('https://') ||
      imageUrl.startsWith('blob:');

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    if (_isNetworkUrl) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    if (imageUrl.isNotEmpty) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Image.asset(
      fallbackAsset,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: AppTextStyle.medium,
            color: AppColor.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.dividerGrey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.dividerGrey),
          ),
          child: Text(
            value,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
