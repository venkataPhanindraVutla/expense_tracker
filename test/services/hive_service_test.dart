import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:expense_tracker/services/hive_service.dart';
import 'package:hive/hive.dart';

class MockBox<T> extends Mock implements Box<T> {}
class MockDirectory extends Mock implements Directory {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();  // Ensure Flutter bindings are initialized

  group('HiveService Test', () {
    late MockBox mockBox;
    late MockDirectory mockDirectory;

    setUp(() {
      mockBox = MockBox();
      mockDirectory = MockDirectory();

      // Mock the path for getApplicationDocumentsDirectory
      when(mockDirectory.path).thenReturn('/mock/path');
      when(getApplicationDocumentsDirectory()).thenAnswer((_) async => mockDirectory);
    });

    test('should initialize Hive', () async {
      // Call the initializeHive method
      await HiveService.initializeHive();

      // Verify if Hive has registered the adapters
      verify(mockDirectory.path);
    });

    test('should open a Hive box', () async {
      when(Hive.isBoxOpen('testBox')).thenReturn(false);
      when(Hive.openBox('testBox')).thenAnswer((_) async => mockBox);

      final box = await HiveService.openBox('testBox');

      expect(box, isA<MockBox>());
      verify(Hive.openBox('testBox'));
    });

    test('should put an item in the Hive box', () async {
      // Since putItem is a void function, just ensure it doesn't return anything and verify the call
      when(mockBox.put(any, any)).thenAnswer((_) async => Future.value(null));  // Mock future response for put

      // Call the putItem method
      HiveService.putItem(mockBox, 'testKey', 'testValue');

      // Verify if the put method was called with correct arguments
      verify(mockBox.put('testKey', 'testValue')).called(1);
    });

    test('should get an item from the Hive box', () {
      when(mockBox.get('testKey')).thenReturn('testValue');

      final result = HiveService.getItem(mockBox, 'testKey');

      expect(result, 'testValue');
      verify(mockBox.get('testKey')).called(1);  // Verify get is called
    });

    test('should delete an item from the Hive box', () async {
      // Since deleteItem is a void function, mock the Future response and verify the call
      when(mockBox.delete(any)).thenAnswer((_) async => Future.value(null));  // Mock future response for delete

      // Call the deleteItem method
      HiveService.deleteItem(mockBox, 'testKey');

      // Verify if the delete method was called with correct arguments
      verify(mockBox.delete('testKey')).called(1);
    });
  });
}
