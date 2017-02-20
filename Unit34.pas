unit Unit34;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils;

type
  TForm34 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Memo2: TMemo;
    etFind: TEdit;
    Button3: TButton;
    Button4: TButton;
    ListBox1: TListBox;
    Memo3: TMemo;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure etFindKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    procedure onPredictChange(Sender:TObject);
  public
    { Public declarations }
  end;

var
  Form34: TForm34;

implementation

uses USyllableKor, UPredictList;

var
  PredictList: TPredictList;

{$R *.dfm}

procedure TForm34.Button1Click(Sender: TObject);
var
  sSource: string;
  sSyllables: string;
begin
  sSource:= Memo1.Text;
  Memo3.Lines.Clear;

  sSyllables:= TSyllable.SplitJaMo(sSource);
  Memo3.Lines.Append(sSyllables);
end;

procedure TForm34.Button3Click(Sender: TObject);
var
  sItem: string;
begin
  Memo2.Lines.Clear;

  for sItem in Memo1.Lines do
    Memo2.Lines.Append(TSyllable.getFirstSyllables(sItem));
end;

procedure TForm34.Button4Click(Sender: TObject);
var
  sSyllables, sItem: string;
  nPos: Integer;
begin
  sSyllables:= Memo3.Text;
  Memo3.Clear;

  while sSyllables <> '' do
  begin
    nPos:= Pos(sLineBreak, sSyllables);
    if nPos > 0 then
    begin
      sItem:= LeftStr(sSyllables, nPos - 1);
      Delete(sSyllables, 1, nPos + Length(sLineBreak) - 1 );
    end
    else
    begin
      sItem:= sSyllables;
      sSyllables:= '';
    end;

    Memo3.Lines.Append(TSyllable.MergeJaMo(sItem));
  end;
end;

procedure TForm34.Button5Click(Sender: TObject);
var
  sItem: string;
begin
  PredictList.clear;
  for sItem in Memo1.Lines do
    PredictList.add(sItem);
end;

procedure TForm34.etFindKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  PredictList.sSearchTxt:= etFind.Text;
end;

procedure TForm34.FormCreate(Sender: TObject);
begin
  PredictList:= TPredictList.Create;
  PredictList.OnPredictChange:= onPredictChange;
end;

procedure TForm34.FormDestroy(Sender: TObject);
begin
  PredictList.Free;
end;

procedure TForm34.onPredictChange(Sender: TObject);
var
  orgItem: TPredictItem;
begin
  ListBox1.Clear;

  for orgItem in PredictList.zPredicted do
    ListBox1.Items.Add(orgItem.orgItem.sName);

  ListBox1.Visible:= (ListBox1.Items.Count > 0);
end;

end.
