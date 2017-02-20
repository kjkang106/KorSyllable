(********************************************************************************
한글의 음절이란 초성+중성+종성(받침 있는 글자) 혹은 초성+중성(받침 없는 글자)으로
구성된 한글 한 글자를 말한다.
유니코드(Unicode)란 모든 언어를 표현할 수 있는 2바이트의 코드로 유니코드의 한글은
0xAC00 부터 시작하며 한글 음절의 갯수는 (초성 19)*(중성 21)*(종성 28)=11,172 이다.

한글 음절은 아래와 같은 공식으로 유니코드가 부여된다
  음절 유니코드
     = (0xAC00) + (초성 인덱스값* 0x024C) + (중성 인덱스값* 0x001C) + (종성 인덱스값)
     = (0xAC00) + (초성 인덱스값* 21*28) + (중성 인덱스값* 28) + (종성 인덱스값)

초성 19자, 중성 21자, 종성 28자(원래 27자 이지만 종성이 없는 경우까지 해서 28자)
이므로 각각의 인덱스 값과 문자는 아래와 같다. 종성의 첫번쨰 인덱스 문자는 공백
  초성 인덱스값: 0~18 (19개) 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ'
  중성 인덱스값: 0~20 (21개) 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ'
  종성 인덱스값: 0~27 (28개) ' ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ'

초성,중성,종성의 인덱스값을 계산하는 방법은 위 공식을 통하여 쉽게 만들수 있다.
  초성 인덱스값: (음절 유니코드 - 0xAC00) / (21*28)
  중성 인덱스값: (음절 유니코드 - 0xAC00) % (21*28) / 28
  종성 인덱스값: (음절 유니코드 - 0xAC00) % (21*28) % 28  {중간의 "% (21*28)"은 생략가능}

예제들면,
  '가' = (0xAC00) + (0*21*28) + (0*28) + (0) = 0xAC00
  '김' = (0xAC00) + (0*21*28) + (20*28) + (16) = 0xAE40
********************************************************************************)
unit USyllableKor;

interface

uses
  SysUtils;

const
  ChoSungTbl:  WideString = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
  JungSungTbl: WideString = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
  JongSungTbl: WideString = ' ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';
  EngUpTbl : WideString = 'ㅁㅠㅊㅇㄸㄹㅎㅗㅑㅓㅏㅣㅡㅜㅒㅖㅃㄲㄴㅆㅕㅍㅉㅌㅛㅋ';
  EngLowTbl: WideString = 'ㅁㅠㅊㅇㄷㄹㅎㅗㅑㅓㅏㅣㅡㅜㅐㅔㅂㄱㄴㅅㅕㅍㅈㅌㅛㅋ';
  UniCodeHangeulBase = $AC00;
  UniCodeHangeulLast = $D79F;

type
  TSyllable = class
  public
    class function AnsiToUnicode(const Source: AnsiString): WideString;
    class function SplitJaMo(const Source: WideString): WideString; overload;
    class function SplitJaMo(Unicode: WideChar; var ChoSung, JungSung, JongSung: WideChar): Boolean; overload;

    // 초성, 중성, 종성을 가지고 한글자로 조합합니다
    // 예) ㄱ + ㅜ + ㄹ => 굴
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

// Unicode가 한글 음절이면 True를 그렇지 않으면 False를 돌려준다.
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
  ChoSungIdx := Code div (21 * 28);   // 초성 Index
  Code := Code mod (21 * 28);
  JungSungIdx := Code div 28;         // 중성 Index
  JongSungIdx := Code mod 28;         // 종성 Index
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
