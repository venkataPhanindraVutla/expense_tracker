import 'package:flutter_test/flutter_test.dart';
// import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/view_model/specific_day_view_model.dart';

void main() {
  group('SpecificDayViewModel Tests', () {
    late SpecificDayViewModel viewModel;

    setUp(() {
      viewModel = SpecificDayViewModel();
    });

    test('Initial values are set correctly', () {
      expect(viewModel.selectedDate, isA<DateTime>());
      expect(viewModel.expenses, isEmpty);
    });

    test('Add expense updates the expense list', () {
      viewModel.addExpense('Lunch', 10.0, 'Food');

      expect(viewModel.expenses.length, 1);
      expect(viewModel.expenses.first.title, 'Lunch');
      expect(viewModel.expenses.first.amount, 10.0);
      expect(viewModel.expenses.first.category, 'Food');
      expect(viewModel.expenses.first.date, viewModel.selectedDate);
    });

    test('Delete expense removes the correct item', () {
      viewModel.addExpense('Lunch', 10.0, 'Food');
      viewModel.addExpense('Dinner', 15.0, 'Food');

      viewModel.deleteExpense(0);

      expect(viewModel.expenses.length, 1);
      expect(viewModel.expenses.first.title, 'Dinner');
    });

    test('Edit expense updates the correct expense', () {
      viewModel.addExpense('Lunch', 10.0, 'Food');
      viewModel.editExpense(0, 'Brunch', 12.0, 'Food');

      expect(viewModel.expenses.first.title, 'Brunch');
      expect(viewModel.expenses.first.amount, 12.0);
    });

    test('Get total expenses calculates the correct total', () {
      viewModel.addExpense('Lunch', 10.0, 'Food');
      viewModel.addExpense('Dinner', 15.0, 'Food');

      expect(viewModel.getTotalExpenses(), 25.0);
    });

    test('Update selected date filters expenses by date', () {
      final date1 = DateTime(2024, 1, 1);
      final date2 = DateTime(2024, 1, 2);

      viewModel.selectedDate = date1;
      viewModel.addExpense('Expense 1', 10.0, 'Category 1');
      viewModel.selectedDate = date2;
      viewModel.addExpense('Expense 2', 15.0, 'Category 2');

      viewModel.updateSelectedDate(date1);

      expect(viewModel.expenses.length, 1);
      expect(viewModel.expenses.first.title, 'Expense 1');
    });
  });
}
