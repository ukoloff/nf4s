#include <stdio.h>
#include <for2c.h>

/* *** Function definitions *** */
void Bubble(Integer2 JA,Integer4 R[1000],Integer2 IB[1000]);
void preob(char *aa,int b);
void proc(int a, char *name);
void YKLADN(Integer2 NY[1000],Integer4 *FY);
void YKLADL(Integer2 NY[1000],Integer4 *FY, char *name);
/*void YKLADL(Integer2 NY[1000],Integer4 *FY);*/
char *getcwd(char *buffer,int maxlen);
Real4 CYPER(Real8 *B);
int forSignI(Integer4 X);
void TESTO(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
Integer4 A,Integer4 B,Integer4 *O,Integer4 *S,Integer4 *P);
void TEST0(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
Integer4 A,Integer4 B,Integer4 *O,Integer4 *S,Integer4 *P);
void WIBER(Integer2 NS,Integer4 A[60],Integer4 B[60],Integer2 *N);
void DYPLO(Integer4 WS,Integer2 L,Integer4 B[60],Integer4 H[60],Integer4 X[60],Integer4 MI
[60],Integer4 MA[60]);
void GRANI(Integer4 YB[60],Integer4 YH[60],Integer4 X[60],Integer2 *L);
/* extern void pram();*/
void pram(int zz, char *name);

void zap_1(FILE *fo,int dlin);
void zap_1xy(FILE *fo,float x,float y);
void zap_8(FILE *fi);
otxody(long massivx[],long massivy[],int k1,char mPARTID[9],char *geoname);
void zap_26(FILE *fo,char *mPARTID);
void zap_27(FILE *fi,float areaa,float perima);
void CSpan(float x01,float y01,float x11,float y11,float t01,float *area);
void Perimet(float x01,float y01,float x11,float y11,float t01,float *prm);

/* *** Common definitions *** */
struct			// Исходные данные
 {
   Integer2 IJ;		// Количество листов
   Integer4 DL[20];	// Длины листов
   Integer4 WS[20];	// Высоты листов
   Integer2 JA;		// Количество деталей
   Integer4 D[1000];	// Длины деталей
   Integer4 W[1000];	// Высоты деталей
   Integer4 POV[1000];	// ???
   Integer4 NUM[1000];	// ??? Номер исходной детали ???
   Integer4 F[20];	//
 }
ComQQ;

struct			// Результат
 {
   Integer4 T[1000];	// Правые границы деталей
   Integer4 H[1000];	// Верхние границы деталей
   Integer4 LP[1000];	// Признак поворота
   Integer2 NY[1000];	// ???
   Integer4 FY;		// Общая длина листа
 }
RES;
    char filer[64];   /* Имя файла */
    float *xm,*ym;    /* Размеры прямоугольников */
    float *px,*py;    /* Левый нижний угол */
    int *priz;        /* Признак 0 - деталь 1 - образ */
    int *kkon;        /* Номер ориг. контура */
    int nn;           /* Размер массива */
   Integer4 T1[1000];
   Integer2 NLIST[1000];
   Integer2 NTIP[1000];
   /*Integer2 NPR[20][1000];*/
   Integer2 KL=0;
   Integer2 KK=0;
   Integer2 TL[20];
   Integer2 TD[100];
   Integer2 PROD[20][50];
   Integer4 N1;
   Integer4 N2;
   Integer4 dopusk;

