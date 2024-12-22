import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/views/specific_day_screen.dart';
import 'package:expense_tracker/router.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  test('should navigate to SpecificDayScreen for Routes.specificDay', () {
    // Arrange: Define the route settings for '/specificDay'
    final routeSettings = RouteSettings(name: Routes.specificDay);

    // Act: Generate the route
    final route = AppRouter.generateRoute(routeSettings);

    // Assert: Verify that the route is of type MaterialPageRoute
    expect(route, isA<MaterialPageRoute>());

    final materialPageRoute = route as MaterialPageRoute;

    // Verify that the builder is a closure that returns a SpecificDayScreen
    expect(materialPageRoute.builder, isA<SpecificDayScreen Function(BuildContext)>());

    // Mock BuildContext to call the builder
    final mockContext = MockBuildContext();

    // Act: Call the builder with the mock context to create the widget
    final widget = materialPageRoute.builder(mockContext);

    // Assert: Verify that the widget created by the builder is of type SpecificDayScreen
    expect(widget, isA<SpecificDayScreen>());
  });

  test('should return a fallback route for undefined routes', () {
    // Arrange: Define the route settings for an undefined route
    final routeSettings = RouteSettings(name: '/undefinedRoute');

    // Act: Generate the route
    final route = AppRouter.generateRoute(routeSettings);

    // Assert: Verify that the fallback route is returned
    expect(route, isA<MaterialPageRoute>());
    final materialPageRoute = route as MaterialPageRoute;

    // Mock BuildContext to call the builder
    final mockContext = MockBuildContext();

    // Check that the fallback route displays the correct text
    final fallbackWidget = materialPageRoute.builder(mockContext);
    expect(
      (fallbackWidget as Scaffold).body,
      isA<Center>().having(
        (center) => (center.child as Text).data,
        'text',
        'No route defined for /undefinedRoute',
      ),
    );
  });
}
