import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

// import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      // canvasColor: Colors.black,
      // fontFamily: "Muli",
      appBarTheme: const AppBarTheme(
          color: Colors.white,
          
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
          titleTextStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 15),
            
      ),
      textTheme: const TextTheme(
         bodyLarge: TextStyle(color: kTextColor),
         bodyMedium: TextStyle(color: kTextColor),
         bodySmall: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
         titleLarge: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        textColor: Colors.black,
        backgroundColor: Colors.white
      ),
       
      //inputDecorationTheme: const InputDecorationTheme(
      //   floatingLabelBehavior: FloatingLabelBehavior.always,
      //   contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      //   enabledBorder: outlineInputBorder,
      //   focusedBorder: outlineInputBorder,
      //   border: outlineInputBorder,
      // ),
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     elevation: 0,
      //     backgroundColor: kPrimaryColor,
      //     foregroundColor: Colors.white,
      //     minimumSize: const Size(double.infinity, 48),
      //     shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(16)),
      //     ),
      //   ),
      // ),
       
    );

  }
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 38, 38, 38),
      
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 34, 34, 34),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        
        
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white54),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black, 
      ),
      listTileTheme: const ListTileThemeData(
        
        textColor: Colors.white,
        tileColor: Color.fromARGB(255, 29, 29, 29),
        selectedTileColor: Color.fromARGB(255, 29, 29, 29),
        selectedColor: Color.fromARGB(255, 29, 29, 29),

      ),
      expansionTileTheme: const ExpansionTileThemeData(
        textColor: Colors.black,
        backgroundColor: Colors.white
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: kPrimaryLightColor,

      ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     elevation: 0,
      //     backgroundColor: kPrimaryColorDark,
      //     foregroundColor: Colors.white,
      //     minimumSize: const Size(double.infinity, 48),
      //     shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(16)),
      //     ),
      //   ),
      // ),
    );
  }
}

// const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(28)),
//   borderSide: BorderSide(color: kTextColor),
//   gapPadding: 10,
// );
