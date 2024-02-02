#ifndef __STACK_H__
#define __STACK_H__

#define KB(v) (v * 1024)
#define MB(v) (KB(v) * 1024)

#define FIQ_STACK_SIZE KB(8)
#define IRQ_STACK_SIZE KB(8)
#define ABT_STACK_SIZE KB(8)
#define UDF_STACK_SIZE KB(8)
#define SVC_STACK_SIZE KB(8)
#define SYS_STACK_SIZE KB(8)

#endif
