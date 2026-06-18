import 'package:flutter_test/flutter_test.dart';
import 'package:jfs_ecommerce/core/utils/validators.dart';

void main() {
  group('Login Validation Unit Tests', () {

    group('Email Validation', () {
      test('should return error string if email is null', () {
        final result = Validators.validateEmail(null);
        expect(result, 'Email required');
      });

      test('should return error string if email is empty', () {
        final result = Validators.validateEmail('');
        expect(result, 'Email required');
      });

      test('should return error string if email format is invalid', () {
        final result = Validators.validateEmail('invalid-email@com');
        expect(result, 'Enter a valid email address');
      });

      test('should return null if email format is valid', () {
        final result = Validators.validateEmail('user@example.com');
        expect(result, null);
      });
    });

    group('Password Validation', () {
      test('should return error string if password is null', () {
        final result = Validators.validatePassword(null);
        expect(result, 'Password required');
      });

      test('should return error string if password is empty', () {
        final result = Validators.validatePassword('');
        expect(result, 'Password required');
      });

      test('should return error string if password is too short', () {
        final result = Validators.validatePassword('12345');
        expect(result, 'Password must be at least 6 characters');
      });

      test('should return null if password meets all requirements', () {
        final result = Validators.validatePassword('secure123');
        expect(result, null);
      });
    });
  });
}