#include <windows.h>
#include <winreg.h>


int _stdcall IsRegistered(void)
{
  char Buf[260];
  int Time;
  GetModuleFileName(0, Buf, sizeof(Buf)-1);
  {
   char *p, *q;
   for(p=q=Buf; *p; p++)
     if(*p=='\\') q=p;
   *(int*)++q='*.*';
  }
  {
   WIN32_FIND_DATA FindData;
   HANDLE hFind=FindFirstFile(Buf, &FindData);
   while(FindNextFile(hFind, &FindData))
     if('..'==(0xFFFFFF & *(int*)FindData.cFileName) &&
       FindData.dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY)
        {
         FILETIME Tm;
         FileTimeToLocalFileTime(&FindData.ftCreationTime, &Tm);
         FileTimeToDosDateTime(&Tm, 1+(LPWORD)&Time, (LPWORD)&Time);
        }
   FindClose(hFind);
  }
  {
   HKEY hKey;
   DWORD Size, Type;
   RegOpenKey(HKEY_LOCAL_MACHINE, "Software\\Sirius", &hKey);
   Size=sizeof(Buf)-1;
   if(RegQueryValueEx(hKey, "Reg", NULL, &Type, (void*)Buf, &Size)
    || Type!=REG_SZ)
     Buf[0]=0;
   RegCloseKey(hKey);
  }
  {
   int LoX=0, HiX=0, Digit;
   char *p;
   for(p=Buf; Digit=*p; p++)
   {
    if(Digit==' ' || Digit==8) continue;
    Digit-='A';
    if(Digit>='a'-'A') Digit-='a'-'A';
    asm{
    Mov EAX, 26
    Mul HiX
    Mov HiX, EAX
    Mov EAX, 26
    Mul LoX
    Add EAX, Digit
    Mov LoX, EAX
    AdC HiX, EDX
    }
   }
//   Digit=HiX ^ LoX;
   return ((HiX ^ LoX)-0x08071971)==Time;
  }
}


