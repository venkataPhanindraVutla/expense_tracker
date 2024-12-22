import 'package:expense_tracker/locator.dart';
import 'package:expense_tracker/services/theme_service.dart';
import 'package:expense_tracker/view_model/home_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeCalendarScreen extends StackedView<HomeCalendarScreenViewModel> {
  const HomeCalendarScreen({super.key});

  @override
  void onViewModelReady(HomeCalendarScreenViewModel model) {
    // TODO: implement onViewModelReady
    model.initialise();
  }

  @override
  HomeCalendarScreenViewModel viewModelBuilder(BuildContext context) =>
      HomeCalendarScreenViewModel();

  @override
  Widget builder(
      BuildContext context, HomeCalendarScreenViewModel model, Widget? child) {
    final themeService = Theme.of(context);
    final colorScheme = themeService.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(dateTimeService.getMonthName(model.appBarDate)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: model.onSearch,
                  icon: Icon(
                    Icons.search,
                    color: colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
                InkWell(
                  onTap: model.onTapCircleAvatar,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userConfig.photoUrl),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: SfCalendar(
          controller: model.calendarController,
          cellBorderColor: themeService.colorScheme.secondary.withOpacity(0.5),
          onViewChanged: (details) {
            final visibleDates = details.visibleDates;
            final currentDate = visibleDates[0];
            model.changeappBarMonth(currentDate);
          },
          onTap: model.onTapCell,
          monthViewSettings: const MonthViewSettings(
            showTrailingAndLeadingDates:
                false, // Adjust the width of the border (optional)
          ),
          monthCellBuilder: (BuildContext context, MonthCellDetails details) {
            // Get the date for the cell
            DateTime date = details.date;

            // Check if the cell is today
            bool isToday = DateTime.now().difference(date).inDays == 0 &&
                DateTime.now().day == date.day;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(
                    color: colorScheme.secondary.withOpacity(0.4), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.highLightColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.white,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          headerHeight: 0,
          view: CalendarView.month,
        ),
      ),
    );
  }
}
