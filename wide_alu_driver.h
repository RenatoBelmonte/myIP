#include <wide_alu_auto.h>
#include <stdint.h>
#include <hal/pulp.h>

void set_op(uint8_t operation);
void set_delay(uint8_t delay);
void trigger_op(void);
void set_operands(uint32_t* a, uint32_t* b);
int poll_done(void);
void clear_error(void);
int wide_multiply(uint32_t a[8], uint32_t b[8], uint32_t result[16]);
