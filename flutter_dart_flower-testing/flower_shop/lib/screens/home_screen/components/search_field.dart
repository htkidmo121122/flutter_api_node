import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_care/screens/search_screen/components/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust the padding as needed
    child: Form(
      child: 
      TextFormField(
        onChanged: (value) {
          Provider.of<SearchProvider>(context, listen: false).updateSearchQuery(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: kWhite.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: searchOutlineInputBorder,
          focusedBorder: searchOutlineInputBorder,
          enabledBorder: searchOutlineInputBorder,
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    ),
  );
}
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
