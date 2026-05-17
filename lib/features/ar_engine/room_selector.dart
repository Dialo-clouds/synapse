import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../shared/models/room.dart';

class RoomSelector extends StatelessWidget {
  final String selectedRoom;
  final ValueChanged<SmartRoom> onRoomSelected;

  const RoomSelector({
    super.key,
    required this.selectedRoom,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    final rooms = SmartRoom.getDefaultRooms();

    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final isSelected = room.id == selectedRoom;

          return GestureDetector(
            onTap: () => onRoomSelected(room),
            child: AnimatedContainer(
              duration: SynapseTokens.durationFast,
              margin: const EdgeInsets.only(right: 10),
              width: 80,
              decoration: BoxDecoration(
                color: isSelected 
                    ? SynapseTokens.electricBlue.withOpacity(0.15) 
                    : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected 
                      ? SynapseTokens.electricBlue.withOpacity(0.4) 
                      : Colors.white.withOpacity(0.06),
                  width: isSelected ? 1.5 : 0.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: SynapseTokens.electricBlue.withOpacity(0.15), blurRadius: 12)]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getRoomIcon(room.iconType),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    room.name.split(' ').first,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? SynapseTokens.electricBlue : SynapseTokens.textSecondary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn().slideY(begin: -20, end: 0);
  }

  String _getRoomIcon(String type) {
    switch (type) {
      case 'sofa': return '🛋️';
      case 'bed': return '🛏️';
      case 'cook': return '🍳';
      case 'bath': return '🛁';
      case 'desk': return '🖥️';
      case 'car': return '🚗';
      default: return '🏠';
    }
  }
}