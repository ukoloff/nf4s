{$N+}
{$E+}
{$R-}
{$I-}
(*{$D-}
{$L-}*)
{--------------------------------------------------------------------------}
{ Программа перекодировки файла DBS в формат DXF или файла DXF в формат DBS}
{                                                                          }
{                                       В.Видяпин   Июль 1990г.            }
{--------------------------------------------------------------------------}
uses Dos,TpCrt,TpString,TpDos,Trig;
var
  title:array [1..5] of integer;  {Заголовок записи DBS}
  ind:integer;                    {Целое в записи DBS}
  R:single;                       {Вещественное из записи DBS}
  Grn,Grk:single;
  Ent:string;                   {Строка из DXF}
  Xn,Yn,Tg:single;              {Координаты вершины и выпуклость}
  X1n,Y1n,X1k,Y1k,Tg1:single;   {Координаты начала и конца первого спана}
  Tip:integer;                  {Тип записи DBS}
  Len:integer;                  {Длина записи DBS}
  Dbs:file;                     {Бесформатный файл .DBS}
  Dxf:text;                     {Tекстовый файл .DXF}
  FPos:longint;                    {Текущая позиция в файле}
  Ch:char;
  Wrd:word;
  i,j,k,KolDet,null:integer;
  FileNameDbs,FileNameDxf:string; {Имена файлов DBS,DXF и CLD}
  Layer:string;           {Слой полилиний}
  Cos1,Sin1,Cos2,Sin2,X0,Y0:single;  {Kоординаты полюса К-кривой}
  NPoly,NumMainKCU,Narc,Nline:integer;     {Количество полилиний}
  Rev:integer;                       {Признак реверса К-кривой}
  Kcu:integer;                       {Номер текущей К-кривой}
  Ver:integer;                       {Количество вершин полилинии}
  DxfStr:string;          {Строка из файла DXF}
  PartId:string;          {Имя детали}
  ClosePolyLine,CloseKcu:boolean;  {Признак замкнутой полилинии}
  Xmin,Ymin,Xmax,Ymax:single;
  Xstart,Ystart,Xend,Yend:single;
  Entit:string[4];
  Area,Perim:single;               {Площадь детали}
  am:array[1..100] of single;
  Start,Finish:boolean;
  path:string;

procedure Initialize;
{Инициализация аттрибутов}
var
  i:integer;
  cur_dir:string;
  ch:char;
begin
  path:=GetEnv('GEOM');
  if Length(path)=0 then path:='C:\GEODET';
{Проверка наличия дирректория файлов геометрии}
  GetDir(0,cur_dir);
  ChDir(path);
  if IOResult<>0 then begin
      Writeln('Дирректорий '+path+' не найден.');
      Ch:=ReadKey;
      Halt(1);
  end;
  ChDir(cur_dir);
  path:=path+'\';

  FileNameDbs:='';  FileNameDxf:='';
  NumMainKCU:=1;
  null:=0;
  PartId:='1111    ';
  Narc:=0; Nline:=0;
  KolDet:=0;
  for i:=1 to 100 do am[i]:=0.0;
  Area:=0.0;
  Perim:=0.0;
end; {Initialize}

procedure BackToDos;
{Возврат в DOS}
begin
   Halt;
end;


procedure Error(ErrStr:string);
{Выводит сообщение об ошибке}
begin
  Writeln(ErrStr);
end;


procedure OpenFiles;
{Открывает файлы при перекодировке из DXF в DBS}
begin
  if ParamCount<1 then begin
     Writeln('Не задано имя DXF-файла.');
     Halt;
  end;
  FileNameDxf:=ParamStr(1);
{  Write('File DXF: '); Readln(FileNameDxf);}
  FileNameDxf:=ForceExtension(FileNameDxf,'DXF');
  if not ExistFile(FileNameDxf) then begin
     Writeln('Файл '+FileNameDxf+' не найден.');
     Halt;
  end;
  FileNameDbs:=path+JustFileName(FileNameDxf);
  FileNameDbs:=ForceExtension(FileNameDbs,'DBS');
  if ExistFile(FileNameDbs) then begin
    Write('Файл '+FileNameDbs+' уже существует. Перезаписывать ? (Y/N) ');
    Ch:=ReadKey;
    Writeln;
    if UpCase(Ch)<>'Y' then Halt;
  end;
  Assign(dbs,FileNameDbs);
  Assign(Dxf,FileNameDxf);
  Rewrite(Dbs,2);
  Reset(Dxf);
