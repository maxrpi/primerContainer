# 
# This Makefile was created by the configure script using
# the files config/MakeDefs.linux and primer/Makefile.in 
# 
# linux with dynamic libraries 

# these next values for compilers will be used unless overridden with an argument to configure
cc = gcc
CC = g++
FC = gfortran

# MPI include directory (set by configure script
MPI_INCLUDE = 

# On some 64-bit machines some libraries are in lib64 instead of lib
# this next line will be changed by the configure script
LIB64 = lib64

# Mesa lib directory: 
LIBMESA = lib64

# Here is the rpath command
OV_RPATH = -Wl,-rpath,
#xlc OV_RPATH = -R

MOTIF_LIB = $(MOTIF)/$(LIB64)
OPENGL_LIB = $(OpenGL)/$(LIBMESA)

XLIBS_LIB = $(XLIBS)/$(LIB64)

# *wdh* libXpm does not seem to be needed anymore 2014/04/02
# OV_X_LIBRARIES = -L$(XLIBS_LIB) -lXpm -lXt -lXmu -lXi -lXext -lX11
OV_X_LIBRARIES = -L$(XLIBS_LIB) -lXt -lXmu -lXi -lXext -lX11
#ubuntu OV_X_LIBRARIES = -L$(XLIBS_LIB) -lXt -lXi -lX11

OV_MOTIF_LIBRARIES = $(OV_RPATH)$(MOTIF_LIB) -L$(MOTIF_LIB) -lXm

LAPACK_LIBRARIES = $(OV_RPATH)$(LAPACK) -L$(LAPACK) -llapack -lblas

# these next lines will be changed by the configure script
USE_DOUBLE_OR_SINGLE = -DOV_USE_DOUBLE
#xlc USE_DOUBLE_OR_SINGLE = -WF,-DOV_USE_DOUBLE

A++ = $(APlusPlus)
A+++ = $(APlusPlus)
# AppLibraries = -L$(APlusPlus) -lA++ -lA++_static
AppLibraries = $(OV_RPATH)$(APlusPlus)/lib -L$(APlusPlus)/lib -lApp -lApp_static 

Include=  -I$(Overture)/include -I. 
Lib=      $(Overture)/lib
LibOverture= -lOverture -lOverture_static -lOgmg
# Make 2 dynamic libs for ibm: 
#xlc LibOverture= -lOverture1 -lOverture2 -lOverture_static
LibRapsodi= -lRapsodi -lRapsodi_static 
BOXLIB_DEFS = -DBL_USE_DOUBLE -DBL_Solaris

# Here is where we can find the perl include files and library (CORE)
# These will normally be changed by the configure script unless it can't find the location of the perl CORE 
OV_PERL_INCLUDE = /usr/lib/x86_64-linux-gnu/perl/5.34/CORE
OV_PERL_LIB = /usr/lib/x86_64-linux-gnu/perl/5.34/CORE
#kkc 060111 here is an attempt to automatically setup the perl stuff
PERLSYSS := $(shell perl -V:archname)
PERL_SYS := $(shell $(PERLSYSS) echo $${archname} )
PERLDIRS := $(shell perl -V:prefix)
PERL_DIR := $(shell $(PERLDIRS) echo $${prefix} )
PERLVERS := $(shell perl -V:version)
PERL_VER := $(shell $(PERLVERS) echo $${version} )
OV_PERL_INCLUDE = /usr/lib/x86_64-linux-gnu/perl/5.34/CORE
OV_PERL_LIB = /usr/lib/x86_64-linux-gnu/perl/5.34/CORE
# Here are the perl libraries we need to link to (NOTE: this next line is set by the configure script)
OV_PERL_LIBRARIES = $(OV_RPATH)$(OV_PERL_LIB) -L$(OV_PERL_LIB) -lperl -ldl -lm -lpthread -lc -lcrypt
# old OV_PERL_LIBRARIES = $(OV_RPATH)$(OV_PERL_LIB) -L$(OV_PERL_LIB) -lperl -lcrypt

# these next flags are compiler dependent
# *** WARNING *** these next lines are changed by the configure script
cc_FLAGS = -fPIC
CC_FLAGS = -fPIC
FF_FLAGS = -fPIC -fallow-argument-mismatch
# turn off warnings from intel f95 compiler
#ifc FF_FLAGS = -fPIC -fallow-argument-mismatch -w

# these next values may be changed by the configure script
C_OPTIMIZATION_FLAG = -g
CPP_OPTIMIZATION_FLAG = -g
FORTRAN_OPTIMIZATION_FLAG = -g

