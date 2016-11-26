#include <stdio.h>
#include "for2c32.h"

#define EXPORT _export __stdcall

/* *** Function definitions *** */
void Bubble(Integer2 JA,Integer4 R[1000],Integer2 IB[1000]);
void YKLADN(Integer2 NY[1000],Integer4 *FY);
Real4 CYPER(Real8 *B);
int forSignI(Integer4 X);
int TESTO(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
  Integer4 A,Integer4 B,Integer4 *O,Integer4 *S,Integer4 *P);
int TEST0(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
  Integer4 A,Integer4 B,Integer4 *O,Integer4 *S,Integer4 *P);
void WIBER(Integer2 NS,Integer4 A[60],Integer4 B[60],Integer2 *N);
void DYPLO(Integer4 WS,Integer2 L,Integer4 B[60],Integer4 H[60],Integer4 X[60],Integer4 MI
[60],Integer4 MA[60]);
void GRANI(Integer4 YB[60],Integer4 YH[60],Integer4 X[60],Integer2 *L);

/* *** Common definitions *** */
struct			// ��室�� �����
 {
   Integer2 IJ;		// ������⢮ ���⮢
   Integer4 DL[20];	// ����� ���⮢
   Integer4 WS[20];	// ����� ���⮢
   Integer2 JA;		// ������⢮ ��⠫��
   Integer4 D[1000];	// ����� ��⠫��
   Integer4 W[1000];	// ����� ��⠫��
   Integer4 POV[1000];	// �ਧ��� ������
   Integer4 NUM[1000];	// ����� ��室��� ��⠫�
   Integer4 F[20];	// ???
 }
ComQQ;

struct			// �������
 {
   Integer4 T[1000];	// �ࠢ� �࠭��� ��⠫��
   Integer4 H[1000];	// ���孨� �࠭��� ��⠫��
   Integer4 LP[1000];	// �ਧ��� ������
   Integer2 NY[1000];	// ???
   Integer4 FY;		// ���� ����� ����
 }
RES;

struct Position
{
  Integer4 X, Y, W, H;
  Integer2 ListNo, DetailNo, Rotated;
};

int EXPORT GetPosition(int No, struct Position* Pos)
{
  int i;
  if(No<0 || No>=ComQQ.JA) return 0;
  Pos->ListNo=-1;
  Pos->DetailNo=ComQQ.NUM[No];
  Pos->Rotated=(RES.LP[No]!=0);
  Pos->W=ComQQ.D[No];
  Pos->H=ComQQ.W[No];
  Pos->X=RES.T[No]-(&Pos->W)[Pos->Rotated];
  Pos->Y=RES.H[No]-(&Pos->W)[1-Pos->Rotated];
  for(i=0; i<ComQQ.IJ; i++)
    if(ComQQ.F[i]>Pos->X)
     {
      Pos->ListNo=i;
      break;
     }
  return 1;
}

/* ****************** ���䨣��樮��� ��ࠬ���� ******************* */
Integer4 NPAR=2;
Integer4 KOL=3;

/*********************************************
static void ReadConfig(void)
{
  FILE* PAR=fopen("PARAM.PAR", "rt");
  fscanf(PAR, "%3ld%9ld", &NPAR, &KOL);
  fclose(PAR);
}
*********************************************/

void EXPORT SetParameters(int nPar, int Kol)
{
  NPAR=nPar;
  KOL=Kol;
}

void EXPORT AddRectangle(int IsList, int Count, Integer4 X, Integer4 Y)
{
  if(IsList)
   {
    while(--Count>=0)
     {
      ComQQ.DL[ComQQ.IJ]=X;
      ComQQ.WS[ComQQ.IJ]=Y;
      ComQQ.IJ++;
     }
    ComQQ.DL[ComQQ.IJ] = 5*ComQQ.DL[ComQQ.IJ-1];  // ����� ���� ???
    ComQQ.WS[ComQQ.IJ] = ComQQ.WS[ComQQ.IJ-1];
   }
  else
   {
    while(--Count>=0)
     {
      static int DetNo=0;
      ComQQ.D[ComQQ.JA]=X;
      ComQQ.W[ComQQ.JA]=Y;
      ComQQ.POV[ComQQ.JA]=0;
      ComQQ.NUM[ComQQ.JA]= ++DetNo;
      ComQQ.JA++;
     }
   }
}


void EXPORT Kapral(void)
{
  Integer4 KMM[5];
  Integer4 IRR[5];
  Integer2 IN[1000];
  Integer4 P[1000];
  Real8 B;
  Real4 X, XS;
  Integer4 KM;
  Integer4 IR;
  Integer4 N, N1, N2;
  Integer4 FI;
  Integer4 JR;

  Integer2 I, ISS,  J, JJ1,  JJ2, J1, J2, K, KK=0;

  if( ComQQ.IJ<1 || ComQQ.JA<=1) return;

//  ReadConfig();

  KM = 500*NPAR/ComQQ.JA ;
  KMM[1-1] = KM;
  KMM[2-1] = KM;
  KMM[3-1] = KM/2;
  KMM[4-1] = KM/2;
  KMM[5-1] = KM;

  IR = 2*ComQQ.JA;
  IRR[1-1] = 3*ComQQ.JA/4+1;
  IRR[2-1] = ComQQ.JA/4+1;
  IRR[3-1] = 5;
  IRR[5-1] = ComQQ.JA;
  IRR[4-1] = 3;

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
//   SL = 0;
   for(I = 1 ; I <= ComQQ.IJ+1 ; I++)
    {
      if(RES.FY<=ComQQ.F[I-1])
	 goto _122;
//      SL += ComQQ.DL[I-1]*ComQQ.WS[I-1];
    }
_122:
   ;
   /* YKLADL(  RES.NY, &RES.FY); */
    YKLADN(  RES.NY, &RES.FY);

//   SL += (RES.FY-ComQQ.F[I-1]+ComQQ.DL[I-1])*ComQQ.WS[I-1];
//   KRUL = I;

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


} // Kapral.end

int forSignI(Integer4 X)
{
  return X==0 ? 0 : ( X<0 ? -1 : +1);
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

   Integer4 MP; 	/* ???	*/

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


Real4 CYPER(Real8 *B)
 {
   static Real8 A=67108.8671875;

   *B *= 312.5;
   *B -=  (long)(*B/A) * A;
   return *B/A;
 }

int TESTO(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
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
            return 0;
						}
         if(AX1> DL)
	          continue;
            *O = AX1;
            *S = U[IS-1]+ B;
            *P = 1;
            return 0;
			    }
				 continue;
    }

         if(AX1<= DL && IS!=0)
            {
            *O = AX1;
            *S = U[IS-1]+ B;
            *P = 1;
            return 0;
            }
   if( ++(*N) <= ComQQ.IJ+1)
     return 0;
   return 1; // ������ �� ������ - ������ ���
 }

int TEST0(Integer2 L,Integer4 U[60],Integer4 V[60],Integer4 X[60],Integer4 DL,Integer2 *N,
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
      return 0;
    }
   if( ++(*N) <= ComQQ.IJ+1)
     return 0;
   return 1; // ������ �� ������ - ������ ���
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

