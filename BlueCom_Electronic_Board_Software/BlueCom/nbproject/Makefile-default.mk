#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/Sources/BlueCom.o ${OBJECTDIR}/Sources/Interrupts.o ${OBJECTDIR}/Sources/main.o ${OBJECTDIR}/Sources/UARTIntC.o ${OBJECTDIR}/Sources/tick.o ${OBJECTDIR}/Sources/BC_rtcc.o ${OBJECTDIR}/Sources/BC_pwm.o
POSSIBLE_DEPFILES=${OBJECTDIR}/Sources/BlueCom.o.d ${OBJECTDIR}/Sources/Interrupts.o.d ${OBJECTDIR}/Sources/main.o.d ${OBJECTDIR}/Sources/UARTIntC.o.d ${OBJECTDIR}/Sources/tick.o.d ${OBJECTDIR}/Sources/BC_rtcc.o.d ${OBJECTDIR}/Sources/BC_pwm.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/Sources/BlueCom.o ${OBJECTDIR}/Sources/Interrupts.o ${OBJECTDIR}/Sources/main.o ${OBJECTDIR}/Sources/UARTIntC.o ${OBJECTDIR}/Sources/tick.o ${OBJECTDIR}/Sources/BC_rtcc.o ${OBJECTDIR}/Sources/BC_pwm.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

# The following macros may be used in the pre and post step lines
Device=PIC18F44J11
ProjectDir="M:\projet_jc\Projets\BlueCom\BlueCom_Electronic_Board_Software\BlueCom"
ConfName=default
ImagePath="dist\default\${IMAGE_TYPE}\BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ImageDir="dist\default\${IMAGE_TYPE}"
ImageName="BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"

.build-conf:  .pre ${BUILD_SUBPROJECTS}
	${MAKE} ${MAKE_OPTIONS} -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: []"
	@
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=18F44J11
MP_PROCESSOR_OPTION_LD=18f44j11
MP_LINKER_DEBUG_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/Sources/BlueCom.o: Sources/BlueCom.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/BlueCom.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/BlueCom.o   Sources/BlueCom.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/BlueCom.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/BlueCom.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/Interrupts.o: Sources/Interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/Interrupts.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/Interrupts.o   Sources/Interrupts.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/Interrupts.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/Interrupts.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/main.o: Sources/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/main.o   Sources/main.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/main.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/main.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/UARTIntC.o: Sources/UARTIntC.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/UARTIntC.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/UARTIntC.o   Sources/UARTIntC.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/UARTIntC.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/UARTIntC.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/tick.o: Sources/tick.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/tick.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/tick.o   Sources/tick.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/tick.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/tick.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/BC_rtcc.o: Sources/BC_rtcc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/BC_rtcc.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/BC_rtcc.o   Sources/BC_rtcc.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/BC_rtcc.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/BC_rtcc.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/BC_pwm.o: Sources/BC_pwm.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/BC_pwm.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/BC_pwm.o   Sources/BC_pwm.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/BC_pwm.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/BC_pwm.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
else
${OBJECTDIR}/Sources/BlueCom.o: Sources/BlueCom.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/BlueCom.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/BlueCom.o   Sources/BlueCom.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/BlueCom.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/BlueCom.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/Interrupts.o: Sources/Interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/Interrupts.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/Interrupts.o   Sources/Interrupts.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/Interrupts.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/Interrupts.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/main.o: Sources/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/main.o   Sources/main.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/main.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/main.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/UARTIntC.o: Sources/UARTIntC.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/UARTIntC.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/UARTIntC.o   Sources/UARTIntC.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/UARTIntC.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/UARTIntC.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/tick.o: Sources/tick.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/tick.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/tick.o   Sources/tick.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/tick.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/tick.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/BC_rtcc.o: Sources/BC_rtcc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/BC_rtcc.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/BC_rtcc.o   Sources/BC_rtcc.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/BC_rtcc.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/BC_rtcc.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
${OBJECTDIR}/Sources/BC_pwm.o: Sources/BC_pwm.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/Sources 
	@${RM} ${OBJECTDIR}/Sources/BC_pwm.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE) -p$(MP_PROCESSOR_OPTION) -I".." -ms -oa- -Ou- -Ot- -Ob- -Op- -Or- -Od- -Opa-  -I ${MP_CC_DIR}\\..\\h  -fo ${OBJECTDIR}/Sources/BC_pwm.o   Sources/BC_pwm.c 
	@${DEP_GEN} -d ${OBJECTDIR}/Sources/BC_pwm.o 
	@${FIXDEPS} "${OBJECTDIR}/Sources/BC_pwm.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION_LD)  -w -x -u_DEBUG -m"$(BINDIR_)$(TARGETBASE).map" -w -l"/C:/MCC18/lib"  -z__MPLAB_BUILD=1  -u_CRUNTIME -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_PK3=1 $(MP_LINKER_DEBUG_OPTION) -l ${MP_CC_DIR}\\..\\lib  -o dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}   
else
dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION_LD)  -w  -m"$(BINDIR_)$(TARGETBASE).map" -w -l"/C:/MCC18/lib"  -z__MPLAB_BUILD=1  -u_CRUNTIME -l ${MP_CC_DIR}\\..\\lib  -o dist/${CND_CONF}/${IMAGE_TYPE}/BlueCom.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}   
endif

.pre:
	@echo "--------------------------------------"
	@echo "User defined pre-build step: []"
	@
	@echo "--------------------------------------"

# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
