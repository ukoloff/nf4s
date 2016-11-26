// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"

#include "../dbs/Dbs.h"

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}

    dbs::Span s;
    s.bulge = 1;
    s.radius();

    return TRUE;
}

void Eksport()
{
    dbs::File Z;
    Z.read(".");
}