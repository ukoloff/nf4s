{$N+}
{$E+}
{$M 16384,16384,600000}
{$I-}
{$I TPDEFINE.INC}
{--------------------------------------------------------------------------}
{ Программа пpосмотpа детали                                               }
{                                                                          }
{                                       В.Видяпин  Октябpь 1991г.          }
{--------------------------------------------------------------------------}
uses Dos,TpCrt,TpString,TpDos,Trig,graph;
const
   dyp=40;
var
  ind,Rev:integer;                    {Целое в записи DBS}
  Cos1,Sin1,Cos2,Sin2,
  X0,Y0:single;                   {Вещественное из записи DBS}
  Len:integer;                    {Длина записи DBS}
  D:file;                         {Бесформатный файл .DBS}
  title:array[1..5] of integer;   {Заголовок записи}
  Ch:char;
  FileNameDbsPart:string;         {Имена файлов DBS}
  XMinP,YMinP,XmaxP,YmaxP:real;   {Габаpиты листа и детали}
  XMin,YMin,XMax,YMax:real;
  Gd,GraphMode:integer;
  MaxX,MaxY:word;
  ErrorCode:integer;
  ScaleX,ScaleY:real;                         {Масштаб изобpажения}
  XorigP,YorigP:word;
  Xn,Yn,Tg:single;
  path:string;

procedure FullPort;
{ Set the view port to the entire screen }
begin
  SetViewPort(0, 0, MaxX, MaxY, ClipOn);
end; { FullPort }

procedure MainWindow;
begin
  SetBkColor(Black);
  ClearDevice;                             { Clear the screen }
  FullPort;                                { Full screen view port }
end; { MainWindow }


procedure EgaVgaDriverProc; external;
{$L EGAVGA.OBJ }


procedure Initialize;
{Инициализация аттрибутов}
var
  ch:char;
begin
  XMinP:=100000.0;
  YMinP:=100000.0;
  XMaxP:=-100000.0;
  YMaxP:=-100000.0;

  if RegisterBGIDriver(@EGAVGADriverProc)<0 then
  begin
    Writeln('Ошибка регистрации драйвера: ',GraphErrorMsg(Graphresult));
    Halt(1);
  end;

  ClrScr;
  DirectVideo := False;
  GD := Detect;
  InitGraph(GD, GraphMode, '');
  case Gd of
    3,4,9:;
    else begin
      Writeln('Этот тип гpафического адаптеpа не поддеpживается');
      ch:=Readkey;
      Halt(1);
    end
  end;
  ErrorCode := GraphResult;
  if ErrorCode <> grOK then
    begin
      Writeln('Гpафическая ошибка: ', GraphErrorMsg(ErrorCode));
      if ErrorCode = grFileNotFound then
        Writeln('Не найден гpафический дpайвеp');
        ch:=Readkey;
      Halt(1);
    end;
  MaxX := GetMaxX;
  MaxY := GetMaxY;
  MainWindow;
end; {Initialize}


procedure OpenFiles;
{Открывает файлы}
var
  i:byte;
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

  FileNameDbsPart:=ParamStr(1);

  FileNameDbsPart:=path+ForceExtension(FileNameDbsPart,'DBS');
  if not ExistFile(FileNameDbsPart) then begin
    Writeln('Файл '+FileNameDbsPart+' не найден');
    Halt;
  end;
  Assign(D,FileNameDbsPart);
  Reset(D,2);
end;

procedure CloseFiles;
{Закрывает открытые файлы}
begin
  Close(d);
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
  chrd,a1,b1,p10,p11,p1,p2,x4,y4,x5,y5:single;
  tt:single;
begin
  if Abs(t)<0.000001 then Exit;  {спан не дуга}
  chrd:=dist(x1,y1,x2,y2);
  p10:=Abs(t)/2.0;
  a1:=y2-y1;
  b1:=x1-x2;
  {Если Т=1, т.е. ровно половина окружности}
  tt:=Abs(t);
  If (Abs(TT-1))<0.00001 then begin
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
       if XMin>bx[i] then XMin:=bx[i];
       if YMin>by[i] then YMin:=by[i];
       if XMax<bx[i] then XMax:=bx[i];
       if YMax<by[i] then YMax:=by[i];
    end;
  end;
  if XMin>X1 then XMin:=X1;
  if YMin>Y1 then YMin:=Y1;
  if XMin>X2 then XMin:=X2;
  if YMin>Y2 then YMin:=Y2;
  if XMax<X1 then XMax:=X1;
  if YMax<Y1 then YMax:=Y1;
  if XMax<X2 then XMax:=X2;
  if YMax<Y2 then YMax:=Y2;
