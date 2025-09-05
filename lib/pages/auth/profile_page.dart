import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/auth/auth_gate.dart';
import 'package:greatchem/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  Map<String, dynamic>? _profileData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await authService.getProfile();
      setState(() {
        _profileData = profile;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat profil: $e")));
      }
    }
  }

  void logout() async {
    try {
      await authService.signOut();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profileData;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6C432D)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Akun',
          style: TextStyle(
            color: Color(0xFF6C432D),
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Color(0xFFDFCFB5),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF6C432D),
          image: DecorationImage(
            image: AssetImage('assets/images/pattern.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : profile == null
                ? const Center(child: Text("Data profil tidak tersedia"))
                : Center(
                    child: Container(
                      height: 380.h,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Color(0xFFFDFCEA),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Color(0xFF6C432D), width: 1.w),
                      ),
                      child: ListView(
                        padding: EdgeInsets.all(20.r),
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            child: Text(
                              profile['name'] != null &&
                                      profile['name'].isNotEmpty
                                  ? profile['name'][0].toUpperCase()
                                  : '?',
                              style: TextStyle(fontSize: 32.sp),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            profile['name'] ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C432D),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            profile['role'] ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF6C432D),
                            ),
                          ),
                          Divider(height: 32.h, color: Color(0xFF6C432D)),
                          _buildProfileField("Sekolah", profile['school_name']),
                          _buildProfileField("NISN / NIP", profile['nisn_nip']),
                          _buildProfileField(
                            "Target Capaian",
                            "${profile['target_capaian'] ?? 0}%",
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton.icon(
                            onPressed: logout,
                            icon: const Icon(Icons.logout),
                            label: const Text("Keluar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileField(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Color(0xFF6C432D),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: TextStyle(
                color: Color(0xFF6C432D),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
