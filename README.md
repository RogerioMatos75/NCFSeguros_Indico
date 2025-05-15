# NCF Seguros Indico - Aplicativo de Indicações

## Sobre o Projeto

O NCF Seguros Indico é um aplicativo web desenvolvido para facilitar e incentivar a indicação de novos clientes para seguros de automóveis. O aplicativo permite que segurados indiquem amigos e familiares interessados em contratar seguros, recebendo descontos acumulativos na renovação de suas próprias apólices.

## Funcionalidades

### Para Segurados

- **Cadastro e Login**: Autenticação segura com Firebase Auth
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
- **Firebase Cloud Messaging**: Sistema de notificações push

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
- `flutter build web`: Gera build de produção
- `flutter test`: Executa os testes

## Deploy

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