end;

procedure MinMax(P,L:word);
  {Определяет мин. и макс. координаты вершин К-кривой,
   начиная с позиции P; L - количество вершин}
  var
    X,Y,T:single;
    Xend,Yend:single;
    Start:boolean;
    i:byte;
  begin
    Start:=False;
    Seek(d,P);
    for i:=1 to L do begin
      BlockRead(d,X,2);
      BlockRead(d,Y,2);
      BlockRead(d,T,2);
      Xn:=X*Cos1+Y*Cos2+X0;
      Yn:=X*Sin1+Y*Sin2+Y0;
      if Start then begin
         XYMax(Xend,Yend,Xn,Yn,Tg);
         Xend:=Xn; Yend:=Yn;  Tg:=T*Rev;
      end
      else begin
         Xmax:=Xn;  Xmin:=Xn;
         Ymax:=Yn;  Ymin:=Yn;
         Xend:=Xn;  Yend:=Yn;
         Tg:=T*Rev;
         Start:=True;
      end;
    end;
  end;

procedure ReadRecordTitle;
{ Читает заголовок записи, устанавливает тип записи     }
var
  i,j:byte;
begin
  BlockRead(d,Title[1],1);
  Len:=Title[1];
  if Len=-1 then begin     {Проверка на конец файла}
     BlockRead(d,Title[2],1); Exit;
  end;
  for i:=2 to 5 do BlockRead(d,title[i],1);
  Len:=Len*2+2-5;
end;

procedure ReadTip1;
{Читает записи типа 1}
var
  i:integer;
  P:longint;
begin
   for i:=1 to 14 do Blockread(d,ind,1);
   if Abs(ind)=1 then Rev:=-1 else Rev:=1;
   Blockread(d,ind,1);
   BlockRead(d,Cos1,2);   {Cos(X,X)}
   BlockRead(d,Sin1,2);   {Sin(X,X)}
   BlockRead(d,Cos2,2);   {Cos(Y,X)}
   BlockRead(d,Sin2,2);   {Sin(Y,X)}
   BlockRead(d,X0,2);   {Кооpдината полюса X}
   BlockRead(d,Y0,2);   {Кооpдината полюса Y}
   P:=FilePos(d);
   MinMax(P,(Len-27) div 6);
end; {ReadTip1}


procedure SkipRecord(L:word);
{Пропускает в файле DBS L слов}
begin
  Seek(d,FilePos(d)+L);
end; {SkipRecord}

procedure CalcGab;
{Опpеделение минимальных кооpдинат детали  и габаpитов}
begin
  Len:=0;
  While Len<>-1 do begin
  ReadRecordTitle;
  {Поиск записи типа 1}
    While (Title[5]<>1) and (Len<>-1) do begin
      SkipRecord(Len);
      ReadRecordTitle;
    end;
    if Len=-1 then Exit;
    ReadTip1;
     if XMaxP<(XMax-XMin) then XMaxP:=XMax-XMin;
     if YMaxP<(YMax-YMin) then YMaxP:=YMax-YMin;
     if XMinP>XMin then XMinP:=XMin;
     if YMinP>YMin then YMinP:=YMin;
  end;
end;

function Min(R1,R2:real):real;
begin
  if R1>R2 then Min:=R2 else Min:=R1;
end;

(*function Max(R1,R2:real):real;
begin
  if R1>R2 then Max:=R1 else Max:=R2;
end;*)

procedure CalcScale;
{pасчет масштаба}
var
  Scale:real;
  Xasp,Yasp:word;
  dxp:word;
begin
  CalcGab;
  GetAspectRatio(Xasp,Yasp);
  dxp:=Round(dyp*(MaxX/MaxY));
  ScaleX:=(MaxX-2*dxp)/XMaxP;
  ScaleY:=(MaxY-2*dyp)/YMaxP;
  Scale:=Min(ScaleX,ScaleY);
  ScaleY:=Scale;
  ScaleX:=Scale*(Yasp/XAsp);
  YorigP:=MaxY-(Round(MaxY/2)-Round(YMaxP/2*ScaleY));
  XorigP:=Round(MaxX/2)-Round(XMaxP/2*ScaleX);