struct finp
 {

   int pr;
   char put[64];
   char partid[8];
   int  col;
   int pr1;
   float dop;
   float x;
   float y;
 };
    struct finp  massstr[100];

   FILE  *UTMP[20];
   FILE  *in;

   char  *xx = {"XXXXX"};
   char  *ks = {"\0"};
   char  *prob = {" "};
   char *n0 = {"0"};
   char  *dt = {".dat"};
   char  *dbs = {".dbs"};
   char  *cbs = {".cbs"};
   char  *ks_ = {"_"};
   char  *ksV = {"V"};
   char  p2[8];
   int ii = 0;
   int  j;
   char string[120];
   char mass[64];
   char str[36];
   char namtmp[16];
   int c,uk;
   int ipr2;
   int IIK1, kstr, kgil;
   int NGIL[200];


 main(int argc, char *argv[], char **envp)
 {
   FILE    *UNI5, *IFILE, *IGIL, *fo, *PAR;

   Integer2 I, III, ISS,  J, JIA, JJ1,  JJ2, J1, J2, K;
   int i,zzz,c1;

   Integer4 IW[20];
   Integer4 ID[20];
   double sumpi[20];
   double coefi[20];
   double del;
   double pli=0;
   double pld=0;
   Integer4 KT[20];
   Integer4 NPAR;
   Integer4 KOL;
   Integer4 NK;
   Integer4 KM;
   Integer4 IR;
   Integer4 N;
   Integer4 FI;
   Integer4 JR;
   Integer2 NT;
   Integer4 UN1;
   Integer4 UN2;
   Integer4 KMM[5];
   Integer4 IRR[5];
   Integer4 PR0[100];
   Integer4 DD0[100];
   Integer4 WW0[100];
   Integer4 DD[100];
   Integer4 WW[100];
   Integer4 NN[100];
   Integer4 PP[100];
   Integer4 P[1000];
   Integer2 IN[1000];

   Integer4 TP;
   Integer4 HP;
   Integer4 LPP;
   Integer4 PRP;
   Integer4 AA;
   Integer4 BB;

   /* переменные файла .DAT */
  /*  int prizl;   */    /* Признак 0 - лист, >0-деталь(N приорит.) */
  /*  char pathdbs[64];*/ /* Путь к файлу DBS */
  /*  char part[8]; */    /* PARTID */
   /* int koli;  */       /* количество (листов)деталей данного типа */
   /* int prizp;  */      /* Признак 0 - прямоугольник, 1-нет(N приорит.) */
  /*  float dops; */      /* допуск */
   /* int xd[70];*/      /* габарит по X */
   /* int yd[70]; */     /* габарит по Y */

  /* переменные из Оли */
   /* декларац. из лин. раскр.*/
   Integer2 KRUL;
   Integer2 IS;
   Integer4 LX;
   Integer2 KPR[1000];

   /* конец декларац. из лин. раскр.*/

   Real8 B, S, SL, Z, S1;
   Real8 QUAL;
   Real4 X;
   Real4 XS;


   char name[12];
   char fname[12];

   IIK1=argc;
   ipr2=0;

   if (IIK1 !=2 && IIK1 !=3)
   {
    printf(" Неверное количество аргументов!\n");
    printf(" Исходные данные будут взяты из файла XXXXX.dat\n" );
   strcpy(name,xx);
   strcpy(fname,name);
   strcat(fname,dt);
   }
      else
    {
   strcpy(name,argv[1]);
   for(i=0;i<strlen(name);i++)
      if (name[i]=='.') name[i]='\0';
   strcpy(fname,name);
   strcat(fname,dt);
      if (IIK1 == 3 )
      {
      strcpy(p2,argv[2]);
      ipr2 = atoi(p2);
      }
    }

   if((in = fopen(fname, "r")) != NULL)
     while(fgets(string,120,in) != NULL)
    { // =============== Начало цикла считывания файла данных
        j = 0;
        i = 0;
        while (string[j] != *prob && string[j] != *ks)
        {
    /* printf("%sstring",string);*/
     mass[i++] = string[j++]; }
     mass[i] = *ks;
     massstr[ii].pr = atoi(mass);
        i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
       strcpy(massstr[ii].put,mass);

       i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
       strcpy(massstr[ii].partid,mass);
       i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
     massstr[ii].col = atoi(mass);
       i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
     massstr[ii].pr1 = atoi(mass);

       i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
     massstr[ii].dop = atof(mass);


       i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
     massstr[ii].x = atof(mass);

       i = 0;j++;
        while (string[j] != *prob && string[j] != *ks)

     mass[i++] = string[j++];

     mass[i] = *ks;
     massstr[ii].y = atof(mass);

// присвоения переменных для Капрала

           dopusk=massstr[0].dop;
           if(massstr[ii].pr==0 )
             {
           ID[KL]=   massstr[ii].x;
           IW[KL]=   massstr[ii].y;
           KT[KL]=   massstr[ii].col;
           /*TL[KL]= ii+1;*/
           pli=pli+ID[KL]*IW[KL]*KT[KL];
           KL++;

             }
           else
           if(ipr2==0 || (ipr2==2 && massstr[ii].pr1==2) ||
                        (ipr2==1 && massstr[ii].pr1==2))
             {
           PR0[KK]= massstr[ii].pr;
           DD0[KK]=   massstr[ii].x;
           WW0[KK]=   massstr[ii].y;
           DD[KK]=   massstr[ii].x + dopusk;
           WW[KK]=   massstr[ii].y + dopusk;
           NN[KK]=   massstr[ii].col;
           PP[KK]=   0;
           TD[KK]= ii+1;
           KK++;
             }

          ii++;

     } // ================== Конец считывания входных данных (?)

     else printf("я не смогла открыть файл %s\n",fname);

     if(ii>100)
     {
     printf(" кол-во строк  в файле *.dat=%d>100 \n",ii);
     return;
     }


     if(KL==0)
     {
     printf(" В задании %s отсутствуют листы для раскроя \n",fname);
     return;
     }
     if(KK==0)
     {
     printf(" В задании %s отсутствуют данные для раскроя \n",fname);
     return;
     }

// ============================ Начало собственно раскроя

    printf(" Идет расчет прямоугольного раскроя...Ждите...\n");
   /* printf("\n%d",KL);
    printf("\n%d",KK);*/
   fclose(in);

   IFILE=fopen("NEST1_D.OUT", "wt");
   kstr=ii;
   if(ipr2==2)
   {
   kgil=0;
   IGIL=fopen("GIL.TMP", "wt");
   for(ii=0;ii<kstr;ii++)
           if(massstr[ii].pr!=0 && massstr[ii].pr1!=2 )
      {
      NGIL[kgil]=ii;
      kgil++;

      fprintf(IGIL,"%d %s %s %d %d %.2f %d %d\n",massstr[ii].pr,
          massstr[ii].put,massstr[ii].partid,massstr[ii].pr1,
          massstr[ii].col, massstr[ii].dop,massstr[ii].x,massstr[ii].y);
      }
   fclose(IGIL);
   }
   Bubble( KK,  PR0,  IN);
                i=0;
    while (pld<=pli && i<KK )
      {
           pld=pld+DD[i]*WW[i]*NN[i];
           i++;
      }
      KK=i;
       ii=0;
       while (pld>pli)
         {
         pld=pld-DD[KK-1]*WW[KK-1];
         ii++;
         }
       if(ii>=1)NN[KK-1]=NN[KK-1]-ii;

   fprintf(IFILE, "  РAЗMEРЫ ЛИСТОВ\n"
		  " *************************************\n");

   for(J = 1 ; J <= KL; J++)
      fprintf(IFILE, " % 5ld %6ld%6ld\n",
         KT[J-1] ,ID[J-1], IW[J-1]);

   B = 21.;


   PAR=fopen("PARAM.PAR", "rt");
   fscanf(PAR, "%3ld%9ld", &NPAR, &KOL);
   fclose(PAR);


   ComQQ.IJ = 0;
		{
          for(I = 1 ; I <= KL ; I++)
       {
	 NK = KT[I-1];
	  {
	    for(J = 1 ; J <= NK ; J++)
	     {
	       ++ComQQ.IJ;
         TL[ComQQ.IJ-1] = I;
	       ComQQ.DL[ComQQ.IJ-1] = ID[I-1];
	       ComQQ.WS[ComQQ.IJ-1] = IW[I-1];
	     }
	  }
       }
   ComQQ.DL[ComQQ.IJ+1-1] = 5*ComQQ.DL[ComQQ.IJ-1];
   ComQQ.WS[ComQQ.IJ+1-1] = ComQQ.WS[ComQQ.IJ-1];
		}
   ComQQ.JA = 0;
   S = 0;
    {
      for(I = 1 ; I <= KK ; I++)
       {
	 NK = NN[I-1];
	  {
	    for(J = 1 ; J <= NK ; J++)
	     {
	       ++ComQQ.JA;
     if(ComQQ.JA>1000)
     {
     printf("  Задание некорректно. Количество деталей > 1000 \n");
     return;
     }

		   ComQQ.D[ComQQ.JA-1] = DD[I-1];
	       ComQQ.W[ComQQ.JA-1] = WW[I-1];
	       ComQQ.POV[ComQQ.JA-1] = PP[I-1];
	       P[ComQQ.JA-1] = DD[I-1]*WW[I-1];
	       S = S+P[ComQQ.JA-1];
	       ComQQ.NUM[ComQQ.JA-1] = I;
	     }
	  }
       }
    }
     if(ComQQ.JA==1)
     {
     printf("  Задание некорректно. Количество деталей =1 \n");
     return;
     }
   fprintf(IFILE, " ВСЕГО ЛИСТОВ           %3d \n",ComQQ.IJ);
   fprintf(IFILE, "\n  РAЗMEРЫ ПРЯMOУГOЛЬНИKOВ\n"
		  " *************************************\n");

   for(J = 1 ; J <= KK ; J++)
       fprintf(IFILE," %3d.   %6ld%6ld %3d%3d\n",
         J , DD0[J-1], WW0[J-1], NN[J-1], PP[J-1]);
   fprintf(IFILE, " ВСЕГО ДЕТАЛЕЙ       %3d \n",ComQQ.JA);

   KM = 500*NPAR/ComQQ.JA ;

   IR = 2*ComQQ.JA;
   KMM[1-1] = KM;
   IRR[1-1] = /*INT*/( 3*ComQQ.JA/4.+1);
   KMM[2-1] = KM;
   IRR[2-1] = /*INT*/( ComQQ.JA/4.+1);
   KMM[3-1] = KM/2;
   IRR[3-1] = 5;
   KMM[4-1] = KM/2;
   IRR[4-1] = 3;
   KMM[5-1] = KM;
   IRR[5-1] = ComQQ.JA;


   /*fprintf(IFILE, "  РAЗMEРЫ ЛИСТОВ\n"
		  " *************************************\n");

   for(J = 1 ; J <= ComQQ.IJ; J++)
       fprintf(IFILE, " %3d.   %6ld%6ld\n",
	       J , ComQQ.DL[J-1], ComQQ.WS[J-1]);

   fprintf(IFILE, "  РAЗMEРЫ ПРЯMOУГOЛЬНИKOВ\n"
		  " *************************************\n");

   for(J = 1 ; J <= ComQQ.JA ; J++)
       fprintf(IFILE, " %3d.   %6ld%6ld\n",
         J , ComQQ.D[J-1], ComQQ.W[J-1]);*/


   fprintf(IFILE, " *************************************\n\n"
		  "  Сложность алгоритма =%3d\n", NPAR);
   fprintf(IFILE, " *************************************\n\n"
		  "  Кол-во итераций =%9d\n", KOL);

   N = 1;
	 N1 = 1;
		      for(J = 1 ; J <= ComQQ.JA ; J++)
	            RES.NY[J-1] = J;
	 ComQQ.F[1-1] = ComQQ.DL[1-1];
   for(I = 1 ; I <= ComQQ.IJ ; I++)
      ComQQ.F[I+1-1] = ComQQ.F[I-1]+ComQQ.DL[I+1-1];
   for(K = 1 ; K <= ComQQ.JA ; K++)
      RES.NY[K-1] = K;
   YKLADN(  RES.NY, &RES.FY);
   Bubble( ComQQ.JA,  ComQQ.D,  IN);
   YKLADN(  IN, &FI);
	 N1++;
   if(FI>=RES.FY)
      goto _78;
   RES.FY = FI;
   for(I = 1 ; I <= ComQQ.JA ; I++)
      RES.NY[I-1] = IN[I-1];
_78:;
   Bubble( ComQQ.JA,  ComQQ.W,  IN);
   YKLADN(  IN, &FI);
   if(FI>=RES.FY)
      goto _80;
   RES.FY = FI;
   for(I = 1 ; I <= ComQQ.JA ; I++)
      RES.NY[I-1] = IN[I-1];
_80:;
   Bubble( ComQQ.JA,  P,  IN);
   YKLADN(  IN, &FI);
   if(FI>=RES.FY)
      goto _82;
   RES.FY = FI;
   for(I = 1 ; I <= ComQQ.JA ; I++)
      RES.NY[I-1] = IN[I-1];
_82:;
   ISS = 0;
_6: X = CYPER( &B);
   JR = /*INT*/ ( IR*X+1);
   if(JR==IR+1)
      JR--;
   for(K = 1 ; K <= ComQQ.JA ; K++)
      IN[K-1] = RES.NY[K-1];
    {
      for(I = 1 ; I <= JR ; I++)
       {
	 XS = CYPER( &B);
	 J1 = /*INT*/( XS*ComQQ.JA+1);
	 if(J1==ComQQ.JA+1)
	    J1--;
_3:      XS = CYPER( &B);
	 J2 = /*INT*/( XS*ComQQ.JA+1);
	 if(J2==ComQQ.JA+1)
	    J2--;
	 if(J1 != J2 && ( ComQQ.D[IN[J1-1]] != ComQQ.D[IN[J2-1]] ||
	                  ComQQ.W[IN[J1-1]] != ComQQ.W[IN[J2-1]] ))
	    goto _4;
	 else
	    goto _3;
_4:      JJ1 = IN[J1-1];
	 JJ2 = IN[J2-1];
	 IN[J1-1] = JJ2;
	 IN[J2-1] = JJ1;
       }
    }
   N++;
   YKLADN(  IN, &FI);
	 N1++;
   if(FI>=RES.FY)
      goto _33;
   RES.FY = FI;
   for(I = 1 ; I <= ComQQ.JA ; I++)
      RES.NY[I-1] = IN[I-1];
_33:if(N<KM)
      goto _6;
		if(N1<KOL && N2==-1)
			goto _6;
   YKLADN(  RES.NY, &RES.FY);
	 N1++;
   SL = 0;
   for(I = 1 ; I <= ComQQ.IJ+1 ; I++)
    {
      if(RES.FY<=ComQQ.F[I-1])
	 goto _122;
      SL += ComQQ.DL[I-1]*ComQQ.WS[I-1];
    }
_122:
   ;
   /* YKLADL(  RES.NY, &RES.FY); */
    YKLADN(  RES.NY, &RES.FY);

   SL += (RES.FY-ComQQ.F[I-1]+ComQQ.DL[I-1])*ComQQ.WS[I-1];
   KRUL = I;
   Z = SL;
   QUAL = S/Z;
   fprintf(IFILE, "   ПAРAMETРЫ AЛГOРИTMA =%6ld%6ld\n",KM, IR);
   fprintf(IFILE, "   KOЭФФИЦИEНT ПРЯMOУГOЛЬНOГO РAСKРOЯ = %5.3f\n", QUAL);

   Z = SL;

/************************************************************************ */
 /*  QUAL = S1/SL; */
   if(ISS>=5)
      goto _66;
   ISS++;
   KM = KMM[ISS-1];
   IR = IRR[ISS-1];
   N = 1;
	 if(N1>KOL)
	     goto _77;
   goto _6;
_66:;
	 N2=-1;
	 IR=3*KK;
	 if(N1<KOL)
	 goto _6;
_77:;

    YKLADL(  RES.NY, &RES.FY, name);

   fprintf(IFILE,"   ПOРЯДOK УKЛAДKИ ");
   for(J = 1 ; J <= ComQQ.JA ; J++)
      fprintf(IFILE,"%4d", RES.NY[J-1]);
   fprintf(IFILE,"\n ДЛИНA ПOЛOСЫ = %ld", RES.FY);
   NT = 0;
   K = 0;
      for(I = 0 ; I < 1000; I++)
      KPR[I]=0;
      for(I = 0 ; I < ComQQ.IJ; I++)
            sumpi[I]=0;
   for(I = 1 ; I <= KK ; I++)
    {
      NK = NN[I-1];
      NT = NT+1;
      for(III = 1 ; III <= NK ; III++)
       {
	 K++;
         for(IS = 1 ; IS <= ComQQ.IJ+1 ; IS++)
          {
          if(RES.T[K-1]<=ComQQ.F[IS-1])
	        goto _123;
          }
      _123:
					;
            LX = RES.T[K-1]-ComQQ.F[IS-1]+ComQQ.DL[IS-1];
            T1[K-1] = LX;
            NLIST[K-1]=IS;
            NTIP[K-1]=NT;
         /*  fprintf(IFILE,"\n %3d. %3d",
                  (int)K,  (int)NTIP[K-1]);*/
              sumpi[IS-1]=sumpi[IS-1]+DD0[NT-1]*WW0[NT-1];

            KPR[IS-1]++;
            /*NPR[IS-1][KPR[IS-1]-1]=NT ;*/
          /* fprintf(IFILE,"%3d. %7ld %7ld %7ld %3ld  %3d%3d%7ld\n",
              (int)K, (long)RES.T[K-1], (long)T1[K-1], RES.H[K-1],
              RES.LP[K-1], (int)NT, (int)IS, (long)LX );*/

       }
    }
  /* fprintf(IFILE," *************************************\n");*/

 /* блок из линейн. раскр*/

   fprintf(IFILE,"\n******************************************\n");
           if(KRUL>ComQQ.IJ)KRUL=ComQQ.IJ;

        for(I = 1 ; I <= KRUL ; I++)
          {
           fprintf(IFILE,"\n %3d. размещено %d деталей \n",
                  (int)I, (int)KPR[I-1]);
           /* sumpi[I-1]=0;*/
           for(III = 1; III <= KPR[I-1]; III++)
              {
         /*   fprintf(IFILE," %3d ",
              NPR[I-1][III-1]);*/
            /*  J2=NPR[I-1][III-1];
              sumpi[I-1]=sumpi[I-1]+DD0[J2-1]*WW0[J2-1];*/
              }
          del=ComQQ.DL[I-1]*ComQQ.WS[I-1];
          coefi[I-1]= sumpi[I-1]/del;
          if(I==KRUL && RES.FY < ComQQ.F[I-1])
        del=(RES.FY-ComQQ.F[I-1]+ComQQ.DL[I-1])*ComQQ.WS[I-1];
          coefi[I-1]= sumpi[I-1]/del;
          /*((RES.FY-ComQQ.F[I-1]+ComQQ.DL[I-1])*ComQQ.WS[I-1]);*/
    fprintf(IFILE, "   KOЭФФИЦИEНT РАСКРОЯ %3d ЛИСТА = %6.3f\n",
            I, coefi[I-1] );
           for(III = 1; III <= KK ; III++)
             PROD[I-1][III-1]=0;
          }

   fprintf(IFILE,"\n******************************************\n");


 /* конец блока из линейн. раскр*/

   fclose(IFILE);

 /* открытие временных файлов для PRAM*/
   UN1=0;
   UN2=0;


   for(J = 1 ; J <= KRUL ; J++)
  {
       strcpy(mass,"tmp.");
       itoa(J,str,10);
        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }
      strcat(mass,str);
       strcpy(namtmp,mass);
   if((UTMP[J-1] = fopen(mass, "w" )) != NULL)
        {
  c = TL[J-1]-1;

  AA = ComQQ.DL[J-1];
  BB = ComQQ.WS[J-1];
  TP = 0;
  HP = 0;
  PRP=0;
  UN2=J+1000;

   fprintf(UTMP[J-1],"%3d\n",KPR[J-1]+1);

   fprintf(UTMP[J-1],"%s %ld %ld %ld %ld %ld %ld %ld \n",
   massstr[c].partid, AA, BB, TP, HP, UN1, UN2, PRP);
   fclose(UTMP[J-1]);

      /*printf(" все ok ");*/

        }
     else
        {
     printf("я не смогла открыть файл %s\n",mass);
     return;
        }

  }
   for(JIA = 1 ; JIA <= ComQQ.JA ; JIA++)
   if(RES.T[JIA-1]-ComQQ.F[KRUL-1]<=0)
	 {
  c1 = TD[ComQQ.NUM[JIA-1]-1]-1;
  uk = NLIST[JIA-1]-1;
       strcpy(mass,"tmp.");
       itoa(uk+1,str,10);
        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }
      strcat(mass,str);
       strcpy(namtmp,mass);
  UTMP[uk] = fopen(mass, "a" );
  PRP=0;
  LPP =  RES.LP[JIA-1];
  AA = ComQQ.D[JIA-1]+LPP*( ComQQ.W[JIA-1]-ComQQ.D[JIA-1])-dopusk;
  BB = ComQQ.W[JIA-1]+LPP*( ComQQ.D[JIA-1]-ComQQ.W[JIA-1])-dopusk;
  TP = T1[JIA-1]-AA-dopusk/2;
  HP = RES.H[JIA-1]-BB-dopusk/2;
  UN1 = 0 ;
  UN2 = NTIP[JIA-1];
  /*UN2 = RES.NY[JIA-1];*/
   if (PROD[uk][UN2-1] ==0)
     {
      PROD[uk][UN2-1] = 1;
      if(LPP>0)PROD[uk][UN2-1] = 501;
   fprintf(UTMP[uk],"%s %ld %ld %ld %ld %ld %ld %ld \n",
    massstr[c1].partid, AA, BB, TP, HP, UN1, UN2, PRP);
      }
      else
      {
      PROD[uk][UN2-1]++;
      if(PROD[uk][UN2-1] > 500)
              {
                if(LPP==0)PRP=1;
              }
      else
                  PRP=LPP;
    UN1=1;

   fprintf(UTMP[uk],"%s %ld %ld %ld %ld %ld %ld %ld \n",
    massstr[c1].partid, AA, BB, TP, HP, UN1, UN2, PRP);

   UN1=0;
      }
      fclose(UTMP[uk]);
	 }
   UNI5 = fopen("in1.tt", "wt");

   fprintf(UNI5,"%3d\n", ComQQ.JA+ComQQ.IJ);
   PRP=0;

   for(JIA = 1 ; JIA <= ComQQ.IJ ; JIA++)
	 {
  c = TL[JIA-1]-1;
	AA = ComQQ.DL[JIA-1];
	BB = ComQQ.WS[JIA-1];
  TP = ComQQ.F[JIA-1]-ComQQ.DL[JIA-1];
  HP = 0;
  UN2=JIA+1000;
   fprintf(UNI5,"%s %ld %ld %ld %ld %ld %ld %ld\n",
   massstr[c].partid , AA, BB, TP, HP, UN1, UN2, PRP);
	 }

   for(JIA = 1 ; JIA <= ComQQ.JA ; JIA++)
	 {
  c = TD[ComQQ.NUM[JIA-1]-1]-1;
  LPP =  RES.LP[JIA-1];
  AA = ComQQ.D[JIA-1]+LPP*( ComQQ.W[JIA-1]-ComQQ.D[JIA-1])-dopusk;
  BB = ComQQ.W[JIA-1]+LPP*( ComQQ.D[JIA-1]-ComQQ.W[JIA-1])-dopusk;
  TP = RES.T[JIA-1]-AA-dopusk/2;
  HP = RES.H[JIA-1]-BB-dopusk/2;
  /* AA = ComQQ.D[JIA-1]+LPP*(ComQQ.W[JIA-1]-ComQQ.D[JIA-1]);
  BB = ComQQ.W[JIA-1]+LPP*(ComQQ.D[JIA-1]-ComQQ.W[JIA-1]);
  TP = RES.T[JIA-1]-AA;
  HP = RES.H[JIA-1]-BB; */
  UN2 = RES.NY[JIA-1];
  /* UN2 = NTIP[JIA-1]; */
   fprintf(UNI5,"%s %ld %ld %ld %ld %ld %ld %ld \n",
    massstr[c].partid, AA, BB, TP, HP, UN1, UN2, PRP);
	 }
   fclose(UNI5);
 /* подготовка общего dbs - файла */

   strcpy(filer,"in1.tt");
   zzz=0;
  /* printf("\n%s",filer);*/
   pram(zzz,name);

 /* подготовка DBS- ФАЙЛОВ   */

   for(I = 1 ; I <= KRUL ; I++)
   {
       strcpy(str," ");
       strcpy(mass,"tmp.");
       itoa(I,str,10);
        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }
      strcat(mass,str);
       strcpy(namtmp,mass);
   strcpy(filer,namtmp);
   pram(I,name);
   proc(I,name);
   unlink(namtmp);
   }
 /* КОНЕЦ подготовки DBS-файлов */
    unlink("gil.tmp");
    unlink("in1.tt");
    printf(" Расчет раскроя завершен. Раскроено %2d листов \n",KRUL);
 }

