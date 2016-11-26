unit CLD;

Interface uses
  Classes,
  SirMath;

Type
  TCldNum=Record
  Case Integer Of
   0:(Int: SmallInt);
   1:(Real: Single);
  End;

  TCldNums=Array[0..(MaxInt Div SizeOf(TCldNum)Div 2)]Of TCldNum;


Implementation

end.
