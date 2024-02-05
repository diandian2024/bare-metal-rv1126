
unsigned char *const UART2_BASE = (unsigned char *)0xff570000;

inline void u8_r(void *addr, unsigned char *val) {
  *val = *((volatile unsigned char *)addr);
  asm volatile("dmb sy" : : : "memory");
}

inline void u8_w(void *addr, unsigned char val) {
  asm volatile("dmb sy" : : : "memory");
  *((volatile unsigned char *)addr) = val;
}

inline void u32_r(void *addr, unsigned int *val) {
  *val = *((volatile unsigned int *)addr);
  asm volatile("dmb sy" : : : "memory");
}

inline void u32_w(void *addr, unsigned int val) {
  asm volatile("dmb sy" : : : "memory");
  *((volatile unsigned int *)addr) = val;
}

#define UART2_USR (*(volatile unsigned int *)(UART2_BASE + 0x007C))

void uart_write_byte(unsigned char val) {
  for (;;) {
    unsigned char lsr = 0;
    u8_r(UART2_BASE + 0x14, &lsr);
    if (lsr & 0b00100000) {
      break;
    }
  }
  u8_w(UART2_BASE, val);
}

void uart_write(void *buffer, int size) {
  unsigned char *pos = buffer;

  while (size--) {
    uart_write_byte(*pos++);
  }
}

static inline void __print_byte_hex_half(int val) {
  if (val >= 0 && val < 10) {
    uart_write_byte('0' + val);
  } else if (val >= 10 && val <= 16) {
    uart_write_byte('A' + val);
  } else {
    uart_write_byte('.');
  }
}

static inline void print_byte_hex(unsigned char val) {
  __print_byte_hex_half(val >> 4);
  __print_byte_hex_half(val & 0x0F);
}

static void print_pointer(unsigned int p) {
  print_byte_hex((p >> 24) & 0xFF);
  print_byte_hex((p >> 16) & 0xFF);
  print_byte_hex((p >> 8) & 0xFF);
  print_byte_hex((p >> 0) & 0xFF);
}

void print_relocate(unsigned int f, unsigned int t) {
  print_pointer(f);
  uart_write("->", 2);
  print_pointer(t);
  uart_write("\r\n", 2);
}

int main() {
  uart_write("ruhr fuck rv1126\r\n", 20);
  return 0;
}
