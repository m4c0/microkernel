void set_char(int x, int y, char c, char attr);

extern "C" void boot() {
  char c = 0;
  char attr = 0;
  for (int y = 0; y < 25; y++) {
    for (int x = 0; x < 40; x++) {
      set_char(x, y, '@' + (c++ % 32), attr += 3);
    }
  }
}
