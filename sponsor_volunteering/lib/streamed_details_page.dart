
import 'package:flutter/widgets.dart';
import 'package:sponsor_volunteering/sponsoree_details_page.dart';
import 'package:sponsor_volunteering/sponsoree_repository.dart';

import 'model/sponsoree.dart';

class StreamedDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: sponsoreeRepository.getAll(),
        builder: (context, snapshotStream) {
          if (snapshotStream.hasError) {
            return Text("MyOrders: Error ${snapshotStream.error}");
          }

          List<Sponsoree> sponsorees = snapshotStream.data;
          return SponsoreeDetailsPage(sponsorees.first);
        }
    );
  }

}