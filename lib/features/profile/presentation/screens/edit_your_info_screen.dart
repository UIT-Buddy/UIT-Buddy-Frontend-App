import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';
import 'dart:typed_data';

class EditYourInfoScreen extends StatefulWidget {
  const EditYourInfoScreen({super.key, required this.info});

  final YourInfoEntity info;

  @override
  State<EditYourInfoScreen> createState() => _EditYourInfoScreenState();
}

class _EditYourInfoScreenState extends State<EditYourInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _genderCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _homeClassCtrl;
  late final TextEditingController _facultyCtrl;
  late final TextEditingController _majorCtrl;

  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _pickedAvatarBytes;
  String? _pickedAvatarPath;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.info.fullName);
    _genderCtrl = TextEditingController(text: widget.info.gender);
    _emailCtrl = TextEditingController(text: widget.info.email);
    _bioCtrl = TextEditingController(text: widget.info.bio);
    _homeClassCtrl = TextEditingController(text: widget.info.homeClass);
    _facultyCtrl = TextEditingController(text: widget.info.faculty);
    _majorCtrl = TextEditingController(text: widget.info.major);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _genderCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    _homeClassCtrl.dispose();
    _facultyCtrl.dispose();
    _majorCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    if (!mounted) return;
    setState(() {
      _pickedAvatarBytes = bytes;
      _pickedAvatarPath = picked.path;
    });
  }

  Future<void> _openAvatarPickerSheet() async {
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
                  _pickAvatar(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from library'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickAvatar(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final updated = YourInfoEntity(
      mssv: widget.info.mssv, // read-only
      fullName: _fullNameCtrl.text.trim(),
      gender: _genderCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      avatarUrl: _pickedAvatarBytes != null
          ? 'data:image/jpeg;base64,${base64Encode(_pickedAvatarBytes!)}'
          : widget.info.avatarUrl,
      bio: _bioCtrl.text.trim(),
      homeClass: _homeClassCtrl.text.trim(),
      faculty: _facultyCtrl.text.trim(),
      major: _majorCtrl.text.trim(),
    );
    context.pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
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
                      style: AppTextStyle.h3.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
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
            ),

            const Divider(height: 1, color: AppColor.dividerGrey),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MSSV is read-only
                      _ReadOnlyField(label: 'MSSV', value: widget.info.mssv),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _fullNameCtrl,
                        label: 'Full Name',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _genderCtrl, label: 'Gender'),
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
                      const SizedBox(height: 24),
                      Text(
                        'Academic',
                        style: AppTextStyle.captionLarge.copyWith(
                          fontWeight: AppTextStyle.bold,
                          color: AppColor.primaryText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _homeClassCtrl,
                        label: 'Home Class',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _facultyCtrl,
                        label: 'Faculty',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _majorCtrl, label: 'Major'),
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
              ),
            ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avatar URL',
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: AppTextStyle.medium,
            color: AppColor.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _openAvatarPickerSheet,
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
                    imageBytes: _pickedAvatarBytes,
                    imageUrl: currentAvatarUrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentAvatarUrl.isEmpty
                        ? 'Tap to select avatar image'
                        : currentAvatarUrl,
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
  const _AvatarPreview({required this.imageBytes, required this.imageUrl});

  final Uint8List? imageBytes;
  final String imageUrl;

  bool get _isNetworkUrl =>
      imageUrl.startsWith('http://') ||
      imageUrl.startsWith('https://') ||
      imageUrl.startsWith('blob:');

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      );
    }

    if (_isNetworkUrl) {
      return Image.network(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    if (imageUrl.isNotEmpty) {
      return Image.asset(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Image.asset(
      'assets/images/placeholder/user-icon.png',
      width: 56,
      height: 56,
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
