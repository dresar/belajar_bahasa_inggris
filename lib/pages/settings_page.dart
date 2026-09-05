import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/gemini_audio_service.dart';
import '../services/neon_db_service.dart';
import '../services/theme_service.dart';
import '../services/xp_service.dart';
import '../shared/animations/scale_animation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  String _audioSpeed = 'Normal';

  NeonUser? _currentUser;
  List<NeonUserProgress> _userProgress = [];
  bool _isLoadingUser = true;
  bool _isLoggingIn = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserAndProgress();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndProgress() async {
    setState(() => _isLoadingUser = true);
    await NeonDbService.instance.initDbAndSeed();
    final user = NeonDbService.instance.currentUser;
    List<NeonUserProgress> progress = [];

    if (user != null) {
      progress = await NeonDbService.instance.getUserProgress(user.id);
    }

    if (mounted) {
      setState(() {
        _currentUser = user;
        _userProgress = progress;
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _handleQuickDevLogin() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoggingIn = true);

    final user = await NeonDbService.instance.login('dev@example.com', 'dev123');
    if (user != null) {
      final progress = await NeonDbService.instance.getUserProgress(user.id);
      if (mounted) {
        setState(() {
          _currentUser = user;
          _userProgress = progress;
          _isLoggingIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text('Berhasil login sebagai ${user.fullName}!'),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      }
    } else {
      if (mounted) setState(() => _isLoggingIn = false);
    }
  }

  Future<void> _handleLogout() async {
    HapticFeedback.lightImpact();
    await NeonDbService.instance.logout();
    if (mounted) {
      setState(() {
        _currentUser = null;
        _userProgress = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Berhasil keluar dari akun.'),
            ],
          ),
          backgroundColor: const Color(0xFF757575),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  void _showLoginDialog() {
    _emailController.clear();
    _passwordController.clear();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.login_rounded,
                          color: Color(0xFF1976D2),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login Akun',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            'Koneksi Database Neon PostgreSQL',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email / Username',
                      hintText: 'e.g. dev@example.com',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'e.g. dev123',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final email = _emailController.text;
                            final pass = _passwordController.text;
                            final messenger = ScaffoldMessenger.of(context);
                            Navigator.of(ctx).pop();

                            setState(() => _isLoggingIn = true);
                            final u = await NeonDbService.instance.login(email, pass);
                            if (u != null) {
                              final prog = await NeonDbService.instance.getUserProgress(u.id);
                              if (mounted) {
                                setState(() {
                                  _currentUser = u;
                                  _userProgress = prog;
                                  _isLoggingIn = false;
                                });
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Selamat datang, ${u.fullName}!'),
                                    backgroundColor: const Color(0xFF4CAF50),
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                setState(() => _isLoggingIn = false);
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Login gagal. Periksa email/password!'),
                                    backgroundColor: Color(0xFFE53935),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onResetProgress() {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Kemajuan belajar berhasil di-reset!'),
          ],
        ),
        backgroundColor: const Color(0xFFE24379),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    _buildUserAccountAndProgressSection(),
                    const SizedBox(height: 16),
                    _buildSettingTile(
                      icon: Icons.volume_up_rounded,
                      iconColor: const Color(0xFF1E88E5),
                      title: 'Efek Suara Game',
                      subtitle: 'Suara tombol, jawaban benar dan salah',
                      trailing: Switch(
                        value: _soundEnabled,
                        activeTrackColor: const Color(0xFF4CAF50),
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() => _soundEnabled = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingTile(
                      icon: Icons.music_note_rounded,
                      iconColor: const Color(0xFFFFB300),
                      title: 'Musik Latar Ceria',
                      subtitle: 'Musik latar santai saat bermain game',
                      trailing: Switch(
                        value: _musicEnabled,
                        activeTrackColor: const Color(0xFF4CAF50),
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() => _musicEnabled = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingTile(
                      icon: Icons.speed_rounded,
                      iconColor: const Color(0xFF8E24AA),
                      title: 'Kecepatan Suara',
                      subtitle: 'Pilih kecepatan pengucapan kata',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: ['Pelan', 'Normal', 'Cepat'].map((speed) {
                          final isSelected = _audioSpeed == speed;
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: ScaleAnimation(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _audioSpeed = speed);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF8E24AA)
                                      : const Color(0xFFF3E5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  speed,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF8E24AA),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingTile(
                      icon: Icons.palette_rounded,
                      iconColor: const Color(0xFFE53935),
                      title: 'Warna Tema Tampilan',
                      subtitle: 'Pilih nuansa warna tampilan aplikasi',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: ThemeService.instance.currentThemeName.value,
                          underline: const SizedBox(),
                          isDense: true,
                          items: ThemeService.palettes.keys
                              .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      t,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              HapticFeedback.selectionClick();
                              ThemeService.instance.setTheme(val);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingTile(
                      icon: Icons.cloud_download_rounded,
                      iconColor: const Color(0xFF1976D2),
                      title: '📥 Export CDN Audio Manifest (Debug Tool)',
                      subtitle: 'Salin database CDN Cloudinary untuk dijadikan kode hardcode',
                      onTap: () {
                        final currentContext = context;
                        GeminiAudioService.instance.exportCdnDatabaseMap().then((dbData) {
                          if (!currentContext.mounted) return;
                          final messenger = ScaffoldMessenger.of(currentContext);
                          showDialog(
                            context: currentContext,
                            builder: (ctx) => AlertDialog(
                              title: const Text('📋 Export CDN Audio DB Map'),
                              content: SingleChildScrollView(
                                child: SelectableText(dbData),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: dbData));
                                    Navigator.of(ctx).pop();
                                    messenger.showSnackBar(
                                      const SnackBar(content: Text('✅ Peta CDN Audio berhasil disalin!')),
                                    );
                                  },
                                  child: const Text('Salin Teks'),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ScaleAnimation(
                            onTap: _onResetProgress,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE53935),
                                  width: 2,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: Color(0xFFE53935),
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Reset Belajar',
                                      style: TextStyle(
                                        color: Color(0xFFE53935),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF1E88E5),
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'SD Kids Edition v1.0',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAccountAndProgressSection() {
    if (_isLoadingUser || _isLoggingIn) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1976D2)),
        ),
      );
    }

    if (_currentUser == null) {
      final xp = XpService.instance.totalXp;
      final lvl = XpService.instance.level;
      final completedCount = XpService.instance.completedChapterIds.length;

      return Column(
        children: [
          // Guest Progress Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$xp XP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Level $lvl',
                              style: const TextStyle(
                                color: Color(0xFFE65100),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pemain Tamu • $completedCount Topik Selesai',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Cloud Login Option
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF0288D1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0288D1).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_sync_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login Progress Cloud',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Konek ke Neon PostgreSQL Database',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                          foregroundColor: const Color(0xFF333333),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _handleQuickDevLogin,
                        icon: const Icon(Icons.flash_on_rounded, size: 20),
                        label: const Text(
                          'Login Dev (Quick)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _showLoginDialog,
                        icon: const Icon(Icons.login_rounded, size: 20),
                        label: const Text(
                          'Login Akun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    final user = _currentUser!;

    return Column(
      children: [
        // Profile Banner Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      user.role == 'developer'
                          ? Icons.developer_board_rounded
                          : Icons.person_rounded,
                      color: const Color(0xFF2E7D32),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD54F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                user.role.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(
                              Icons.storage_rounded,
                              color: Color(0xFFB9F6CA),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Neon PostgreSQL Connected',
                              style: TextStyle(
                                color: Color(0xFFB9F6CA),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _handleLogout,
                    tooltip: 'Logout',
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Progress List Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: Color(0xFFFF8F00),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Topik yang Sudah Dilewati',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_userProgress.length} Topik Selesai',
                      style: const TextStyle(
                        color: Color(0xFFFF8F00),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              if (_userProgress.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Belum ada topik yang dilewati. Ayo mulai bermain!',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: _userProgress.map((prog) {
                    final dateStr =
                        '${prog.completedAt.day}/${prog.completedAt.month}/${prog.completedAt.year}';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Kelas ${prog.grade}',
                              style: const TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prog.chapterTitle,
                                  style: const TextStyle(
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'Selesai pada: $dateStr',
                                  style: const TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF2E7D32),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${prog.score}%',
                                  style: const TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 46),
          const Text(
            'Pengaturan Game SD',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          ScaleAnimation(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE24379),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.reply_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
