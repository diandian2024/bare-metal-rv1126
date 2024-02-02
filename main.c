
unsigned char *const UART_BASE = (unsigned char *)0xff570000;

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

void uart_write(void *buffer, int size) {
  unsigned char *pos = buffer;

  while (size--) {
    unsigned char lsr = 0;
    u8_r(UART_BASE + 5, &lsr);
    if (lsr & 0b00100000) {
      u8_w(UART_BASE, *pos);
    }
  }
}

int main() {
  for (;;) {
    uart_write("AAAA", 4);
  }
  return 0;
}