void Bubble(Integer2 JA,Integer4 R[1000],Integer2 IB[1000])
 {
   Integer2 J4, J5, KA;
   Integer4 A1, A2;

   Integer4 RS[1000];

   for(J4 = 0 ; J4 < JA ; J4++)
    {
      IB[J4] = J4+1;
      RS[J4] = R[J4];
    }
   for(J4 = 1 ; J4 <= JA ; J4++)
      for(J5 = 1 ; J5 < JA; J5++)
	 if( (A1=RS[J5-1]) < (A2=RS[J5]) )
	  {
	    RS[J5-1] = A2;
	    RS[J5] = A1;
	    KA = IB[J5-1];
	    IB[J5-1] = IB[J5];
	    IB[J5] = KA;
	  }
}

void YKLADN(Integer2 NY[1000],Integer4 *FY)
 {
   Integer2 I, J, M, N, K, L, LN, NR;

   Integer4 Q;
   Integer4 A;
   Integer4 B;
   Integer4 N1;
   Integer4 O;
   Integer4 S;
   Integer4 IP;
   Integer4 WP;
   Integer4 X[60];
   Integer4 YB[60];
   Integer4 YH[60];
   Integer4 U[60];
   Integer4 V[60];
   Integer2 LI[1000];
   Integer1 ppov;

   Integer4 MP=0; 	/* ???	*/

   L = 1;
   N = 1;

   for(I = 1 ; I <= ComQQ.JA ; I++)
      LI[I-1] = I;
   K = ComQQ.JA;
   M = 0;
_2: ;
   X[1-1] = 0;
   YH[1-1] = 0;
   YB[1-1] = ComQQ.WS[N-1];
   U[1-1] = 0;
   V[1-1] = ComQQ.WS[N-1];
   Q = ComQQ.DL[N-1];
    {
      for(J = 1 ; J <= K ; J++)
       {
	 MP = 0;
	 LN = LI[J-1];
	 NR = NY[LN-1];
	 RES.LP[NR-1] = 0;
	 ppov = ComQQ.POV[NR-1];
	 if(ppov==1)
	 {
	 A = ComQQ.D[NR-1];
	 B = ComQQ.W[NR-1];
	 N1 = N;
	 TEST0( L,  U,  V,  X, Q, &N, A, B, &O, &S, &IP);
	 MP=1;
	 }
	 else
	 {
	 if(ComQQ.W[NR-1]< ComQQ.D[NR-1])
	 MP = 1;
	 A = ComQQ.W[NR-1]+MP*(ComQQ.D[NR-1]-ComQQ.W[NR-1]);
	 B = ComQQ.D[NR-1]+MP*(ComQQ.W[NR-1]-ComQQ.D[NR-1]);
	 N1 = N;
	 TESTO( L,  U,  V,  X, Q, &N, A, B, &O, &S, &IP);
	 }
	 if(N!=N1)
	    goto _8;
	 X[L+1-1] = O;
	 YB[L+1-1] = S;
	 YH[L+1-1] = S-IP*B-(1-IP)*A;
	 RES.T[NR-1] = ComQQ.F[N-1]-ComQQ.DL[N-1]+O;
	 RES.H[NR-1] = S;
	 if(MP+IP==1)
	    RES.LP[NR-1] = 1;
	 GRANI(  YB,  YH,  X, &L);
	 WP = ComQQ.WS[N-1];
	 DYPLO( WP, L,  YB,  YH,  X,  U,  V);
	 goto _9;
_8:      M++;
	 LI[M-1] = LN;
	 N--;
_9:       ;
       }
    }
   if(M==0)
      goto _3;

   K = M;
   M = 0;
   L = 1;
   N++;
   goto _2;
_3:  *FY = 0;
    {
      for(K = 1 ; K <= L ; K++)
	 if(X[K-1]> *FY)
	     *FY = X[K-1];
    }
   *FY +=  ComQQ.F[N-1]-ComQQ.DL[N-1];
 }




