MEMORY
{
    /*
		DRAM    (rwx): ORIGIN = 0x00400000, LENGTH = 1M
	*/
	DRAM    (rwx): ORIGIN = 0x200000, LENGTH = 64K
}

ENTRY(__start)

SECTIONS
{
	.text :
	{
        KEEP(*(.text.vector_table))
        *(.text*)
        *(.rodata*)
    } > DRAM

    .ARM.extab : 
	{
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > DRAM

	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} > DRAM
    
    __rom_data_s__ = ALIGN (4);

    .data : AT (__rom_data_s__)
	{
        . = ALIGN(4);
        PROVIDE(__data_s__ = .);
        *(.data*)
        . = ALIGN(4);
        PROVIDE(__data_e__ = .);
    } > DRAM

    .bss :
	{
		. = ALIGN(4);
		PROVIDE(__bss_s__ = .);
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		PROVIDE(__bss_e__ = .);
	} > DRAM

    .stack (NOLOAD):
	{
		. = ALIGN(4);
		PROVIDE(__stack_s__ = .);
		*(.stack*)
		. = ALIGN(4);
		PROVIDE(__stack_e__ = .);
	} > DRAM

    .heap (NOLOAD):
	{
		. = ALIGN(4);
		PROVIDE(__heap_s__ = .);
		*(.heap*)
		. = ALIGN(4);
		PROVIDE(__heap_e__ = .);
	} > DRAM
}
