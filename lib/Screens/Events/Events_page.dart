
import 'package:edu_marshal/Model/Event_Model.dart';
import 'package:edu_marshal/Widget/CustomAppBar.dart' as custom_app_bar;
import 'package:edu_marshal/Widget/Event_Custom_Widget.dart';
import 'package:edu_marshal/main.dart';
import 'package:edu_marshal/repository/Event_Repository.dart';
import 'package:flutter/material.dart';

import 'package:edu_marshal/Widget/CommonDrawer.dart'; // Ensure this file contains the definition of the CommonDrawer widget

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey_ = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey_,
      backgroundColor: Color.fromRGBO(242, 246, 255, 1),
      appBar: custom_app_bar.CustomAppBar(
        userName: PreferencesManager().name,
        userImage: PreferencesManager().studentPhoto,
        onTap: () {
          scaffoldKey_.currentState?.openDrawer();
        },
        scaffoldKey_: scaffoldKey_, // Pass the _scaffoldKey
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Menu Item 1'),
              onTap: () {
                // Handle menu item tap
              },
            ),
            ListTile(
              title: Text('Menu Item 2'),
              onTap: () {
                // Handle menu item tap
              },
            ),
          ],
        ),
      ),

      body: 
      FutureBuilder<List<EventModel>>(
        future: EventRepository().fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<EventModel>? events = snapshot.data;
            return ListView.builder(
              itemCount: events?.length ?? 0,
              itemBuilder: (context, index) {
                EventModel event = events![index];
                return ListTile(
                  title: EventCustomWidget(eventName:event.eventName, description: event.detail, societyName: event.hostingOrganization, departmentName: event.registrationUrl, price: event.date, daysLeft: event.event, registrationUrl: event.registrationUrl,),
                  onTap: () {
                    // Handle event tap
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
