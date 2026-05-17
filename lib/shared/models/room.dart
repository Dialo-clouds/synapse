class SmartRoom {
  final String id;
  final String name;
  final String iconType;
  final List<String> deviceIds;

  SmartRoom({
    required this.id,
    required this.name,
    required this.iconType,
    required this.deviceIds,
  });

  static List<SmartRoom> getDefaultRooms() {
    return [
      SmartRoom(id: 'living', name: 'Living Room', iconType: 'sofa', deviceIds: ['light_1', 'thermo_1', 'tv_1']),
      SmartRoom(id: 'bedroom', name: 'Bedroom', iconType: 'bed', deviceIds: ['light_2', 'lock_1']),
      SmartRoom(id: 'kitchen', name: 'Kitchen', iconType: 'cook', deviceIds: ['light_3', 'coffee_1']),
      SmartRoom(id: 'bathroom', name: 'Bathroom', iconType: 'bath', deviceIds: ['light_4']),
      SmartRoom(id: 'office', name: 'Office', iconType: 'desk', deviceIds: ['light_5', 'speaker_1', 'blinds_1']),
      SmartRoom(id: 'garage', name: 'Garage', iconType: 'car', deviceIds: ['light_6', 'lock_2']),
    ];
  }
}