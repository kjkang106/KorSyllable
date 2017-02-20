(********************************************************************************
�ѱ��� �����̶� �ʼ�+�߼�+����(��ħ �ִ� ����) Ȥ�� �ʼ�+�߼�(��ħ ���� ����)����
������ �ѱ� �� ���ڸ� ���Ѵ�.
�����ڵ�(Unicode)�� ��� �� ǥ���� �� �ִ� 2����Ʈ�� �ڵ�� �����ڵ��� �ѱ���
0xAC00 ���� �����ϸ� �ѱ� ������ ������ (�ʼ� 19)*(�߼� 21)*(���� 28)=11,172 �̴�.

�ѱ� ������ �Ʒ��� ���� �������� �����ڵ尡 �ο��ȴ�
  ���� �����ڵ�
     = (0xAC00) + (�ʼ� �ε�����* 0x024C) + (�߼� �ε�����* 0x001C) + (���� �ε�����)
     = (0xAC00) + (�ʼ� �ε�����* 21*28) + (�߼� �ε�����* 28) + (���� �ε�����)

�ʼ� 19��, �߼� 21��, ���� 28��(���� 27�� ������ ������ ���� ������ �ؼ� 28��)
�̹Ƿ� ������ �ε��� ���� ���ڴ� �Ʒ��� ����. ������ ù���� �ε��� ���ڴ� ����
  �ʼ� �ε�����: 0~18 (19��) '��������������������������������������'
  �߼� �ε�����: 0~20 (21��) '�������¤äĤŤƤǤȤɤʤˤ̤ͤΤϤФѤҤ�'
  ���� �ε�����: 0~27 (28��) ' ������������������������������������������������������'

�ʼ�,�߼�,������ �ε������� ����ϴ� ����� �� ������ ���Ͽ� ���� ����� �ִ�.
  �ʼ� �ε�����: (���� �����ڵ� - 0xAC00) / (21*28)
  �߼� �ε�����: (���� �����ڵ� - 0xAC00) % (21*28) / 28
  ���� �ε�����: (���� �����ڵ� - 0xAC00) % (21*28) % 28  {�߰��� "% (21*28)"�� ��������}

�������,
  '��' = (0xAC00) + (0*21*28) + (0*28) + (0) = 0xAC00
  '��' = (0xAC00) + (0*21*28) + (20*28) + (16) = 0xAE40
********************************************************************************)
unit USyllableKor;

interface

uses
  SysUtils;

const
  ChoSungTbl:  WideString = '��������������������������������������';
  JungSungTbl: WideString = '�������¤äĤŤƤǤȤɤʤˤ̤ͤΤϤФѤҤ�';
  JongSungTbl: WideString = ' ������������������������������������������������������';
  EngUpTbl : WideString = '���Ф����������Ǥ��ä��ӤѤ̤¤Ƥ��������Ť������ˤ�';
  EngLowTbl: WideString = '���Ф����������Ǥ��ä��ӤѤ̤��Ĥ��������Ť������ˤ�';
  UniCodeHangeulBase = $AC00;
  UniCodeHangeulLast = $D79F;

type
  TSyllable = class
  public
    class function AnsiToUnicode(const Source: AnsiString): WideString;
    class function SplitJaMo(const Source: WideString): WideString; overload;
    class function SplitJaMo(Unicode: WideChar; var ChoSung, JungSung, JongSung: WideChar): Boolean; overload;

    // �ʼ�, �߼�, ������ ������ �ѱ��ڷ� �����մϴ�
    // ��) �� + �� + �� => ��
    class function MergeJaMo(const Source: WideString): WideString; overload;
    class function MergeJaMo(ChoSung, JungSung, JongSung: WideChar): WideChar; overload;

    class function getFirstSyllables(const Source: WideString): WideString;
    class function getEngSyllables(const Source: WideString): WideString;
  end;

implementation

{ TSyllable }
class function TSyllable.AnsiToUnicode(const Source: AnsiString): WideString;
begin
 // Result:= StringToWideChar(Source, Result, Length(Source)+ 1);
  Result:= WideString(Source);
end;

class function TSyllable.SplitJaMo(const Source: WideString): WideString;
var
  I: Integer;
  ChoSung, JungSung, JongSung: WideChar;
begin
  Result:= '';
  if Source = '' then Exit;
  for i := 1 to Length(Source) do
  begin
    if not SplitJaMo(Source[I], ChoSung, JungSung, JongSung) then
      Result:= Result + Source[I]
    else Result:= Result + ChoSung + JungSung + Trim(JongSung);
  end;
end;

// Unicode�� �ѱ� �����̸� True�� �׷��� ������ False�� �����ش�.
class function TSyllable.SplitJaMo(Unicode: WideChar; var ChoSung, JungSung,
  JongSung: WideChar): Boolean;
var
  Code: Cardinal;
  Value, ChoSungIdx, JungSungIdx, JongSungIdx: Integer;
begin
  Result:= True;
  Value:= Integer(UniCode);
  if (Value < UniCodeHangeulBase) or (Value > UniCodeHangeulLast) then
    // (Value > (UniCodeHangeulBase + (19*588)+(21*28) + 28)) then
  begin
    Result:= False;
    Exit;
  end;
  Code:= Value -  UniCodeHangeulBase;
  ChoSungIdx := Code div (21 * 28);   // �ʼ� Index
  Code := Code mod (21 * 28);
  JungSungIdx := Code div 28;         // �߼� Index
  JongSungIdx := Code mod 28;         // ���� Index
  ChoSung:= ChoSungTbl[ChoSungIdx + 1];
  JungSung:= JungSungTbl[JungSungIdx + 1];
  JongSung:= JongSungTbl[JongSungIdx + 1];