# Use this next flag to optimize files that Bill likes to by default compile optimized
STD_OPT_FLAG = -O 

CFLAGS =  $(cc_FLAGS)  $(Include)  $(C_OPTIMIZATION_FLAG) -I$(XLIBS) -DSHM
# flags for c routines we always optimize (except if debug is on)
CFLAGSO =  $(STD_OPT_FLAG) $(cc_FLAGS)  $(Include)  -I$(XLIBS) -DSHM

# do not include some paths, such as STL in the places searched by makedepend (takes too long)
# *wdh* temporarily add -Wno-deprecated -- fix these later
# ** CC_INCLUDES_FOR_DEPEND =  $(Include)  -DUSE_MESA -I$(APlusPlus)/include -I$(OpenGL)/include -I$(XLIBS)/include  $(BOXLIB_DEFS) -Wno-deprecated -I$(OV_PERL_INCLUDE)
CC_INCLUDES_FOR_DEPEND =  $(Include)  -DUSE_MESA -I$(APlusPlus)/include -I$(OpenGL)/include -I$(XLIBS)/include  $(BOXLIB_DEFS) -I$(OV_PERL_INCLUDE)

STL_INCLUDE = 
#  HAS_MODFL_PROTO is for a perl compile error of OvertureParser.C for gcc 3.4.3
# CC_INCLUDES = $(CC_FLAGS) $(CC_INCLUDES_FOR_DEPEND) $(STL_INCLUDE) -DHAS_MODFL_PROTO
# CC_FLAGS = -fPIC
# wdh 081212 -- remove HAS_MODFL_PROTO since it fails with xlc
CC_INCLUDES = $(CC_FLAGS) $(CC_INCLUDES_FOR_DEPEND) $(STL_INCLUDE) 
CC_FLAGS = -fPIC

CCFLAGS= $(CC_INCLUDES) $(CPP_OPTIMIZATION_FLAG)

# things that are always compiled with optimization use this flag (except if debug is on)
CCFLAGSO= $(CC_INCLUDES) $(STD_OPT_FLAG)

# things that are always compiled with lots of optimization use this flag (except if debug is on)
CCFLAGSF= $(CC_INCLUDES) $(STD_OPT_FLAG)

# things that need to be compiled with no optimization use the following
CCFLAGSG= $(CC_INCLUDES) -g

# ubuntu: gfortran 11.3.0 : to compile ncarfft
FF_FLAGS += -fallow-argument-mismatch

# Notes: There seems to be problems using -O with g77
#        Some older versions of the egcs compiler also had trouble with -fPIC, removing it seemed to work.
FFLAGS=    $(FF_FLAGS)   -fdefault-real-8 -fdefault-double-8 $(FORTRAN_OPTIMIZATION_FLAG) $(Include)
# single precision always:
FFLAGSS=  $(FF_FLAGS)  $(FORTRAN_OPTIMIZATION_FLAG)  $(Include)
FFLAGSSO = ${FF_FLAGS}  $(Include) $(STD_OPT_FLAG)
FFLAGSO = $(FF_FLAGS)  -fdefault-real-8 -fdefault-double-8 $(STD_OPT_FLAG) $(Include)
FFLAGSG = $(FF_FLAGS)  -fdefault-real-8 -fdefault-double-8 -g $(Include)
FFLAGSG2 = $(FF_FLAGS)  -fdefault-real-8 -fdefault-double-8 -g $(Include)
# The ifort compiler can take for-ever if we use -g so use -O instead
#ifort FFLAGSG = $(FF_FLAGS)  -fdefault-real-8 -fdefault-double-8 -O $(Include)

# things that are always compile with optimization use these flags (except if debug is on)
FFLAGSO= $(STD_OPT_FLAG) $(FF_FLAGS)  -fdefault-real-8 -fdefault-double-8  $(FLAGS) $(Include) 
FFLAGSSO= $(STD_OPT_FLAG)  $(FF_FLAGS)  $(FLAGS) $(Include)

# Here we add a path to the compiler lib directory (this is sometimes needed so that we find the correct
# version of the compiler libraries if they are different from the the ones in /usr/lib for e.g.)
#OV_COMPILER_LIBS = $(OV_RPATH)$(COMPILER_LIB_DIRECTORY) -L$(COMPILER_LIB_DIRECTORY)

# here are the hdf libraries (the configure script will change this line for use with hdf5)
HDF_LIBS = $(OV_RPATH)$(HDF)/lib -L$(HDF)/lib -lhdf5 -ljpeg -lz 
#xlc HDF_LIBS = $(OV_RPATH)$(HDF)/lib -L$(HDF)/lib -lhdf5 -lz 

