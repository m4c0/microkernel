using uint16_t = unsigned short;

static uint16_t *mem_buf = (uint16_t *)0xb8000;

// Just to prove a point (aka: we can use the stack)
void set_char(int x, int y, char c, char attr) {
  mem_buf[y * 40 + x] = ((uint16_t)attr << 8) | c;
}
