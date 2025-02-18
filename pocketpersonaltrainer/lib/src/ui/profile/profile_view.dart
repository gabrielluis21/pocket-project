import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel model;

  const ProfileScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    print(model.toMap());
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 9, bottom: 9),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CachedNetworkImage(
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset("assets/images/person"),
              imageUrl: model.photoUrl!,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                maxRadius: 70.0,
                backgroundImage: imageProvider,
              ),
            ),
          ]),
        ),
        Text(
          "${model.name}",
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          textAlign: TextAlign.center,
        ),
        Text(
          "${model.email}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          "${model.address}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16.0,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context)!.editProfile),
        )
      ],
    );
  }
}
