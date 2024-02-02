#include "stack.h"

MEMORY
{
	ROM	(rx): ORIGIN = 0x00000000, LENGTH = 128M
    RAM (rwx): ORIGIN = 0x40000000, LENGTH = 128M
}

ENTRY(__start)

SECTIONS
{
	.text :
	{
        *(.text*)
        *(.rodata*)
    } > ROM

    .ARM.extab : 
	{
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > ROM

	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} > ROM
    
	/*
	.got : 
	{
		. = ALIGN(4);
		*(.got*)
		. = ALIGN(4);
	} > ROM
	*/
	
    __rom_data_s__ = ALIGN (4);

    .data : AT (__rom_data_s__)
	{
        . = ALIGN(4);
        PROVIDE(__data_s__ = .);
        *(.data*)
        . = ALIGN(4);
        PROVIDE(__data_e__ = .);
    } > RAM

    .bss :
	{
		. = ALIGN(4);
		PROVIDE(__bss_s__ = .);
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		PROVIDE(__bss_e__ = .);
	} > RAM

    .stack (NOLOAD):
	{
		. = ALIGN(4);
		PROVIDE(__stack_s__ = .);
		*(.stack*)
		. = ALIGN(4);
		PROVIDE(__stack_e__ = .);
	} > RAM

    .heap (NOLOAD):
	{
		. = ALIGN(4);
		PROVIDE(__heap_s__ = .);
		*(.heap*)
		. = ALIGN(4);
		PROVIDE(__heap_e__ = .);
	} > RAM
}
