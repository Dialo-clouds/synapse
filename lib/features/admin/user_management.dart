import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final List<_TeamMember> _members = [
    _TeamMember(name: 'Alex Karanja', email: 'alex@synapse.app', role: 'Admin', status: 'Online'),
    _TeamMember(name: 'Sarah Chen', email: 'sarah@synapse.app', role: 'User', status: 'Online'),
    _TeamMember(name: 'Mike Johnson', email: 'mike@synapse.app', role: 'User', status: 'Offline'),
    _TeamMember(name: 'Emily Davis', email: 'emily@synapse.app', role: 'Guest', status: 'Online'),
    _TeamMember(name: 'Tom Wilson', email: 'tom@synapse.app', role: 'Guest', status: 'Away'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: const Center(child: Icon(Icons.arrow_back, color: SynapseTokens.textSecondary, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'User Management',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('ADD USER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                  ),
                ],
              ),
            ),

            // Role summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _RoleBadge(label: 'Admin', count: 1, color: SynapseTokens.neuralPink),
                  const SizedBox(width: 8),
                  _RoleBadge(label: 'Users', count: 2, color: SynapseTokens.electricBlue),
                  const SizedBox(width: 8),
                  _RoleBadge(label: 'Guests', count: 2, color: SynapseTokens.auroraTeal),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  final roleColor = _getRoleColor(member.role);
                  final statusColor = _getStatusColor(member.status);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [roleColor.withOpacity(0.4), roleColor.withOpacity(0.1)]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              member.name[0],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: roleColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(member.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 6, height: 6,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(member.email, style: const TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(member.role, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: roleColor)),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.more_vert, color: SynapseTokens.textTertiary.withOpacity(0.4), size: 16),
                      ],
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: index * 60)).slideX(begin: 10, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin': return SynapseTokens.neuralPink;
      case 'User': return SynapseTokens.electricBlue;
      case 'Guest': return SynapseTokens.auroraTeal;
      default: return SynapseTokens.textTertiary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Online': return SynapseTokens.auroraTeal;
      case 'Offline': return SynapseTokens.textTertiary;
      case 'Away': return SynapseTokens.plasmaAmber;
      default: return SynapseTokens.textTertiary;
    }
  }
}

class _TeamMember {
  final String name, email, role, status;
  _TeamMember({required this.name, required this.email, required this.role, required this.status});
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _RoleBadge({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text('$count $label', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}