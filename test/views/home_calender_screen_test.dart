import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:expense_tracker/services/theme_service.dart';
import 'package:expense_tracker/view_model/home_calendar_screen_view_model.dart';
import 'package:expense_tracker/views/home_calendar_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  // Create a mock HomeCalendarScreenViewModel
  late HomeCalendarScreenViewModel viewModel;

  setUp(() {
    // Initialize the viewModel before each test
    viewModel = HomeCalendarScreenViewModel();
    viewModel.initialise();
  });

  testWidgets('should display HomeCalendarScreen with SfCalendar and AppBar', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomeCalendarScreen(),
      ),
    );

    // Check if AppBar is displayed with correct title (e.g., current month)
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.textContaining("January"), findsOneWidget); // Assuming "January" as default month name

    // Check if the SfCalendar widget is present in the body
    expect(find.byType(SfCalendar), findsOneWidget);

    // Check if the search button is present in the AppBar
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Check if the CircleAvatar widget is present in the AppBar (mock photo URL)
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('should update appBarMonth when calendar view is changed', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomeCalendarScreen(),
      ),
    );

    // Find the SfCalendar widget
    final sfCalendar = find.byType(SfCalendar);

    // Simulate the month change
    final calendar = tester.widget<SfCalendar>(sfCalendar);
    final calendarController = calendar.controller;

    // Change the view by updating the visible dates (for example, to simulate month change)
    calendarController.view = CalendarView.month;

    // Let the UI rebuild after the change
    await tester.pumpAndSettle();

    // Verify that the AppBar title (month) is updated after changing the calendar view
    expect(find.textContaining("February"), findsOneWidget); // Update to the expected month
  });

  testWidgets('should call search function when search icon is tapped', (WidgetTester tester) async {
    bool searchTapped = false;

    // Override the onSearch method with a simple function to set searchTapped to true
    viewModel.onSearch = () {
      searchTapped = true;
    };

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomeCalendarScreen(),
      ),
    );

    // Find the search icon and tap it
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Verify that the onSearch method was called (i.e., searchTapped should be true)
    expect(searchTapped, true);
  });

  testWidgets('should call onTapCircleAvatar when avatar is tapped', (WidgetTester tester) async {
    bool avatarTapped = false;

    // Override the onTapCircleAvatar method to update avatarTapped
    viewModel.onTapCircleAvatar = () {
      avatarTapped = true;
    };

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomeCalendarScreen(),
      ),
    );

    // Find the CircleAvatar and tap it
    await tester.tap(find.byType(CircleAvatar));
    await tester.pump();

    // Verify that the onTapCircleAvatar method was called (i.e., avatarTapped should be true)
    expect(avatarTapped, true);
  });
}
