unit UPredictList;

interface

uses
  SysUtils, Classes, Generics.Defaults, Generics.Collections, USyllableKor,
  StrUtils;

type
  TSourceItem = record
    sCode: string;
    sName: string;
    nOrder: Integer;
  end;

  TPredictItem = record
    orgItem: TSourceItem;

    nInsSeq: Integer;
    isPredictive: Boolean;
  end;
  TzPredictItems  = TList<TPredictItem>;

  TManagedItem = record
    sManagedTxt: string;
  end;
  TzManagedItems  = TList<TManagedItem>;

  TPredictList = class
    private
      FzOrgItems      : TzPredictItems;
      FzPredicted     : TzPredictItems;
      FzFullSyllables : TzManagedItems;
      FzFirstSyllables: TzManagedItems;
      FzEngSyllables  : TzManagedItems;

      FsSearchTxt: string;
      FOnPredictChange: TNotifyEvent;

      procedure setSearchTxt(const ASearchTxt: string);
      function getCount: Integer;

      procedure doPredict;
    public
      constructor Create;
      destructor Destroy; override;

      function find(AItem: TSourceItem): Integer;
      procedure add(AItem: TSourceItem); overload;
      procedure add(AItem: string); overload;
      procedure delete(AItem: TSourceItem); overload;
      procedure delete(AItem: TPredictItem); overload;
      procedure delete(AIdx: integer); overload;
      procedure clear;

      property sSearchTxt: string read FsSearchTxt write setSearchTxt;
      property zPredicted: TzPredictItems read FzPredicted write FzPredicted;
      property zOrgItems : TzPredictItems read FzOrgItems  write FzOrgItems;

      property count: Integer read getCount;
      property OnPredictChange : TNotifyEvent read FOnPredictChange write FOnPredictChange;
  end;

implementation

{ TPredictList }

procedure TPredictList.add(AItem: TSourceItem);
var
  prItem: TPredictItem;
  maItem: TManagedItem;
begin
  if find(AItem) >= 0 then
    Exit;

  prItem:= Default(TPredictItem);
  prItem.orgItem:= AItem;
  prItem.nInsSeq:= Count;
  prItem.isPredictive:= False;
  FzOrgItems.Add(prItem);

  maItem:= Default(TManagedItem);
  maItem.sManagedTxt:= TSyllable.SplitJaMo(AItem.sName);
  FzFullSyllables.Add(maItem);

  maItem:= Default(TManagedItem);
  maItem.sManagedTxt:= TSyllable.getFirstSyllables(AItem.sName);
  FzFirstSyllables.Add(maItem);

  maItem:= Default(TManagedItem);
  maItem.sManagedTxt:= TSyllable.getEngSyllables(AItem.sName);
  FzEngSyllables.Add(maItem);
end;

procedure TPredictList.add(AItem: string);
var
  addItem: TSourceItem;
begin
  addItem:= Default(TSourceItem);
  addItem.sName:= AItem;

  add(addItem);
end;

procedure TPredictList.clear;
begin
  FzOrgItems.Clear;
  FzPredicted.Clear;

  FzFullSyllables.Clear;
  FzFirstSyllables.Clear;
  FzEngSyllables.Clear;

  FsSearchTxt:= '';
end;

constructor TPredictList.Create;
var
  Comparison: TComparison<TPredictItem>;
begin
  FzOrgItems      := TzPredictItems.Create;

  Comparison :=
    // TList sort routine
    //>0 (positive) Item1 is greater than Item2
    //0             Item1 is equal to Item2
    //<0 (negative) Item1 is less than Item2
    function(const Item1, Item2: TPredictItem): Integer
    begin
      if Item1.orgItem.nOrder > Item2.orgItem.nOrder then
        Result := 1
      else if Item1.orgItem.nOrder = Item2.orgItem.nOrder then
      begin
        if Item1.nInsSeq > Item2.nInsSeq then
          Result := 1
        else if Item1.nInsSeq = Item2.nInsSeq then
          Result := 0
        else
          Result := -1;
      end
      else
        Result := -1;
    end;
  FzPredicted     := TzPredictItems.Create(TComparer<TPredictItem>.Construct(Comparison));

  FzFullSyllables := TzManagedItems.Create;
  FzFirstSyllables:= TzManagedItems.Create;
  FzEngSyllables  := TzManagedItems.Create;

  FsSearchTxt:= '';
end;