void YKLADL(Integer2 NY[1000],Integer4 *FY, char *name)
 {
   FILE  *UNI6;

   Integer2 I, J, M, M1, N, K, L, LN, NR;
   Integer2 nu, kol;
   Integer4 Q;
   Integer4 A;
   Integer4 B;
   Integer4 N1;
   Integer4 O;
   Integer4 S;
   Integer4 IP;
   Integer4 WP;
   Integer4 X[60];
   Integer4 YB[60];
   Integer4 YH[60];
   Integer4 U[60];
   Integer4 V[60];
   Integer2 IN[60];
   Integer2 LI[1000];
   Integer2 SPND[1000];
   Integer1 ppov;
   Integer2 DELT=5;
   Integer2 ZER=0;

   /* переменные файла .DAG */
   int prizl;        /* Признак 0 - лист, >0-деталь(N приорит.) */
   char pathdbs[64];  /* Путь к файлу DBS */
   char part[12];     /* PARTID */
   int koli;         /* количество (листов)деталей данного типа */
   int prizp;        /* Признак 0 - прямоугольник, 1-нет(N приорит.) */
   float dops;       /* допуск */
   int xd[60];       /* габарит по X */
   int yd[60];       /* габарит по Y */

   Integer4 MP=0; 	/* ???	*/

 char gname[16];
 char  *dag = {".dag"};
 char  *slag = {"\\"};
 FILE  *ing;

 float x,y;
 char geoname[64];
 char mPARTID[9];
 int k1,MAXX,MAXY;
 long massivx[60];
 long massivy[60];
 k1=9;
//  massivx - массив координат по Х
//  massivy - массив координат по У
//  k1      - размерность массива
//  mPARTID - партид внутри файла геометрии
//  geoname - имя файла геометрии


       getcwd(pathdbs,64);
       strcat(pathdbs,slag);


   UNI6 = fopen("OSTAT.TXT", "wt");
       if(ipr2==2)
       {
       strcpy(gname,name);
       strcat(gname,dag);
       ing=fopen(gname,"wt");
       }


   L = 1;
   N = 1;

   for(I = 1 ; I <= ComQQ.JA ; I++)
      LI[I-1] = I;
   K = ComQQ.JA;
   M = 0;
   M1 = 0;
_2: ;
   X[1-1] = 0;
   YH[1-1] = 0;
   YB[1-1] = ComQQ.WS[N-1];
   U[1-1] = 0;
   V[1-1] = ComQQ.WS[N-1];
   Q = ComQQ.DL[N-1];
    {
      for(J = 1 ; J <= K ; J++)
       {
	 MP = 0;
	 LN = LI[J-1];
	 NR = NY[LN-1];
	 RES.LP[NR-1] = 0;
	 ppov = ComQQ.POV[NR-1];
	 if(ppov==1)
	 {
	 A = ComQQ.D[NR-1];
	 B = ComQQ.W[NR-1];
	 N1 = N;
	 TEST0( L,  U,  V,  X, Q, &N, A, B, &O, &S, &IP);
	 MP=1;
	 }
	 else
	 {
	 if(ComQQ.W[NR-1]< ComQQ.D[NR-1])
	 MP = 1;
	 A = ComQQ.W[NR-1]+MP*(ComQQ.D[NR-1]-ComQQ.W[NR-1]);
	 B = ComQQ.D[NR-1]+MP*(ComQQ.W[NR-1]-ComQQ.D[NR-1]);
	 N1 = N;
	 TESTO( L,  U,  V,  X, Q, &N, A, B, &O, &S, &IP);
	 }
	 if(N!=N1)
	    goto _8;
	 X[L+1-1] = O;
	 YB[L+1-1] = S;
	 YH[L+1-1] = S-IP*B-(1-IP)*A;
	 RES.T[NR-1] = ComQQ.F[N-1]-ComQQ.DL[N-1]+O;
	 RES.H[NR-1] = S;
	 if(MP+IP==1)
	    RES.LP[NR-1] = 1;
	 GRANI(  YB,  YH,  X, &L);
	 WP = ComQQ.WS[N-1];
	 DYPLO( WP, L,  YB,  YH,  X,  U,  V);
	 goto _9;
_8:      M++;
	 LI[M-1] = LN;
   if( N >= ComQQ.IJ+1)
					 {
   M1++;
   SPND[M1-1]=ComQQ.NUM[NY[NR-1]-1];
	 NR=LN;
	 fprintf(UNI6,"номер= %3d  N дет= %3d  ТИП = %3d\n",
	        NR, NY[NR-1], ComQQ.NUM[NY[NR-1]-1]);


					 }
	 N--;
_9:       ;
       }
    }
   if(M==0)
     goto _3;


   for(K = 1 ; K <= L ; K++)
    {
      X[K-1]=X[K-1]+DELT;
      YB[K-1]=YB[K-1]+DELT;
      YH[K-1]=YH[K-1]-DELT;
      if( X[K-1]>ComQQ.DL[N-1]) X[K-1]=ComQQ.DL[N-1];
      if(YB[K-1]>ComQQ.WS[N-1]) YB[K-1]=ComQQ.WS[N-1];
      if(YH[K-1]<ZER) YH[K-1]=ZER;
    }

   L--;
	 GRANI(  YB,  YH,  X, &L);

   for(K = 1 ; K <= L ; K++)
   V[K-1]=YB[K-1];

   Bubble( L, YB, IN);

   for(K = 1 ; K <= L ; K++)
   YB[K-1]=V[K-1];

   massivx[0]=0;
   massivy[0]=0;
   massivx[1]=0;
   massivy[1]=ComQQ.WS[N-1];

   k1=2*L+2;
   J=1;
   for(K = 1 ; K <= L ; K++)
	 {
    Q=0;
    if(K<L)Q= YB[IN[K]-1]  ;

   massivx[k1-J]=ComQQ.DL[N-1]-X[IN[K-1]-1];
   massivy[k1-J]=ComQQ.WS[N-1]-YB[IN[K-1]-1];
   J++;
   massivx[k1-J]=ComQQ.DL[N-1]-X[IN[K-1]-1];
   massivy[k1-J]=ComQQ.WS[N-1]-Q;
   J++;

   }
   massivx[k1]=massivx[0];
   massivy[k1]=massivy[0];

      for(K = 1 ; K <= 2 ; K++)


   if(massivx[k1-1]==massivx[0] &&  massivy[k1-1]==massivy[0])
     {
      k1=k1-2;
      massivy[0]=massivy[k1];
      massivy[k1+1]=massivy[k1];

     }



     if (k1>4)
  {
    if(massivx[1]==massivx[2] &&  massivy[1]==massivy[2])
     {
      k1=k1-2;

      massivy[1]=massivy[3];
      for(K = 2 ; K <= k1 ; K++)
                {
        massivx[K]=massivx[K+2];
        massivy[K]=massivy[K+2];
                }
      }
/****************************************************/


       strcpy(mass,name);
       strcat(mass,ksV);
       itoa(N,str,10);

        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }

      strcat(mass,str);
       strcpy(part,mass);
      strcat(mass,dbs);
   /* printf("\n%s",mass);*/

/*    mPARTID[9]="OSTAT     ";*/
       strcpy(geoname,mass);
       strcpy(mPARTID,name);


         k1++;
  /* fprintf(UNI6,"               %3d\n",k1);
   for(K = 1 ; K <= k1 ; K++)
   fprintf(UNI6,"  +       %ld %ld %ld\n",
   (long)massivx[K-1], (long)massivy[K-1],(long)massivy[1]);*/
    MAXX=ComQQ.DL[N-1]-X[0];
    MAXY=massivy[1];
          otxody(massivx,massivy,k1,mPARTID,geoname);
              if(ipr2==2)
              {
                N1= 0;
                N2= 1;
                fprintf(ing,"%d %s %s %d %d %.2f %d %d\n",
                                      0,
                                      pathdbs,
                                      part,
                                      1,1,
                0.00, MAXX,MAXY);
              }

 }
