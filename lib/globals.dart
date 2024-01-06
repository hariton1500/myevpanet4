Map<String, dynamic> appState = {'guids': [], 'accounts': [], 'token': ''};

bool get isRegistered =>
    appState['guids'] is List && appState['guids'].length > 0;

String lastApiErrorMessage = '';
