import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Pages/logs.dart';
import 'package:myevpanet4/globals.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key, required this.onSuccess});
  final VoidCallback onSuccess;

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _phoneNumberFormatter = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final MaskTextInputFormatter _idNumberFormatter =
      MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});

  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print((appState['accounts'] as Map).values.map((e) => e.id));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Авторизация',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      bottomSheet: remark(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_idNumberFormatter],
                  decoration: const InputDecoration(
                    labelText: 'Введите ваш ID',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите свой ID';
                    }
                    if ((appState['accounts'] as Map)
                        .values
                        .map((e) => e.id.toString())
                        .contains(value)) {
                      return 'Этот ID уже есть в списке учетных записей';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneNumberFormatter],
                  decoration: const InputDecoration(
                    labelText: 'Введите номер телефона',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  ),
                  validator: (value) {
                    //print(value?.length);
                    if (value == null || value.isEmpty || value.length != 18) {
                      return 'Пожалуйста, введите номер телефона полностью';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_formKey.currentState?.validate() ?? false) {
                      authenticate(
                              token: appState['token'],
                              phoneNumber:
                                  '+${_phoneNumberFormatter.getUnmaskedText()}',
                              uid: _idNumberFormatter.getUnmaskedText())
                          .then((value) {
                        if (value.isEmpty) {
                          // Пользователь не найден
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(lastApiErrorMessage),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          //добавляем к текущему списку guids и убираем дубликаты

                          //guids = [...guids, ...value];
                          appState['guids'] = <String>{...guids, ...value}.toList();
                          // Пользователи найдены / сохраняем в локальном хранилище
                          saveAppState(guids: guids);
                          // Вызываем onSuccess, чтобы перейти к следующему экрану
                          widget.onSuccess();
                        }
                      });
                    }
                  },
                  child: _isLoading ? const CircularProgressIndicator.adaptive() : const Text('Пройти авторизацию'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget remark() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: GestureDetector(
        onDoubleTap: () {
          magic++;
          if (magic >= 3) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const LogsPage()))
                .then((value) {
              magic = 0;
            });
          }
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
            ),
            children: [
              TextSpan(text: 'Для авторизации введите '),
              TextSpan(
                text: 'ID и номер телефона.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '\n\n'),
              TextSpan(
                text: 'ID: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      'Ваш абонентский идентификатор, он же номер договора, он же номер пополнения баланса\n'),
              TextSpan(
                text: 'Номер телефона: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Который закреплен к вашему абонентскому счету.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
