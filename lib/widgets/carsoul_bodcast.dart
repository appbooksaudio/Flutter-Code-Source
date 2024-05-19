
import 'package:ejazapp/data/models/podcast.dart';
import 'package:ejazapp/pages/home/home_page.dart';
import 'package:ejazapp/widgets/bodcast_item.dart';
import 'package:flutter/material.dart';


class BodcastCarsoule extends StatefulWidget {
  const BodcastCarsoule({super.key});

  @override
  State<BodcastCarsoule> createState() => _BodcastCarsouleState();
}

class _BodcastCarsouleState extends State<BodcastCarsoule> {


  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    return SizedBox(
      height: 354,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             const SizedBox(height: 10),
                          buildSettingApp(
                            context,
                            title: "Podcast",
                            style: theme.textTheme.headlineLarge,
                            trailing: Container(),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: mockPoscast.length,
                itemBuilder: (BuildContext context, int index)
                { 
                  Podcast pod =mockPoscast[index];
                  return Card(
                      child: BodcastItem( poscast:pod,index: index,),
                    );},
              ),
            ),
            
          ],
        ),
    );
  }
}