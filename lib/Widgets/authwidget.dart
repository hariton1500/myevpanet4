import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/globals.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Введите ваш ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите свой ID';
                        }
                        // Дополнительные проверки по вашим требованиям
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
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите номер телефона';
                        }
                        // Дополнительные проверки по вашим требованиям
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Все проверки пройдены, выполняем логику авторизации
                          // authService.signIn(_idController.text, _phoneController.text);
                          // Ваш код здесь
                          authenticate(
                                  token: appState['token'],
                                  phoneNumber: _phoneController.text,
                                  uid: _idController.text)
                              .then((value) {
                            if (value.isEmpty) {
                              // Пользователь не найден
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(lastApiErrorMessage),
                                ),
                              );
                            } else {
                              // Пользователи найдены
                              appState['guids'] = value;
                              saveAppState(value);
                              setState(() {});
                            }
                          });
                        }
                      },
                      child: const Text('Войти'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
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
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
