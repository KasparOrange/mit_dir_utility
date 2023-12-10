import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimetableView extends StatefulWidget implements SidebarInterface {
  const TimetableView({super.key});

  @override
  State<TimetableView> createState() => _TimetableViewState();

  @override
  List<Widget> get sidebarWidgets {
    return [
      const Text("TimetableView Sidebar"),
    ];
  }
}

class _TimetableViewState extends State<TimetableView> {
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    // _getShiftScheduler(_events, _onCalendarTapped, _onViewChanged);

    SfCalendar(
      view: CalendarView.timelineWeek,
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings:
          const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }
  final CalendarController _calendarController = CalendarController();

  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final List<Appointment> _shiftCollection = <Appointment>[];
  final List<CalendarResource> _employeeCollection = <CalendarResource>[];
  final List<String> _nameCollection = <String>['Tom', 'Lisa'];
  final List<TimeRegion> _specialTimeRegions = <TimeRegion>[];
  final List<String> _userImages = <String>[];
  final List<String> _colorNames = <String>[];
  final List<String> _timeZoneCollection = <String>[];


  late List<DateTime> _visibleDates;

  Appointment? _selectedAppointment;

  late _ShiftDataSource _events;

  @override
  void initState() {
    _calendarController.view = CalendarView.timelineWeek;
    _selectedAppointment = null;
    _addResources(); // Adds random events
    _addSpecialRegions();
    _addAppointmentDetails();
    _addAppointments();
    _events = _ShiftDataSource(_shiftCollection, _employeeCollection);
    super.initState();
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    _visibleDates = visibleDatesChangedDetails.visibleDates;
  }

