import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/appointment_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _bloodGroupCtrl;
  late TextEditingController _dobCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nameCtrl = TextEditingController(text: profile.name);
    _emailCtrl = TextEditingController(text: profile.email);
    _phoneCtrl = TextEditingController(text: profile.phone);
    _bloodGroupCtrl = TextEditingController(text: profile.bloodGroup);
    _dobCtrl = TextEditingController(text: profile.dateOfBirth);
    _addressCtrl = TextEditingController(text: profile.address);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bloodGroupCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileProvider>().updateProfile(
          UserProfile(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            bloodGroup: _bloodGroupCtrl.text.trim(),
            dateOfBirth: _dobCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
          ),
        );
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final apptProvider = context.watch<AppointmentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _nameCtrl.text = profile.name;
                _emailCtrl.text = profile.email;
                _phoneCtrl.text = profile.phone;
                _bloodGroupCtrl.text = profile.bloodGroup;
                _dobCtrl.text = profile.dateOfBirth;
                _addressCtrl.text = profile.address;
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 48,
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Appointment stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      value: apptProvider.totalCount.toString(),
                      label: 'Total',
                      icon: Icons.assignment,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      value: apptProvider.upcoming.length.toString(),
                      label: 'Upcoming',
                      icon: Icons.upcoming,
                      color: AppTheme.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      value: apptProvider.completed.length.toString(),
                      label: 'Done',
                      icon: Icons.check_circle_outline,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),

            // Profile details / edit form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isEditing
                  ? _EditForm(
                      formKey: _formKey,
                      nameCtrl: _nameCtrl,
                      emailCtrl: _emailCtrl,
                      phoneCtrl: _phoneCtrl,
                      bloodGroupCtrl: _bloodGroupCtrl,
                      dobCtrl: _dobCtrl,
                      addressCtrl: _addressCtrl,
                      onSave: _saveProfile,
                    )
                  : _ViewProfile(profile: profile),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ViewProfile extends StatelessWidget {
  final UserProfile profile;
  const _ViewProfile({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoTile(
              icon: Icons.person_outline,
              label: 'Full Name',
              value: profile.name,
            ),
            const Divider(height: 1),
            InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profile.email,
            ),
            const Divider(height: 1),
            InfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: profile.phone,
            ),
            const Divider(height: 1),
            InfoTile(
              icon: Icons.bloodtype_outlined,
              label: 'Blood Group',
              value: profile.bloodGroup,
              iconColor: AppTheme.error,
            ),
            const Divider(height: 1),
            InfoTile(
              icon: Icons.cake_outlined,
              label: 'Date of Birth',
              value: profile.dateOfBirth,
            ),
            const Divider(height: 1),
            InfoTile(
              icon: Icons.home_outlined,
              label: 'Address',
              value: profile.address,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController bloodGroupCtrl;
  final TextEditingController dobCtrl;
  final TextEditingController addressCtrl;
  final VoidCallback onSave;

  const _EditForm({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.bloodGroupCtrl,
    required this.dobCtrl,
    required this.addressCtrl,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Phone required' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: bloodGroupCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Blood Group',
                    prefixIcon: Icon(Icons.bloodtype_outlined),
                    hintText: 'e.g. O+',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: dobCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: addressCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Icons.home_outlined),
              alignLabelWithHint: true,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Address required' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
