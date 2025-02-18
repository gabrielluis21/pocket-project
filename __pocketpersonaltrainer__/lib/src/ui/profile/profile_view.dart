import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel model;

  const ProfileScreen({Key? key, required this.model}) : super(key: key);

  ImageProvider buildAvatarPhoto() {
    if (model.photoUrl == null || model.photoUrl == '') {
      return const AssetImage("assets/images/person.png");
    } else {
      return NetworkImage(model.photoUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(model.toMap());
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 9, bottom: 9),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CircleAvatar(maxRadius: 70.0, backgroundImage: buildAvatarPhoto()),
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