FORTRAN_LIBS = 
FORTRAN_LIBS =-lnsl -lg2c
FORTRAN_LIBS =-lgfortran
# This next line will be used with the Portland group compiler (the configure script will set the next line)
# 080623: aio_read etc. are found in /usr/lib/librt.so
PGI_LIB = 
#pgf77 FORTRAN_LIBS = $(OV_RPATH)$(PGI_LIB) -L$(PGI_LIB) -lpgftnrtl -lpgmp  -lpgc -lrt -lstd
# This next line will be used with the intel fortran compiler. (the configure script will set the next line)
# g2c may be needed by lapack (for cg)
IFORT_LIB = 
#ifc FORTRAN_LIBS = $(OV_RPATH)$(IFORT_LIB) -L$(IFORT_LIB) -lF90 -lIEPCF90 -lg2c
# old ifc FORTRAN_LIBS = -Wl,-rpath,/opt/intel/compiler60/ia32/lib -L/opt/intel/compiler60/ia32/lib -lF90 -lIEPCF90 -L/usr/lib/gcc-lib/i386-redhat-linux/2.96 -lg2c
# Here are the libraries for the new intel compiler (called ifort instead of ifc) (use "ifort -dryrun" to see libraries needed)
#ifort FORTRAN_LIBS = $(OV_RPATH)$(IFORT_LIB) -L$(IFORT_LIB) -lifcoremt
# Libraries using xlf and linux
#xlf FORTRAN_LIBS = -L/opt/ibmcmp/xlf/bg/11.1/bglib -lxlopt -lxl -lxlf90 -lxlfmath -L/opt/ibmcmp/xlsmp/bg/1.7/bglib/ -lxlomp_ser
LIB_TARGETS= lib_date libso_date
LIB_DEPENDENCIES= ../lib/lib_date
TEMPLATES=  
RAPTEMPLATES=  

# The KCC compiler should be used to build the static library (for templates)
AR = ar
#KCC AR = KCC
ARFLAGS = ruv  
#KCC ARFLAGS = -o 

LD = $(CC)
LDFLAGS = -L
RANLIB = ranlib
SOFLAGS = -shared
#xlc SOFLAGS = -qmkshrobj -qnostaticlink
# the next line is changed by the configure script
OpenGLibs =-lGL -lGLU -lOSMesa 
# put App libs here since in parallel these may include mpi libs in /usr which conflicts with mesa
GLIBS=  $(OV_PERL_LIBRARIES) $(OV_RPATH)$(OPENGL_LIB) -L$(OPENGL_LIB) $(OpenGLibs) $(OV_MOTIF_LIBRARIES) $(OV_X_LIBRARIES) $(AppLibraries) $(LAPACK_LIBRARIES) -lm

# On Don's machine the pgi libraries need to follow the mpi libraries : 
# FLIBS= $(OV_RPATH)$(Overture)/lib $(LDFLAGS)$(Overture)/lib $(LibOverture) $(HDF_LIBS) $(FORTRAN_LIBS) $(AppLibraries) 
FLIBS= $(OV_RPATH)$(Overture)/lib $(LDFLAGS)$(Overture)/lib $(LibOverture) $(OV_COMPILER_LIBS) $(HDF_LIBS) $(FORTRAN_LIBS)

# Ubuntu: To get OpenGL lib's properly loaded need to have any /usr/lib/x86... after Mesa libs *wdh* Sept 18, 2019
#ubuntu GLIBS=  $(OV_PERL_LIBRARIES) $(OV_RPATH)$(OPENGL_LIB) -L$(OPENGL_LIB) $(OpenGLibs) $(OV_MOTIF_LIBRARIES) $(OV_X_LIBRARIES) $(AppLibraries) $(HDF_LIBS) $(FORTRAN_LIBS) $(OV_COMPILER_LIBS)  $(LAPACK_LIBRARIES) -lm
#ubuntu FLIBS= $(OV_RPATH)$(Overture)/lib $(LDFLAGS)$(Overture)/lib $(LibOverture) 



# Ubuntu 13 needs this: when loading the dynamic library
#ubuntu LIBLIBS = $(HDF_LIBS) $(FORTRAN_LIBS) $(AppLibraries)

OGMGLIB = $(OV_RPATH)$(Overture)/lib $(LDFLAGS)$(Overture)/lib -lOgmg
#
#
# Primer examples:
#    type `make programName' to make the example called `programName', see the
#       possible program names below
#    type `make' to make all examples
#


