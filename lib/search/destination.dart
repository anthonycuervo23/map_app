import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/search_response.dart';
import 'package:map_app/models/search_result.dart';
import 'package:map_app/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  //esto sirve si quisieramos cambiar el search que sale por defecto
  // final String searchFieldLabel;

  final TrafficService _trafficService;
  final LatLng _proximity;
  SearchDestination(this._proximity) : this._trafficService = TrafficService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final searchResult = SearchResult(cancel: true);
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => this.close(context, searchResult));
  }

  @override
  Widget buildResults(BuildContext context) {
    this._trafficService.getSearchResults(this.query.trim(), _proximity);
    return this._buildResultSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('find a location manually'),
            onTap: () {
              this.close(context, SearchResult(cancel: false, manual: true));
            },
          ),
        ],
      );
    }
    return this._buildResultSuggestions();
  }

  Widget _buildResultSuggestions() {
    // if (this.query == 0) {
    //   return Container();
    // }
    return FutureBuilder(
      future:
          this._trafficService.getSearchResults(this.query.trim(), _proximity),
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final places = snapshot.data.features;
        if (places.length == 0) {
          return ListTile(
            title: Text('Nothing found for $query'),
          );
        }
        return ListView.separated(
            itemCount: places.length,
            separatorBuilder: (_, index) => Divider(),
            itemBuilder: (_, index) {
              final place = places[index];

              return ListTile(
                leading: Icon(Icons.place),
                title: Text(place.textEs),
                subtitle: Text(place.placeNameEs),
                onTap: () {
                  this.close(
                      context,
                      SearchResult(
                        cancel: false,
                        manual: false,
                        position: LatLng(place.center[1], place.center[0]),
                        destinationName: place.textEs,
                        description: place.placeNameEs,
                      ));
                },
              );
            });
      },
    );
  }
}
