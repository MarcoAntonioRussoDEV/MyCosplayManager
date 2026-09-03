import '../core/api_client.dart';

class UserSettings {
  final String email;
  final String name;
  final int notificationDaysBefore;

  UserSettings({required this.email, required this.name, required this.notificationDaysBefore});

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        email: json['email'] as String,
        name: json['name'] as String,
        notificationDaysBefore: json['notificationDaysBefore'] as int,
      );
}

class TeamInfo {
  final String name;
  final String inviteCode;

  TeamInfo({required this.name, required this.inviteCode});

  factory TeamInfo.fromJson(Map<String, dynamic> json) =>
      TeamInfo(name: json['name'] as String, inviteCode: json['inviteCode'] as String);
}

class SettingsRepository {
  final ApiClient _apiClient;

  SettingsRepository(this._apiClient);

  Future<UserSettings> getUser() async =>
      UserSettings.fromJson(await _apiClient.get('/api/users/me') as Map<String, dynamic>);

  Future<UserSettings> updateNotificationDaysBefore(int days) async => UserSettings.fromJson(
      await _apiClient.patch('/api/users/me', body: {'notificationDaysBefore': days}) as Map<String, dynamic>);

  Future<TeamInfo> getTeam() async =>
      TeamInfo.fromJson(await _apiClient.get('/api/teams/me') as Map<String, dynamic>);

  Future<TeamInfo> joinTeam(String inviteCode) async => TeamInfo.fromJson(
      await _apiClient.post('/api/teams/join', body: {'inviteCode': inviteCode}) as Map<String, dynamic>);
}