end;

function dist(x1,y1,x2,y2:single):single;
begin
  dist:=Sqrt(Sqr(X1-X2)+Sqr(Y1-Y2));
end;

function wtbm(Xstart,Ystart,Xend,Yend,Xt,Yt:single):byte;
{Возвращает положение точки по отношению к прямой
  = 0 - знак плюс
  = 1 - знак минус }
var
  a1,b1,c1,p1:single;
begin
  a1:=Yend-Ystart;
  b1:=Xstart-Xend;
  c1:=Ystart*Xend-Xstart*Yend;
  p1:=a1*xt+b1*yt+c1;
  if p1>0 then wtbm:=1 else wtbm:=0;
end;

procedure CenterSpan(X1,Y1,X2,Y2,T:single; var Xc,Yc,Xm,Ym,R:single);
{Вычисление координат центра, средней точки и радиуса кругового спана}
var
  chrd,a1,b1,p10,p11,p1,p2,x4,y4,x5,y5,tt:single;
begin
  if Abs(t)<0.000001 then Exit;  {спан не дуга}
  chrd:=dist(x1,y1,x2,y2);
  p10:=Abs(t)/2.0;
  a1:=y2-y1;
  b1:=x1-x2;
  tt:=Abs(t);
  {Если Т=1, т.е. ровно половина окружности}
  If Abs(TT-1)<0.000001 then begin
     Xc:=(X1+X2)/2.0;
     Yc:=(Y1+Y2)/2.0;
     R:=chrd/2.0;
     if T>0 then begin
        Xm:=Xc+a1*p10;
        Ym:=Yc+b1*p10;
     end else begin
        Xm:=Xc-a1*p10;
        Ym:=Yc-b1*p10;
     end;
     Exit;
  end;
{расчет радиуса}
  p11:=Abs(T)*2.0;
  p1:=p10*chrd;
  p2:=chrd/p11;
  R:=(p1+p2)/2;
{координаты центра и средней точки}
  x4:=(x1+x2)/2.0;
  y4:=(y1+y2)/2.0;
  if t<0 then begin
     x5:=x4+a1/p11;
     y5:=y4+b1/p11;
     xm:=x4-a1*p10;
     ym:=y4-b1*p10;
     xc:=(x5+xm)/2.0;
     yc:=(y5+ym)/2.0;
  end else begin
     x5:=x4-a1/p11;
     y5:=y4-b1/p11;
     xm:=x4+a1*p10;
     ym:=y4+b1*p10;
     xc:=(x5+xm)/2.0;
     yc:=(y5+ym)/2.0;
  end;
end;

procedure XYMax(X1,Y1,X2,Y2,Tg:single);
{Расчет габаритов}
var
  bx,by:array[1..4] of single;
  Xc,Yc,Xm,Ym,R:single;
  i,j,p:byte;
begin
  j:=0;
  if Abs(Tg)>0.00001 then begin
    CenterSpan(X1,Y1,X2,Y2,Tg,Xc,Yc,Xm,Ym,R);
    p:=wtbm(X1,Y1,X2,Y2,Xc+R,Yc);
    if ((p=1) and (Tg>0.0)) or ((p=0) and (Tg<0.0)) then begin
      j:=j+1;
      bx[j]:=Xc+R; by[j]:=Yc;
    end;
    p:=wtbm(X1,Y1,X2,Y2,Xc-R,Yc);
    if ((p=1) and (Tg>0.0)) or ((p=0) and (Tg<0.0)) then begin
      j:=j+1;
      bx[j]:=Xc-R; by[j]:=Yc;
    end;
    p:=wtbm(X1,Y1,X2,Y2,Xc,Yc+R);
    if ((p=1) and (Tg>0.0)) or ((p=0) and (Tg<0.0)) then begin
      j:=j+1;
      bx[j]:=Xc; by[j]:=Yc+R;
    end;
    p:=wtbm(X1,Y1,X2,Y2,Xc,Yc-R);
    if ((p=1) and (Tg>0.0)) or ((p=0) and (Tg<0.0)) then begin
      j:=j+1;
      bx[j]:=Xc; by[j]:=Yc-R;
    end;
    for i:=1 to j do begin
       if XMin>bx[i] then begin XMin:=bx[i]; NumMainKCU:=NPoly; end;
       if YMin>by[i] then begin YMin:=by[i]; NumMainKCU:=NPoly; end;
       if XMax<bx[i] then begin XMax:=bx[i]; NumMainKCU:=NPoly; end;
       if YMax<by[i] then begin YMax:=by[i]; NumMainKCU:=NPoly; end;
    end;
  end;
  if XMin>X1 then begin XMin:=X1; NumMainKCU:=NPoly; end;
  if YMin>Y1 then begin YMin:=Y1; NumMainKCU:=NPoly; end;
  if XMin>X2 then begin XMin:=X2; NumMainKCU:=NPoly; end;
  if YMin>Y2 then begin YMin:=Y2; NumMainKCU:=NPoly; end;
  if XMax<X1 then begin XMax:=X1; NumMainKCU:=NPoly; end;
  if YMax<Y1 then begin YMax:=Y1; NumMainKCU:=NPoly; end;
  if XMax<X2 then begin XMax:=X2; NumMainKCU:=NPoly; end;
  if YMax<Y2 then begin YMax:=Y2; NumMainKCU:=NPoly; end;