end;

class function TSyllable.getEngSyllables(const Source: WideString): WideString;
var
  sSyllables: string;
  nMax, i: Integer;
  idx,nPos: Integer;
begin
  Result:= '';
  sSyllables:= SplitJaMo(Source);

  nMax:= Length(sSyllables);
  for i:= 1 to nMax do
  begin
    nPos:= Pos(sSyllables[i], EngLowTbl);
    if nPos > 0 then
    begin
      idx:= (Ord('a') - 1) + nPos;
      Result:= Result + Char(idx);
    end
    else
    begin
      nPos:= Pos(sSyllables[i], EngUpTbl);
      if nPos > 0 then
      begin
        idx:= (Ord('A') - 1) + nPos;
        Result:= Result + Char(idx);
      end
      else
        Result:= Result + sSyllables[i];
    end;
  end;
end;

class function TSyllable.getFirstSyllables(
  const Source: WideString): WideString;
var
  ChoSung, JungSung, JongSung: WideChar;
  sSyllables: string;
  nMax, i: Integer;
begin
  sSyllables:= '';

  nMax:= Length(Source);
  for i:= 1 to nMax do
  begin
    if SplitJaMo(Source[i], ChoSung, JungSung, JongSung) then
      sSyllables:= sSyllables + ChoSung
    else
      sSyllables:= sSyllables + Source[i];
  end;

  Result:= sSyllables;
end;

class function TSyllable.MergeJaMo(ChoSung, JungSung, JongSung: WideChar): WideChar;
var
  Code, ChoSungIdx, JungSungIdx, JongSungIdx: Integer;
begin
  Result:= #0;
  ChoSungIdx:= Pos(ChoSung, ChoSungTbl) - 1;
  JungSungIdx:= Pos(JungSung, JungSungTbl) - 1;
  JongSungIdx:= Pos(JongSung, JongSungTbl) - 1;
  if (ChoSungIdx = -1) and (JungSungIdx = -1) and (JongSungIdx = -1)  then Exit;
  Code:= UniCodeHangeulBase +(ChoSungIdx * 21 + JungSungIdx) * 28 + JongSungIdx;
  Result:= WideChar(Code);
end;

class function TSyllable.MergeJaMo(const Source: WideString): WideString;
var
  ChoSung, JungSung, JongSung: WideChar;
  sMergeStr: string;
  nMax, i: Integer;
begin
  sMergeStr:= '';

  nMax:= Length(Source);
  ChoSung := ' ';
  JungSung:= ' ';
  JongSung:= ' ';
  for i:= 1 to nMax do
  begin
    if ChoSung = ' ' then
    begin
      if Pos(Source[i], ChoSungTbl) > 0 then
        ChoSung:= Source[i]
      else
        sMergeStr:= sMergeStr + Source[i];
      JungSung:= ' ';
      JongSung:= ' ';
    end
    else if JungSung = ' ' then
    begin
      if Pos(Source[i], JungSungTbl) > 0 then
        JungSung:= Source[i]
      else
      begin
        sMergeStr:= sMergeStr + ChoSung;
        if Pos(Source[i], ChoSungTbl) > 0 then
          ChoSung:= Source[i]
        else
        begin
          sMergeStr:= sMergeStr + ChoSung;
          ChoSung:= ' ';
        end;
      end;
      JongSung:= ' ';
    end
    else
    begin
      if Source[i] = ' ' then
      begin
        sMergeStr:= sMergeStr + MergeJaMo(ChoSung, JungSung, JongSung) + Source[i];
        ChoSung := ' ';
        JungSung:= ' ';
        JongSung:= ' ';
      end
      else if Pos(Source[i], JongSungTbl) > 0 then
      begin
        if (i + 1 <= nMax) and (Pos(Source[i + 1], JungSungTbl) > 0) then
        begin
          sMergeStr:= sMergeStr + MergeJaMo(ChoSung, JungSung, JongSung);
          ChoSung := Source[i];
          JungSung:= ' ';
        end
        else
        begin
          JongSung:= Source[i];
          sMergeStr:= sMergeStr + MergeJaMo(ChoSung, JungSung, JongSung);
          ChoSung := ' ';
          JungSung:= ' ';
          JongSung:= ' ';
        end;
      end
      else
      begin
        if Pos(Source[i], ChoSungTbl) > 0 then
        begin
          sMergeStr:= sMergeStr + MergeJaMo(ChoSung, JungSung, JongSung);
          ChoSung:= Source[i];
        end
        else
        begin
          sMergeStr:= sMergeStr + MergeJaMo(ChoSung, JungSung, JongSung) + Source[i];
          ChoSung := ' ';
        end;
        JungSung:= ' ';
        JongSung:= ' ';
      end;
    end;
  end;
  if JungSung <> ' ' then
    sMergeStr:= sMergeStr + MergeJaMo(ChoSung, JungSung, JongSung)
  else if ChoSung <> ' ' then
    sMergeStr:= sMergeStr + ChoSung;
  Result:= sMergeStr;
end;

end.
