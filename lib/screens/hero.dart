import 'package:flutter/material.dart';
import '../widget/custom_dropdown.dart';
import '../widget/custom_textarea.dart';
import '../widget/custom_textfield.dart';
import 'map_screen.dart';
import 'dart:convert';

class CanziHero extends StatefulWidget {
  const CanziHero({super.key});

  @override
  _CanziHeroState createState() => _CanziHeroState();
}

class _CanziHeroState extends State<CanziHero> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController endPointController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedService = "";
  Map<String, dynamic>? pickupData;
  Map<String, dynamic>? endPointData;

  final Map<String, int> services = {
    "Service 1": 25,
    "Service 2": 50,
    "Service 3": 75,
  };

  Future<void> navigateToMap(TextEditingController controller, bool isPickup) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (result != null && result is Map<dynamic, dynamic>) {
      setState(() {
        controller.text = result['address'];
        if (isPickup) {
          pickupData = Map<String, dynamic>.from(result);
        } else {
          endPointData = Map<String, dynamic>.from(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConfirmEnabled = selectedService.isNotEmpty &&
        pickupController.text.isNotEmpty &&
        endPointController.text.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Image.asset(
          'assets/images/canzi_Logo.png',
          height: 200,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xffFF0000),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xffFF0000),
      body: Stack(
        children: [
          Container(
            color: const Color(0xffFF0000),
          ),
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Image.asset(
              'assets/images/user_image.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => navigateToMap(pickupController, true),
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      controller: pickupController,
                                      hintText: 'Pickup Point',
                                      prefixIcon: Icons.home,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () => navigateToMap(endPointController, false),
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      controller: endPointController,
                                      hintText: 'End Point',
                                      prefixIcon: Icons.location_on,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 50,
                              left: MediaQuery.of(context).size.width / 2 - 45,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final temp = pickupController.text;
                                    pickupController.text =
                                        endPointController.text;
                                    endPointController.text = temp;

                                    final tempData = pickupData;
                                    pickupData = endPointData;
                                    endPointData = tempData;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.swap_vert,
                                    color: Color(0xffFF0000),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          hintText: "Service Type",
                          suffixIcon: Icons.arrow_drop_down,
                          selectedValue: selectedService.isNotEmpty
                              ? selectedService
                              : null,
                          items: const ["Service 1", "Service 2", "Service 3"],
                          onChanged: (value) {
                            setState(() {
                              selectedService = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextArea(
                          controller: noteController,
                          hintText: 'Note',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selectedService.isNotEmpty
                                  ? "${services[selectedService]}dh"
                                  : "0dh",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: isConfirmEnabled
                              ? () {
                            final result = {
                              'pickup_point': pickupData,
                              'end_point': endPointData,
                              'service_type': selectedService,
                              'note': noteController.text.trim(),
                              'total_price': services[selectedService],
                            };
                            print(jsonEncode(result));
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isConfirmEnabled
                                ? const Color(0xffFF0000)
                                : Colors.grey, 
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}