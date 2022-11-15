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

  @override
  void initState() {
    _placeStart = destinations.first;
    _placeFinish = destinations[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: AppLocalizations.of(context, 'flights'),
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
                    setState(() => _placeFinish = destinations.firstWhere((element) => element.value == newVal));
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
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: AppLocalizations.of(context, 'create'),
              onPressed: () async{
                final startDate = _startDateController.text.trim();
                final endDate = _endDateController.text.trim();
                if(startDate.isNotEmpty && endDate.isNotEmpty){
                  if(DateFormat(dateFormat24h).parse(endDate).isAfter(DateFormat(dateFormat24h).parse(startDate))){
                    Navigator.pop(context);
                    await appBloc.addNewFlight(
                      _placeStart.title,
                      _placeFinish.title,
                      startDate,
                      endDate
                    );
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
    super.dispose();
  }
}
