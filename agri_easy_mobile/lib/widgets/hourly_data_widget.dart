import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:agri_easy/controller/global_controller.dart';
import 'package:agri_easy/model/weather_data_hourly.dart';
import 'package:agri_easy/utils/custom_colors.dart';

class HourlyDataWidget extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;
  HourlyDataWidget({Key? key, required this.weatherDataHourly})
      : super(key: key);

//card index
  RxInt cardIndex = GlobalController().getIndex();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          alignment: Alignment.topCenter,
          child: Text(
            "Today",
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        hourlyList(),
      ],
    );
  }

  Widget hourlyList() {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly.hourly.length > 12
            ? 12
            : weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          return Obx(
            (() => GestureDetector(
                  onTap: () {
                    cardIndex.value = index;
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 0.5,
                          spreadRadius: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ],
                      gradient: cardIndex.value == index
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 1, 174, 1),
                                Color.fromARGB(255, 2, 94, 8)
                              ],
                            )
                          : null,
                      color: cardIndex.value != index
                          ? const Color.fromARGB(255, 229, 247, 224)
                          : null, // fallback color
                    ),
                    child: HourlyDetails(
                      cardIndex: cardIndex.toInt(),
                      index: index,
                      temp: weatherDataHourly.hourly[index].temp!,
                      timeStamp: weatherDataHourly.hourly[index].dt!,
                      weatherIcon:
                          weatherDataHourly.hourly[index].weather![0].icon!,
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}

//hourly details

class HourlyDetails extends StatelessWidget {
  int temp;
  int timeStamp;
  int index;
  int cardIndex;
  String weatherIcon;

  HourlyDetails(
      {Key? key,
      required this.cardIndex,
      required this.index,
      required this.timeStamp,
      required this.temp,
      required this.weatherIcon})
      : super(key: key);

  String getTime(final timestamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String x = DateFormat("jm").format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            getTime(timeStamp),
            style: TextStyle(
              color: cardIndex == index
                  ? Colors.white
                  : CustomColors.textColorBlack,
            ),
          ),
        ),
        Image.asset(
          "assets/weather/$weatherIcon.png",
          height: 40,
          width: 40,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text("$temp°",
              style: TextStyle(
                color: cardIndex == index
                    ? Colors.white
                    : CustomColors.textColorBlack,
              )),
        )
      ],
    );
  }
}