  /// Navigates to appointment editor page when the calendar elements tapped
  /// other than the header, handled the editor fields based on tapped element.
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
  }

  /// Creates the required resource details as list

  /// Creates the required appointment details as a list.
  void _addAppointmentDetails() {
    _subjectCollection.add('General Meeting');
    _subjectCollection.add('Plan Execution');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Development Meeting');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Project Completion');
    _subjectCollection.add('Release updates');
    _subjectCollection.add('Performance Check');

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('Argentina Standard Time');
    _timeZoneCollection.add('Atlantic Standard Time');
    _timeZoneCollection.add('Azerbaijan Standard Time');
    _timeZoneCollection.add('Azores Standard Time');
    _timeZoneCollection.add('Bahia Standard Time');
    _timeZoneCollection.add('Bangladesh Standard Time');
    _timeZoneCollection.add('Belarus Standard Time');
    _timeZoneCollection.add('Canada Central Standard Time');
    _timeZoneCollection.add('Cape Verde Standard Time');
    _timeZoneCollection.add('Caucasus Standard Time');
    _timeZoneCollection.add('Cen. Australia Standard Time');
    _timeZoneCollection.add('Central America Standard Time');
    _timeZoneCollection.add('Central Asia Standard Time');
    _timeZoneCollection.add('Central Brazilian Standard Time');
    _timeZoneCollection.add('Central Europe Standard Time');
    _timeZoneCollection.add('Central European Standard Time');
    _timeZoneCollection.add('Central Pacific Standard Time');
    _timeZoneCollection.add('Central Standard Time');
    _timeZoneCollection.add('China Standard Time');
    _timeZoneCollection.add('Dateline Standard Time');
    _timeZoneCollection.add('E. Africa Standard Time');
    _timeZoneCollection.add('E. Australia Standard Time');
    _timeZoneCollection.add('E. South America Standard Time');
    _timeZoneCollection.add('Eastern Standard Time');
    _timeZoneCollection.add('Egypt Standard Time');
    _timeZoneCollection.add('Ekaterinburg Standard Time');
    _timeZoneCollection.add('FLE Standard Time');
    _timeZoneCollection.add('Fiji Standard Time');
    _timeZoneCollection.add('GMT Standard Time');
    _timeZoneCollection.add('GTB Standard Time');
    _timeZoneCollection.add('Georgian Standard Time');
    _timeZoneCollection.add('Greenland Standard Time');
    _timeZoneCollection.add('Greenwich Standard Time');
    _timeZoneCollection.add('Hawaiian Standard Time');
    _timeZoneCollection.add('India Standard Time');
    _timeZoneCollection.add('Iran Standard Time');
    _timeZoneCollection.add('Israel Standard Time');
    _timeZoneCollection.add('Jordan Standard Time');
    _timeZoneCollection.add('Kaliningrad Standard Time');
    _timeZoneCollection.add('Korea Standard Time');
    _timeZoneCollection.add('Libya Standard Time');
    _timeZoneCollection.add('Line Islands Standard Time');
    _timeZoneCollection.add('Magadan Standard Time');
    _timeZoneCollection.add('Mauritius Standard Time');
    _timeZoneCollection.add('Middle East Standard Time');
    _timeZoneCollection.add('Montevideo Standard Time');
    _timeZoneCollection.add('Morocco Standard Time');
    _timeZoneCollection.add('Mountain Standard Time');
    _timeZoneCollection.add('Mountain Standard Time (Mexico)');
    _timeZoneCollection.add('Myanmar Standard Time');
    _timeZoneCollection.add('N. Central Asia Standard Time');
    _timeZoneCollection.add('Namibia Standard Time');
    _timeZoneCollection.add('Nepal Standard Time');
    _timeZoneCollection.add('New Zealand Standard Time');
    _timeZoneCollection.add('Newfoundland Standard Time');
    _timeZoneCollection.add('North Asia East Standard Time');
    _timeZoneCollection.add('North Asia Standard Time');
    _timeZoneCollection.add('Pacific SA Standard Time');
    _timeZoneCollection.add('Pacific Standard Time');
    _timeZoneCollection.add('Pacific Standard Time (Mexico)');
    _timeZoneCollection.add('Pakistan Standard Time');
    _timeZoneCollection.add('Paraguay Standard Time');
    _timeZoneCollection.add('Romance Standard Time');
    _timeZoneCollection.add('Russia Time Zone 10');
    _timeZoneCollection.add('Russia Time Zone 11');
    _timeZoneCollection.add('Russia Time Zone 3');
    _timeZoneCollection.add('Russian Standard Time');
    _timeZoneCollection.add('SA Eastern Standard Time');
    _timeZoneCollection.add('SA Pacific Standard Time');
    _timeZoneCollection.add('SA Western Standard Time');
    _timeZoneCollection.add('SE Asia Standard Time');
    _timeZoneCollection.add('Samoa Standard Time');
    _timeZoneCollection.add('Singapore Standard Time');
    _timeZoneCollection.add('South Africa Standard Time');
    _timeZoneCollection.add('Sri Lanka Standard Time');
    _timeZoneCollection.add('Syria Standard Time');
    _timeZoneCollection.add('Taipei Standard Time');
    _timeZoneCollection.add('Tasmania Standard Time');
    _timeZoneCollection.add('Tokyo Standard Time');
    _timeZoneCollection.add('Tonga Standard Time');
    _timeZoneCollection.add('Turkey Standard Time');
    _timeZoneCollection.add('US Eastern Standard Time');
    _timeZoneCollection.add('US Mountain Standard Time');
    _timeZoneCollection.add('UTC');
    _timeZoneCollection.add('UTC+12');
    _timeZoneCollection.add('UTC-02');
    _timeZoneCollection.add('UTC-11');
    _timeZoneCollection.add('Ulaanbaatar Standard Time');
    _timeZoneCollection.add('Venezuela Standard Time');
    _timeZoneCollection.add('Vladivostok Standard Time');
    _timeZoneCollection.add('W. Australia Standard Time');
    _timeZoneCollection.add('W. Central Africa Standard Time');
    _timeZoneCollection.add('W. Europe Standard Time');
    _timeZoneCollection.add('West Asia Standard Time');
    _timeZoneCollection.add('West Pacific Standard Time');
    _timeZoneCollection.add('Yakutsk Standard Time');
  }

  /// Method that creates the resource collection for the calendar, with the
  /// required information.
  void _addResources() {
    final Random random = Random();
    for (int i = 0; i < _nameCollection.length; i++) {
      _employeeCollection.add(CalendarResource(
        displayName: _nameCollection[i],
        id: '000$i',
        color: Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1),
        image: i < _userImages.length ? ExactAssetImage(_userImages[i]) : null
      ));
    }
  }

  /// Method that creates the collection the time region for calendar, with
  /// required information.
  void _addSpecialRegions() {
    final DateTime date = DateTime.now();
    final Random random = Random();
    for (int i = 0; i < _employeeCollection.length; i++) {
      _specialTimeRegions.add(TimeRegion(
          startTime: DateTime(date.year, date.month, date.day, 13),
          endTime: DateTime(date.year, date.month, date.day, 14),
          text: 'Lunch',
          color: Colors.grey.withOpacity(0.2),
          resourceIds: <Object>[_employeeCollection[i].id],
          recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));

      if (i.isEven) {
        continue;
      }

      final DateTime startDate = DateTime(date.year, date.month, date.day, 17 + random.nextInt(7));

      _specialTimeRegions.add(TimeRegion(
        startTime: startDate,
        endTime: startDate.add(const Duration(hours: 1)),
        text: 'Not Available',
        color: Colors.grey.withOpacity(0.2),
        enablePointerInteraction: false,
        resourceIds: <Object>[_employeeCollection[i].id],
      ));
    }
  }

  /// Method that creates the collection the data source for calendar, with
  /// required information.
  void _addAppointments() {
    final Random random = Random();
    for (int i = 0; i < _employeeCollection.length; i++) {
      final List<Object> employeeIds = <Object>[_employeeCollection[i].id];
      if (i == _employeeCollection.length - 1) {
        int index = random.nextInt(5);
        index = index == i ? index + 1 : index;
        final Object employeeId = _employeeCollection[index].id;
        if (employeeId is String) {
          employeeIds.add(employeeId);
        }
      }

      for (int k = 0; k < 365; k++) {
        if (employeeIds.length > 1 && k.isEven) {
          continue;
        }
        for (int j = 0; j < 2; j++) {
          final DateTime date = DateTime.now().add(Duration(days: k + j));
          int startHour = 9 + random.nextInt(6);
          startHour = startHour >= 13 && startHour <= 14 ? startHour + 1 : startHour;
          final DateTime shiftStartTime = DateTime(date.year, date.month, date.day, startHour);
          _shiftCollection.add(Appointment(
              startTime: shiftStartTime,
              endTime: shiftStartTime.add(const Duration(hours: 1)),
              subject: _subjectCollection[random.nextInt(8)],
              color: _colorCollection[random.nextInt(8)],
              startTimeZone: '',
              endTimeZone: '',
              resourceIds: employeeIds));
        }
      }
    }
  }

  Widget _getSpecialRegionWidget(BuildContext context, TimeRegionDetails details) {
    if (details.region.text == 'Lunch') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.grey.withOpacity(0.5),
        ),
      );
    } else if (details.region.text == 'Not Available') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.block,
          color: Colors.grey.withOpacity(0.5),
        ),
      );
    }

    return Container(color: details.region.color);
  }

  /// Returns the calendar widget based on the properties passed
  SfCalendar _getShiftScheduler(
      [CalendarDataSource? calendarDataSource]) {
    return SfCalendar(
      controller: _calendarController,
      dataSource: calendarDataSource,
      onTap: (details) {
        print(details.toString());
      },
      // calendarTapCallback,
    );
  }
}

class _ShiftDataSource extends CalendarDataSource {
  _ShiftDataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

// NOTE: Use for rezising the shift cards
// GestureDetector(
//   behavior: HitTestBehavior.opaque,
//   onHorizontalDragUpdate: (details) {
//     final delta = details.delta.dx;
//     // right is positive and left is negative
//     if (delta.isNegative) {
//       // reduce the size of the left size
//       // and increase the right one.
//     } else {
//       // reduce the size of the right size
//       // and increase the left one.
//     }
//   },
//   child: Container(
//     height: dragHandleSize,
//     width: dragHandleSize,
//     decoration: const BoxDecoration(
//       shape: BoxShape.circle,
//       color: Colors.red,
//     ),
//   ),
// ),
