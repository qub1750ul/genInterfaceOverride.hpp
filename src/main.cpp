/* genInterfaceOverride
 * A program to generate importable override signatures from a list of virtual
 * function prototypes
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

#include <fstream>
#include <string>
#include <string_view>
#include <vector>

#include "functions.hpp"

int main( const int argc, const char ** argv ) {

		if( const auto narg = 3 ; argc != narg + 1 ) {
				std::cerr << "Wrong number of arguments. Required " << narg
					<< ", provided " << argc << std::endl ;
				std::exit( EXIT_FAILURE ) ;
			}

		std::vector < std::string > prototypeList  ;

		const std::string_view importMacroName( argv[ 1 ] ) ;
		std::ifstream sourceFile( argv[ 2 ] ) ;
		std::ofstream macroFile( argv[ 3 ], std::ios_base::trunc ) ;

		checkFstreamValidity( sourceFile ) ;
		checkFstreamValidity( macroFile  ) ;

		// Extract virtual prototypes and convert them to override prototypes
		while( ! sourceFile.eof() ) {

				std::string prototype = extractPrototype( sourceFile ) ;

				if( prototype.empty() ) continue ;

				beautifyPrototype( prototype ) ;
				std::cerr << "Found virtual function:\t" << prototype << "\n" ;

				{
					const std::array < std::string, 4 > blankableWords =
						{ "virtual", "= 0", "= default", ";" } ;

					for( auto & word : blankableWords )
						blankWord( word, prototype ) ;
				}

				prototype += " override ;" ;

				beautifyPrototype( prototype ) ;
				std::cerr << "Generated override:\t" << prototype << "\n\n" ;
				prototypeList.push_back( prototype ) ;
			}

		// Build the signature import macro and save it to file
		{
			const std::string cppMacroEndlEscape( "\\\n" ) ;
			auto lastPrototypeIter = -- prototypeList.end() ;

			macroFile << "#define " << importMacroName << " " << cppMacroEndlEscape ;

			for(
					auto prototypeIter = prototypeList.begin() ;
					prototypeIter < lastPrototypeIter ;
					++ prototypeIter
				)
				macroFile << "\t" << * prototypeIter << " " << cppMacroEndlEscape ;
		}

		macroFile << "\t" << prototypeList.back() << "\n" ;
	}
