unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

const

  { Der Standard ASTM B 258-02 definiert das Durchmesserverhältnis von aufeinanderfolgenden AWG-Größen als:
    d_AWG−1 / d_AWG = 39th root(92) ~= 1,1229322
  }
  r_ratio:double = 1.1229321965322813952078503974187;

  { Spez. elekt. Widerstand für Cu-ETP aka E-Cu 58: 0,01786 (Ω x mm² /m)
  }
  rs_cu = 0.01786;


  { IEC 60228 Leiterquerschnitte [in mm²] }
  d_metric : array[0..27] of double = ( 0.09, 0.14, 0.25, 0.34, 0.5, 0.75,
                                        1.0, 1.5, 2.5, 4.0, 6.0, 10.0,
                                        16.0, 25.0, 35.0, 50.0, 70.0, 95.0,
                                        120.0, 150.0, 185.0, 240.0, 300.0,
                                        400.0, 500.0, 630.0, 800.0, 1000.0
                                       );

function d_mm(AWG:integer):double;
function d_inch(AWG:integer):double;

implementation

{$R *.lfm}

function d_mm(AWG:integer):double;
begin
  result:= 0.127 * (92.0 ** ((36.0-AWG) / 39.0));
end;

function d_inch(AWG:integer):double;
begin
  result := d_mm(AWG) / 25.4;
end;

function A(mm:double):double;
begin
  result := 0.25 * mm * mm * pi();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  w, i,j:integer;
  mm,a_mm,rm:double;
  un:string;
  units:array[0..4] of string;
begin
  w := (Stringgrid1.Width - 30);
  Stringgrid1.Columns[0].Width:=w div 6;
  Stringgrid1.Columns[1].Width:=w div 6;
  Stringgrid1.Columns[2].Width:=w div 3;
  Stringgrid1.Columns[3].Width:=w div 3;
  units[0] := 'm';
  units[1] := 'µ';
  units[2] := 'n';
  units[3] := 'p';
  units[4] := 'f';


  for i:=1 to 55 do
     begin
     Stringgrid1.Cells[0,i+4]:=IntToStr(i);
     end;

  mm:=0.46 * 25.4; // first entry: AWG 0000 (4/0) in mm

  for i:=1 to 59 do
     begin
     Stringgrid1.Cells[1,i]:=FloatToStrF(mm,ffFixed,8,4);

     a_mm:= A(mm);
     Stringgrid1.Cells[2,i]:=FloatToStrF(a_mm,ffFixed,8,4);

     un := '';
     j := 0;
     rm := rs_cu * 1.0 / a_mm; // per meter.
     while rm < 1.0 do
        begin
        un := units[j];
        inc(j);
        rm *= 1000.0;
        end;
     Stringgrid1.Cells[3,i]:=FloatToStrF(rm,ffFixed,8,4) + un;

     j := 0;
     while a_mm > d_metric[j] do inc(j);
     Stringgrid1.Cells[4,i]:=FloatToStrF(d_metric[j],ffGeneral,8,4);

     mm /= r_ratio;
     end;

end;





end.

