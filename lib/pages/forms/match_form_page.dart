import 'package:flutter/material.dart';
import 'package:padel_diary/models/match_model.dart';
import 'package:padel_diary/models/player_model.dart';
import 'package:padel_diary/providers/match_provider.dart';
import 'package:padel_diary/providers/player_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

class MatchFormPage extends StatefulWidget {
  @override
  _MatchFormPageState createState() => _MatchFormPageState();
}

class _MatchFormPageState extends State<MatchFormPage> {
  final formKey = GlobalKey<FormState>();
  Match matchModel = Match();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _durationController = new TextEditingController();

  double _effortSliderValue = 5.0;
  List<Player> _restOfPlayers = [];
  List<Player> _mvpPlayers = [];

  @override
  Widget build(BuildContext context) {
    final _playerProvider = Provider.of<PlayerProvider>(context);
    final _players = _playerProvider.players;
    setState(() {
      _restOfPlayers = _players;
      matchModel.teamAFirstSet = 0;
      matchModel.teamASecondSet = 0;
      matchModel.teamAThirdSet = 0;
      matchModel.teamBFirstSet = 0;
      matchModel.teamBSecondSet = 0;
      matchModel.teamBThirdSet = 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir nuevo partido'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ListTile(title: Text('Equipo A'), leading: Icon(Icons.people)),
                Divider(),
                Row(
                  children: [
                    Expanded(child: _inputTeamALeft()),
                    SizedBox(width: 10.0),
                    Expanded(child: _inputTeamARight()),
                  ],
                ),
                ListTile(title: Text('Equipo B'), leading: Icon(Icons.people)),
                Divider(),
                Row(
                  children: [
                    Expanded(child: _inputTeamBLeft()),
                    SizedBox(width: 10.0),
                    Expanded(child: _inputTeamBRight()),
                  ],
                ),
                SizedBox(height: 15.0),
                _resultContainer(),
                _mvpInput(),
                Row(children: [
                  Expanded(child: _dateInput(context)),
                  SizedBox(width: 10.0),
                  Expanded(child: _durationInput(context))
                ]),
                SizedBox(height: 15.0),
                _temperatureInput(),
                //_inputClub(),
                //_inputTournament(),
                //_inputBall(),
                SizedBox(height: 25.0),
                _effortInput(),
                SizedBox(height: 25.0),
                _commentsInput(),
                SizedBox(height: 25.0),
                _submitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultContainer() {
    return Column(
      children: [
        SizedBox(height: 25.0),
        Card(
          elevation: 12.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              defaultColumnWidth: FlexColumnWidth(2.0),
              children: [
                TableRow(children: [
                  SizedBox(),
                  Text('Set 1', textAlign: TextAlign.center),
                  Text('Set 2', textAlign: TextAlign.center),
                  Text('Set 3', textAlign: TextAlign.center),
                ]),
                TableRow(children: [
                  SizedBox(height: 10.0),
                  SizedBox(),
                  SizedBox(),
                  SizedBox()
                ]),
                TableRow(children: [
                  Text('Equipo A', textAlign: TextAlign.center),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    textAlign: TextAlign.center,
                    onSaved: (value) =>
                        matchModel.teamAFirstSet = int.tryParse(value),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    textAlign: TextAlign.center,
                    onSaved: (value) =>
                        matchModel.teamASecondSet = int.tryParse(value),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    textAlign: TextAlign.center,
                    onSaved: (value) =>
                        matchModel.teamAThirdSet = int.tryParse(value),
                  ),
                ]),
                TableRow(children: [
                  SizedBox(height: 10.0),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                ]),
                TableRow(children: [
                  Text('Equipo B', textAlign: TextAlign.center),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    textAlign: TextAlign.center,
                    onSaved: (value) =>
                        matchModel.teamBFirstSet = int.tryParse(value),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    textAlign: TextAlign.center,
                    onSaved: (value) =>
                        matchModel.teamBSecondSet = int.tryParse(value),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    textAlign: TextAlign.center,
                    onSaved: (value) =>
                        matchModel.teamBThirdSet = int.tryParse(value),
                  ),
                ]),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Widget _mvpInput() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0),
          child: DropdownButtonFormField(
            hint: Text('⭐ MVP del partido'),
            items: _mvpPlayers.length ==
                    4 //TODO: repasar adds y removes de _mvpPlayers
                ? _getDropdownMenuPlayers(_mvpPlayers)
                : [],
            onChanged: (value) => setState(() {
              matchModel.mvp = value.playerId;
            }),
            onSaved: (value) => matchModel.mvp = value.playerId,
          ),
        ),
        SizedBox(height: 25.0)
      ],
    );
  }

  Widget _inputTeamALeft() {
    return DropdownButtonFormField(
      hint: Text('Jugador revés'),
      items: _getDropdownMenuPlayers(_restOfPlayers),
      onChanged: (value) => setState(() {
        matchModel.teamALeft = value.playerId;
        if (matchModel.teamALeft != null) {
          _mvpPlayers
              .removeWhere((player) => player.playerId == matchModel.teamALeft);
        }
        _mvpPlayers.add(value);
      }),
      onSaved: (value) => matchModel.teamALeft = value.playerId,
    );
  }

  Widget _inputTeamARight() {
    return DropdownButtonFormField(
      hint: Text('Jugador drive'),
      items: _getDropdownMenuPlayers(_restOfPlayers),
      onChanged: (value) => setState(() {
        matchModel.teamARight = value.playerId;
        if (matchModel.teamARight != null) {
          _mvpPlayers.removeWhere(
              (player) => player.playerId == matchModel.teamARight);
        }
        _mvpPlayers.add(value);
      }),
      onSaved: (value) => matchModel.teamARight = value.playerId,
    );
  }

  Widget _inputTeamBRight() {
    return DropdownButtonFormField(
      hint: Text('Jugador drive'),
      items: _getDropdownMenuPlayers(_restOfPlayers),
      onChanged: (value) => setState(() {
        matchModel.teamBRight = value.playerId;
        if (matchModel.teamBRight != null) {
          _mvpPlayers.removeWhere(
              (player) => player.playerId == matchModel.teamBRight);
        }
        _mvpPlayers.add(value);
      }),
      onSaved: (value) => matchModel.teamBRight = value.playerId,
    );
  }

  Widget _inputTeamBLeft() {
    return DropdownButtonFormField(
      hint: Text('Jugador revés'),
      items: _getDropdownMenuPlayers(_restOfPlayers),
      onChanged: (value) => setState(() {
        matchModel.teamBLeft = value.playerId;
        if (matchModel.teamBLeft != null) {
          _mvpPlayers
              .removeWhere((player) => player.playerId == matchModel.teamBLeft);
        }
        _mvpPlayers.add(value);
      }),
      onSaved: (value) => matchModel.teamBLeft = value.playerId,
    );
  }

  Widget _dateInput(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _dateController,
      decoration: InputDecoration(hintText: 'Fecha', labelText: 'Fecha'),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final String pickedDate = picked.toString().split(' ')[0];
      final List<String> dateNumbers = pickedDate.split('-');
      final String dateToPrint =
          '${dateNumbers[2]}-${dateNumbers[1]}-${dateNumbers[0]}';
      setState(() {
        matchModel.date = picked.microsecondsSinceEpoch;
        _dateController.text = dateToPrint;
      });
    }
  }

