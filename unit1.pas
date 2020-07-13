unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DBCtrls, LCLintf, LCLType, usnake;

type

  rec = record
    name:ansistring;
    score:longint;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;

    sizeLabel: TLabel;
    pauseButton: TButton;
    recordButton: TButton;
    controlsText: TStaticText;
    recordLabel: TLabel;
    Timer1: TTimer;
    procedure controlsTextClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormPaint(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure paintRAt(x,y:integer);
    procedure pauseButtonClick(Sender: TObject);
    procedure recordButtonClick(Sender: TObject);
    procedure startNewGame();
    procedure Timer1Timer(Sender: TObject);
    procedure updatemeta;
    procedure msg(msga:ansistring);
  private

  public
    model:qSnake;
    colours:array[1..6] of string;
    ttm:boolean;
  end;


var Form1: TForm1;
  var  f: TextFile;

implementation

{$R *.lfm}

{ TForm1 }

procedure tform1.msg(msga:string);
begin
    Application.messagebox(pchar(msga),'Snake');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     colours[1]:='clRed';colours[4]:='clOlive';colours[3]:='clNavy';colours[2]:='clYellow';colours[5]:='clAqua';colours[6]:='clTeal';
     ttm:=false;
     startnewgame;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.controlsTextClick(Sender: TObject);
begin

end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
if not ttm then begin
  if(key='w')then begin model.up; ttm:=true; end;
  if(key='s')then begin model.down; ttm:=true; end;
  if(key='a')then begin model.left; ttm:=true; end;
  if(key='d')then begin model.right; ttm:=true; end;
end;
end;


procedure TForm1.recordButtonClick(Sender: TObject);

var name1, name2, name3:ansistring;
begin
     timer1.enabled:=false;
     begin
    assignfile(f, 'records');
    reset(f);
   while not eof(f) do
   begin
      readln(f,name1);
      readln(f,name2);
      readln(f,name3);
   end;
      msg('Рекорды:' + sLineBreak + name1 + sLineBreak + name2 +sLineBreak+ name3);
  closefile(f)
  end;
     timer1.enabled:=true;
     end;





procedure TForm1.Timer1Timer(Sender: TObject);
var score1, score2, score3:rec;
l1,l2,l3:ansistring;
l1s, l2s, l3s: TStringArray;
begin

      model.update;
      if model.getsize < 19 then
         timer1.interval:= 230 - 10*model.getsize() else timer1.interval:=50;
      ttm:=false;
    if(model.chcollision) then begin
                          timer1.enabled:=false; msg('Вы проиграли!');
                                assignFile(f, 'records');
                                 reset(f);
                                 readln(f, l1);
                                 readln(f, l2);
                                 readln(f, l3);
                                        closefile(f);
                                 l1s:=l1.Split(' ');
                                 l2s:=l2.Split(' ');
                                 l3s:=l3.Split(' ');
                                 score1.name:=l1s[0];score1.score:=strtoint(l1s[1]);
                                 score2.name:=l2s[0];score2.score:=strtoint(l2s[1]);
                                 score3.name:=l3s[0];score3.score:=strtoint(l3s[1]);
                                 rewrite(f);

                                 if model.getscore>score1.score then
                                                         begin                             msg('Рекорд побит, вы на 1 месте'+ slinebreak +'Cчет - '+inttostr(model.getscore));
                                                                                      score3:=score2;
                                                                                      score2:=score1;
                                                                score1.name := edit1.text;
                                                                score1.score :=model.getscore();

                                                                   end
                                                                      else
                                                                      if model.getscore>score2.score then begin
                                                                                                     msg('Вы занимаете второе место в таблице'+ slinebreak +'Cчет - '+inttostr(model.getscore));
                                                                                                   score3:=score2;
                                                                                         score2.name := edit1.text;
                                                                score2.score :=model.getscore();
                                                              end
                                                                      else
                                                                          if model.getscore>score3.score then begin
                                                                                                       msg('Вы занимаете третье место в таблице'+ slinebreak +'Cчет - '+inttostr(model.getscore))                                        ;
                                                                                         score3.name := edit1.text;
                                                                score3.score :=model.getscore();
                                                              end                                                             ;
                                                                      writeln(f, score1.name, ' ',score1.score)                                                ;
                                                                             writeln(f, score2.name, ' ',score2.score);
                                                                               writeln(f, score3.name, ' ',score3.score);
                                 closefile(f);
                                  startnewgame;

              end;
    FormPaint(self);
end;

procedure TForm1.FormPaint(Sender: TObject);
var n,h:nodeptr; bkg:TRect;
begin
     updatemeta;
     bkg.left:=0;
     bkg.right:=600;
     bkg.top:=0;
     bkg.bottom:=600;
     Canvas.Brush.Color := clGreen;
     n:=model.gettail;
     h:=model.gethead;
     Canvas.rectangle(bkg);
     Canvas.Brush.Color := stringtocolor(colours[model.getccol]);
     while(n<>h) do begin
        paintrat(n^.place.x, n^.place.y);
        n:=n^.next;
     end;
     Canvas.Brush.Color := stringtocolor(colours[model.getfrtype]) ;
     paintrat(model.getfrp.x, model.getfrp.y);
     Canvas.Brush.Color := stringtocolor(colours[model.getccol]);
     paintrat(n^.place.x, n^.place.y);
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.paintrat(x,y:integer);
var R: TRect;
begin
     R.Left := 24*x;
     R.Top := 24*y;
     R.Right := 24*(x-1);
     R.Bottom := 24*(y-1);

     Canvas.Brush.Style := bsSolid;


     Canvas.Rectangle(R);

end;

procedure TForm1.pauseButtonClick(Sender: TObject);
begin
    timer1.enabled:= not timer1.enabled;
end;

procedure TForm1.startnewgame;
begin
    model:=qSnake.con;
    model.create;

end;

procedure TForm1.updatemeta;
begin
    if(timer1.enabled)then pausebutton.caption:= 'Пауза' else pausebutton.caption:='Старт';
    sizeLabel.caption := 'Длина змейки - '+inttostr(model.getsize);
    recordlabel.caption:= 'Количество очков - '+ inttostr(model.getscore());

end;



end.

