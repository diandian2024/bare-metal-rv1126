
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

void uart_write_byte(unsigned char val) 
{
  for (; ; ) {
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

int main() {
  for (;;) {
    uart_write("AAAA\n\r", 6);
  }
  return 0;
}
