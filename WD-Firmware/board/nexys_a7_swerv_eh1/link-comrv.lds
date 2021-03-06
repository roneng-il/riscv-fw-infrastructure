/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright 2019 Western Digital Corporation or its affiliates.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/ 

/*
 Linker script
*/

OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  /* --------  flash (rxai!w) : ORIGIN = 0x20400000, LENGTH = 512M --------  */
  ram (wxa!ri) : ORIGIN = 0x00000000, LENGTH = 128K
  ovl          : ORIGIN = 0xE0000000, LENGTH = 0x1000
  /* TODO: Temporary old section. Will be removed shortly */
  ovltmp           : ORIGIN = 0xF0000000, LENGTH = 0x10000
}

PHDRS
{
  rom_load PT_LOAD;
  ram_init PT_LOAD;
  ram_load PT_LOAD;
  ovl PT_NULL;
}

/*----------------------------------------------------------------------*/
/* Sections                            */
/*----------------------------------------------------------------------*/

SECTIONS
{
  __stack_size = DEFINED(__stack_size) ? __stack_size : 4K;
  __comrv_align_size = __comrv_cache_size != 0 ? 512 : 0;

  .text.init :
  {
    *(.text.init)
    . = ALIGN(8);
  } > ram : rom_load

  .text :
  {
    *(.text.unlikely .text.unlikely.*)
    *(.text.startup .text.startup.*)
    *(.text .text.*)
    *(.gnu.linkonce.t.*)
    . = ALIGN(4);
  } >ram : ram_load

  .rodata :
  {
    *(.rdata)
    *(.rodata .rodata.*)
    *(.gnu.linkonce.r.*)
    . = ALIGN(4);
  } > ram : rom_load

  /* this is a placeholder for comrv overlay groups.
     after linking, we'll use objcopy utility and change the
     address of .ovlgrpdata to this address */ 
  .reserved_ovl  :
  {
    __OVERLAY_STORAGE_START__ADDRESS__ = .;
    . = 0xe00;
  } > ram : ram_load

  
  .lalign : 
  {
    . = ALIGN(4);
    PROVIDE( _data_lma = . );
  } > ram : ram_load
  
  .dalign :
  {
    . = ALIGN(4);
    PROVIDE( _data = . );
  } > ram : ram_load
  
  .data :
  {
    *(.data .data.*)
    *(.gnu.linkonce.d.*)
    . = ALIGN(8);
  } > ram : ram_load

  .sdata :
  {
    . = ALIGN(8);
    __global_pointer$ = . + 0x800;
    *(.sdata .sdata.*)
    *(.gnu.linkonce.s.*)
    . = ALIGN(8);
    *(.srodata .srodata.*)
   . = ALIGN(8);
  } > ram : ram_load
  
  .sbss :
  {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
    . = ALIGN(8);
  } > ram : ram_load
  
  . = ALIGN(4);
  PROVIDE( _edata = . );
  PROVIDE( edata = . );

  PROVIDE( _fbss = . );
  PROVIDE( __bss_start = . );
  
  .bss :
  {
    *(.bss)
    . = ALIGN(8);
  } >ram : ram_load

  _end = .;

  .stack :
  {
    _heap_end = .;
    . = . + __stack_size;
    _sp = .;
  } > ram : ram_load

  /* this area is used for loading and executing the comrv 
     overlay groups */
  .overlay_sec ALIGN(__comrv_align_size) :
  {
    __OVERLAY_CACHE_START__ = . ;
    . = __comrv_cache_size; 
    __OVERLAY_CACHE_END__ = . ;
  }  >ram 

  /* this is the location of all comrv overlay groups.
     after linking, we'll use objcopy utility and change
     this address to the .reserved_ovl address. we do this
     to make sure there is no address dependency after linking */ 
     
  .ovlgrpdata       : 
  {
    PROVIDE (OVERLAY_START_OF_OVERLAYS = .);
    *(SORT_BY_USER(.ovlinput.*))
  } >ovl AT>ovl :ovl

  /* TODO: Temporary old section. Will be removed shortly */
  .ovlgrp_legacy     : {*(.ovlgrpdata)} > ovltmp
}
