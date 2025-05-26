# NCF Seguros Indico - Aplicativo de Indicações

## Sobre o Projeto

O NCF Seguros Indico é um aplicativo web desenvolvido para facilitar e incentivar a indicação de novos clientes para seguros de automóveis. O aplicativo permite que segurados indiquem amigos e familiares interessados em contratar seguros, recebendo descontos acumulativos na renovação de suas próprias apólices.

## Funcionalidades

### Para Segurados

- **Cadastro e Login**:
  - Autenticação segura com Firebase Auth
  - Login com email e senha
  - Login com Google
  - Login com Facebook
  - Recuperação de senha
  - "Lembrar-me" para manter sessão ativa
- **Perfil de Usuário**: Gerenciamento de informações pessoais
- **Indicação de Amigos**: Formulário simples para indicar potenciais clientes
- **Acompanhamento de Indicações**: Visualização do status de todas as indicações feitas
- **Desconto Acumulativo**: Visualização do desconto acumulado para renovação do seguro

### Para Administradores

- **Painel Administrativo**: Visualização de todas as indicações recebidas
- **Gerenciamento de Status**: Atualização do status das indicações (pendente, contatado, convertido, rejeitado)
- **Notificações**: Sistema de push notificações para novas indicações
- **Formulario**: [Acessar Formulário](https://villa.segfy.com/Publico/Segurados/Orcamentos/SolicitarCotacao?e=P6pb0nbwjHfnbNxXuNGlxw%3D%3D)

## Regras de Negócio

- Cada indicação gera 1% de desconto para o segurado que indicou.
- Se a indicação se converter em cliente, o segurado ganha mais 1% de desconto
- O desconto máximo acumulado é de 10%
- Os descontos são aplicados na renovação da apólice do segurado

## Tecnologias Utilizadas

- **Firebase Auth**: Autenticação de usuários
  - Login com Email/Senha
  - Login com Google
  - Login com Facebook
- **Firebase Cloud Messaging**: Sistema de notificações push

## 🛠️ Configuração do Ambiente e Primeiros Passos

Para configurar o ambiente de desenvolvimento e rodar o projeto pela primeira vez, siga os passos abaixo.

### 1. Pré-requisitos Essenciais

- **Flutter SDK:** Certifique-se de ter o Flutter instalado e configurado. Siga as instruções de instalação para o seu sistema operacional no [site oficial do Flutter](https://flutter.dev/docs/get-started/install).
- **Dart SDK:** Vem embutido com o Flutter.
- **Node.js:** Necessário para a Firebase CLI. Você pode [baixá-lo aqui](https://nodejs.org/).
- **Git:** Para controle de versão.
- **Um Editor de Código:** VS Code com as extensões do Flutter e Dart, ou Android Studio.

### 2. Obter o Código do Projeto

   Se você ainda não tem o projeto localmente, clone o repositório. Se já o tem, navegue até o diretório raiz do projeto.

### 3. Instalar Dependências do Flutter

   No terminal, dentro da pasta do projeto, execute:

   ```bash
   flutter pub get
   ```

### 4. Verificar o Ambiente com

 `flutter doctor`
   Execute o comando abaixo e resolva quaisquer problemas pendentes. É crucial que todas as seções estejam com um "check" (✓).

   ```bash
   flutter doctor
   ```
  
**Atenção para o Visual Studio (Desenvolvimento Windows):**
  
Se o `flutter doctor` indicar problemas com o Visual Studio (e.g., falta de "Desktop development with C++" ou componentes como MSVC build tools, C++ CMake tools):

1. Abra o "Visual Studio Installer"
2. Clique em "Modificar" na sua instalação do Visual Studio
3. Garanta que a carga de trabalho "Desenvolvimento para desktop com C++" esteja selecionada
4. Na aba "Componentes Individuais", verifique e instale os componentes solicitados pelo `flutter doctor`
5. Após a instalação, reinicie o computador se solicitado e rode `flutter doctor` novamente

### 5. Configurar o Firebase com FlutterFire CLI

Este projeto utiliza o Firebase. A configuração é simplificada pela FlutterFire CLI.

   a. **Instale a Firebase CLI globalmente** (se ainda não tiver):
      ```bash
      npm install -g firebase-tools
      ```

   b. **Faça login no Firebase pela CLI**:
      ```bash
      firebase login
      ```
      (Autentique-se com a conta Google associada ao seu projeto Firebase)

   c. **Instale a FlutterFire CLI globalmente**:
      ```bash
      `dart pub global activate flutterfire_cli`
      `firebase login`
      `flutterfire configure`
      `flutterfire configure --project=ncfseguros-indico`      `firebase logout`
      ```
      *   **⚠️ Atenção ao PATH:** Após a instalação, o terminal pode avisar que o diretório de executáveis do Pub não está no seu PATH (e.g., `C:\Users\SEU_USUARIO\AppData\Local\Pub\Cache\bin`). Você **precisa** adicionar este diretório à variável de ambiente "Path" do seu sistema para que o comando `flutterfire` seja reconhecido. Após adicionar, **reinicie seu terminal/VS Code**.

   d. **Configure o Firebase no Projeto Flutter** (o comando `flutterfire configure` já está listado em "Comandos Úteis"):
      Navegue até a pasta raiz do projeto `NCFSeguros_Indico` e execute `flutterfire configure`. Siga as instruções interativas para selecionar/criar seu projeto Firebase e as plataformas desejadas (android, ios, web, etc.).
      Isso irá gerar automaticamente o arquivo `lib/firebase_options.dart`.

   e. **Garanta o `firebase_core` e Inicialize o Firebase no `main.dart`**:Certifique-se de que o pacote `firebase_core` está no seu `pubspec.yaml`. Se não estiver, adicione-o e rode `flutter pub get`.
      ```yaml
      # pubspec.yaml
      dependencies:
        flutter:
          sdk: flutter
        firebase_core: ^MAIS_RECENTE # Verifique a versão mais recente no pub.dev
        # ... firebase_auth, cloud_firestore, etc.
      ```
      No seu arquivo `lib/main.dart`, garanta que o Firebase seja inicializado:

   f. **Importante sobre `lib/firebase_options.dart`**:
      Este arquivo é gerado pelo `flutterfire configure` e contém as chaves de configuração do cliente para o Firebase.
      **Recomendação de Segurança:** Para evitar a exposição acidental de chaves de API, é **altamente recomendado adicionar `lib/firebase_options.dart` ao seu arquivo `.gitignore`**.
      Cada desenvolvedor (e seu ambiente de CI/CD) deve executar `flutterfire configure` localmente para gerar este arquivo com as chaves apropriadas para o ambiente Firebase que estão utilizando.
      A segurança dos seus dados no Firebase é primariamente gerenciada pelas **Regras de Segurança (Security Rules)** e **App Check** configurados no console do Firebase. No entanto, não versionar as chaves adiciona uma camada extra de proteção.
      Se você optar por versionar este arquivo, certifique-se de que seu repositório é privado e que você compreende os riscos associados.

### 6. Executar o Projeto

   Após a configuração do Firebase, você pode executar o projeto. Para isso, utilize o comando abaixo para rodar no navegador:

   ```bash
   Após a configuração, você pode executar o projeto utilizando os comandos listados na seção "Comandos Úteis" (e.g., `flutter run -d chrome`).

## Estrutura do Projeto

```text
lib/
├── core/           # Configurações e constantes
├── data/           # Models e repositories
├── presentation/   # UI e ViewModels
│   ├── ui/
│   │   ├── screens/
│   │   └── widgets/
│   └── viewmodels/
└── services/       # Serviços da aplicação
```

## Comandos Úteis

- `flutter run -d chrome`: Executa o projeto no navegador
- `flutter build web`: Gera build de produção para o navegador  
- `flutter test --coverage`: Executa os testes
- `flutter clean`: Limpa Caches
- `flutter pub get`: Executa a atualização de pacotes
- `flutter pub upgrade --major-versions`: Atualiza pacotes para versões principais
- `flutter pub outdated`: Lista pacotes desatualizados
- `flutter doctor`: Verifica o ambiente de desenvolvimento
- `flutter doctor -v`: Verifica o ambiente de desenvolvimento com suas versões
- `flutter doctor --android-licenses`: Aceita as licenças do Android SDK:
- `flutter pub run build_runner build --delete-conflicting-outputs`: Executa o código gerado para os modelos
- `flutter pub run build_runner watch --delete-conflicting-outputs`: Executa o código gerado para os modelos em watch mode
- `flutter pub run build_runner clean`: Limpa os arquivos gerados pelo build_runner
- `flutter pub run flutter_launcher_icons:main`: Gera os ícones do aplicativo para Android e iOS
- `flutter pub run flutter_native_splash:create`: Gera a splash screen do aplicativo
- `flutter pub run flutter_native_splash:remove`: Remove a splash screen do aplicativo
- `flutter pub run flutter_native_splash:clean`: Limpa os arquivos gerados pela splash screen

### Build de Produção

1. Atualize a versão no `pubspec.yaml`
2. Execute `flutter build web`
3. Configure as opções de PWA no `web/manifest.json`
4. Deploy para o Firebase Hosting:

   ```bash
   firebase deploy
   ```

### Configurações PWA

O aplicativo é configurado como PWA (Progressive Web App) com:

- Service Worker para cache e funcionamento offline
- Manifesto para instalação como aplicativo
- Ícones e splash screens responsivos

## Contribuição

1. Crie uma branch para sua feature
2. Faça commit das alterações
3. Crie um Pull Request
4. Aguarde a revisão

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.

## Contato

NCF Seguros - [contato@ncfseguros.com.br]

## Suporte
