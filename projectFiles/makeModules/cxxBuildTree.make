# cxxBuildTree.make
# A make library implementing rules to compile c++ programs in a mirrored source
# tree, allowing usage of stub and dynamic source files while keeping the main
# source tree clean
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
MAKE_CXXBUILDTREE_VERSION := v1.0.0

# Variables to control loading message echoing
CXXBUILDTREE_SILENT_LOAD ?= $(QUB1750UL_MAKEMODULES_SILENT_LOAD)

# Module environment variables and sensible defaults
CXXBUILDTREE_CPPFLAGS        ?= $(ALL_CPPFLAGS)
CXXBUILDTREE_CXXFLAGS        ?= $(ALL_CXXFLAGS)
CXXBUILDTREE_SRCDIR          ?= $(SRCDIR)
CXXBUILDTREE_COMPDIR         ?= $(COMPDIR)
CXXBUILDTREE_RULE_DEPENDENCY ?= $(CXXBUILDTREE_COMPDIR)/%.cpp
CXXBUILDTREE_RULE_TARGET     ?= $(subst .cpp,.d,$(CXXBUILDTREE_RULE_DEPENDENCY))

define cxxbuildtree_required_env_vars :=
  CXXBUILDTREE_SRCDIR
  CXXBUILDTREE_COMPDIR
  CXXBUILDTREE_RULE_DEPENDENCY
  CXXBUILDTREE_RULE_TARGET
  CXX
endef

# Callable functions to stop make if required environment variables are unset
requiredEnvCheck_check_single = $(if $($(1)),,$(error Required variable '$(1)' is not set))
requiredEnvCheck_check = $(foreach var,$(1),$(call requiredEnvCheck_check_single,$(var)))

# Begin executable code section
# Display the loading message if not disabled
$(if $(CXXBUILDTREE_SILENT_LOAD),,$(info Loading cxxBuildTree module version $(MAKE_CXXBUILDTREE_VERSION)))

# Check for required environment to be set
$(call requiredEnvCheck_check,$(cxxbuildtree_required_env_vars))

# Object file generation recipe
$(CXXBUILDTREE_RULE_TARGET): srcdir   := $(CXXBUILDTREE_SRCDIR)
$(CXXBUILDTREE_RULE_TARGET): compdir  := $(CXXBUILDTREE_COMPDIR)
$(CXXBUILDTREE_RULE_TARGET): cppflags := $(CXXBUILDTREE_CPPFLAGS)
$(CXXBUILDTREE_RULE_TARGET): cxxflags := $(CXXBUILDTREE_CXXFLAGS)
$(CXXBUILDTREE_RULE_TARGET): output    = $(subst .cpp,.o,$^)
$(CXXBUILDTREE_RULE_TARGET): $(CXXBUILDTREE_RULE_DEPENDENCY)
	mkdir -p $(dir $@)
	echo "Generating make rule for $(output)"

# Generate recipe dependencies
	$(CXX) -o $@ $(subst $(compdir),$(srcdir),$<) \
		-MM -MT $(output) $(cppflags) $(cxxflags)

# Patch the generated recipe to request source files from $(COMPDIR)
	tr '[:space:]' '\n' < '$@' |                  \
	sed -e 's!\\$$!!' -e '/^$$/d' -e 's!$$! \\!'  \
	  -e 's!$(srcdir)/!$(compdir)/!' > '$@.new'

	mv '$@.new' '$@'

# Inject compilation instructions
	echo -e '\n\t$(CXX) -c -o $(output) $^ $(cppflags) $(cxxflags)' >> $@

# Recipe to build the mirrored source tree
$(CXXBUILDTREE_COMPDIR)/%: $(CXXBUILDTREE_SRCDIR)/%
	@ mkdir -p $(dir $@)
	@ ln -sf $(realpath $<) $@
