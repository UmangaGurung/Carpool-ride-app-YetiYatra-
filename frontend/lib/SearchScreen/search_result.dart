import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../RideDetails/ride_details_page.dart';
import 'Widget/search_result_list.dart';
import 'package:yeti_yatra_project/SearchScreen/Model/search_result_model.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search Results',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RideDetailsPage(
                              searchResultPerson: searchResultModelList[index],
                            ),
                          ),
                        );
                      },
                      child: searchResultModelList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                  itemCount: searchResultModelList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<SearchResultModel> searchResultModelList = [
  SearchResultModel(
      isCompleted: null,
      isHistoryPage: false,
      profilePicture: "images/avatar.jpg",
      driver: "Shruti Agarwal",
      phoneNumber: "9808284125"),
  SearchResultModel(
      isCompleted: null,
      isHistoryPage: false,
      profilePicture: "images/avatar.jpg",
      driver: "Shruti Agarwal",
      phoneNumber: "9808284125"),
  SearchResultModel(
      isCompleted: null,
      isHistoryPage: false,
      profilePicture: "images/avatar.jpg",
      driver: "Shruti Agarwal",
      phoneNumber: "9808284125"),
];