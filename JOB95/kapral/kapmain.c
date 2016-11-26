#include <stdio.h>
#include "for2c32.h"

#define EXPORT _export __stdcall

struct Position
{
  Integer4 X, Y, W, H;
  Integer2 ListNo, DetailNo, Rotated;
};

void EXPORT Kapral(void);
void EXPORT AddRectangle(int IsList, int Count, Integer4 X, Integer4 Y);
int EXPORT GetPosition(int No, struct Position* Pos);

void Feed(void)
{
  FILE* F=fopen("kap.in", "rt");
  while(!feof(F))
   {
    int L, Cnt, X, Y;
    Cnt=0;
    fscanf(F, "%d %d %d %d", &L, &Cnt, &X, &Y);
    if(Cnt)
      AddRectangle(L, Cnt, X, Y);
   }
  fclose(F);
}

void Put(void)
{
  int i=0;
  struct Position Pos;
  FILE*F=fopen("kap.out", "wt");
  while(GetPosition(i++, &Pos))
   {
    fprintf(F, "%d %d %d %d %d\n", Pos.X, Pos.Y, Pos.W, Pos.H,
      Pos.ListNo);
   }
}

void main(void)
{
  Feed();
  printf("Starting\n");
  Kapral();
  printf("Ending\n");
  Put();
}