  Widget _durationInput(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: Colors.blue,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.grey,
                displayColor: Colors.black,
              )),
      child: Builder(
        builder: (context) => TextFormField(
          enableInteractiveSelection: false,
          controller: _durationController,
          decoration:
              InputDecoration(hintText: 'Duración', labelText: 'Duración'),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDuration(context);
          },
        ),
      ),
    );
  }

  _selectDuration(BuildContext context) async {
    Duration picked = await showDurationPicker(
      context: context,
      initialTime: new Duration(hours: 1, minutes: 30),
    );

    if (picked != null) {
      final String _pickedDate = picked.toString().split('.')[0];
      final List<String> _dateNumbers = _pickedDate.split(':');
      final String _durationToPrint = '${_dateNumbers[0]}:${_dateNumbers[1]}';
      final int _minutes =
          int.tryParse(_dateNumbers[0]) * 60 + int.tryParse(_dateNumbers[1]);
      setState(() {
        matchModel.duration = _minutes;
        _durationController.text = _durationToPrint;
      });
    }
  }

  Widget _effortInput() {
    return Row(
      children: [
        Text('Esfuerzo'),
        Expanded(
          child: Slider(
            value: _effortSliderValue,
            min: 1.0,
            max: 10.0,
            label: _effortSliderValue.toInt().toString(),
            divisions: 9,
            onChanged: (value) {
              setState(() {
                _effortSliderValue = value;
                matchModel.effort = value.toInt();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _temperatureInput() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Temperatura ºC'),
      onSaved: (value) => matchModel.temperature = int.tryParse(value),
    );
  }

  Widget _commentsInput() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        labelText: 'Comentarios',
        hintText:
            '¿Cómo te has encontrado? ¿Te has entendido bien con tu pareja? ¿La meteorología ha sido dura?',
      ),
      onSaved: (value) => matchModel.comments = value,
    );
  }

  Widget _submitButton() {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Crear partido'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: _submit,
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    matchProvider.createMatch(matchModel);

    formKey.currentState.reset();
    setState(() {
      matchModel = Match();
    });
  }

  List<DropdownMenuItem<Player>> _getDropdownMenuPlayers(List<Player> players) {
    List<DropdownMenuItem<Player>> _dropdownItems = [];
    players.forEach((player) {
      final _dropdownItem = DropdownMenuItem(
        child: Text(player.name),
        value: player,
      );
      _dropdownItems.add(_dropdownItem);
    });
    return _dropdownItems;
  }
}
