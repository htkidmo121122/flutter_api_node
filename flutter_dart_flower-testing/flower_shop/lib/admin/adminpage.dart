import 'package:flutter/material.dart';
import 'package:health_care/admin/Orders/Orders.dart';
import 'package:health_care/admin/Products/Products.dart';
import 'package:health_care/admin/Users/Users.dart';
import 'package:health_care/constants.dart';

class AdminMainPage extends StatefulWidget {
  static String routeName = "/admin_main";

  @override
  // ignore: library_private_types_in_public_api
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kcolorminor,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Manage Orders'),
              onTap: () {
                Navigator.pushNamed(context, AdminOrdersScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.pushNamed(context, ProductsScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pushNamed(context, AdminUsers.routeName);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardCard('Product', '', Colors.blue),
                _buildDashboardCard('User', '', Colors.yellow),
                _buildDashboardCard('Order', '', Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            // Expanded(
            //   // child: _buildTrafficChart(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, Color color) {
    return Card(
      color: color,
      child: Container(
        width: 100,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficChart() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Traffic'),
            // Here, you would typically use a chart library to display a traffic chart.
            // For simplicity, this is just a placeholder.
            Expanded(
              child: Center(
                child: Text('Traffic chart goes here'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
