#include <stdio.h>

extern "C" int _stdcall IsRegistered(void);

void main(void)
{
  printf(IsRegistered()? "Ok" : "Fail");
}