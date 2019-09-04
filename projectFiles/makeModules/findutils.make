# findutils.make
# A make library to ease common 'find' usage in makefiles
#
# Copyright (C) 2019 Giuseppe Masino ( qub1750ul ) <dev.giuseppemasino@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Current version of this module
MAKE_FINDUTILS_VERSION := v1.0.0

# Variables to control loading message echoing
FINDUTILS_SILENT_LOAD ?= $(QUB1750UL_MAKEMODULES_SILENT_LOAD)

# Module environment variables and sensible defaults
FINDUTILS_FIND     ?= $(FIND)
FINDUTILS_ROOTPATH ?= $(SRCDIR)
FINDUTILS_SUBMAKEFILE_NAMES ?= makefile Makefile GNUMakefile

define findutils_required_env_vars :=
  FINDUTILS_FIND
  FINDUTILS_ROOTPATH
  FINDUTILS_SUBMAKEFILE_NAMES
endef

# Callable functions to stop make if required environment variables are unset
requiredEnvCheck_check_single = $(if $($(1)),,$(error Required variable '$(1)' is not set))
requiredEnvCheck_check = $(foreach var,$(1),$(call requiredEnvCheck_check_single,$(var)))

# Display the loading message if not disabled
$(if $(FINDUTILS_SILENT_LOAD),,$(info Loading findutils module version $(MAKE_FINDUTILS_VERSION)))

# Check for required environment to be set
$(call requiredEnvCheck_check,$(findutils_required_env_vars))

##
# Invoke find
findutils_find = $(shell $(FINDUTILS_FIND) $(FINDUTILS_ROOTPATH) $(1))

##
# Find listed files
# @param $(1) A list of files
findutils_findFileList = $(call findutils_find,-false $(foreach name,$(1),-or -type f -name $(name) -print))

##
# Find parent directories of listed files
# @param $(1) A list of files
findutils_findFileListDirs = $(shell printf "%s\n" $(dir $(call findutils_findFileList,$(1))) | sed 's!/$$!\*!' )

##
# Find subtree roots that contain a makefile of the type listed in FINDUTILS_SUBMAKEFILE_NAMES
findutils_findSubMakeDirs = $(call findutils_findFileListDirs,$(FINDUTILS_SUBMAKEFILE_NAMES))

##
# Generate a list of POSIX 'find' commands to exclude some paths from the results
# @param $(1) A list of paths
findutils_genPruneCmds = -false $(foreach path,$(1),-or -path $(path) -prune)

##
# Generate a list of POSIX 'find' commands to exclude tree branches that contain
# makefiles having a name listed in FINDUTILS_SUBMAKEFILE_NAMES
findutils_submakeRootsPruneCmds = $(call findutils_genPruneCmds,$(call findutils_findSubMakeDirs))

##
# Generate a source list excluding source tree branches that contain a makefile
# @param $(1) At least a find expression containing the -print predicate (e.g. -false -print )
findutils_gensrclist = $(call findutils_find,$(findutils_submakeRootsPruneCmds) -or $(1))
