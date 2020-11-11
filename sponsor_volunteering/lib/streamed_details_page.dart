
import 'package:flutter/widgets.dart';
import 'package:sponsor_volunteering/sponsoree_details_page.dart';
import 'package:sponsor_volunteering/sponsoree_repository.dart';

import 'model/sponsoree.dart';

class StreamedDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: sponsoreeRepository.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("MyOrders: Error ${snapshot.error}");
          }

          if (!snapshot.hasData) {
            return Container();
          }
          
          List<Sponsoree> sponsorees = snapshot.data;
          print('!!!! firstSponsoree: ${sponsorees.first}');
          return SponsoreeDetailsPage(sponsorees.first);
        }
    );
  }

}