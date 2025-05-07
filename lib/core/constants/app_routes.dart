class AppRoutes {
  // Rotas de autenticação
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  
  // Rotas do usuário
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String myIndications = '/my-indications';
  static const String newIndication = '/new-indication';
  
  // Rotas do admin
  static const String adminDashboard = '/admin';
  static const String indicationDetail = '/admin/indication/:id';
  
  // Outras rotas
  static const String settings = '/settings';
  static const String about = '/about';
  static const String help = '/help';
  
  // Funções auxiliares para rotas dinâmicas
  static String indicationDetailPath(String id) => '/admin/indication/$id';
}