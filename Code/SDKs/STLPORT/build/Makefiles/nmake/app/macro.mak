# -*- makefile -*- Time-stamp: <03/09/28 17:22:37 ptr>
# $Id$

DBG_SUFFIX = d
STLDBG_SUFFIX = stl$(DBG_SUFFIX)

PRG_NAME_BASE          = $(PRGNAME)
PRG_NAME_DBG_BASE      = $(PRGNAME)$(DBG_SUFFIX)
PRG_NAME_STLDBG_BASE   = $(PRGNAME)$(STLDBG_SUFFIX)
PRG_NAME_A_BASE        = $(PRGNAME)_static
PRG_NAME_A_DBG_BASE    = $(PRGNAME)$(DBG_SUFFIX)_static
PRG_NAME_A_STLDBG_BASE = $(PRGNAME)$(STLDBG_SUFFIX)_static

PRG          = $(OUTPUT_DIR)\$(PRG_NAME_BASE)$(EXE)
PRG_DBG      = $(OUTPUT_DIR_DBG)\$(PRG_NAME_DBG_BASE)$(EXE)
PRG_STLDBG   = $(OUTPUT_DIR_STLDBG)\$(PRG_NAME_STLDBG_BASE)$(EXE)
PRG_A        = $(OUTPUT_DIR_A)\$(PRG_NAME_A_BASE)$(EXE)
PRG_A_DBG    = $(OUTPUT_DIR_A_DBG)\$(PRG_NAME_A_DBG_BASE)$(EXE)
PRG_A_STLDBG = $(OUTPUT_DIR_A_STLDBG)\$(PRG_NAME_A_STLDBG_BASE)$(EXE)

PDB_NAME_OUT            = $(OUTPUT_DIR)\$(PRG_NAME_BASE).pdb
PDB_NAME_OUT_DBG        = $(OUTPUT_DIR_DBG)\$(PRG_NAME_DBG_BASE).pdb
PDB_NAME_OUT_STLDBG     = $(OUTPUT_DIR_STLDBG)\$(PRG_NAME_STLDBG_BASE).pdb
MANIFEST_NAME_OUT            = $(PRG).manifest
MANIFEST_NAME_OUT_DBG        = $(PRG_DBG).manifest
MANIFEST_NAME_OUT_STLDBG     = $(PRG_STLDBG).manifest
A_PDB_NAME_OUT          = $(OUTPUT_DIR_A)\$(PRG_NAME_A_BASE).pdb
A_PDB_NAME_OUT_DBG      = $(OUTPUT_DIR_A_DBG)\$(PRG_NAME_A_DBG_BASE).pdb
A_PDB_NAME_OUT_STLDBG   = $(OUTPUT_DIR_A_STLDBG)\$(PRG_NAME_A_STLDBG_BASE).pdb
