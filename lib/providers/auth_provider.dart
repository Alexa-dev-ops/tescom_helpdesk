import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tescom_helpdesk/services/auth_service.dart';

final authProvider = Provider<AuthService>((ref) => AuthService());
