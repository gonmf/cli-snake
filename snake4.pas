program snake;
uses wincrt;
type
norm=array[1..72,1..24] of record
occupied: boolean;
life: byte;
end;
var
teclas: array[1..2] of record
nome: string;
up,down,left,right: char;
end;
multi: array[1..2] of record
teclas: record
nome: string;
up,down,left,right: char;
end;
highscore,points,maxlife,plustotal,padrao,mapx,mapy: longint;
menu,prevmenu: char;
end;
padrao: byte;
textfile: text;
file1: file of longint;
filemap: file of norm;
mapname: string[12];
menu,prevmenu,submenu,choice,symbol: char;
cont1,cont2,mapx,mapy: longint;
defeat: boolean;
highscore: longint;
map: norm;
speed,cresc,points: longint;
plusx,plusy: byte;
plustotal: word;
maxlife: byte;
procedure timer;
begin   
for cont2:=1 to (11-speed)*110000 do write('');
end;         
begin
randomize;
writeln('Erro: Falta ficheiros');
assign(file1,'snakesav.dat');
reset(file1);
read(file1,highscore);
close(file1);
clrscr;
teclas[1].nome:='Padrão WASD';
teclas[1].up:='W';
teclas[1].down:='S';
teclas[1].left:='A';
teclas[1].right:='D';
teclas[2].nome:='Numérico esquerdo';
teclas[2].up:='8';
teclas[2].down:='2';
teclas[2].left:='4';
teclas[2].right:='6';
symbol:='#';
repeat
repeat
clrscr;
writeln;
writeln(' :SNAKE:');
writeln;
writeln(' a - Jogo Solo');
writeln(' b - 2 Jogadores(!)');
writeln(' c - Instrucções');
writeln(' d - Sair');
write(' ');
menu:=upcase(readkey);
if menu='C' then begin
writeln;
writeln;
writeln;
writeln;
writeln(' -Direccionais');
writeln;
writeln('    W                   8');
writeln('  A   D       ou      4   6         P para parar a partida');
writeln('    S                   2');
writeln;
writeln(' ! -> Apanhe para a cobra crescer e ganhar pontos / Nr apanhado');
writeln(' V -> Velocidade da partida');
writeln(' C -> Velocidade de crescimento da cobra');
writeln(' P -> Pontos da partida');
writeln(' R -> Recorde de pontos de todas as partidas');
writeln;
write('  Não embate nas paredes ou na própria cobra senão perde o jogo.');
readkey;
end;
if menu='D' then donewincrt;
until (menu='A') or (menu='B');
if menu='A' then begin
mapname:='level001.txt';
speed:=1;
cresc:=1;
padrao:=1;
repeat
clrscr;
writeln;
writeln(' :SNAKE:');
writeln;
writeln(' a - Mapa=',mapname);
writeln(' b - Velocidade=',speed);
writeln(' c - Crescimento=',cresc);
writeln(' d - Teclas=',teclas[padrao].nome);
writeln(' e - Aceitar e continuar');
write(' ');
submenu:=upcase(readkey);
if submenu='A' then begin
gotoxy(11,4);
readln(mapname);
mapname:=mapname+'.txt';
clrscr;
writeln('Erro: Mapa não encontrado, programa crashou');
assign(textfile,mapname);
reset(textfile);
close(textfile);
end;
if submenu='B' then
repeat
gotoxy(17,5);
readln(speed);
until (speed>=1) and (speed<=10);
if submenu='C' then
repeat
gotoxy(18,6);
readln(cresc);
until (cresc>=1) and (cresc<=10);
if submenu='D' then
if padrao=1 then padrao:=2 else padrao:=1;   
until submenu='E';      
clrscr;
defeat:=false;
maxlife:=10; 
prevmenu:=teclas[padrao].up;
points:=0;
plustotal:=0;
assign(textfile,mapname);
reset(textfile);
for cont2:=1 to 24 do begin
for cont1:=1 to 72 do begin
read(textfile,symbol);
if symbol='1' then begin
map[cont1,cont2].occupied:=true;
gotoxy(cont1,cont2);
write('N');
end else begin
map[cont1,cont2].occupied:=false;
end;
end;
readln(textfile);
end;
readln(textfile,mapx);
if mapx=2 then menu:=teclas[padrao].left else
if mapx=3 then menu:=teclas[padrao].down else
if mapx=4 then menu:=teclas[padrao].right else
menu:=teclas[padrao].up;
readln(textfile,mapx);
readln(textfile,mapy);
readln(textfile,plusx);
readln(textfile,plusy);
close(textfile);         
repeat
for cont1:=1 to 72 do
for cont2:=1 to 24 do 
if map[cont1,cont2].life>0 then begin
map[cont1,cont2].life:=map[cont1,cont2].life-1;
if (map[cont1,cont2].life=0) then begin
map[cont1,cont2].occupied:=false;
gotoxy(cont1,cont2);
write(' ');
end;
end;
gotoxy(plusx,plusy);
write('!');
gotoxy(73,1);
write(' V=',speed);
gotoxy(73,2);
write(' C=',cresc);
gotoxy(73,3);
write(' !=',plustotal);
gotoxy(73,4);
if points<1000 then write(' P=',points) else write('P=',points);
gotoxy(73,5);
if highscore<1000 then write(' R=',highscore) else write('R=',highscore);
if keypressed=true then menu:=upcase(readkey);
if (menu<>'P') and (menu<>teclas[padrao].up) and (menu<>teclas[padrao].down) and (menu<>teclas[padrao].left) and
(menu<>teclas[padrao].right) then menu:=prevmenu;
if menu='P' then begin
readkey;
menu:=prevmenu;
end;
if menu=teclas[padrao].left then begin
mapx:=mapx-1;
mapy:=mapy;
end else
if menu=teclas[padrao].down then begin
mapx:=mapx;
mapy:=mapy+1;
end else
if menu=teclas[padrao].right then begin
mapx:=mapx+1;
mapy:=mapy;
end else 
if menu=teclas[padrao].up then begin
mapx:=mapx;
mapy:=mapy-1;
end;
if map[mapx,mapy].occupied=true then defeat:=true else
begin
gotoxy(mapx,mapy);
write('#');
map[mapx,mapy].occupied:=true;
map[mapx,mapy].life:=maxlife;
if (mapx=plusx) and (mapy=plusy) then begin
repeat
cont1:=random(71)+2;
cont2:=random(23)+2;
until (cont1<>mapx) and (cont2<>mapy) and (map[cont1,cont2].occupied=false);
plusx:=cont1;
plusy:=cont2;
points:=points+(speed*cresc);
gotoxy(plusx,plusy);
write('!');
plustotal:=plustotal+1;
for cont1:=1 to 72 do
for cont2:=1 to 24 do
if map[cont1,cont2].life>0 then
map[cont1,cont2].life:=map[cont1,cont2].life+cresc;
maxlife:=maxlife+cresc;
end;
end;
timer;
prevmenu:=menu
until defeat=true;
if defeat=true then begin
if points>highscore then begin
highscore:=points;
assign(file1,'snakesav.dat');
rewrite(file1);
write(file1,highscore);
close(file1);
end;
gotoxy(28,1);
write(' Acabou a partida ');
for cont1:=1 to 3 do timer;
readkey;
end;
end else begin
{ MULTIPLAYER }
mapname:='multi001.txt';
speed:=3;
cresc:=1;
for cont1:=1 to 2 do begin
multi[cont1].teclas.nome:=teclas[cont1].nome;
multi[cont1].teclas.up:=teclas[cont1].up;
multi[cont1].teclas.left:=teclas[cont1].left;
multi[cont1].teclas.down:=teclas[cont1].down;
multi[cont1].teclas.right:=teclas[cont1].right;
multi[cont1].highscore:=999;
multi[cont1].points:=0;
multi[cont1].maxlife:=10;
multi[cont1].plustotal:=0;
multi[cont1].padrao:=cont1;
end;        
repeat
clrscr;
writeln;
writeln(' :SNAKE:');
writeln;
writeln(' a - Mapa=',mapname);
writeln(' b - Velocidade=',speed);
writeln(' c - Crescimento=',cresc);
writeln(' x - Teclas (Jogador 1=',multi[1].teclas.nome,' Jogador 2=',multi[2].teclas.nome,')');
writeln(' e - Aceitar e continuar');
write(' ');
submenu:=upcase(readkey);
if submenu='A' then begin
gotoxy(11,4);
readln(mapname);
mapname:=mapname+'.txt';
clrscr;
writeln('Erro: Mapa não encontrado, programa crashou');
assign(textfile,mapname);
reset(textfile);
close(textfile);
end;
if submenu='B' then
repeat
gotoxy(17,5);
readln(speed);
until (speed>=1) and (speed<=10);
if submenu='C' then
repeat
gotoxy(18,6);
readln(cresc);
until (cresc>=1) and (cresc<=10);
if submenu='D' then begin end; 
until submenu='E';      
clrscr;
writeln('Bugs:');
writeln(' Certas joagadas de um jogador podem afectar a direcção do outro');
writeln(' Os recordes do jogo para ambos os jogadores inda não sao registados');
writeln;
readkey;
clrscr;
defeat:=false;
symbol:='#';
multi[1].prevmenu:=multi[1].teclas.up;
multi[2].prevmenu:=multi[2].teclas.up;
assign(textfile,mapname);
reset(textfile);
for cont2:=1 to 24 do begin
for cont1:=1 to 72 do begin
read(textfile,symbol);
if symbol='1' then begin
map[cont1,cont2].occupied:=true;
gotoxy(cont1,cont2);
write('N');
end else begin
map[cont1,cont2].occupied:=false;
end;
end;
readln(textfile);
end;    
for cont1:=1 to 2 do begin
readln(textfile,mapx);  
if mapx=2 then multi[cont1].menu:=multi[cont1].teclas.left else
if mapx=3 then multi[cont1].menu:=multi[cont1].teclas.down else
if mapx=4 then multi[cont1].menu:=multi[cont1].teclas.right else
multi[cont1].menu:=multi[cont1].teclas.up;
end;
multi[1].prevmenu:=multi[1].menu;
multi[2].prevmenu:=multi[2].menu;   
readln(textfile,mapx);
readln(textfile,mapy);
multi[1].mapx:=mapx;
multi[1].mapy:=mapy;
readln(textfile,mapx);
readln(textfile,mapy);
multi[2].mapx:=mapx;
multi[2].mapy:=mapy;
readln(textfile,plusx);
readln(textfile,plusy);
close(textfile);
repeat
defeat:=false;
for cont1:=1 to 72 do
for cont2:=1 to 24 do 
if map[cont1,cont2].life>0 then begin
map[cont1,cont2].life:=map[cont1,cont2].life-1;
if (map[cont1,cont2].life=0) then begin
map[cont1,cont2].occupied:=false;
gotoxy(cont1,cont2);
write(' ');
end;
end;
gotoxy(plusx,plusy);
write('!');
gotoxy(73,1);
write(' Jog. 1');
gotoxy(73,2);
write(' V=',speed);
gotoxy(73,3);
write(' C=',cresc);
gotoxy(73,4);
write(' !=',multi[1].plustotal);
gotoxy(73,5);
if multi[1].points<1000 then write(' P=',multi[1].points) else write('P=',multi[1].points);
gotoxy(73,6);
if multi[1].highscore<1000 then write(' R=',multi[1].highscore) else write('R=',multi[1].highscore);
gotoxy(73,9);
write(' Jog. 1');
gotoxy(73,10);
write(' V=',speed);
gotoxy(73,11);
write(' C=',cresc);
gotoxy(73,12);
write(' !=',multi[2].plustotal);
gotoxy(73,13);
if multi[2].points<1000 then write(' P=',multi[2].points) else write('P=',multi[2].points);
gotoxy(73,14);
if multi[2].highscore<1000 then write(' R=',multi[2].highscore) else write('R=',multi[2].highscore);
if keypressed=true then menu:=upcase(readkey);
if menu='P' then begin
readkey;
multi[1].menu:=multi[1].prevmenu;
multi[2].menu:=multi[2].prevmenu;
end;
for cont1:=1 to 2 do begin
if (menu<>multi[cont1].teclas.up) and (menu<>multi[cont1].teclas.down) and (menu<>multi[cont1].teclas.left) and
(menu<>multi[cont1].teclas.right) then multi[cont1].menu:=multi[cont1].prevmenu;
if (menu=multi[cont1].teclas.up) or (menu=multi[cont1].teclas.down) or (menu=multi[cont1].teclas.left) or
(menu=multi[cont1].teclas.right) then 
multi[cont1].menu:=menu;   
if multi[cont1].menu=multi[cont1].teclas.left then begin
multi[cont1].mapx:=multi[cont1].mapx-1;
multi[cont1].mapy:=multi[cont1].mapy;
end else
if multi[cont1].menu=multi[cont1].teclas.down then begin
multi[cont1].mapx:=multi[cont1].mapx;
multi[cont1].mapy:=multi[cont1].mapy+1;
end else
if multi[cont1].menu=multi[cont1].teclas.right then begin
multi[cont1].mapx:=multi[cont1].mapx+1;
multi[cont1].mapy:=multi[cont1].mapy;
end else 
if multi[cont1].menu=multi[cont1].teclas.up then begin
multi[cont1].mapx:=multi[cont1].mapx;
multi[cont1].mapy:=multi[cont1].mapy-1;
end;
if map[multi[cont1].mapx,multi[cont1].mapy].occupied=true then defeat:=true else
begin
gotoxy(multi[cont1].mapx,multi[cont1].mapy);
write('#');
map[multi[cont1].mapx,multi[cont1].mapy].occupied:=true;
map[multi[cont1].mapx,multi[cont1].mapy].life:=multi[cont1].maxlife;
if (multi[cont1].mapx=plusx) and (multi[cont1].mapy=plusy) then begin
repeat
cont1:=random(71)+2;
cont2:=random(23)+2;
until (cont1<>multi[cont1].mapx) and (cont2<>multi[cont1].mapy) and (map[cont1,cont2].occupied=false);
plusx:=cont1;
plusy:=cont2;
multi[cont1].points:=multi[cont1].points+(speed*cresc);
gotoxy(plusx,plusy);
write('!');
multi[cont1].plustotal:=multi[cont1].plustotal+1;
for cont1:=1 to 72 do
for cont2:=1 to 24 do
if map[cont1,cont2].life>0 then
map[cont1,cont2].life:=map[cont1,cont2].life+cresc;
multi[cont1].maxlife:=multi[cont1].maxlife+cresc;
end;
end;  
end;  
timer;
multi[1].menu:=multi[1].prevmenu;
multi[2].menu:=multi[2].prevmenu;
until defeat=true;
if defeat=true then begin
if points>highscore then begin
highscore:=points;
assign(file1,'snakesav.dat');
rewrite(file1);
write(file1,highscore);
close(file1);
end;
gotoxy(28,1);
write(' Acabou a partida ');
readkey;
end;{ / MULTIPLAYER }
end;
until defeat=false;
end.
                                             