end;

procedure DrawArc(Xs,Ys,Xn,Yn,Tg:single; Kx,Ky:longint);
var
  Xc,Yc,Xm,Ym,R:single;
  Dalfa,Aln,Alk,Alfa:real;
  K:word;
  i:word;
begin
  CenterSpan(Xs,Ys,Xn,Yn,Tg,Xc,Yc,Xm,Ym,R);
  Aln:=Arc_Tan((Xs-Xc),(Ys-Yc));
  Alk:=Arc_Tan((Xn-Xc),(Yn-Yc));
  Alfa:=Alk-Aln;
  if (Alk<Aln) and (Tg>0.0) then Alfa:=Alfa+2*Pi;
  if (Alk>Aln) and (Tg<0.0) then Alfa:=Alfa-2*Pi;

  K:=Trunc(0.2*Abs(RadiansToDegrees(Alfa))*Sqrt(R*ScaleX*0.01));
  if K<1 then
     LineTo(XorigP-KX+Round(Xn*ScaleX),YorigP+KY-Round(Yn*ScaleY))
  else begin
     Dalfa:=Alfa/K;
     for i:=1 to K-1 do begin
       Xs:=Xc+R*Cos(Aln+Dalfa*i);
       Ys:=Yc+R*Sin(Aln+Dalfa*i);
       LineTo(XorigP-KX+Round(Xs*ScaleX),YorigP+KY-Round(Ys*ScaleY));
     end;
     LineTo(XorigP-KX+Round(Xn*ScaleX),YorigP+KY-Round(Yn*ScaleY))
   end;
end;

procedure DrawPart;
var
  KX,KY:longint;
  X,Y,Xs,Ys:single;
  i:byte;
  t:single;
begin
  Seek(d,0);
  KX:=Round(XMinP*ScaleX);
  KY:=Round(YMinP*ScaleY);
  Len:=0;
  while Len<>-1 do begin
   {Поиск записи типа 1}
   ReadRecordTitle;
   While (Title[5]<>1) and (Len<>-1) do begin
     SkipRecord(Len);
     ReadRecordTitle;
   end;
   if Len=-1 then  Exit;
   for i:=1 to 14 do Blockread(d,ind,1);
   if Abs(ind)=1 then Rev:=-1 else Rev:=1;
   Blockread(d,ind,1);
   Len:=(Len-27) div 6;
   BlockRead(d,Cos1,2);   {Cos(X,X)}
   BlockRead(d,Sin1,2);   {Sin(X,X)}
   BlockRead(d,Cos2,2);   {Cos(Y,X)}
   BlockRead(d,Sin2,2);   {Sin(Y,X)}
   BlockRead(d,X0,2);   {Кооpдината полюса X}
   BlockRead(d,Y0,2);   {Кооpдината полюса Y}
   for i:=1 to Len do begin
      BlockRead(d,X,2);
      BlockRead(d,Y,2);
      BlockRead(d,T,2);
      Xn:=X*Cos1+Y*Cos2+X0;
      Yn:=X*Sin1+Y*Sin2+Y0;
      if i=1 then MoveTo(XOrigP-KX+Round(Xn*ScaleX),YOrigP+KY-Round(Yn*ScaleY))
      else
        if Abs(Tg)<0.00001 then
            LineTo(XOrigP-KX+Round(Xn*ScaleX),YOrigP+KY-Round(Yn*ScaleY))
        else
            DrawArc(Xs,Ys,Xn,Yn,Tg,Kx,Ky);
      Tg:=T*Rev;
      Xs:=Xn;  Ys:=Yn;
   end;
  end;
end;

begin
  OpenFiles;
  Initialize;
  CalcScale;
  SetColor(Yellow);
  DrawPart;
  SetColor(Green);
  SetTextStyle(0,0,2);
  OutTextXY(140,MaxY-20,'Нажмите любую клавишу...');
  SetTextStyle(0,0,1);
  OutTextXY(4,4,'Файл: '+Pad(JustFileName(FileNameDbsPart),12)+
  ' Габаpиты: '+Long2Str(Round(XMaxP))+'x'+Long2Str(Round(YMaxP)));
  ch:=readkey;
  CloseGraph;
  CloseFiles;
end.



