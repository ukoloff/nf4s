/************************************************/
/*                                              */
/*           FORTRAN to C converter             */
/*              Include file                    */
/*                                              */
/************************************************/

/*	Standard C header files	*/

#include <math.h>
#include <stdio.h>
#include <stdlib.h>


/*	Some useful constants	*/

#define	TRUE	1
#define	FALSE	0

#define	_COMMON_	/*extern*/	/* COMMON blocks declarator */
#define	_TMP_CONST_	/*static*/	/* Temporal constants       */

/*	FORTRAN standard types definitions	*/

typedef	char	Character;
typedef	char	Integer1;
typedef short	Integer2;
typedef int	Integer4;
typedef char	Logical1;
typedef short	Logical2;
typedef int	Logical4;
typedef float	Real4;
typedef double	Real8;

struct _Entry_Point_ { int _; };	/* Entry point catcher	*/


/*	FORTRAN statement implementation prototypes	*/

void forPauseT(char*);
void forPauseN(int);

void forStopT(char*);
void forStopN(int);

int forSignI(Integer4	X);
int forSignR(Real8 X);


/*	FORTRAN power operator implementation		*/

Integer4 forPowerI(Integer4, Integer4);
double   forPowerR(double, double);

/*	FORTRAN string operators implementation		*/

char* forSubStr(char *Src, unsigned Total,
		unsigned Start, unsigned Stop, 
		unsigned *ResLen);
char* forStrCat(char *Res, unsigned Total, int Count,...);
/*		char *A1, unsigned Len1,	*/
/*		char *A2, unsigned Len2, ...	*/
void forStrAssign(char *Dst, unsigned Total, char *Src, unsigned Len);
short forStrCmp(char *One, unsigned Len1, char* Two, unsigned Len2);


/*	FORTAN standard functions	*/

#define	SIN(x)	sin(x)
#define COS(x)	cos(x)
#define	TAN(x)	tan(x)
#define	ATAN(x)	atan(x)

#define	EXP(x)	exp(x)
#define	LOG10(x)	log10(x)
#define	ALOG10(x)	log10(x)
#define	ALOG(x)		log(x)
#define	LOG(x)		log(x)

#define	SQRT(x)	sqrt(x)

#define	CHAR(x)		((char*)(x))
#define ICHAR(x)	(*(char*)(x))
#define	REAL(x)		((Real4)(x))

#define	LOCNEAR(x)	((Integer2)&(x))
#define	LOCFAR(x)	((Integer4)&(x))

/*--[End of File]----------------------------------------*/