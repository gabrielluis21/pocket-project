import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_model.dart';
import 'package:pocketpersonaltrainer/src/ui/gyms/widgets/gym_map.dart';
import 'package:pocketpersonaltrainer/src/widgets/custom_image_details.dart';
import 'package:url_launcher/url_launcher.dart';

class GymPage extends StatefulWidget {
  const GymPage({super.key, required this.academia, required this.language});
  final GymModel academia;
  final String language;

  @override
  State<GymPage> createState() => _GymPageState();
}

class _GymPageState extends State<GymPage> {
  @override
  void initState() {
    super.initState();

    //initSettingsController(Get.find<SettingsController>(tag: 'settings'));
  }

  List<Widget> buildImageList() {
    return List<Widget>.from(
      growable: false,
      widget.academia.images!.map(
        (e) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CustomImageDetails(
                image: e,
                label: widget.academia.name!,
              ),
            ),
          ),
          child: CachedNetworkImage(
            height: 400,
            imageUrl: e,
            fit: BoxFit.fill,
            placeholder: (context, url) => const FlareActor(
              'assets/animations/WeightSpin.flr',
              fit: BoxFit.cover,
              animation: 'Spin',
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/empty.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      /* decoration: BoxDecoration(
        gradient: settingsController.themeMode == ThemeMode.dark ? AppColorTheme().customDarkColorScheme.surface, : AppColorTheme().customLightColorScheme.surface,
      ), */
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            widget.academia.name ?? '',
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ), //Text(widget.exercise.name),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  top: 0,
                  left: 10,
                  right: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 350,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: buildImageList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.academia.name ?? '',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppColorTheme().customLightColorScheme.primary,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Text(
                            widget.academia.address ?? '',
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColorTheme().customDarkColorScheme.primary,
                                ),
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Text(
                            '${widget.academia.city} - ${widget.academia.state}',
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColorTheme().customDarkColorScheme.primary,
                                ),
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: widget.academia.phones!
                                .map(
                                  (e) => TextButton(
                                    onPressed: () async => launchUrl(Uri.parse("tel://$e")),
                                    child: Text(
                                      e,
                                      textAlign: TextAlign.justify,
                                      style: Theme.of(context).textTheme.headlineSmall,
                                      softWrap: true,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 520,
                  left: 10,
                  right: 10,
                  bottom: 70,
                  child: GymMap(
                    latitude: widget.academia.location!['latitude'],
                    longitude: widget.academia.location!['longitude'],
                    currentUser: Get.find<UserController>(tag: 'user').user,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        icon: const Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (widget.academia.phones!.length == 1) {
                            await launchUrl(
                              Uri.parse(
                                "https://wa.me/${widget.academia.phones!.first}?text=Olá",
                              ),
                            );
                          } else {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return BottomSheet(
                                  onClosing: () {},
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 50.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: widget.academia.phones!
                                              .map(
                                                (phone) => TextButton.icon(
                                                  onPressed: () async {
                                                    await launchUrl(
                                                      Uri.parse(
                                                        "https://wa.me/$phone?text=Olá",
                                                      ),
                                                    );
                                                  },
                                                  label: Text(
                                                    phone,
                                                    style: AppTextTheme.theme.bodyLarge,
                                                  ),
                                                  icon: Icon(
                                                    FontAwesomeIcons.whatsapp,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                        label: Text(
                          'Whatsapp',
                          style: AppTextTheme.theme.headlineSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                        ),
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.facebook, color: Colors.white),
                        label: Text(
                          'Facebook',
                          style: AppTextTheme.theme.headlineSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
