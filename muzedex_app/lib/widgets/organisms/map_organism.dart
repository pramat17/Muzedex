import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/remaining_items_button_atom.dart';
import 'package:muzedex_app/widgets/molecules/floor_navigation_molecule.dart';
import 'package:muzedex_app/widgets/molecules/room_navigation_molecule.dart';
import 'package:muzedex_app/widgets/molecules/toast_message_molecule.dart';
import 'package:xml/xml.dart';

// Comporte le plan d'un étage, le sélecteurs de salle/étage et les items à trouver
class MapOrganism extends StatefulWidget {
  final String floorImage;
  final String floorSvg;
  final List<Room> rooms;
  final int currentFloor;
  final int floorsCount;
  final Function(int) setCurrentFloor;
  final Room initialRoom;

  const MapOrganism({
    required this.floorImage,
    required this.floorSvg,
    required this.rooms,
    required this.initialRoom,
    required this.currentFloor,
    required this.floorsCount,
    required this.setCurrentFloor,
    super.key,
  });

  @override
  State<MapOrganism> createState() => _MapOrganismState();
}

class _MapOrganismState extends State<MapOrganism> {
  final GlobalKey _imageKey = GlobalKey();
  Size? _imageSize;
  String? modifiedSvg;
  bool _toastDisplayed = false;

  final ScrollController _scrollController = ScrollController();

