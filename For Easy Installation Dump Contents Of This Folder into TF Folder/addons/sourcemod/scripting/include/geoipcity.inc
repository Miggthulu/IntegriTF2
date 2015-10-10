/**
 * vim: set ts=4 :
 * =============================================================================
 * SourceMod (C)2004-2008 AlliedModders LLC.  All rights reserved.
 * =============================================================================
 *
 * This file is part of the SourceMod/SourcePawn SDK.
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */

#if defined _geoipcity_included
  #endinput
#endif
#define _geoipcity_included

#include <core>

/**
 * @section IP addresses can contain ports, the ports will be stripped out.
 */

/**
 * Gets the GeoIP record from an IP address.
 *
 * @param ip				Ip to determine the country code.
 * @param city				Destination string buffer to store the city name. (45 characters max)
 * @param region			The region/province/state name. (45 characters max)
 * @param country_name		The country name. (45 characters max)
 * @param country_code		The two character country code. (US, CA, etc)
 * @param country_code3		The three character country code. (USA, CAN, etc)
 * @return					True on success, false if no record found.
 */
native bool:GeoipGetRecord(const String:ip[], String:city[45], String:region[45], String:country_name[45], String:country_code[3], String:country_code3[4]);

/**
 * @endsection
 */

/**
 * Do not edit below this line!
 */
public Extension:__ext_geoipcity = 
{
	name = "GeoIPCity",
	file = "geoipcity.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
#if defined REQUIRE_EXTENSIONS
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_EXTENSIONS
public __ext_geoipcity_SetNTVOptional()
{
	MarkNativeAsOptional("GeoipGetRecord");
}
#endif
