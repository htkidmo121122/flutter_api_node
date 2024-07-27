import 'package:flutter/material.dart';
import 'package:health_care/provider/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Update the state when the focus changes
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Form(
            child: TextFormField(
              focusNode: _focusNode,
              onChanged: (value) {
                Provider.of<SearchProvider>(context, listen: false)
                    .updateSearchQuery(value);
              },
              onFieldSubmitted: (value) {
                Provider.of<SearchProvider>(context, listen: false)
                    .addSearchHistory(value);
                _focusNode.unfocus(); // Hide history after submission
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: kWhite.withOpacity(0.1),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: searchOutlineInputBorder,
                focusedBorder: searchOutlineInputBorder,
                enabledBorder: searchOutlineInputBorder,
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<SearchProvider>(
            builder: (context, provider, child) {
              if (!_focusNode.hasFocus || provider.searchHistory.isEmpty) {
                return Container();
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.searchHistory.length,
                    itemBuilder: (context, index) {
                      final query = provider.searchHistory[index];
                      return ListTile(
                        title: Text(query),
                        onTap: () {
                          Provider.of<SearchProvider>(context, listen: false)
                              .updateSearchQuery(query);
                          Provider.of<SearchProvider>(context, listen: false)
                              .addSearchHistory(query);
                          _focusNode.unfocus(); // Hide history after selection
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
