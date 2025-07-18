String przypiszRole(String login) {
  final admini = ['emka', 'adas'];
  final normalized = login.trim().toLowerCase();

  if (admini.contains(normalized)) {
    return 'ADMIN';
  }

  return 'PRACOWNIK';
}