/****************************************************/


   K = M;
   M = 0;
   L = 1;
   N++;
   goto _2;
_3:  *FY = 0;


   if( N < ComQQ.IJ+1)

         {

   for(K = 1 ; K <= L ; K++)
    {
      X[K-1]=X[K-1]+DELT;
      YB[K-1]=YB[K-1]+DELT;
      YH[K-1]=YH[K-1]-DELT;
      if( X[K-1]>ComQQ.DL[N-1]) X[K-1]=ComQQ.DL[N-1];
      if(YB[K-1]>ComQQ.WS[N-1]) YB[K-1]=ComQQ.WS[N-1];
      if(YH[K-1]<ZER) YH[K-1]=ZER;
    }

   L--;
	 GRANI(  YB,  YH,  X, &L);

   for(K = 1 ; K <= L ; K++)
   V[K-1]=YB[K-1];

   Bubble( L, YB, IN);

   for(K = 1 ; K <= L ; K++)
   YB[K-1]=V[K-1];

   massivx[0]=0;
   massivy[0]=0;
   massivx[1]=0;
   massivy[1]=ComQQ.WS[N-1];

   k1=2*L+2;
   J=1;

   for(K = 1 ; K <= L ; K++)
	 {

    Q=0;
    if(K<L)Q= YB[IN[K]-1]  ;

   massivx[k1-J]=ComQQ.DL[N-1]-X[IN[K-1]-1];
   massivy[k1-J]=ComQQ.WS[N-1]-YB[IN[K-1]-1];
   J++;
   massivx[k1-J]=ComQQ.DL[N-1]-X[IN[K-1]-1];
   massivy[k1-J]=ComQQ.WS[N-1]-Q;
   J++;

   }
   massivx[k1]=massivx[0];
   massivy[k1]=massivy[0];

      for(K = 1 ; K <= 2 ; K++)


   if(massivx[k1-1]==massivx[0] &&  massivy[k1-1]==massivy[0])
     {
      k1=k1-2;
      massivy[0]=massivy[k1];
      massivy[k1+1]=massivy[k1];

     }
     if (k1>4)
 {
    if(massivx[1]==massivx[2] &&  massivy[1]==massivy[2])
     {
      k1=k1-2;
      massivy[1]=massivy[3];
      for(K = 2 ; K <= k1 ; K++)
              {
      massivx[K]=massivx[K+2];
      massivy[K]=massivy[K+2];
              }
     }
/****************************************************/

     /*  strcpy(mass,ksV);*/
       strcpy(mass,name);
       strcat(mass,ksV);
       itoa(N,str,10);
        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }

      strcat(mass,str);
       strcpy(part,mass);
      strcat(mass,dbs);
    /* printf("\n%s",mass);*/

    /* mPARTID[9]="OSTAT     ";*/
       strcpy(geoname,mass);
       strcpy(mPARTID,name);

/****************************************************/
         k1++;

  /* fprintf(UNI6,"               %3d\n",k1);
   for(K = 1 ; K <= k1 ; K++)
   fprintf(UNI6,"         %ld %ld\n",
   (long)massivx[K-1], (long)massivy[K-1]);*/

    MAXX=ComQQ.DL[N-1]-X[0];
    MAXY=massivy[1];
         otxody(massivx,massivy,k1,mPARTID,geoname);
              if(ipr2==2)
               {
                N1= 0;
                N2= 1;
                fprintf(ing,"%d %s %s %d %d %.2f %d %d\n",
                                      0,
                                      pathdbs,
                                      part,
                                      1,1,
                (float)0,MAXX,MAXY);
               }

 }
           }
    {
      for(K = 1 ; K <= L ; K++)
	 if(X[K-1]> *FY)
	     *FY = X[K-1];
    }
   *FY +=  ComQQ.F[N-1]-ComQQ.DL[N-1];
   *FY = *FY-DELT;
     if(ipr2==2)

    if(N<=ComQQ.IJ)
    {
                nu= TL[N-1]-1;
                K=N;
                kol=massstr[nu].col;
                while(TL[K-1]==TL[N-1] && K>=1)
                {
                kol=kol-1;
                K=K-1;
                }
                if( kol>0)
                {
                N1= massstr[nu].x;
                N2= massstr[nu].y ;

                fprintf(ing,"%d %s %s %d %d %.2f %ld %ld\n",
                                      massstr[nu].pr,
                                      massstr[nu].put,
                                      massstr[nu].partid,
                                      kol,
                                      massstr[nu].pr1,
                                      massstr[nu].dop,
                                      N1,
                                      N2);
                }
                if( KL>nu+1)
      for(K = nu+1 ; K <= KL-1 ; K++)
      {
                kol=massstr[K].col;
                N1= massstr[K].x;
                N2= massstr[K].y ;
                fprintf(ing,"%d %s %s %d %d %.2f %ld %ld\n",
                                      massstr[K].pr,
                                      massstr[K].put,
                                      massstr[K].partid,
                                      kol,
                                      massstr[K].pr1,
                                      massstr[K].dop,
                                      N1,
                                      N2);
      }
    }
     if(ipr2==2)
      if(kgil>0)
      for(K = 0 ; K <= kgil-1 ; K++)
      {
      ii=NGIL[K];
                N1= massstr[ii].x;
                N2= massstr[ii].y ;
      fprintf(ing,"%d %s %s %d %d %.2f %ld %ld\n",massstr[ii].pr,
          massstr[ii].put,massstr[ii].partid,massstr[ii].col,
          massstr[ii].pr1, massstr[ii].dop,N1,N2);
      }
   if(ipr2==2) fclose(ing);
	 fclose(UNI6);
 }


