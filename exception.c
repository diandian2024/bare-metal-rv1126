struct arm_regs_t {
  unsigned int esp;
  unsigned int cpsr;
  unsigned int r[13];
  unsigned int sp;
  unsigned int lr;
  unsigned int pc;
};

static void show_regs(struct arm_regs_t *regs) {
  //   int i;

  //   LOG("pc : [<%08lx>] lr : [<%08lx>] cpsr: %08lx\r\n", regs->pc, regs->lr,
  //       regs->cpsr);
  //   LOG("sp : %08lx esp : %08lx\r\n", regs->sp, regs->esp);
  //   for (i = 12; i >= 0; i--)
  //     LOG("r%-2d: %08lx\r\n", i, regs->r[i]);
  //   LOG("\r\n");
}

void arm32_do_undefined_instruction(struct arm_regs_t *regs) {
  show_regs(regs);
  regs->pc += 4;
}

void arm32_do_software_interrupt(struct arm_regs_t *regs) {
  show_regs(regs);
  regs->pc += 4;
}

void arm32_do_prefetch_abort(struct arm_regs_t *regs) {
  show_regs(regs);
  regs->pc += 4;
}

void arm32_do_data_abort(struct arm_regs_t *regs) {
  show_regs(regs);
  regs->pc += 4;
}

__attribute__((weak)) void interrupt_handle_exception(void *regs) {}

void arm32_do_irq(struct arm_regs_t *regs) { interrupt_handle_exception(regs); }

void arm32_do_fiq(struct arm_regs_t *regs) { interrupt_handle_exception(regs); }
