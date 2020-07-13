unit uSnake;

{$mode objfpc}{$H+}

interface

type point = Record
    x,y:integer;
end;
type
  nodeptr = ^snakeNode;
  snakeNode = Record
    next: ^snakeNode;
    place: point;
end;
qSnake = class(TObject)
   private
     tail, head:nodeptr;
     upv, rightv:integer;
     size, score, boxh, boxw, frx, fry, frtype, curcolor:integer;
   public
     constructor con;
     procedure grow(base:point);
     procedure chfreaten(b:point);
     procedure gennewfr;
     function getfrtype:integer;
     function getfrp:point;
     procedure move;
     function chCollision():boolean;
     procedure up;
     procedure down;
     procedure left;
     procedure right;
     function getsize:integer;
     function getscore:integer;
     procedure Create;
     procedure swcolor;
     function getccol:integer;
     procedure update;
     procedure ttxt;
     function gettail:nodeptr;
     function gethead:nodeptr;
end;


implementation

function qSnake.getscore:integer;
begin
getscore:=score;
end;

procedure qSnake.ttxt;
  var n:nodeptr;
begin
     n:=tail;
     writeln(n^.place.x, ' ', n^.place.y);
     while (n <> head) do begin
         n:=n^.next;
         writeln(n^.place.x, ' ', n^.place.y)  ;
     end;
     writeln('fr', frtype,' @ ', frx,' ', fry);
end;

procedure qSnake.update;
var b:point;
begin
     b:=tail^.place;
     move;
     chfreaten(b);
end;

function qSnake.getfrtype():integer;
begin
     getfrtype:=frtype;
end;

function qSnake.gettail:nodeptr;
begin
     gettail:=tail;
end;

function qSnake.gethead:nodeptr;
begin
     gethead:=head;
end;

procedure qSnake.chfreaten(b:point);
begin
     if(head^.place.x=frx) and (head^.place.y=fry) then begin
                           if (frtype=1) then begin grow(b); score:=score+1 end else if (frtype=2) then begin
                              score:=score+3;
                           end else begin score:=score+2; swColor; end; gennewfr;
     end;

end;

procedure qSnake.gennewfr;
begin
     randomize;
     frtype:=random(3)+1;
     frx:=random(boxw)+1;
     fry:=random(boxh)+1;
end;

function qSnake.getfrp:point;
begin
     getfrp.x:=frx;
     getfrp.y:=fry;
end;

procedure qSnake.swcolor;
begin
     curcolor:=curcolor+1;
     if curcolor>6 then curcolor:=1;
end;

function qSnake.getccol:integer;
begin
     getccol:=curcolor;
end;

procedure qSnake.grow(base:point);
     var newtail:nodeptr;
     begin
        new(newtail);
        size:=size+1;
        newtail^.place := base;
        newtail^.next := tail;
        tail:=newtail;

     end;
procedure qSnake.move;
   var n:nodeptr;
   begin
        n:= tail;
        while (n<>head) do begin
              n^.place := n^.next^.place;
              n := n^.next;
        end;
        head^.place.x := head^.place.x + rightv;
        head^.place.y := head^.place.y + upv;
   end;
function qSnake.chCollision():boolean;
var n:^snakeNode;
     rval:boolean;
   begin
        rval:=false;
        n:=tail;
        if(head^.place.x < 1) or (head^.place.y<1) or (head^.place.x>boxw) or (head^.place.y>boxh) then rval:=true else
        while(n<>head) do begin
            if((n^.place.x=head^.place.x)and(n^.place.y=head^.place.y)) then begin
                                                                        rval:=true;break;

            end;
            n:=n^.next;
        end;
        chCollision:=rval;
   end;

procedure qSnake.down();
   begin
        if(upv<>-1) then begin
                   upv:=1;
                   rightv:=0;
        end;
   end;
procedure qSnake.up();
   begin
        if (upv<>1) then begin
           upv:=-1;
           rightv:=0;
        end;
   end;
procedure qSnake.left();
   begin
        if (rightv<>1) then begin
           upv:=0;
           rightv:=-1;
        end;
   end;
procedure qSnake.right();
  begin
       if (rightv<>-1) then begin
          upv:=0;
          rightv:=1;
       end;
  end;
function qSnake.getsize:longint;
  begin
       getsize:=size;

  end;

constructor qSnake.con;
begin

end;

procedure qSnake.Create;
  var h,m,t:nodeptr;
  begin
  boxw:=25;
  boxh:=25;
  gennewfr;
  curcolor:=1;
  size:= 3;
  rightv:=1;
  upv:=0;
  new(h);
  h^.place.x:=4;
  h^.place.y:=2;
  head:=h;
  new(m);
  m^.place.x:=3;
  m^.place.y:=2;
  m^.next:=h;
  new(t);
  t^.place.x:=2;
  t^.place.y:=2;
  t^.next:=m;
  tail:=t;
  end;
end.