end;

procedure CloseFiles;
{Закрывает открытые файлы}
begin
  Close(dbs);
  Close(dxf);
end;

procedure EndDbs;
{Запись в DBS 8 и 26 записи}
var
  Id:array[1..4] of integer;
begin
{Запись типа 8}
  Len:=(NPoly*2+6) div 2;
  BlockWrite(dbs,Len,1);
  ind:=2001;
  BlockWrite(dbs,ind,1);
  BlockWrite(dbs,Len,1);
  BlockWrite(dbs,null,1);
  i:=8;
  BlockWrite(dbs,i,1);
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,ind,1);
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,NumMainKCU,1);
  BlockWrite(dbs,null,1);
  for i:=1 to NPoly do
    if i<>NumMainKCU then begin
      BlockWrite(dbs,i,1);
      BlockWrite(dbs,null,1);
  end;
{Запись типа 26}
  Len:=5;
  BlockWrite(dbs,Len,1);
  BlockWrite(dbs,ind,1);
  BlockWrite(dbs,Len,1);
  BlockWrite(dbs,null,1);
  i:=26;
  BlockWrite(dbs,i,1);
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,ind,1);
  BlockWrite(dbs,null,1);
  j:=1;
  {Идентификатор детали}
      PartId:=JustFilename(FileNameDbs);
      Delete(PartId,Pos('.',PartId),4);
      PartId:=Pad(StUpCase(PartId),8);
  for i:=1 to 4 do begin
    Id[i]:=Ord(PartId[j])*256+Ord(PartId[j+1]);
    j:=j+2;
    BlockWrite(dbs,Id[i],1);
  end;
     if CloseKcu then begin
{       Writeln('Площадь детали = '+Real2Str(Area,0,2)+' кв.дм');}
{тип записи 27 - площадь детали}
         Len:=5;
         BlockWrite(dbs,Len,1);
         BlockWrite(dbs,ind,1);
         BlockWrite(dbs,Len,1);
         BlockWrite(dbs,null,1);
         i:=27;
         BlockWrite(dbs,i,1);
         BlockWrite(dbs,null,1);
         BlockWrite(dbs,ind,1);
         BlockWrite(dbs,null,1);
         Area:=0.0;
         for i:=1 to NPoly do begin
            if i=NumMainKCU then Area:=Area+Abs(am[i])
            else Area:=Area-Abs(am[i]);
         end;
         BlockWrite(dbs,Area,2);
         BlockWrite(dbs,Perim,2);
     end
     else
Error('В детали имеется незамкнутый контур. Запись о площади игнорируется');
  j:=-1;
  for i:=1 to 2 do BlockWrite(dbs,j,1);  {Признак конца файла}
end;

procedure PrepKcu;
{Подготавливает запись типа 1}
begin
  NPoly:=NPoly+1;
  if NPoly>100 then begin
    Writeln('Ошибка! Слишком много контуpов в детали.');
    Halt;
  end;
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,Npoly,1);
  for i:=1 to 2 do BlockWrite(dbs,null,1);
  BlockWrite(dbs,Tip,1);
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,NPoly,1);
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,Tip,1);
  for i:=1 to 5 do BlockWrite(dbs,null,1);
  i:=-2001;
  BlockWrite(dbs,i,1);
  BlockWrite(dbs,null,1);
  BlockWrite(dbs,Npoly,1);
  for i:=1 to 3 do BlockWrite(dbs,null,1);
  BlockWrite(dbs,Cos1,2);
  BlockWrite(dbs,Sin1,2);
  BlockWrite(dbs,Cos2,2);
  BlockWrite(dbs,Sin2,2);
  BlockWrite(dbs,X0,2);
  BlockWrite(dbs,Y0,2);
