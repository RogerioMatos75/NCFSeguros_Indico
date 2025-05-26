# Configuração do Login com Facebook

Para configurar o login com Facebook no aplicativo NCF Seguros Indico, siga estes passos:

1. Acesse [Facebook Developers](https://developers.facebook.com) e crie um novo aplicativo.

2. No painel do Facebook Developers:
   - Vá para "Configurações > Básico"
   - Adicione "Android" como plataforma
   - Configure o nome do pacote: `br.com.ncf.seguros.indico`
   - Adicione a chave de hash de desenvolvimento e produção

3. No arquivo `android/app/src/main/AndroidManifest.xml`, adicione dentro da tag `<application>`:

```xml
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>
<meta-data 
    android:name="com.facebook.sdk.ClientToken"
    android:value="@string/facebook_client_token"/>

<activity
    android:name="com.facebook.FacebookActivity"
    android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
    android:label="@string/app_name" />
<activity
    android:name="com.facebook.CustomTabActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="@string/fb_login_protocol_scheme" />
    </intent-filter>
</activity>
```

1. Crie/atualize o arquivo `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">NCF Seguros Indico</string>
    <string name="facebook_app_id">[SEU_APP_ID_AQUI]</string>
    <string name="fb_login_protocol_scheme">fb[SEU_APP_ID_AQUI]</string>
    <string name="facebook_client_token">[SEU_CLIENT_TOKEN_AQUI]</string>
</resources>
```

1. Adicione as permissões necessárias no `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

1. No `android/app/build.gradle`, certifique-se de que a versão mínima do SDK é 21:

```gradle
defaultConfig {
    minSdkVersion 21
}
```

## Observações Importantes

1. Substitua `[SEU_APP_ID_AQUI]` pelo ID do seu aplicativo Facebook
2. Substitua `[SEU_CLIENT_TOKEN_AQUI]` pelo token do cliente gerado no painel do Facebook

3. Para gerar a chave de hash de desenvolvimento:

```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

1. A senha padrão do debug.keystore é: `android`
