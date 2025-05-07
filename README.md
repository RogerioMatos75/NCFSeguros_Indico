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
- **Formulario**: https://villa.segfy.com/Publico/Segurados/Orcamentos/SolicitarCotacao?e=P6pb0nbwjHfnbNxXuNGlxw%3D%3D


## Regras de Negócio

- Cada indicação gera 1% de desconto para o segurado que indicou.
- Se a indicação se converter em cliente, o segurado ganha mais 1% de desconto
- O desconto máximo acumulado é de 10% 
- Os descontos são aplicados na renovação da apólice do segurado

## Tecnologias Utilizadas

- **Firebase Auth**: Autenticação de usuários
- **Firebase Cloud Messaging**: Sistema de notificações push


## Estrutura do Projeto

- **model**: Classes de dados
- **repository**: Camada de acesso a dados
- **viewmodel**: Lógica de negócios e gerenciamento de estado
- **ui**: Componentes de interface do usuário
  - **screens**: Telas do aplicativo
  - **components**: Componentes reutilizáveis
  - **navigation**: Navegação entre telas
- **service**: Serviços em background
- **worker**: Workers para tarefas periódicas


## Contribuição

Para contribuir com o projeto, siga estas etapas:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça commit das suas alterações (`git commit -m 'Adiciona nova funcionalidade'`)
4. Faça push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.

## Contato

NCF Seguros - [contato@ncfseguros.com.br](mailto:contato@ncfseguros.com.br) 