procedure TPredictList.delete(AItem: TSourceItem);
var
  AIdx: Integer;
begin
  AIdx:= find(AItem);
  if AIdx >= 0 then
    delete(AIdx);
end;

procedure TPredictList.delete(AIdx: integer);
begin
  FzOrgItems.Delete(AIdx);

  FzFullSyllables.Delete(AIdx);
  FzFirstSyllables.Delete(AIdx);
  FzEngSyllables.Delete(AIdx);

  if FzPredicted.Count > 0 then
    doPredict;
end;

procedure TPredictList.delete(AItem: TPredictItem);
var
  AIdx: Integer;
begin
  AIdx:= FzOrgItems.IndexOf(AItem);
  if AIdx >= 0 then
    delete(AIdx);
end;

destructor TPredictList.Destroy;
begin
  FOnPredictChange:= nil;

  FreeAndNil(FzOrgItems);
  FreeAndNil(FzPredicted);

  FreeAndNil(FzEngSyllables);
  FreeAndNil(FzFirstSyllables);
  FreeAndNil(FzFullSyllables);

  inherited;
end;

procedure TPredictList.doPredict;
var
  sManagedTxt: string;
  nMax, i: Integer;
  findItem: TManagedItem;
  addItem : TPredictItem;
begin
  nMax:= count;
  for i:= 0 to nMax - 1 do
  begin
    addItem:= FzOrgItems[i];
    addItem.isPredictive:= False;
    FzOrgItems[i]:= addItem;
  end;
  FzPredicted.Clear;

  if nMax = 0 then
    Exit;

  sManagedTxt:= TSyllable.SplitJaMo(FsSearchTxt);
  for i:= 0 to nMax - 1 do
  begin
    findItem:= FzFullSyllables[i];
    if ContainsText(findItem.sManagedTxt, sManagedTxt) then
    begin
      addItem:= FzOrgItems[i];
      if not addItem.isPredictive then
      begin
        addItem.isPredictive:= True;
        FzOrgItems[i]:= addItem;

        FzPredicted.Add(addItem);
      end;
    end;
  end;

  //sManagedTxt:= TSyllable.getFirstSyllables(FsSearchTxt);
  //초성검색도 입력값 모두와 비교한다.
  //sManagedTxt:= TSyllable.SplitJaMo(FsSearchTxt);
  for i:= 0 to nMax - 1 do
  begin
    findItem:= FzFirstSyllables[i];
    if ContainsText(findItem.sManagedTxt, sManagedTxt) then
    begin
      addItem:= FzOrgItems[i];
      if not addItem.isPredictive then
      begin
        addItem.isPredictive:= True;
        FzOrgItems[i]:= addItem;

        FzPredicted.Add(addItem);
      end;
    end;
  end;

  sManagedTxt:= TSyllable.getEngSyllables(FsSearchTxt);
  for i:= 0 to nMax - 1 do
  begin
    findItem:= FzEngSyllables[i];
    if ContainsText(findItem.sManagedTxt, sManagedTxt) then
    begin
      addItem:= FzOrgItems[i];
      if not addItem.isPredictive then
      begin
        addItem.isPredictive:= True;
        FzOrgItems[i]:= addItem;

        FzPredicted.Add(addItem);
      end;
    end;
  end;

  FzPredicted.Sort;
  if Assigned(OnPredictChange) then
    OnPredictChange(Self);
end;

function TPredictList.find(AItem: TSourceItem): Integer;
var
  i, nMax: Integer;
  scItem: TSourceItem;
begin
  nMax:= count;
  if AItem.sCode = '' then
  begin
    for i:= 0 to nMax - 1 do
    begin
      scItem:= FzOrgItems[i].orgItem;
      if (scItem.sName = AItem.sName) then
        Exit(i);
    end;
  end
  else
  begin
    for i:= 0 to nMax - 1 do
    begin
      scItem:= FzOrgItems[i].orgItem;
      if (scItem.sCode = AItem.sCode) then
        Exit(i);
    end;
  end;
  Result:= -1;
end;

function TPredictList.getCount: Integer;
begin
  Result:= FzOrgItems.Count;
end;

procedure TPredictList.setSearchTxt(const ASearchTxt: string);
begin
  if FsSearchTxt <> ASearchTxt then
  begin
    FsSearchTxt:= ASearchTxt;
    doPredict;
  end
  else
    FsSearchTxt:= ASearchTxt;
end;

end.