/***************прямоугольник*******************/
int otxody(long massivx[],long massivy[],int k1,char mPARTID[9],char *geoname)
{
/**********************************/
int i1,idat,ilen,ilen1,i2,dlin;
float area,prm;
FILE *fo;
int shapi[20];
float shapr[6];
int i;
/* static char fail[64];*/
if ((fo=fopen(geoname,"wb"))==NULL)
 return -1;
// запись типа геометрия  -тип записи 1
dlin=k1*3+15;
zap_1(fo,dlin);
prm=0.0;
area=0.0;
for(i=1;i<=k1;i++)
 {
   zap_1xy(fo,massivx[i-1],massivy[i-1]);
   if (i>1)
    {
      Perimet(massivx[i-2],massivy[i-2],massivx[i-1],massivy[i-1],0.0,&prm);
      CSpan(massivx[i-2],massivy[i-2],massivx[i-1],massivy[i-1],0.0,&area);
    }
 }
// запись типа 8  -связка контуров в одну деталь
zap_8(fo);
// запись типа 26 -название детали
zap_26(fo,mPARTID);
zap_27(fo,area,prm);
shapi[0]=-1;
shapi[1]=-1;
fwrite((char *)&shapi,2,2,fo);
fclose(fo);
return 0;
}


Real4 CYPER(Real8 *B)
 {
   static Real8 A=67108.8671875;

   *B *= 312.5;
   *B -=  (long)(*B/A) * A;
   return *B/A;
 }

void TESTO(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
Integer4 A,Integer4 B,Integer4 *O,Integer4 *S,Integer4 *P)
 {
   Integer2 I,IS;
   Integer4 AX,AX1;
   Integer4 H[60];
			IS = 0 ;

   for(I = 1 ; I <= L ; I++)
      H[I-1] = V[I-1]-U[I-1];
   for(I = 1 ; I <= L ; I++)
    {
      if(B>H[I-1])
	 continue;
			 if(IS==0)
			   {
			   IS=I;
         AX1= X[I-1]+ A;
			   }

			 if(A <= H[I-1])
				 {
         AX = X[I-1]+ B;
			   if ( AX<AX1 && AX<=DL )
			      {
            *O = AX;
            *S = U[I-1]+ A;
            *P = 0;
            return ;
						}
         if(AX1> DL)
	          continue;
            *O = AX1;
            *S = U[IS-1]+ B;
            *P = 1;
            return ;
			    }
				 continue;
    }

         if(AX1<= DL && IS!=0)
            {
            *O = AX1;
            *S = U[IS-1]+ B;
            *P = 1;
            return ;
            }
   if( ++(*N) <= ComQQ.IJ+1)
     return;
   printf("MECTOB HET.ДETAЛЬ HE BЛAЗИT");
   exit(1);
 }
void TEST0(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
Integer4 A,Integer4 B,Integer4 *O,Integer4 *S,Integer4 *P)
 {
   Integer2 I;
   Integer4 AX;
   Integer4 H[60];

   for(I = 1 ; I <= L ; I++)
      H[I-1] = V[I-1]-U[I-1];
   for(I = 1 ; I <= L ; I++)
    {
      if(B>H[I-1])
	 continue;
      AX = X[I-1]+ A;
      if(AX> DL)
	 continue;
      *O = AX;
      *S = U[I-1]+ B;
      *P = 1;
      return ;
    }
   if( ++(*N) <= ComQQ.IJ+1)
     return;
   printf("MECTOB HET.ДETAЛЬ HE BЛAЗИT");
   exit(1);
 }

void WIBER(Integer2 NS,Integer4 A[60],Integer4 B[60],Integer2 *N)
 {
   Integer2 I, J, K;

   *N =  NS;
   I = 0;
_1: I++;
   if(I == *N)
      goto _5;
   if(A[I-1]<A[*N-1] || B[I-1]>B[*N-1])
      goto _1;
   K =  *N-1;
   for(J = I ; J <= K ; J++)
    {
      A[J-1] = A[J+1-1];
      B[J-1] = B[J+1-1];
    }
   --I;
   --(*N) ;
   goto _1;
_5:;
 }

void DYPLO(Integer4 WS,Integer2 L,Integer4 B[60],Integer4 H[60],
	   Integer4 X[60], Integer4 MI[60], Integer4 MA[60])
 {
   Integer2 I, K;
   Integer4 MIH;
   Integer4 MAK;

   if( L==1)
      goto _5;
    {
      for(K = 1 ; K < L ; K++)
       {
         MIH = 0;
         MAK = WS;
          {
            for(I = K+1 ; I <= L ; I++)
             {
               if(X[I-1]==X[K-1])
                  continue;
               if(B[I-1]>=B[K-1])
                  goto _3;
               if(B[I-1]>MIH)
                  MIH = B[I-1];
               continue;
_3:            if(H[I-1]<MAK)
                  MAK = H[I-1];
             }
          }
         MI[K-1] = MIH;
	 MA[K-1] = MAK;
       }
    }
_5: MI[ L-1] = 0;
   MA[ L-1] =  WS;
 }

void GRANI(Integer4 YB[60],Integer4 YH[60],Integer4 X[60],Integer2 *L)
 {
   Integer2 I, IS, J, J2, IM, JQ, K, K1, KA, KB, M, MI, N;
   Integer2 KP, LP, LG, N1, N2;

   Integer4 E;
   Integer4 EH;
   Integer4 EB;
   Integer4 IL;
   Integer4 JL;
   Integer4 HI;

   Integer4 A[60];
   Integer4 B[60];
   Integer2 LI[60];
   Integer4 W[60];
   Integer4 H[60];
   for(I = 1 ; I <= *L ; I++)
    {
      if(X[I-1]>X[ *L+1-1])
	 goto _2;
    }
   goto _23;
_2: E = X[I-1];
   EH = YH[I-1];
   EB = YB[I-1];
   X[I-1] = X[ *L+1-1];
   YB[I-1] = YB[ *L+1-1];
   YH[I-1] = YH[ *L+1-1];
   if(I== *L)
      goto _26;
    {
      for(K = 1 ; K < *L ; K++)
       {
	 J =  *L+I-K;
	 X[J+1-1] = X[J-1];
	 YB[J+1-1] = YB[J-1];
	 YH[J+1-1] = YH[J-1];
       }
    }
_26:X[I+1-1] = E;
   YB[I+1-1] = EB;
   YH[I+1-1] = EH;
_23:I = 0;
   N = 1;
   A[1-1] = YH[ *L+1-1];
   B[1-1] = YB[ *L+1-1];
    {
      for(IM = 1 ; IM <= *L; IM++)
       {
	 M =  *L-IM+1;
	 IL = 0;
	 JL = 0;
	 KA = 0;
	 KB = 0;
	  {
	    for(K = 1 ; K <= N ; K++)
	     {
	       if(YH[M-1]>=A[K-1] && YH[M-1]<=B[K-1])
		  goto _7;
	     }
	  }
	 goto _10;
_7:      KA = K;
	 IL = 1;
_10:      ;
	  {
	    for(K = 1 ; K <= N ; K++)
	     {
	       if(YB[M-1]>=A[K-1] && YB[M-1]<=B[K-1])
		  goto _8;
	     }
	  }
	 goto _11;
_8:      KB = K;
	 JL = 2;
_11:     if(KA==0 && KB==0)
	    goto _22;
	 if(KA==KB)
	    goto _9;
	 switch(forSignI(IL+JL-2))
	  {
	    case -1:goto _4;
	    case  0:goto _5;
	    default:goto _6;
	  }
_4:      A[N+1-1] = A[KA-1];
	 B[N+1-1] = YB[M-1];
	 goto _16;
_5:      A[N+1-1] = YH[M-1];
	 B[N+1-1] = B[KB-1];
	 goto _16;
_6:      A[N+1-1] = A[KA-1];
	 B[N+1-1] = B[KB-1];
	 goto _16;
_22:     A[N+1-1] = YH[M-1];
         B[N+1-1] = YB[M-1];
_16:     WIBER( N+1,  A,  B, &N);
	 goto _14;
_9:      LI[I++] = M;
_14:     ;
       }
    }
   switch(forSignI(I-1))
    {
      case -1:goto _15;
      case  0:goto _82;
      default:goto _81;
    }
_81:IS=I-1;
    {
      for(J = 1 ; J <=IS ; J++)
       {
	 if(LI[IS-J+2-1]+1==LI[IS-J+1-1])
	    goto _17;
	 K = LI[IS-J+2-1];
	 N = LI[IS-J+1-1]-2;
	  {
	    for(MI = K ; MI <= N ; MI++)
	     {
	       YB[MI-J+1-1] = YB[MI+1-1];
	       YH[MI-J+1-1] = YH[MI+1-1];
	       X[MI-J+1-1] = X[MI+1-1];
	     }
	  }
_17:      ;
       }
    }
_82:K = LI[1-1];
   N =  *L;
    {
      for(J = K ; J <= N ; J++)
       {
	 YB[J-I+1-1] = YB[J+1-1];
	 YH[J-I+1-1] = YH[J+1-1];
	 X[J-I+1-1] = X[J+1-1];
       }
    }
    *L =  *L-I;
_15: *L =  *L+1;
   if( *L==1)
      goto _68;
   I = 0;
_91:I = I+1;
   if(I== *L)
      goto _68;
   if(X[I+1-1]!=X[I-1])
      goto _91;
   K = I;
   N = 1;
_92:I++;
   if(X[I+1-1]!=X[K-1] || I== *L)
      goto _93;
   N = N+1;
   goto _92;
_93:;
   HI = YH[K-1];
   JQ = K;
    {
      for(J = 1 ; J <= N ; J++)
       {
	 if(YH[K+J-1]>=HI)
	    continue;
	 HI = YH[K+J-1];
	 JQ = K+J;
       }
    }
   W[1-1] = YB[JQ-1];
   H[1-1] = YH[JQ-1];
   KP = 1;
   N1=N+1;
    {
      for(I = 1 ; I <= N+1 ; I++)
       {
	  {
	    for(LP = 1 ; LP <= KP ; LP++)
	     {
	       if(YB[K+I-1-1]-W[KP-LP+1-1]>0)
		  goto _44;
	     }
	  }
	 goto _51;
_44:     if(LP==1)
	    goto _55;
	 K1 = KP-LP+2;
	  {
	    for(J = K1 ; J <= KP ; J++)
	     {
	       W[KP-J+K1+1-1] = W[KP-J+K1-1];
	       H[KP-J+K1+1-1] = H[KP-J+K1-1];
	     }
	  }
_55:     KP++;
	 W[KP-LP+1-1] = YB[K+I-1-1];
	 H[KP-LP+1-1] = YH[K+I-1-1];
_51:      ;
       }
    }
   M = 0;
_61:
   if( ++M == N+1)
      goto _62;
   if(W[M-1]!=H[M+1-1])
      goto _61;
   N--;
   --(*L);
   W[M-1] = W[M+1-1];
   if(M==N+1)
      goto _62;
    {
      for(J = M+1 ; J <= N+1 ; J++)
       {
	 W[J-1] = W[J+1-1];
	 H[J-1] = H[J+1-1];
       }
    }
   goto _61;
_62:;
   N2=N+1;
    {
      for(J = 1 ; J <= N2 ; J++)
       {
	 YH[K+J-1-1] = H[J-1];
	 YB[K+J-1-1] = W[J-1];
       }
    }
   LG = N1-N2;
   if(K+N== *L)
      goto _68;
   if(LG==0)
      goto _66;
   J2 = K+N+1;
    {
      for(J = J2 ; J <= *L ; J++)
       {
	 X[J-1] = X[J+LG-1];
	 YH[J-1] = YH[J+LG-1];
	 YB[J-1] = YB[J+LG-1];
       }
    }
_66:I = K+N;
   goto _91;
_68:return ;
 }


