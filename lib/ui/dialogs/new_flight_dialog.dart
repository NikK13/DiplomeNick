import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/lists.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:diplome_nick/ui/widgets/button.dart';
import 'package:diplome_nick/ui/widgets/dialog.dart';
import 'package:diplome_nick/ui/widgets/dropdown.dart';
import 'package:diplome_nick/ui/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class NewFlightDialog extends StatefulWidget {
  final Function? updateList;

  const NewFlightDialog({Key? key, this.updateList}) : super(key: key);

  @override
  State<NewFlightDialog> createState() => _NewFlightDialogState();
}

class _NewFlightDialogState extends State<NewFlightDialog> {
  late ListItem _placeStart, _placeFinish;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final _economicPriceController = TextEditingController();
  final _businessPriceController = TextEditingController();

  final _economicCountController = TextEditingController();
  final _businessCountController = TextEditingController();

  @override
  void initState() {
    _placeStart = destinations.first;
    _placeFinish = destinations[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: AppLocalizations.of(context, 'details'),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownPicker(
                  title: '${AppLocalizations.of(context, 'departure')}:*',
                  myValue: _placeStart.value,
                  items: destinations,
                  darkColor: const Color(0xFF242424),
                  onChange: (newVal){
                    final place = destinations.firstWhere((element) => element.value == newVal);
                    if(place.value != _placeFinish.value){
                      setState(() => _placeStart = place);
                    }
                  },
                  onSubmit: null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownPicker(
                  title: '${AppLocalizations.of(context, 'arrival')}:*',
                  myValue: _placeFinish.value,
                  items: destinations,
                  darkColor: const Color(0xFF242424),
                  onChange: (newVal){
                    final place = destinations.firstWhere((element) => element.value == newVal);
                    if(place.value != _placeStart.value){
                      setState(() => _placeFinish = place);
                    }
                  },
                  onSubmit: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InputField(
                  hint: AppLocalizations.of(context, 'departure_date'),
                  controller: _startDateController, inputType: TextInputType.number,
                  onTap: (){
                    DatePicker.showDateTimePicker(
                      context,
                      locale: LocaleType.ru,
                      minTime: DateTime(2023, 2, 1),
                      onConfirm: (DateTime date){
                        _startDateController.text = DateFormat(dateFormat24h).format(date).toString();
                      }
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  hint: AppLocalizations.of(context, 'arrival_date'),
                  controller: _endDateController, inputType: TextInputType.number,
                  onTap: (){
                    DatePicker.showDateTimePicker(
                      context,
                      locale: LocaleType.ru,
                      minTime: DateTime(2023, 2, 1),
                      onConfirm: (DateTime date){
                        _endDateController.text = DateFormat(dateFormat24h).format(date).toString();
                      }
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "${AppLocalizations.of(context, 'tickets')}(${AppLocalizations.of(context, 'economic_class')})",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InputField(
                  hint: AppLocalizations.of(context, 'price'),
                  controller: _economicPriceController,
                  inputType: TextInputType.number,
                  isOnlyNum: true,
                )
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  hint: AppLocalizations.of(context, 'count'),
                  controller: _economicCountController,
                  inputType: TextInputType.number,
                  isOnlyNum: true,
                )
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "${AppLocalizations.of(context, 'tickets')}(${AppLocalizations.of(context, 'business_class')})",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InputField(
                  hint: AppLocalizations.of(context, 'price'),
                  controller: _businessPriceController,
                  inputType: TextInputType.number,
                  isOnlyNum: true,
                )
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  hint: AppLocalizations.of(context, 'count'),
                  controller: _businessCountController,
                  inputType: TextInputType.number,
                  isOnlyNum: true,
                )
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: AppLocalizations.of(context, 'create'),
              onPressed: () async{
                final startDate = _startDateController.text.trim();
                final endDate = _endDateController.text.trim();
                final economicPrice = _economicPriceController.text.trim();
                final economicCount = _economicCountController.text.trim();
                final businessPrice = _businessPriceController.text.trim();
                final businessCount = _businessCountController.text.trim();
                if(startDate.isNotEmpty && endDate.isNotEmpty &&
                  economicCount.isNotEmpty && economicPrice.isNotEmpty &&
                  businessCount.isNotEmpty && businessPrice.isNotEmpty){
                  if(DateFormat(dateFormat24h).parse(endDate).isAfter(DateFormat(dateFormat24h).parse(startDate))){
                    Navigator.pop(context);
                    final flight = Flight(
                      startDate: startDate,
                      endDate: endDate,
                      titleStart: _placeStart.title,
                      titleEnd: _placeFinish.title,
                    );
                    final tickets = Ticket(
                      economicTicketsCount: int.tryParse(economicCount) ?? 0,
                      economicTicketsPrice: double.tryParse(economicPrice) ?? 0.0,
                      businessTicketsCount: int.tryParse(businessCount) ?? 0,
                      businessTicketsPrice: double.tryParse(businessPrice) ?? 0.0
                    );
                    await appBloc.addNewFlight(flight, tickets);
                    await widget.updateList!();
                  }
                  else{
                    showInfoDialog(context, "INCORRECT DATE OR TIME PICKED");
                  }
                }
                else{
                  showInfoDialog(context, AppLocalizations.of(context, 'empty_fields'));
                }
              }
            )
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _businessCountController.dispose();
    _businessPriceController.dispose();
    _economicCountController.dispose();
    _economicPriceController.dispose();
    super.dispose();
  }
}