Source=mappedGridExample1.C mappedGridExample2.C mappedGridExample3.C mappedGridExample3CC.C mappedGridExample4.C \
           mappedGridExample5.C mappedGridExample6.C \
	   example1.C example2.C example3.C example4.C example5.C example6.C example7.C example8.C example9.C \
           move1.C amrExample1.C mgExample1.C mgExample2.C lins.C wave.C ChannelMapping.C getDt.C \
           amrh.C rk.C util.C callingFortran.C gridGenExample.C deform.C sendToHDF5.C gridShimIn.C gridShimOut.C

# Here are the things we can make
PROGRAMS = mappedGridExample1 mappedGridExample2 mappedGridExample3 mappedGridExample4 \
           mappedGridExample5 mappedGridExample6 \
	   example1 example2 example3 example4 example5 example6 example7 example8 example9  \
           move1 amrExample1 mgExample1 mgExample2 lins wave amrh callingFortran gridGenExample deform gridShimIn gridShimOut

all:  depend_date $(PROGRAMS)

.SUFFIXES:
.SUFFIXES: .C .C .o .f 

.C.o :;	$(CC) $(CCFLAGS) -c $*.C
.f.o:; $(FC) $(FFLAGS) -c $*.f
.C: $(LIB_DEPENDENCIES)
	 $(CC) $(CCFLAGS) -o $@ $< $(CLIBS) $(FLIBS)  $(GLIBS)

mappedGridExample4 = mappedGridExample4.o ChannelMapping.o
mappedGridExample4: $(mappedGridExample4) 
	$(CC) $(CCFLAGS) -o mappedGridExample4 $(mappedGridExample4) $(CLIBS) $(FLIBS) $(GLIBS) 

mappedGridExample6 = mappedGridExample6.o getDt.o
mappedGridExample6: $(mappedGridExample6) 
	$(CC) $(CCFLAGS) -o mappedGridExample6 $(mappedGridExample6) $(CLIBS) $(FLIBS) $(GLIBS) 

gridShimIn = gridShimIn.o inAndOut.o
gridShimIn: $(gridShimIn) 
	$(CC) $(CCFLAGS) -o gridShimIn $(gridShimIn) $(CLIBS) $(FLIBS) $(GLIBS) 

gridShimOut = gridShimOut.o sendToHDF5.o inAndOut.o
gridShimOut: $(gridShiOut) 
	$(CC) $(CCFLAGS) -o gridShimOut $(gridShimOut) $(CLIBS) $(FLIBS) $(GLIBS) 

# 2d wave equation
wave = wave.o getDt.o
wave: $(wave) 
	$(CC) $(CCFLAGS) -o wave $(wave) $(CLIBS) $(FLIBS) $(GLIBS) 

# 2d wave equation -- parallel version --
pwave = pwave.o getDt.o 
pwave: $(pwave) 
	$(CC) $(CCFLAGS) -o pwave $(pwave) $(CLIBS) $(FLIBS) $(GLIBS) 

testpogi = testpogi.o
testpogi: $(testpogi) 
	$(CC) $(CCFLAGS) -o testpogi $(testpogi) $(CLIBS) $(FLIBS) $(GLIBS)

# test the redistrubution to one processor
testDistribute = testDistribute.o 
testDistribute: $(testDistribute) 
	$(CC) $(CCFLAGS) -o testDistribute $(testDistribute) $(CLIBS) $(FLIBS) $(GLIBS)

# hyperbolic amr example
amrh= amrh.o getDt.o util.o rk.o
amrh: $(amrh) 
	$(CC) $(CCFLAGS) -o amrh $(amrh) $(CLIBS) $(FLIBS) $(GLIBS)

callingFortran = callingFortran.o mySolver.o
callingFortran: $(callingFortran) 
	$(CC) $(CCFLAGS) -o callingFortran $(callingFortran) $(CLIBS) $(FLIBS) $(GLIBS)

# simplified interface for compiling user programs
getFlags: $(Overture)/bin/makeGetFlags
	/bin/rm -f  getFlags
	$(Overture)/bin/makeGetFlags \
	   --cflags '$(CFLAGS)' --ccflags '$(CCFLAGS)'  \
	   --fflags '$(FFLAGS)' --clibs '$(CLIBS)'        \
	   --flibs '$(FLIBS)' --glibs '$(GLIBS)'          \
	   --libs  '$(CLIBS) $(FLIBS) $(GLIBS)' > getFlags
	chmod u+x getFlags

clean:  
	rm -f $(PROGRAMS) *.o 

depend_date: depend; perl $(Overture)/config/makeDepend -f depend -Y -- $(CC_INCLUDES_FOR_DEPEND) -- $(Source)
	touch $@
# include the dependencies here
include depend

.PRECIOUS: depend_date

