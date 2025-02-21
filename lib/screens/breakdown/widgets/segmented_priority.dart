import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SegmentedControlPriority extends StatefulWidget {
  @override
  _SegmentedControlPriorityState createState() =>
      _SegmentedControlPriorityState();
  final Function(String)
      onPriorityChanged; // Add this callback to pass the value up
  const SegmentedControlPriority({super.key, required this.onPriorityChanged});
}

class _SegmentedControlPriorityState extends State<SegmentedControlPriority> {
  String _selectedStatus = 'Low';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: CupertinoSegmentedControl<String>(
        children: const {
          'Low': const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text('Low'),
          ),
          'Medium': const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text('Medium'),
          ),
          'High': const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text('High'),
          ),
        },
        groupValue: _selectedStatus,
        onValueChanged: (String value) {
          setState(() {
            _selectedStatus = value;
            widget.onPriorityChanged(value);
          });
        },
        borderColor: Colors.grey,
        selectedColor: Color.fromRGBO(30, 152, 165, 1),
        unselectedColor: Colors.white,
        pressedColor: Colors.lightBlueAccent,
      ),
    );
  }
}

class SegmentedControlStatus extends StatefulWidget {
  @override
  _SegmentedControlStatusState createState() => _SegmentedControlStatusState();
  final Function(String)
      onStatusChanged; // Add this callback to pass the value up
  const SegmentedControlStatus({super.key, required this.onStatusChanged});
}

class _SegmentedControlStatusState extends State<SegmentedControlStatus> {
  String _selectedStatus = '1';
  String selectedPriority = 'Low';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: CupertinoSegmentedControl<String>(
        children: const {
          '1': const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text('Running'),
          ),
          '0': const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text('Stopped'),
          ),
        },
        groupValue: _selectedStatus,
        onValueChanged: (String value) {
          setState(() {
            _selectedStatus = value;
            widget.onStatusChanged(value);
          });
        },
        borderColor: Colors.grey,
        selectedColor: Color.fromRGBO(30, 152, 165, 1),
        unselectedColor: Colors.white,
        pressedColor: Colors.lightBlueAccent,
      ),
    );
  }

  void handlePriorityChanged(String priority) {
    setState(() {
      selectedPriority = priority; // Update the state when the priority changes
    });
  }

  void handleStausChanged(String status) {
    setState(() {
      selectedPriority = status; // Update the state when the priority changes
    });
  }
}