/****************************************************************/
void zap_1(FILE *fo,int dlin)
 {
short shapi[20];
float shapr[6];
shapi[0]=dlin;
shapi[1]=1;
shapi[2]=dlin;
shapi[3]=0;
shapi[4]=1;
shapi[5]=0;
shapi[6]=1;
shapi[7]=0;
shapi[8]=1;
shapi[9]=0;
shapi[10]=0;
shapi[11]=0;
shapi[12]=0;
shapi[13]=0;
shapi[14]=-2001;
shapi[15]=0;
shapi[16]=1;
shapi[17]=0;
shapi[18]=0;
shapi[19]=0;
shapr[0]=1.0;
shapr[1]=0.0;
shapr[2]=0.0;
shapr[3]=1.0;
shapr[4]=0.0;
shapr[5]=0.0;
fwrite((char *)&shapi,2,20,fo);
fwrite((char *)&shapr,4,6,fo);
return;
 }
/*****************************************/
void zap_1xy(FILE *fo,float x,float y)
{
  float z;
  float shapr[3];
  z=0.0;
  shapr[0]=x;
  shapr[1]=y;
  shapr[2]=z;
  fwrite((char *)&shapr,4,3,fo);
  return;
}
/*****************************************/
void zap_8(FILE *fo)
 {
// запись типа 8  -связка контуров в одну деталь
 short shapi[10];
 shapi[0]=4;
 shapi[1]=2001;
 shapi[2]=4;
 shapi[3]=0;
 shapi[4]=8;
 shapi[5]=0;
 shapi[6]=2001;
 shapi[7]=0;
 shapi[8]=1;
 shapi[9]=0;
 fwrite((char *)&shapi,2,10,fo);
 return;
 }
/*****************************************/
void zap_26(FILE *fo,char *mPARTID)
 {
 int k2,i1;
// запись типа 26 -название детали
 char mPART[9],nPART[9];
 short shapi[8];
 shapi[0]=5;
 shapi[1]=2001;
 shapi[2]=5;
 shapi[3]=0;
 shapi[4]=26;
 shapi[5]=0;
 shapi[6]=2001;
 shapi[7]=0;
 fwrite((char *)&shapi,2,8,fo);
 k2=strlen(mPARTID);
 strcpy(mPART,mPARTID);
 if (k2<8)
  for (i1=k2+1;i1<=8;i1++)  mPART[i1-1]=32;
 nPART[0]=mPART[1];
 nPART[1]=mPART[0];
 nPART[2]=mPART[3];
 nPART[3]=mPART[2];
 nPART[4]=mPART[5];
 nPART[5]=mPART[4];
 nPART[6]=mPART[7];
 nPART[7]=mPART[6];
 fwrite((char *)&nPART,1,8,fo);
 return;
 }
/*******************************************/
void zap_27(FILE *fo,float areaa,float perima)
{
 int i;
 short shapi[8];
 float shapr[2];
// запись типа 27 -площадь и периметр детали
 shapi[0]=5;
 shapi[1]=2001;
 shapi[2]=5;
 shapi[3]=0;
 shapi[4]=27;
 shapi[5]=0;
 shapi[6]=2001;
 shapi[7]=0;
 fwrite((char *)&shapi,2,8,fo);
 shapr[0]=areaa;
 shapr[1]=perima;
 fwrite((char *)&shapr,4,2,fo);
 return;
}
/******************************************************/
void Perimet(float x01,float y01,float x11,float y11,float t01,float *prm)
{
float dx,dy,cnst,xc,yc;
float x0,y0,x1,y1;
float alfa,rad,t0;
x0=x01*0.01;
y0=y01*0.01;
x1=x11*0.01;
y1=y11*0.01;
t0=t01;
dx=x1-x0;
dy=y1-y0;
  /* вычисляем длину хоpды */
*prm=dx*dx+dy*dy;
if (fabs(t0)>=0.001)
 {
  /*  считаем  длину дуги  */
  cnst=(t0-1.0/t0)*0.25;
  xc=(x0+x1)*0.5+dy*cnst;
  yc=(y0+y1)*0.5-dx*cnst;
 	dx=x0-xc;dy=y0-yc;
 	rad=dx*dx+dy*dy;
  alfa=4.0*atan(t0);
  *prm=sqrt(rad)*fabs(alfa);
 }
else
	 *prm=sqrt(*prm);
 return;
}
/*************************************************/
void CSpan(float x01,float y01,float x11,float y11,float t01,float *area)
 {
 float PI;
 float  at,dx,dy,chd,r,theta,c,temp,a1,a2,a3;
 float x0;
 float y0;
 float x1;
 float y1;
 float t0;
 PI=3.1415926;
	x0=x01*0.01;
 y0=y01*0.01;
	x1=x11*0.01;
	y1=y11*0.01;
	t0=t01;
	at=fabs(t0);
	dx=x1-x0;
	dy=y1-y0;
 *area=*area+(dx*(y0+y1)*0.5);
	chd=sqrt(dy*dy+dx*dx);
	if ((at<0.001) || (chd<0.001))
  return;
	/*      pасчет   pадиуса      */
	r=fabs(t0+1/t0)*chd*0.25;
	theta=4.0*atan(at);
	c=PI*2.0-theta;
	/*    площадь   тpеугольника  */
	temp=r*r*0.5;
	a1=temp*sin(c);
	/* площадь кpугового сегмента */
	a2=temp*theta;
	a3=a2+a1;
	/* если знак тангенса кpивизны отpицательный - площадь сегмента */
	if (t0>0.0)
 	a3=-a3;
 *area=*area+a3;
 return;
 }






