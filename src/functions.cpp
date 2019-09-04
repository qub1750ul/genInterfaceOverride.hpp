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

#include "functions.hpp"

const std::string extractPrototype( std::istream & stream ) {

		std::string prototype ;
		std::string wordbuf   ;

		while( ! stream.eof() ) {

			std::getline( stream, wordbuf, ' ' ) ;
			const std::string_view strippedWordbuf = indentStripView( wordbuf ) ;

			if( strippedWordbuf == "virtual" ) {

					( prototype += strippedWordbuf ) += " " ;

					{
						char c ;

						while( ! stream.eof() && ( ';' != ( c = stream.get() ) ) ) {

								prototype += c ;

								if( c == '(' )
									prototype += extractFuncArgDeclList( stream ) ;
							}
					}

					prototype += ";" ;

					return prototype ;

				} else {

					std::getline( stream, wordbuf ) ;
					continue ;
				}
		}

		return "" ;
	}

const std::string extractFuncArgDeclList( std::istream & stream ) {

		std::string declarationList ;
		char c = ' ' ;

		while( ! stream.eof() && c != ')' ) {

				c = stream.get() ;

				if( c == '\n' ) c = ' ' ;

				if( c == '=' )
					while( c != ',' && c != ')' )
						c = stream.get() ;

				declarationList += c ;
			}

		return declarationList ;
	}

void blankWord( const std::string_view & word, std::string & str ) {

		const auto wordOffset = str.find( word ) ;

		if( wordOffset == std::string::npos ) return ;

		auto beginIter = str.begin() + wordOffset ;
		auto endIter   = beginIter + word.size() ;

		str.erase( beginIter, endIter ) ;
	}

void beautifyPrototype( std::string & prototype ) {

		static auto isToRemove = []( const char & c ) -> bool {

				static const std::string charsToKeep =
					{ '~', '=' } ;

				const char & nextChar = * ( std::addressof( c ) + 1 ) ;
				const bool isToKeep = ( c != nextChar ) || isalnum( c ) ||
					[ & ](){
							for( auto & keepable : charsToKeep )
								if( keepable == c ) return true ;

							return false ;
						}() ;

				return ! isToKeep ;
			} ;

		prototype.erase(
				std::remove_if( prototype.begin(), prototype.end(), isToRemove ) ,
				prototype.end()
			);
	}
