#ifndef _INTERRUPTS_H
#define _INTERRUPTS_H

#include "types.h"

extern uint8_t pressW;
extern uint8_t pressA;
extern uint8_t pressS;
extern uint8_t pressD;

extern uint16_t register_interrupt_handlers();

#endif