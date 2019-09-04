# inspector.make
# A make library implementing a variable inspector useful to debug makefiles
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

.SILENT: inspect
.PHONY: inspect
inspect:
	echo "Starting inspector mode"
	$(if $(INSPECT),$(foreach var,$(INSPECT),echo -e "$(var) = $($(var))" ;),echo "Need to set INSPECT first")
