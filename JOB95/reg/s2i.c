int Str2Int(void)
{
  int rLo=0, rHi=0;
Cycle:
  asm{
      CLD
      XOR EAX, EAX
      LodSB
      Or	AL, AL
      JZ Done
      Cmp AL, ' '
      JE Cycle
      Cmp AL, 8
      JE Cycle
      Cmp AL, 'a'
      JB LoCase
      Sub AL, 'a'-'A'
  }
LoCase:
  asm{
    	Sub AL, 'A'
      Push	EAX
		Mov AL, 26
      Mul rHi
      Push EAX
      Mov EAX, 26
      Mul rLo
      Pop ECX
      Pop EBX
      Add EAX, EBX
      AdC EDX, ECX
      Mov rLo, EAX
      Mov rHi, EDX
      Jmp	Cycle
  }
Done:
  return rLo ^ rHi;
}
