/* genInterfaceOverride
 * A program to generate override signatures from a list of abstract function
 * prototypes
 *
 * Copyright (C) 2019 Giuseppe Masino ( qub1750ul ) <dev.giuseppemasino@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#pragma once

#include <iostream>
#include <string_view>
#include <algorithm>

/**
 * Extract a virtual function prototype from c++ source code
 * @method extractPrototype
 * @param  stream           A character input stream
 * @return The extracted string
 */
const std::string extractPrototype( std::istream & stream ) ;

/**
 * Extract a colon separed list of declaration signatures
 * E.g. Removing default assignments
 * @method extractDecListSign
 * @param  stream             A character input stream
 * @return The extracted string
 */
const std::string extractFuncArgDeclList( std::istream & stream ) ;

/**
 * Blank a word in a string
 * @method blankWord
 * @param  word      Target word
 * @param  str       String to edit
 */
void blankWord( const std::string_view & word, std::string & str ) ;

/**
 * Beautify a prototype
 * @method beautifyPrototype
 * @param  prototype         A function prototype
 */
void beautifyPrototype( std::string & prototype ) ;

/**
 * Check if the fstream object is in usable state
 * @method checkFstreamValidity
 * @param  f                    A file stream
 */
template < class Fstream >
void checkFstreamValidity( const Fstream & f )
	{
		if( f.is_open() ) return ;

		std::cerr << "ERROR: Cannot open file" << std::endl ;
		exit( EXIT_FAILURE ) ;
	}

/**
 * Get a view of a string with indentation characters stripped away
 * @method indentStripView
 * @param  c               A character container
 * @return A string_view
 */
template < class CharContainer >
std::string_view indentStripView( CharContainer c )
	{
		auto iterator = std::find_if
				(
					c.begin(), c.end(),
					[]( const char & c ) -> bool
						{ return c != ' ' && c != '\t' ; }
				) ;

		return std::addressof( * iterator ) ;
	}
