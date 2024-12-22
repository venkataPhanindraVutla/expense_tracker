import 'package:expense_tracker/views/specific_day_screen.dart';
import 'package:expense_tracker/view_model/specific_day_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked/stacked.dart';

// Mock ViewModel
class MockSpecificDayViewModel extends Mock implements SpecificDayViewModel {}

void main() {
  late MockSpecificDayViewModel mockViewModel;
  late CalendarTapDetails mockDetails;

  setUp(() {
    mockViewModel = MockSpecificDayViewModel();
    mockDetails = CalendarTapDetails(
      date: DateTime.now(),
      targetElement: CalendarElement.appointment,
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: SpecificDayScreen(details: mockDetails),
    );
  }

  group('SpecificDayScreen Widget Tests', () {
    testWidgets('should render the screen and show CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(true);
      when(mockViewModel.expenses).thenReturn([]);

      await tester.pumpWidget(ViewModelBuilder<SpecificDayViewModel>.reactive(
        viewModelBuilder: () => mockViewModel,
        builder: (context, model, child) => SpecificDayScreen(details: mockDetails),
      ));

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show "No expenses recorded for today" when expenses list is empty',
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.expenses).thenReturn([]);

      await tester.pumpWidget(ViewModelBuilder<SpecificDayViewModel>.reactive(
        viewModelBuilder: () => mockViewModel,
        builder: (context, model, child) => SpecificDayScreen(details: mockDetails),
      ));

      // Act
      await tester.pump();

      // Assert
      expect(find.text('No expenses recorded for today.'), findsOneWidget);
    });

    testWidgets('should show list of expenses and dismiss item', (WidgetTester tester) async {
      // Arrange
      final expenses = [
        Expense(title: 'Test Expense 1', amount: 100, category: 'Food'),
        Expense(title: 'Test Expense 2', amount: 50, category: 'Transport')
      ];

      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.expenses).thenReturn(expenses);

      await tester.pumpWidget(ViewModelBuilder<SpecificDayViewModel>.reactive(
        viewModelBuilder: () => mockViewModel,
        builder: (context, model, child) => SpecificDayScreen(details: mockDetails),
      ));

      // Act
      await tester.pump();
      await tester.drag(find.byType(Dismissible).first, Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Expense 1'), findsNothing);
      verify(mockViewModel.deleteExpense(0)).called(1);
    });

    testWidgets('should open add expense dialog when floating action button is pressed',
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.expenses).thenReturn([]);

      await tester.pumpWidget(ViewModelBuilder<SpecificDayViewModel>.reactive(
        viewModelBuilder: () => mockViewModel,
        builder: (context, model, child) => SpecificDayScreen(details: mockDetails),
      ));

      // Act
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Add New Expense'), findsOneWidget);
    });

    testWidgets('should allow editing an expense', (WidgetTester tester) async {
      // Arrange
      final expenses = [
        Expense(title: 'Test Expense 1', amount: 100, category: 'Food'),
      ];

      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.expenses).thenReturn(expenses);

      await tester.pumpWidget(ViewModelBuilder<SpecificDayViewModel>.reactive(
        viewModelBuilder: () => mockViewModel,
        builder: (context, model, child) => SpecificDayScreen(details: mockDetails),
      ));

      // Act
      await tester.pump();
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Edit Expnese'), findsOneWidget);
    });
  });
}
