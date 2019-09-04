#!/usr/bin/env make
# Copyright (C) 2019 Giuseppe Masino ( qub1750ul ) <dev.giuseppemasino@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

PACKAGE     := genInterfaceOverride
MAKEMODULES := projectFiles/makeModules

QUB1750UL_MAKEMODULES_SILENT_LOAD := yes

.DEFAULT_GOAL = $(EXEPATH)
.SUFFIXES :=

include $(MAKEMODULES)/defaultEnv.make
include $(MAKEMODULES)/findutils.make

# Default flags

CPPFLAGS ?=
CXXFLAGS ?= -g
LDFLAGS  ?=

# Mandatory flags

cppflags := -I$(INCLUDEDIR)
cxxflags := -std=c++17
ldflags  :=

# Project settings

EXEPATH := $(DISTDIR)/$(PACKAGE).elf

src := $(call findutils_gensrclist,-type f -name *.cpp -print)
dep := $(subst $(SRCDIR),$(COMPDIR),$(src:.cpp=.d))
obj := $(dep:.d=.o)

ALL_CPPFLAGS := $(sort $(cppflags) $(CPPFLAGS) $(lib.cppflags))
ALL_CXXFLAGS := $(sort $(cxxflags) $(CXXFLAGS))
ALL_LDFLAGS  := $(sort $(ldflags) $(LDFLAGS) $(lib.ldflags))
ALL_OBJ      := $(sort $(obj) $(lib.obj))

include $(MAKEMODULES)/cxxBuildTree.make
include $(MAKEMODULES)/GNUTargets.make
include $(MAKEMODULES)/inspector.make

# Include object file rules
.SILENT: $(dep)
include $(dep)

# Build the application
$(EXEPATH): $(ALL_OBJ)
	mkdir -p $(dir $@)
	$(CXX) -o $@ $^ $(ALL_LDFLAGS)