  late ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    _loadAndModifySvg(widget.initialRoom);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  // Méthode pour centrer sur la salle active
  void _centerActiveRoom() {
    if (_imageSize == null) return;
    final currentRoom = context.read<RoomCubit>().state.currentRoom;
    if (currentRoom == null) return;
    final parts = currentRoom.position.split(';');
    if (parts.length != 2) return;
    final roomX = double.parse(parts[0]);
    final activeX = _imageSize!.width * (roomX / 100);
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = activeX - screenWidth / 2;
    // On s'assure que l'offset reste dans les bornes
    final boundedOffset = offset.clamp(
      0.0,
      _scrollController.hasClients
          ? _scrollController.position.maxScrollExtent
          : 0.0,
    );
    _scrollController.animateTo(
      boundedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // FONCTION POUR CHARGER ET MODIFIER LE SVG AFIN DE RENDRE LA SALLE ACTIVE VISIBLE
  Future<void> _loadAndModifySvg(activeRoom) async {
    final rawSvg =
        await DefaultAssetBundle.of(context).loadString(widget.floorSvg);
    final document = XmlDocument.parse(rawSvg);

    for (final path in document.findAllElements('path')) {
      final id = path.getAttribute('id');
      if (id != null) {
        if (id == activeRoom.name) {
          path.setAttribute('opacity', '1');
        } else {
          path.setAttribute('opacity', '0');
        }
      }
    }

    setState(() {
      modifiedSvg = document.toXmlString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final itemJustFound = arguments?['itemJustFound'] as Item?;

    if (itemJustFound != null &&
        context.read<RoomCubit>().state.lastItemFound != itemJustFound) {
      confettiController.play();
      context.read<RoomCubit>().setLastItemFound(itemJustFound);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (itemJustFound != null && !_toastDisplayed) {
        ScaffoldMessenger.of(context).showSnackBar(ToastMessageMolecule.create(
          title: 'Félicitations !',
          message:
              'La carte ${itemJustFound.name[0].toUpperCase()}${itemJustFound.name.substring(1)} a été ajoutée au Muzédex !',
        ));

        arguments?.remove('itemJustFound');

        setState(() {
          _toastDisplayed = true;
        });
      }
    });

    _loadAndModifySvg(context.read<RoomCubit>().state.currentRoom as Room);
    context.read<RoomCubit>().fetchPlayerName();

    return Stack(
      children: [
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/orangeGradientBottom.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/leavesBottomMap.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: [
                Image.asset(
                  widget.floorImage,
                  key: _imageKey,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0),
                  height: double.infinity,
                  width: null,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final RenderBox box = _imageKey.currentContext!
                            .findRenderObject() as RenderBox;
                        final size = box.size;

                        if (_imageSize != size) {
                          setState(() {
                            _imageSize = size;
                          });
                          _centerActiveRoom();
                        }
                      });
                    }
                    return child;
                  },
                ),
                if (modifiedSvg != null)
                  SvgPicture.string(
                    modifiedSvg!,
                    fit: BoxFit.cover,
                    height: _imageSize?.height,
                  ),
                // BOUTONS DES SALLES SUR LE PLAN
                if (_imageSize != null)
                  ...widget.rooms.map((room) {
                    final positionParts = room.position.split(';');
                    if (positionParts.length != 2 ||
                        room == context.read<RoomCubit>().state.currentRoom) {
                      return const SizedBox.shrink();
                    }

                    final roomX = double.parse(positionParts[0]);
                    final roomY = double.parse(positionParts[1]);

                    final x = _imageSize!.width * (roomX / 100);
                    final y = _imageSize!.height * (roomY / 100);

                    return Positioned(
                      left: x,
                      top: y,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<RoomCubit>().selectRoom(room);
                          context
                              .read<RoomCubit>()
                              .setCurrentRoomIndex(widget.rooms.indexOf(room));
                          _loadAndModifySvg(room);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: Text(room.number.toString(),
                            style: const TextStyle(
                                color: greyBrown,
                                fontFamily: "Belanosima",
                                fontSize: 26)),
                      ),
                    );
                  }),
                // AFFICHAGE DES ITEMS RESTANTS POUR LA SALLE ACTUELLE
                if (_imageSize != null)
                  Builder(
                    builder: (context) {
                      final currentRoom =
                          context.read<RoomCubit>().state.currentRoom;
                      if (currentRoom == null) return const SizedBox.shrink();

                      final positionParts = currentRoom.position.split(';');
                      if (positionParts.length != 2) {
                        return const SizedBox.shrink();
                      }

                      final roomX = double.parse(positionParts[0]);
                      final roomY = double.parse(positionParts[1]);

                      final x = _imageSize!.width * (roomX / 100);
                      final y = _imageSize!.height * (roomY / 100);

                      return RemainingItemsButtonAtom(
                        x: x + 7,
                        y: y,
                        roomNumber: currentRoom.number,
                        items: currentRoom.items,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        // CURRENT ROOM NAME
        RoomNavigationMolecule(
          activeRoomIndex: context.read<RoomCubit>().state.currentRoomIndex,
          activeRoomNumber: widget
              .rooms[context.read<RoomCubit>().state.currentRoomIndex].number,
          activeRoomName: widget
              .rooms[context.read<RoomCubit>().state.currentRoomIndex].name,
          totalRooms: widget.rooms.length,
          onPrevious: () {
            setState(() {
              context.read<RoomCubit>().previousRoom();
              context.read<RoomCubit>().selectRoom(widget
                  .rooms[context.read<RoomCubit>().state.currentRoomIndex]);
              _loadAndModifySvg(
                  context.read<RoomCubit>().state.currentRoom as Room);
            });
          },
          onNext: () {
            setState(() {
              // activeRoomIndex++;
              context.read<RoomCubit>().nextRoom();
              context.read<RoomCubit>().selectRoom(widget
                  .rooms[context.read<RoomCubit>().state.currentRoomIndex]);
              _loadAndModifySvg(
                  context.read<RoomCubit>().state.currentRoom as Room);
            });
          },
        ),
        // FLOOR NAVIGATION
        FloorNavigationMolecule(
            currentFloor: widget.currentFloor,
            floorsCount: widget.floorsCount,
            setCurrentFloor: widget.setCurrentFloor),
        // CONFETTIS
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
            ),
          ),
        ),
      ],
    );
  }
}