void pram(int zz,  char *name)
{

    FILE  *fu,*fo;
    char list[20];
    char detl[20];
    static char *ident[20]={" ","  ","   ","    ","     ","      ","       ",
                        "        ","         ","          ","           ",
                        "            ","             ","              ",
                        "               ","                ",
                        "                 ","                  ",
                        "                   ","                    "};
    char file1[64];
    int k1,k2,words,i,k7,iin,pl,pr;
    float x1,y1,z1;
    float csx,snx,csxx,snxx;
    float smx,smy;
    float mxl,myl;
        if ((fo=fopen(filer,"r"))==NULL)
   {
    printf("Ошибка открытия файла прямоугольников.\n");
    return;
   }

    for (iin=0;filer[iin]!='.';iin++);

    if( iin > 20 )goto kon1;
    strncpy(ident[iin-1],filer,iin);
    pl=0;
      fscanf(fo,"%d",&nn);
         if (feof(fo)) goto kon1;
  /* detl=(char *)calloc(nn,sizeof(char));*/
  xm=(float *)calloc(nn,sizeof(float));
  ym=(float *)calloc(nn,sizeof(float));
  px=(float *)calloc(nn,sizeof(float));
  py=(float *)calloc(nn,sizeof(float));
  priz=(int *)calloc(nn,sizeof(int));
  kkon=(int *)calloc(nn,sizeof(int));

    if(zz>0)
           {
       strcpy(mass,name);
       strcat(mass,ks_);
       strcpy(str," ");
       itoa(zz,str,10);
        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }

      strcat(mass,str);
      strcat(mass,dbs);
      strcpy(file1,mass);
           }
    else
           {
    strcpy(file1,ident[iin-1]);
    strcat(file1,dbs);
           }
    if ((fu=fopen(file1,"wb"))==NULL)
   {
    printf("Ошибка открытия файла DBS\n");
    goto kon1;
   }
    /*fu=fopen(file1,"wb");*/
    pl++;
     for (i= 0; i< nn; i++)
      {
          fscanf(fo,"%s %f%f%f%f%d%d%d",detl,&xm[i],&ym[i],&px[i],&py[i],
                 &priz[i],&kkon[i],&pr);
         /* i=0 - лист , i!=0 - деталь */
        /* priz=0 - деталь, priz!=0 - образ , pr - угол*/
      mxl=xm[i];
      myl=ym[i];
      smx=px[i];
      smy=py[i];
    		words=30;
        if (priz[i]!=0) words=15;
        if (i==0) words=30;
	fwrite((char *)&words,2,1,fu);         /*длина записи*/
	k1=0;
	fwrite((char *)&k1,2,1,fu);            /*0*/
	fwrite((char *)&words,2,1,fu);         /*длина записи*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
	k2=1;
        if (priz[i]!=0) k2=2;
	fwrite((char *)&k2,2,1,fu);            /*тип записи*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
	k7=-1;
        k2=100+i;
        if (priz[i]==0) k2=kkon[i]+2;
        if (i==0) k2=1;
        fwrite((char *)&k2,2,1,fu);            /*номеp контуpа*/
	k2=1;
	fwrite((char *)&k1,2,1,fu);            /*0*/
	fwrite((char *)&k2,2,1,fu);            /*подтип*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
	fwrite((char *)&k1,2,1,fu);            /*текст*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
	fwrite((char *)&k1,2,1,fu);            /*автопослед.*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
        k7=-(20000-i);
        /*if (priz[i]==0) k7=-kkon[i];*/
        fwrite((char *)&k7,2,1,fu);            /*имя гpуппы*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
        k2=kkon[i]+2;
        if (i==0) k2=1;
        fwrite((char *)&k2,2,1,fu);            /*номеp ориг. контуpа*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
       /* if (i==0) k2=2;
         else k2=0;*/
         k2=2;
	fwrite((char *)&k2,2,1,fu);            /*pевеpс*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
  /* pr==0 нет поворота*/
        if (pr==1)
            {
        csx=0;
        snx=1;
            }
        else
            {
        csx=1;
        snx=0;
            }
        csxx=-snx;
        snxx=csx;
        fwrite((char *)&csx,4,1,fu);            /*cos(x,x)*/
        fwrite((char *)&snx,4,1,fu);            /*sin(x,x)*/
        fwrite((char *)&csxx,4,1,fu);           /*cos(y,x)*/
        fwrite((char *)&snxx,4,1,fu);           /*sin(y,x)*/
        x1=smx;
        y1=smy;

        if (pr==0)
            {
              x1=0;
              y1=0;
            }
         else
            {
     /*         x1=xmi[i];*/
              x1=xm[i];
              y1=0;
            }
        x1=x1+smx;
        y1=y1+smy;

	fwrite((char *)&x1,4,1,fu);              /*polx*/
	fwrite((char *)&y1,4,1,fu);              /*poly*/
              if (priz[i]==0)

                   {
          /* оригинальная деталь */
        x1=0;
        y1=0;
	z1=0;
	fwrite((char *)&x1,4,1,fu);              /*x1*/
	fwrite((char *)&y1,4,1,fu);              /*y1*/
	fwrite((char *)&z1,4,1,fu);              /*z1*/
        x1=mxl;
        y1=0;
	z1=0;
	fwrite((char *)&x1,4,1,fu);              /*x1*/
	fwrite((char *)&y1,4,1,fu);              /*y1*/
	fwrite((char *)&z1,4,1,fu);              /*z1*/
        x1=mxl;
        y1=myl;
	z1=0;
	fwrite((char *)&x1,4,1,fu);              /*x1*/
	fwrite((char *)&y1,4,1,fu);              /*y1*/
	fwrite((char *)&z1,4,1,fu);              /*z1*/
        x1=0;
        y1=myl;
	z1=0;
	fwrite((char *)&x1,4,1,fu);              /*x1*/
	fwrite((char *)&y1,4,1,fu);              /*y1*/
	fwrite((char *)&z1,4,1,fu);              /*z1*/
        x1=0;
        y1=0;
	z1=0;
	fwrite((char *)&x1,4,1,fu);              /*x1*/
	fwrite((char *)&y1,4,1,fu);              /*y1*/
	fwrite((char *)&z1,4,1,fu);              /*z1*/

                   }

					/*запись типа 8*/
	words=4;
	fwrite((char *)&words,2,1,fu);         /*длина записи*/
	k1=0;
	fwrite((char *)&k1,2,1,fu);            /*0*/
	fwrite((char *)&words,2,1,fu);         /*длина записи*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
	k2=8;
	fwrite((char *)&k2,2,1,fu);            /*тип записи*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
        k7=20000-i;
        fwrite((char *)&k7,2,1,fu);            /*ссылка к 26*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
        k2=100+i;
        if (priz[i]==0) k2=kkon[i]+2;
        if (i==0) k2=1;
        fwrite((char *)&k2,2,1,fu);            /*номеp контуpа*/
	fwrite((char *)&k1,2,1,fu);            /*0*/
					/*запись типа 26*/
	words=5;
	fwrite((char *)&words,2,1,fu);
	k1=0;
	fwrite((char *)&k1,2,1,fu);
	fwrite((char *)&words,2,1,fu);
	fwrite((char *)&k1,2,1,fu);
				k2=26;
	fwrite((char *)&k2,2,1,fu);
	fwrite((char *)&k1,2,1,fu);
        fwrite((char *)&k7,2,1,fu);
	fwrite((char *)&k1,2,1,fu);
       strcpy(list,detl);
        preob(list,8);
        preob(detl,8);
        detl[0]=list[1];
        detl[1]=list[0];
        detl[2]=list[3];
        detl[3]=list[2];
        detl[4]=list[5];
        detl[5]=list[4];
        detl[6]=list[7];
        detl[7]=list[6];
        strcpy(list,detl);
         if (i==0) fwrite((char *)list,8,1,fu);
          else fwrite((char *)detl,8,1,fu);
      }
         k1=-1;
        fwrite((char *)&k1,2,1,fu);
        fwrite((char *)&k1,2,1,fu);            /*конец*/
        fclose(fu);
        free(xm);
        free(ym);
        free(px);
        free(py);
        free(priz);
        free(kkon);
kon1:;
        fclose(fo);

 }



 void proc(int a,char *name)
   {
       FILE *CBSF;
       Integer2 koli,num ;
       strcpy(mass,name);
       strcat(mass,ks_);
       itoa(a,str,10);
        c = 0;
        while (str[c] != *prob && str[c] != *ks) c++;
        if (c == 1) {  str[2] = str[1];
                       str[1] = str[0];
                       str[0] = *n0;           }
      strcat(mass,str);
      strcat(mass,cbs);
   if((CBSF = fopen(mass, "w")) != NULL)
   {            num= TL[a-1]-1;
                koli=1;
                N1= massstr[num].x;
                N2= massstr[num].y ;
                fprintf(in,"%d %s %s %d %d %.2f %ld %ld\n",
                                      massstr[num].pr,
                                      massstr[num].put,
                                      massstr[num].partid,
                                      koli,
                                      massstr[num].pr1,
                                      massstr[num].dop,
                                      N1,
                                      N2);

     for (j = 1;j <= KK;j++)
          {
          if (PROD[a-1][j-1] !=0)
                {

                koli= PROD[a-1][j-1];
                if(koli>500)koli=koli-500;
                num= TD[j-1]-1;
                N1= massstr[num].x;
                N2= massstr[num].y ;
                fprintf(CBSF,"%d %s %s %d %d %.2f %ld %ld\n",
                                      massstr[num].pr,
                                      massstr[num].put,
                                      massstr[num].partid,
                                      koli,
                                      massstr[num].pr1,
                                      massstr[num].dop,
                                      N1,
                                      N2);
                 }
          }

          fclose(CBSF);
   }
     else printf("я не смогла открыть файл %s\n",mass);
     return;
   }
int forSignI(Integer4 X)
{
  if(X==0)
    return 0;
  else if(X<0)
    return -1;
  else
    return 1;
}
	void preob(char *aa,int b)
		{
		 int i,k,j,k1;
   char a;
		 for(i=0;i<b;i++)
			{
			 j=i;
    if(*(aa+i)=='\0')
			 break;
    a=*(aa+i);
    k1=toupper(a);
    a=k1;
    *(aa+i)=a;
			}
   	for(k=j;k<b;k++)
		  *(aa+k)=' ';
		  *(aa+b)='\0';
 	}





/*--[End of File]--------------------------------*/