end;

function SumPred:single;
var
 r:single;
 i:byte;
begin
 r:=0.0;
 for i:=1 to NPoly-1 do r:=r+am[i];
 SumPred:=r;
end;

procedure Revers;
begin
  i:=2;
  Seek(Dbs,FilePos(Dbs)+11);
  BlockWrite(Dbs,i,1);
  Len:=Len-12;
end;

procedure ReadTitle;
{ Читает заголовок записи, устанавливает тип записи}
begin
  FPos:=FilePos(dbs);
  BlockRead(dbs,Len,1);
  if Len=-1 then begin  {Проверка на конец файла}
     BlockRead(dbs,ind,1); Exit;
  end;
  Len:=Len*2+2-5; {Длина остатка записи}
  for i:=2 to 5 do BlockRead(dbs,title[i],1);
  Tip:=title[5];
end;



procedure CalcArea(X0,Y0,X1,Y1,T0:single);
{Расчет площади под спаном и суммирование с общей площадью}
var
  At,Dx,Dy,Chd,R,Theta,C,Temp,A1,A2,A3:single;
begin
  X0:=X0*1.0E-2;    Y0:=Y0*1.0E-2;
  X1:=X1*1.0E-2;    Y1:=Y1*1.0E-2;
  At:=Abs(T0);
  Dx:=X1-X0;             Dy:=Y1-Y0;
  Area:=Area+(Dx*(Y0+Y1)*0.5);
  Chd:=Sqrt(Sqr(Dy)+Sqr(Dx));
  if (At < 0.001) or (Chd < 0.001) then begin
{Добавляем к периметру длину линейного спана}
    Perim:=Perim+Chd;
    Exit;
  end;
{Расчет радиуса}
  R:=Abs(T0+1/T0)*Chd*0.25;
  Theta:=4.0*ArcTan(At);
  C:=Pi*2.0-Theta;
{Площадь треугольника}
  Temp:=Sqr(R)*0.5;
  A1:=Temp*Sin(C);
{Площадь кругового сегмента}
  A2:=Temp*Theta;
  A3:=A2+A1;
{Если знак тангенса кривизны отрицательный - площадь сегмента вычесть}
  if (T0>0.0) then A3:=-A3;
  Area:=Area+A3;
{Добавляем к периметру длину дуги}
  Perim:=Perim+Theta*R;
end;

procedure EndKcu;
{Заносит длину записи типа 1 }
var
  f:longint;
{  X,Y,T:single;}
begin
  if ClosePolyLine then begin
     f:=FilePos(dbs);
     Seek(dbs,f-Ver*6);
     BlockRead(dbs,Xn,2);
     BlockRead(dbs,Yn,2);
     CalcArea(XEnd,YEnd,Xn,Yn,Tg);
     XYMax(Xend,Yend,Xn,Yn,Tg);
     XEnd:=Xn; YEnd:=Yn;
     Seek(dbs,f);
     BlockWrite(dbs,Xn,2);
     BlockWrite(dbs,Yn,2);
     Tg:=0.0;
     BlockWrite(dbs,Tg,2);
     Ver:=Ver+1;
  end;
  f:=FilePos(dbs);
  Seek(dbs,FilePos(dbs)-Ver*6-32);
  if Ver<=1 then begin             {Одна вершина быть не должна}
      NPoly:=NPoly-1;
      Exit;
  End;
  Len:=(30+Ver*6) div 2;
  BlockWrite(dbs,Len,1);
  Seek(dbs,FilePos(dbs)+1);
  BlockWrite(dbs,Len,1);
  Seek(dbs,f);
  am[NPoly]:=Area-SumPred;
end;


procedure VerTex;
{Обрабатывает одну вершину полилинии}
var
  X,Y,T:single;
