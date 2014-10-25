unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    tier1_1: TPanel;
    tier4_1: TPanel;
    tier4_4: TPanel;
    tier4_3: TPanel;
    tier4_2: TPanel;
    tier4_5: TPanel;
    tier4_7: TPanel;
    tier4_6: TPanel;
    tier3_1: TPanel;
    tier2_1: TPanel;
    tier2_2: TPanel;
    tier2_3: TPanel;
    tier3_4: TPanel;
    tier3_3: TPanel;
    tier3_2: TPanel;
    tier3_5: TPanel;
    mmHistory: TMemo;
    pnlTier1: TPanel;
    pnlTier2: TPanel;
    pnlTier3: TPanel;
    pnlTier4: TPanel;
    pnlHistory: TPanel;
    procedure FormShow(Sender: TObject);
    procedure tier1_1Click(Sender: TObject);
    procedure tier1_1MouseEnter(Sender: TObject);
    procedure tier1_1MouseLeave(Sender: TObject);
  private
    tier1, tier2, tier3, tier4: integer;
    computer_enabled: boolean;
    fp_move: boolean;
    steps: integer;
  public
    procedure computermove;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.tier1_1MouseEnter(Sender: TObject);
var
  prefix: string;
  suffix, i: integer;
begin
  prefix := Copy(TPanel(Sender).Name, 1, Pos('_', TPanel(Sender).Name));
  suffix := StrToInt(Copy(TPanel(Sender).Name, Pos('_', TPanel(Sender).Name)+1, 1));
  for i := 1 to suffix do
    TPanel(FindComponent(Prefix+IntToStr(i))).Font.Color := clGray;
  TPanel(FindComponent(Prefix+IntToStr(suffix))).Font.Color := clYellow;
  TPanel(FindComponent(Prefix+IntToStr(suffix))).Font.Style := [fsBold];
end;

procedure Tform1.computermove;
var
  toRemove: integer;
begin
  //try to remove stone(s) from the 2nd row to reach the optimal solution
  toRemove := tier2 xor tier3 xor tier4;
  if (toRemove <= tier1) then
  begin
    tier1_1Click(TPanel(FindComponent('tier1_'+IntToStr(tier1-toRemove))));
    exit;
  end;

  //try to remove stone(s) from the 2nd row to reach the optimal solution
  toRemove := tier1 xor tier3 xor tier4;
  if (toRemove <= tier2) then
  begin
    tier1_1Click(TPanel(FindComponent('tier2_'+IntToStr(tier2-toRemove))));
    exit;
  end;

  //try to remove stone(s) from the 3rd row to reach the optimal solution
  toRemove := tier1 xor tier2 xor tier4;
  if (toRemove <= tier3) then
  begin
    tier1_1Click(TPanel(FindComponent('tier3_'+IntToStr(tier3-toRemove))));
    exit;
  end;

  //try to remove stone(s) from the 4th row to reach the optimal solution
  toRemove := tier1 xor tier2 xor tier3;
  if (toRemove <= tier4) then
  begin
    tier1_1Click(TPanel(FindComponent('tier4_'+IntToStr(tier4-toRemove))));
    exit;
  end;
end;

procedure TForm1.tier1_1Click(Sender: TObject);
var
  prefix, playern: string;
  suffix, tier, i: integer;
begin
  prefix := Copy(TPanel(Sender).Name, 1, Pos('_', TPanel(Sender).Name));
  suffix := StrToInt(Copy(TPanel(Sender).Name, Pos('_', TPanel(Sender).Name)+1, 1));
  tier := StrToInt(TPanel(Sender).Name[Pos('_', TPanel(Sender).Name)-1]);
  inc(steps);

  //define player's name
  if (fp_move) then
    playern := 'Player 1'
  else begin
    if (computer_enabled) then
      playern := 'Computer'
    else
      playern := 'Player 2';
  end;

  //remove stone(s) from a row
  case tier of
  1: dec(tier1, suffix);
  2: dec(tier2, suffix);
  3: dec(tier3, suffix);
  4: dec(tier4, suffix);
  end;

  //update user interface
  mmHistory.Lines.Insert(0, IntToStr(steps)+': '+playern+' removed '+inttostr(suffix)+' stones from row '+inttostr(tier));
  for i := 1 + 2*(tier-1) downto 1 do
  begin
    if not TPanel(FindComponent(Prefix+IntToStr(i))).Visible then continue;
    TPanel(FindComponent(Prefix+IntToStr(i))).Visible := false;
    dec(suffix);
    if (suffix=0) then break;
  end;
  tier1_1MouseLeave(Sender);
  if TPanel(Sender).Visible then
    tier1_1MouseEnter(Sender);

  //check is game over
  if (tier1 or tier2 or tier3 or tier4) = 0 then
  begin
    if application.MessageBox(PChar(playern+' won.'+LineEnding+LineEnding+'Restart?'), 'Game Over', mb_YesNo) = IDYES then
      FormShow(nil);
    exit;
  end;

  //switch player
  fp_move := not fp_move;

  //if AI is enabled and now is AI's turn
  if ((fp_move=false) and computer_enabled) then begin
    computermove;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: integer;
begin
  tier1 := 1;
  for i := 1 to 1 do
    TPanel(FindComponent('tier1_'+IntToStr(i))).Visible := true;
  tier2 := 3;
  for i := 1 to 3 do
    TPanel(FindComponent('tier2_'+IntToStr(i))).Visible := true;
  tier3 := 5;
  for i := 1 to 5 do
    TPanel(FindComponent('tier3_'+IntToStr(i))).Visible := true;
  tier4 := 7;
  for i := 1 to 7 do
    TPanel(FindComponent('tier4_'+IntToStr(i))).Visible := true;
  steps :=0;
  fp_move := true;
  computer_Enabled := Application.MessageBox('Play with Computer?', 'Game Mode', mb_YesNo) = ID_YES;
  mmHistory.Clear;
end;

procedure TForm1.tier1_1MouseLeave(Sender: TObject);
var
  prefix: string;
  suffix, i: integer;
begin
  prefix := Copy(TPanel(Sender).Name, 1, Pos('_', TPanel(Sender).Name));
  suffix := StrToInt(Copy(TPanel(Sender).Name, Pos('_', TPanel(Sender).Name)+1, 1));
  for i := 1 to suffix do
    TPanel(FindComponent(Prefix+IntToStr(i))).Font.Color := clWhite;
  TPanel(FindComponent(Prefix+IntToStr(suffix))).Font.Style := [];
end;

end.

