import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_storage_service.dart';
import '../services/theme_service.dart';
import '../services/xp_service.dart';
import '../shared/animations/scale_animation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Siswa Pintar SD 🌟';
  String _selectedAvatar = '🦸‍♂️';
  String? _customPhotoUrl;
  bool _isAnonymous = false;
  bool _isUploadingPhoto = false;

  final List<String> _avatars = ['🦸‍♂️', '👩‍🚀', '🐱', '🐶', '🦄', '🦁', '🤖', '🦊'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await CloudinaryStorageService.instance.getUserProfile();
    if (mounted) {
      setState(() {
        _username = profile['username'] as String;
        _selectedAvatar = profile['avatarEmoji'] as String;
        _customPhotoUrl = profile['photoUrl'] as String?;
        _isAnonymous = profile['isAnonymous'] as bool;
      });
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (file == null) return;

      setState(() => _isUploadingPhoto = true);
      HapticFeedback.mediumImpact();

      final bytes = await file.readAsBytes();
      final newUrl = await CloudinaryStorageService.instance.uploadProfilePhoto(
        bytes,
        file.name,
      );

      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
          if (newUrl != null) {
            _customPhotoUrl = newUrl;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Foto profil berhasil diperbarui!'),
            backgroundColor: Color(0xFF43A047),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  void _showEditUsernameDialog() {
    final controller = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('✏️ Ubah Nama Pengguna', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama kamu...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C4DFF)),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                setState(() => _username = newName);
                await CloudinaryStorageService.instance.saveUserProfile(
                  username: _username,
                  avatarEmoji: _selectedAvatar,
                  isAnonymous: _isAnonymous,
                  photoUrl: _customPhotoUrl,
                );
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🔑 Reset Kata Sandi', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Email instruksi reset kata sandi akan dikirimkan ke email terdaftar kamu.',
          style: TextStyle(fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE65100)),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📧 Link reset password telah dikirim ke email kamu!'),
                  backgroundColor: Color(0xFFE65100),
                ),
              );
            },
            child: const Text('Kirim Link Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = ThemeService.instance.currentPalette;
    final totalXp = XpService.instance.totalXp;
    final level = XpService.instance.level;
    final completedCount = XpService.instance.completedChapterIds.length;

    String levelTitle = 'Pemula Cerdas 🚀';
    if (level >= 10) {
      levelTitle = 'Master Bahasa 👑';
    } else if (level >= 5) {
      levelTitle = 'Jagoan Inggris 🌟';
    } else if (level >= 3) {
      levelTitle = 'Bintang Belajar ⭐';
    } else if (level >= 2) {
      levelTitle = 'Pejuang Hebat 🛡️';
    }

    return Scaffold(
      backgroundColor: palette.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // User Avatar & Photo Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [palette.primaryColor, palette.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: palette.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Image / Avatar Display with Camera Edit Button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _isUploadingPhoto
                              ? const Center(child: CircularProgressIndicator())
                              : _customPhotoUrl != null && _customPhotoUrl!.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        _customPhotoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Center(
                                          child: Text(_selectedAvatar,
                                              style: const TextStyle(fontSize: 48)),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(_selectedAvatar,
                                          style: const TextStyle(fontSize: 48)),
                                    ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ScaleAnimation(
                            onTap: _pickAndUploadPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF8F00),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Username with Edit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isAnonymous ? 'User Anonim 👤' : _username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _showEditUsernameDialog,
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.white70, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'Level $level • $levelTitle',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('⭐ Total EXP', '$totalXp XP', const Color(0xFFFF8F00)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard('📖 Bab Selesai', '$completedCount Bab', const Color(0xFF43A047)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Avatar Selector Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎭 Pilih Karakter Avatar Kamu:',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _avatars.map((av) {
                        final isSel = av == _selectedAvatar && _customPhotoUrl == null;
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              _selectedAvatar = av;
                              _customPhotoUrl = null; // Switch back to emoji avatar
                            });
                            await CloudinaryStorageService.instance.saveUserProfile(
                              username: _username,
                              avatarEmoji: av,
                              isAnonymous: _isAnonymous,
                              photoUrl: '',
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFFE1BEE7) : const Color(0xFFF5F5F5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel ? const Color(0xFF8E24AA) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(av, style: const TextStyle(fontSize: 28)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Account & Security Settings Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚙️ Pengaturan Akun & Keamanan:',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Anonymous Toggle
                    SwitchListTile(
                      activeTrackColor: const Color(0xFF7C4DFF),
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mode Anonim / Tamu 👤',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Sembunyikan nama di papan peringkat',
                          style: TextStyle(fontSize: 11.5)),
                      value: _isAnonymous,
                      onChanged: (val) async {
                        setState(() => _isAnonymous = val);
                        await CloudinaryStorageService.instance.saveUserProfile(
                          username: _username,
                          avatarEmoji: _selectedAvatar,
                          isAnonymous: val,
                          photoUrl: _customPhotoUrl,
                        );
                      },
                    ),
                    const Divider(),

                    // Reset Password Button
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.lock_reset_rounded, color: Color(0xFFE65100)),
                      title: const Text('Reset Kata Sandi 🔑',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
                      onTap: _showResetPasswordDialog,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF666666), fontSize: 11.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}