begin

  Ver:=Ver+1;
  While TrimTrail(DxfStr)<>' 10' do Readln(dxf,DxfStr);
  Readln(dxf,Xn);

  While TrimTrail(DxfStr)<>' 20' do Readln(dxf,DxfStr);
  Readln(dxf,Yn);

  { Начало и конец спана совпадают ??? }
  if (Sqrt(Sqr(Abs(Xn-XEnd))+Sqr(Abs(Yn-YEnd)))<=0.0001) and (Ver<>1) then
  begin
     Ver:=Ver-1;
     Exit;
  end;

  BlockWrite(dbs,Xn,2);
  BlockWrite(dbs,Yn,2);

  if Ver=1 then begin
     XStart:=Xn; YStart:=Yn; XEnd:=Xn; YEnd:=Yn;
     if NPoly=1 then begin
       Xmin:=Xstart; Ymin:=Ystart;  Xmax:=Xend;   Ymax:=Yend;
     end;
  end else begin
     CalcArea(XEnd,YEnd,Xn,Yn,Tg);
     XYMax(XEnd,YEnd,Xn,Yn,Tg);
     XEnd:=Xn; YEnd:=Yn
  end;
  While (TrimTrail(DxfStr)<>' 42') and
        (TrimTrail(DxfStr)<>'  0') do  Readln(dxf,DxfStr);
  if Str2Int(DxfStr,ind) then
     if ind=42 then begin                {Тангенс выпуклости}
         Readln(dxf,Tg);
         BlockWrite(dbs,Tg,2);
     end
     else begin
        Tg:=0.0;
        BlockWrite(dbs,Tg,2);
     end;
end;


procedure DecodPolyLines;
{Перекодирует полилинии из DXF в K-кривые DBS}
begin
  CloseKcu:=True;
  Area:=0.0; Tg:=0.0;
  While not Eof(dxf) do begin
    Readln(dxf,DxfStr);
    if TrimTrail(DxfStr)='POLYLINE' then begin
       Readln(dxf,DxfStr);
       Readln(dxf,DxfStr);
       Ver:=0;
       ClosePolyLine:=False;
       PrepKcu;
       while TrimTrail(DxfStr)<>'SEQEND' do begin
          Readln(dxf,DxfStr);
          if TrimTrail(DxfStr)=' 70' then ClosePolyLine:=True;
          if (TrimTrail(DxfStr)='VERTEX') then
            VerTex;
       end;
       EndKcu;
       CloseKcu:=CloseKcu and
       (ClosePolyLine or (Sqrt(Sqr(XEnd-XStart)+Sqr(YEnd-YStart)) < 0.1));
    end;
  end;
  if NPoly<>0 then EndDbs;
  Writeln('Перекодировано: '+Long2Str(NPoly)+' полилиний в файле '+FileNameDxf);
  Writeln('Площадь детали    = '+Real2Str(Area,0,2)+' кв.дм');
  Writeln('Периметр контуров = ',Perim:0:2,' дм.');
end;


procedure SkipRecord(L:word);
{Пропускает в файле DBS L слов}
begin
  Seek(dbs,FilePos(dbs)+L);
end; {SkipRecord}

procedure CheckArea;
{Пpовеpка площади каждого контуpа и pевеpсиpование контуpа пpи
 необходимости }
begin
  Seek(dbs,0);
  While not Eof(dbs) do begin
    ReadTitle;
    if Len=-1 then Exit;
    if Tip = 1 then begin
      BlockRead(dbs,kcu,1);
      BlockRead(dbs,KCU,1);
      Len:=Len-2;
      if ((KCU=NumMainKCU) and (Am[KCU]<0.0)) or
         ((KCU<>NumMainKCU) and (Am[KCU]>0.0)) then
          Revers;
    end;
    SkipRecord(Len);
  end;
end;

procedure DxfToDbs;
{Перекодировка из формата DXF в формат DBS}
begin
  NPoly:=0;  Cos1:=1.0;  Sin2:=1.0; Tip:=1;
  Sin1:=0.0; Cos2:=0.0;  X0:=0.0;  Y0:=0.0;
  {Пропускаем все до секции примитивов}
  While (TrimTrail(DxfStr)<>'ENTITIES') and (not Eof(dxf)) do
      Readln(dxf,DxfStr);
  if not Eof(dxf) then DecodPolyLines
  else Error('Неправильный формат файла DXF');
  CheckArea;
  CloseFiles;
end;  {DxfToDbs}

begin
  Initialize;
  OpenFiles;
  DxfToDbs;
  Write('Нажмите любую клавишу ...'); Ch:=ReadKey;
end.


