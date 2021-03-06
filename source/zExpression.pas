{ * zExpression                                                                * }
{ ****************************************************************************** }
{ * https://github.com/PassByYou888/CoreCipher                                 * }
{ * https://github.com/PassByYou888/ZServer4D                                  * }
{ * https://github.com/PassByYou888/zExpression                                * }
{ * https://github.com/PassByYou888/zTranslate                                 * }
{ * https://github.com/PassByYou888/zSound                                     * }
{ * https://github.com/PassByYou888/zAnalysis                                  * }
{ * https://github.com/PassByYou888/zGameWare                                  * }
{ * https://github.com/PassByYou888/zRasterization                             * }
{ ****************************************************************************** }
unit zExpression;

{$I zDefine.inc}

interface

uses SysUtils, Variants, CoreClasses, TypInfo, TextParsing, PascalStrings, DoStatusIO, ListEngine, OpCode;

type
  TSymbolOperation = (soAdd, soSub, soMul, soDiv, soMod, soIntDiv, soPow, soOr, soAnd, soXor, // math
    soEqual, soLessThan, soEqualOrLessThan, soGreaterThan, soEqualOrGreaterThan, soNotEqual,  // logic
    soShl, soShr,                                                                             // bit
    soBlockIndentBegin, soBlockIndentEnd,                                                     // block indent
    soPropIndentBegin, soPropIndentEnd,                                                       // property indent
    soDotSymbol, soCommaSymbol,                                                               // dot and comma
    soEolSymbol,                                                                              // eol
    soProc, soParameter,                                                                      // proc
    soUnknow);
  TSymbolOperations = set of TSymbolOperation;

  TExpressionDeclType = (
    edtSymbol,                                                                                 // symbol
    edtBool, edtInt, edtInt64, edtUInt64, edtWord, edtByte, edtSmallInt, edtShortInt, edtUInt, // inbuild byte type
    edtSingle, edtDouble, edtCurrency,                                                         // inbuild float type
    edtString,                                                                                 // string
    edtProcExp,                                                                                // proc
    edtExpressionAsValue,                                                                      // expression
    edtUnknow);

  TExpressionDeclTypes = set of TExpressionDeclType;

  TSymbolExpression = class;

  TExpressionListData = packed record
    DeclType: TExpressionDeclType; // declaration
    charPos: Integer;              // char pos
    Symbol: TSymbolOperation;      // symbol
    Value: Variant;                // value
    Expression: TSymbolExpression; // expression
    ExpressionAutoFree: Boolean;   // autofree
  end;

  PExpressionListData = ^TExpressionListData;

  TNumTextType = (nttBool, nttInt, nttInt64, nttUInt64, nttWord, nttByte, nttSmallInt, nttShortInt, nttUInt, nttSingle, nttDouble, nttCurrency, nttUnknow);

  TSymbolExpression = class sealed(TCoreClassObject)
  protected
    FList: TCoreClassList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    procedure PrintDebug(const detail: Boolean; const prefix: SystemString = ''); {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Decl: SystemString;

    function GetCount(t: TExpressionDeclTypes): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function GetSymbolCount(Operations: TSymbolOperations): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AvailValueCount: Integer;
    function Count: Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    { }
    function InsertSymbol(const idx: Integer; v: TSymbolOperation; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Insert(const idx: Integer; v: TExpressionListData): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    procedure InsertExpression(const idx: Integer; e: TSymbolExpression); {$IFDEF INLINE_ASM} inline; {$ENDIF}
    procedure AddExpression(const e: TSymbolExpression); {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddSymbol(const v: TSymbolOperation; charPos: Integer): PExpressionListData;
    function AddBool(const v: Boolean; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddInt(const v: Integer; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddUInt(const v: Cardinal; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddInt64(const v: int64; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddUInt64(const v: UInt64; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddWord(const v: Word; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddByte(const v: Byte; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddSmallInt(const v: SmallInt; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddShortInt(const v: ShortInt; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddSingle(const v: Single; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddDouble(const v: Double; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddCurrency(const v: Currency; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddString(const v: SystemString; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddFunc(const v: SystemString; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddExpressionAsValue(AutoFree: Boolean; Expression: TSymbolExpression; Symbol: TSymbolOperation; Value: Variant; charPos: Integer): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Add(const v: TExpressionListData): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function AddCopy(const v: TExpressionListData): PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    { }
    procedure Delete(const idx: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
    procedure DeleteLast; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    { }
    function Last: PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function First: PExpressionListData; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    { }
    function IndexOf(p: PExpressionListData): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    { }
    function GetItems(index: Integer): PExpressionListData;
    property Items[index: Integer]: PExpressionListData read GetItems; default;
  end;

  TOnDeclValueCall   = procedure(const Decl: SystemString; var ValType: TExpressionDeclType; var Value: Variant);
  TOnDeclValueMethod = procedure(const Decl: SystemString; var ValType: TExpressionDeclType; var Value: Variant) of object;
  {$IFNDEF FPC}
  TOnDeclValueProc = reference to procedure(const Decl: SystemString; var ValType: TExpressionDeclType; var Value: Variant);
  {$ENDIF FPC}
  //
  { text parse support }
  TExpressionParsingState = set of (esFirst, esWaitOp, esWaitIndentEnd, esWaitPropParamIndentEnd, esWaitValue);
  PExpressionParsingState = ^TExpressionParsingState;

function ParseOperationState(ParsingEng: TTextParsing;
  var cPos, bPos, ePos, BlockIndent, PropIndent: Integer; var pStates: TExpressionParsingState): TSymbolOperation; {$IFDEF INLINE_ASM} inline; {$ENDIF}

function ParseSymbol(ParsingEng: TTextParsing; WorkSym: TSymbolExpression;
  var cPos, bPos, ePos, BlockIndent, PropIndent: Integer; pStates: PExpressionParsingState): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}

function __ParseTextExpressionAsSymbol(ParsingEng: TTextParsing; const uName: SystemString;
  const OnDeclValueCall: TOnDeclValueCall; const OnDeclValueMethod: TOnDeclValueMethod;
  {$IFNDEF FPC} const OnDeclValueProc: TOnDeclValueProc; {$ENDIF FPC}
  RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;

function ParseTextExpressionAsSymbol_C(ParsingEng: TTextParsing; const uName: SystemString;
  const OnGetValue: TOnDeclValueCall; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;

function ParseTextExpressionAsSymbol_M(ParsingEng: TTextParsing; const uName: SystemString;
  const OnGetValue: TOnDeclValueMethod; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;
{$IFNDEF FPC}
function ParseTextExpressionAsSymbol_P(ParsingEng: TTextParsing; const uName: SystemString;
  const OnGetValue: TOnDeclValueProc; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;
{$ENDIF FPC}
function ParseTextExpressionAsSymbol(textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueMethod; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;

function ParseTextExpressionAsSymbol(const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;

function ParseTextExpressionAsSymbol(const ExpressionText: SystemString): TSymbolExpression; overload;

function ParseTextExpressionAsSymbol_M(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueMethod; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;
function ParseTextExpressionAsSymbol_C(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueCall; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;
{$IFNDEF FPC}
function ParseTextExpressionAsSymbol_P(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueProc; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression; overload;
{$ENDIF FPC}

// symbol priority
function RebuildLogicalPrioritySymbol(Exps: TSymbolExpression): TSymbolExpression;

// format symbol
function RebuildAllSymbol(Exps: TSymbolExpression): TSymbolExpression;

// op
function BuildAsOpCode(DebugMode: Boolean; SymbExps: TSymbolExpression; const uName: SystemString; LineNo: Integer): TOpCode; overload;
function BuildAsOpCode(SymbExps: TSymbolExpression): TOpCode; overload;
function BuildAsOpCode(DebugMode: Boolean; SymbExps: TSymbolExpression): TOpCode; overload;
function BuildAsOpCode(DebugMode: Boolean; textStyle: TTextStyle; const ExpressionText: SystemString): TOpCode; overload;
function BuildAsOpCode(textStyle: TTextStyle; const ExpressionText: SystemString): TOpCode; overload;
function BuildAsOpCode(const ExpressionText: SystemString): TOpCode; overload;
function BuildAsOpCode(DebugMode: Boolean; textStyle: TTextStyle; const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TOpCode; overload;
function BuildAsOpCode(textStyle: TTextStyle; const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TOpCode; overload;
function BuildAsOpCode(const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TOpCode; overload;

// evaluate(safe thread)
function EvaluateExpressionValue_M(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const ExpressionText: SystemString; const OnGetValue: TOnDeclValueMethod): Variant;
function EvaluateExpressionValue_C(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const ExpressionText: SystemString; const OnGetValue: TOnDeclValueCall): Variant;
{$IFNDEF FPC}
function EvaluateExpressionValue_P(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const ExpressionText: SystemString; const OnGetValue: TOnDeclValueProc): Variant;
{$ENDIF FPC}
function EvaluateExpressionValue(DebugMode: Boolean; const ExpressionText: SystemString; opRT: TOpCustomRunTime): Variant; overload;
function EvaluateExpressionValue(const ExpressionText: SystemString; opRT: TOpCustomRunTime): Variant; overload;
function EvaluateExpressionValue(DebugMode: Boolean; const ExpressionText: SystemString): Variant; overload;
function EvaluateExpressionValue(const ExpressionText: SystemString): Variant; overload;
function EvaluateExpressionValue(textStyle: TTextStyle; const ExpressionText: SystemString; opRT: TOpCustomRunTime): Variant; overload;

// other
function NumTextType(s: TPascalString): TNumTextType; {$IFDEF INLINE_ASM} inline; {$ENDIF}
procedure InitExp(var v: TExpressionListData); {$IFDEF INLINE_ASM} inline; {$ENDIF}
function dt2op(const v: TExpressionDeclType): TOpValueType; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function VariantToExpressionDeclType(var v: Variant): TExpressionDeclType; {$IFDEF INLINE_ASM} inline; {$ENDIF}

var
  OpCache          : THashObjectList;
  SpecialAsciiToken: TListPascalString;

implementation


const
  MethodToken: TExpressionDeclTypes = ([edtProcExp]);

  AllExpressionValueType: TExpressionDeclTypes = ([
    edtBool, edtInt, edtInt64, edtUInt64, edtWord, edtByte, edtSmallInt, edtShortInt, edtUInt,
    edtSingle, edtDouble, edtCurrency,
    edtString, edtProcExp,
    edtExpressionAsValue]);

  SymbolOperationPriority: array [0 .. 3] of TSymbolOperations = (
    ([soOr, soAnd, soXor]),
    ([soEqual, soLessThan, soEqualOrLessThan, soGreaterThan, soEqualOrGreaterThan, soNotEqual]),
    ([soAdd, soSub]),
    ([soMul, soDiv, soMod, soIntDiv, soShl, soShr, soPow]));

  AllowPrioritySymbol: TSymbolOperations = ([
    soAdd, soSub, soMul, soDiv, soMod, soIntDiv, soPow, soOr, soAnd, soXor,
    soEqual, soLessThan, soEqualOrLessThan, soGreaterThan, soEqualOrGreaterThan, soNotEqual,
    soShl, soShr,
    soDotSymbol, soCommaSymbol]);

  OpLogicalSymbol: TSymbolOperations = ([
    soAdd, soSub, soMul, soDiv, soMod, soIntDiv, soPow, soOr, soAnd, soXor,
    soEqual, soLessThan, soEqualOrLessThan, soGreaterThan, soEqualOrGreaterThan, soNotEqual,
    soShl, soShr]);

type
  TSymbolOperationType = packed record
    State: TSymbolOperation;
    Decl: SystemString;
  end;

const
  SymbolOperationTextDecl: array [TSymbolOperation] of TSymbolOperationType = (
    (State: soAdd; Decl: '+'),
    (State: soSub; Decl: '-'),
    (State: soMul; Decl: '*'),
    (State: soDiv; Decl: '/'),
    (State: soMod; Decl: ' mod '),
    (State: soIntDiv; Decl: ' div '),
    (State: soPow; Decl: '^'),
    (State: soOr; Decl: ' or '),
    (State: soAnd; Decl: ' and '),
    (State: soXor; Decl: ' xor '),
    (State: soEqual; Decl: ' = '),
    (State: soLessThan; Decl: ' < '),
    (State: soEqualOrLessThan; Decl: ' <= '),
    (State: soGreaterThan; Decl: ' > '),
    (State: soEqualOrGreaterThan; Decl: ' => '),
    (State: soNotEqual; Decl: ' <> '),
    (State: soShl; Decl: ' shl '),
    (State: soShr; Decl: ' shr '),
    (State: soBlockIndentBegin; Decl: '('),
    (State: soBlockIndentEnd; Decl: ')'),
    (State: soPropIndentBegin; Decl: '['),
    (State: soPropIndentEnd; Decl: ']'),
    (State: soDotSymbol; Decl: '.'),
    (State: soCommaSymbol; Decl: ','),
    (State: soEolSymbol; Decl: ';'),
    (State: soProc; Decl: '|Proc|'),
    (State: soParameter; Decl: ','),
    (State: soUnknow; Decl: '?')
    );

function NumTextType(s: TPascalString): TNumTextType;
type
  TValSym = (vsSymSub, vsSymAdd, vsSymAddSub, vsSymDollar, vsDot, vsDotBeforNum, vsDotAfterNum, vsNum, vsAtoF, vsE, vsUnknow);
var
  cnt: array [TValSym] of Integer;
  v  : TValSym;
  c  : SystemChar;
  i  : Integer;
begin
  if s.Same('true') or s.Same('false') then
      Exit(nttBool);

  for v := low(TValSym) to high(TValSym) do
      cnt[v] := 0;

  for i := 1 to s.Len do
    begin
      c := s[i];
      if CharIn(c, [c0to9]) then
        begin
          Inc(cnt[vsNum]);
          if cnt[vsDot] > 0 then
              Inc(cnt[vsDotAfterNum]);
        end
      else if CharIn(c, [cLoAtoF, cHiAtoF]) then
        begin
          Inc(cnt[vsAtoF]);
          if CharIn(c, 'eE') then
              Inc(cnt[vsE]);
        end
      else if c = '.' then
        begin
          Inc(cnt[vsDot]);
          cnt[vsDotBeforNum] := cnt[vsNum];
        end
      else if CharIn(c, '-') then
        begin
          Inc(cnt[vsSymSub]);
          Inc(cnt[vsSymAddSub]);
        end
      else if CharIn(c, '+') then
        begin
          Inc(cnt[vsSymAdd]);
          Inc(cnt[vsSymAddSub]);
        end
      else if CharIn(c, '$') and (i = 1) then
          Inc(cnt[vsSymDollar])
      else
          Exit(nttUnknow);
    end;

  if cnt[vsDot] > 1 then
      Exit(nttUnknow);
  if cnt[vsSymDollar] > 1 then
      Exit(nttUnknow);
  if (cnt[vsSymDollar] = 0) and (cnt[vsNum] = 0) then
      Exit(nttUnknow);
  if (cnt[vsSymAdd] > 1) and (cnt[vsE] = 0) and (cnt[vsSymDollar] = 0) then
      Exit(nttUnknow);

  if (cnt[vsSymDollar] = 0) and
    ((cnt[vsDot] = 1) or ((cnt[vsE] = 1) and ((cnt[vsSymAddSub] >= 1) and (cnt[vsSymDollar] = 0)))) then
    begin
      if cnt[vsSymDollar] > 0 then
          Exit(nttUnknow);
      if (cnt[vsAtoF] <> cnt[vsE]) then
          Exit(nttUnknow);

      if cnt[vsE] = 1 then
        begin
          Result := nttDouble
        end
      else if ((cnt[vsDotBeforNum] > 0)) and (cnt[vsDotAfterNum] > 0) then
        begin
          if cnt[vsDotAfterNum] < 5 then
              Result := nttCurrency
          else if cnt[vsNum] > 7 then
              Result := nttDouble
          else
              Result := nttSingle;
        end
      else
          Exit(nttUnknow);
    end
  else
    begin
      if cnt[vsSymDollar] = 1 then
        begin
          if cnt[vsSymSub] > 0 then
            begin
              if cnt[vsNum] + cnt[vsAtoF] < 2 then
                  Result := nttShortInt
              else if cnt[vsNum] + cnt[vsAtoF] < 4 then
                  Result := nttSmallInt
              else if cnt[vsNum] + cnt[vsAtoF] < 7 then
                  Result := nttInt
              else if cnt[vsNum] + cnt[vsAtoF] < 13 then
                  Result := nttInt64
              else
                  Result := nttUnknow;
            end
          else
            begin
              if cnt[vsNum] + cnt[vsAtoF] < 3 then
                  Result := nttByte
              else if cnt[vsNum] + cnt[vsAtoF] < 5 then
                  Result := nttWord
              else if cnt[vsNum] + cnt[vsAtoF] < 8 then
                  Result := nttUInt
              else if cnt[vsNum] + cnt[vsAtoF] < 14 then
                  Result := nttUInt64
              else
                  Result := nttUnknow;
            end;
        end
      else if cnt[vsAtoF] > 0 then
          Exit(nttUnknow)
      else if cnt[vsSymSub] > 0 then
        begin
          if cnt[vsNum] < 3 then
              Result := nttShortInt
          else if cnt[vsNum] < 5 then
              Result := nttSmallInt
          else if cnt[vsNum] < 8 then
              Result := nttInt
          else if cnt[vsNum] < 15 then
              Result := nttInt64
          else
              Result := nttUnknow;
        end
      else
        begin
          if cnt[vsNum] < 3 then
              Result := nttByte
          else if cnt[vsNum] < 5 then
              Result := nttWord
          else if cnt[vsNum] < 8 then
              Result := nttUInt
          else if cnt[vsNum] < 16 then
              Result := nttUInt64
          else
              Result := nttUnknow;
        end;
    end;
end;

procedure InitExp(var v: TExpressionListData);
begin
  v.DeclType := edtUnknow;
  v.charPos := -1;
  v.Symbol := soUnknow;
  v.Value := NULL;
  v.Expression := nil;
  v.ExpressionAutoFree := False;
end;

function dt2op(const v: TExpressionDeclType): TOpValueType;
begin
  case v of
    edtBool: Result := ovtBool;
    edtInt: Result := ovtInt;
    edtInt64: Result := ovtInt64;
    edtUInt64: Result := ovtUInt64;
    edtWord: Result := ovtWord;
    edtByte: Result := ovtByte;
    edtSmallInt: Result := ovtSmallInt;
    edtShortInt: Result := ovtShortInt;
    edtUInt: Result := ovtUInt;
    edtSingle: Result := ovtSingle;
    edtDouble: Result := ovtDouble;
    edtCurrency: Result := ovtCurrency;
    edtString: Result := ovtString;
    edtProcExp: Result := ovtProc;
    else Result := ovtUnknow;
  end;
end;

function ParseOperationState(ParsingEng: TTextParsing;
  var cPos, bPos, ePos, BlockIndent, PropIndent: Integer; var pStates: TExpressionParsingState): TSymbolOperation;

var
  c   : SystemChar;
  Decl: TPascalString;
  p   : PExpressionListData;
begin
  Result := soUnknow;
  if not(esWaitOp in pStates) then
      Exit;

  while cPos <= ParsingEng.Len do
    begin
      if ParsingEng.isComment(cPos) then
        begin
          cPos := ParsingEng.GetCommentEndPos(cPos);
          continue;
        end;

      c := ParsingEng.ParsingData.Text[cPos];
      bPos := cPos;

      if (CharIn(c, ';')) then
        begin
          Inc(cPos);
          Result := soEolSymbol;
          Exit;
        end;

      if (CharIn(c, ',')) then
        begin
          Inc(cPos);
          pStates := pStates - [esWaitOp] + [esWaitValue];
          Result := soCommaSymbol;
          Exit;
        end;

      if CharIn(c, ')') then
        begin
          Inc(cPos);
          if (esWaitIndentEnd in pStates) then
            begin
              Dec(BlockIndent);
              if BlockIndent < 0 then
                begin
                  pStates := pStates - [esWaitOp, esWaitIndentEnd];
                  Result := soBlockIndentEnd;
                  Exit;
                end
              else if BlockIndent = 0 then
                  pStates := pStates - [esWaitIndentEnd];

              pStates := pStates + [esWaitOp];
              Result := soBlockIndentEnd;
              Exit;
            end
          else
            begin
              pStates := pStates - [esWaitOp, esWaitIndentEnd];
              Result := soBlockIndentEnd;
              Exit;
            end;
        end;

      if CharIn(c, ']') then
        begin
          Inc(cPos);
          if (esWaitPropParamIndentEnd in pStates) then
            begin
              Dec(PropIndent);
              if PropIndent < 0 then
                begin
                  pStates := pStates - [esWaitOp, esWaitPropParamIndentEnd];
                  Result := soPropIndentEnd;
                  Exit;
                end
              else if PropIndent = 0 then
                  pStates := pStates - [esWaitPropParamIndentEnd];

              pStates := pStates + [esWaitOp];
              Result := soPropIndentEnd;
              Exit;
            end
          else
            begin
              pStates := pStates - [esWaitOp, esWaitPropParamIndentEnd];
              Result := soPropIndentEnd;
              Exit;
            end;
        end;

      if CharIn(c, '(') then
        begin
          Inc(cPos);
          Inc(BlockIndent);
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue, esWaitIndentEnd];

          Result := soBlockIndentBegin;
          Exit;
        end;

      if CharIn(c, '[') then
        begin
          Inc(cPos);
          Inc(PropIndent);
          Result := soPropIndentBegin;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue, esWaitPropParamIndentEnd];
          Exit;
        end;

      if (ParsingEng.ComparePosStr(cPos, '>=')) or (ParsingEng.ComparePosStr(cPos, '=>')) then
        begin
          Inc(cPos, 2);
          Result := soEqualOrGreaterThan;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '<=')) or (ParsingEng.ComparePosStr(cPos, '=<')) then
        begin
          Inc(cPos, 2);
          Result := soEqualOrLessThan;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '<>')) or (ParsingEng.ComparePosStr(cPos, '><')) or (ParsingEng.ComparePosStr(cPos, '!=')) then
        begin
          Inc(cPos, 2);
          Result := soNotEqual;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '==')) then
        begin
          Inc(cPos, 2);
          Result := soEqual;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '&&')) then
        begin
          Inc(cPos, 2);
          Result := soAnd;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '||')) then
        begin
          Inc(cPos, 2);
          Result := soOr;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '<<')) then
        begin
          Inc(cPos, 2);
          Result := soShl;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;
      if (ParsingEng.ComparePosStr(cPos, '>>')) then
        begin
          Inc(cPos, 2);
          Result := soShr;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;

      if CharIn(c, '+-*/^=><.,&|%') then
        begin
          if c = '+' then
              Result := soAdd
          else if c = '-' then
              Result := soSub
          else if c = '*' then
              Result := soMul
          else if c = '/' then
              Result := soDiv
          else if c = '^' then
              Result := soPow
          else if c = '=' then
              Result := soEqual
          else if c = '>' then
              Result := soGreaterThan
          else if c = '<' then
              Result := soLessThan
          else if c = '.' then
              Result := soDotSymbol
          else if c = ',' then
              Result := soCommaSymbol
          else if c = '&' then
              Result := soAnd
          else if c = '|' then
              Result := soOr
          else if c = '%' then
              Result := soMod;
          Inc(cPos);
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;

      if (ParsingEng.isAscii(cPos)) then
        begin
          bPos := cPos;
          ePos := ParsingEng.GetAsciiEndPos(cPos);
          Decl := ParsingEng.GetStr(bPos, ePos);

          if Decl.Same('or') then
              Result := soOr
          else if Decl.Same('and') then
              Result := soAnd
          else if Decl.Same('xor') then
              Result := soXor
          else if Decl.Same('div') then
              Result := soIntDiv
          else if Decl.Same('idiv') then
              Result := soIntDiv
          else if Decl.Same('intdiv') then
              Result := soIntDiv
          else if Decl.Same('fdiv') then
              Result := soDiv
          else if Decl.Same('floatdiv') then
              Result := soDiv
          else if Decl.Same('mod') then
              Result := soMod
          else if Decl.Same('shl') then
              Result := soShl
          else if Decl.Same('shr') then
              Result := soShr
          else
            begin
              Result := soUnknow;
              Exit;
            end;

          cPos := ePos;
          pStates := pStates - [esWaitOp];
          pStates := pStates + [esWaitValue];
          Exit;
        end;

      if ParsingEng.isNumber(cPos) then
        begin
          Result := soUnknow;
          Exit;
        end;

      Inc(cPos);
    end;
  pStates := [];
  Result := soEolSymbol;
end;

function ParseSymbol(ParsingEng: TTextParsing; WorkSym: TSymbolExpression;
  var cPos, bPos, ePos, BlockIndent, PropIndent: Integer; pStates: PExpressionParsingState): Boolean;
var
  bak_cPos: Integer;
  Decl    : SystemString;
  OpState : TSymbolOperation;
  rv      : Variant;
  robj    : TCoreClassObject;
  p       : PExpressionListData;
begin
  while cPos <= ParsingEng.Len do
    begin
      pStates^ := pStates^ - [esWaitValue, esFirst];
      pStates^ := pStates^ + [esWaitOp];

      bak_cPos := cPos;
      OpState := ParseOperationState(ParsingEng, cPos, bPos, ePos, BlockIndent, PropIndent, pStates^);

      case OpState of
        soUnknow, soEolSymbol:
          begin
            Result := False;
            Exit;
          end;
        soDotSymbol:
          begin
            Result := False;
            Exit;
          end;
        soCommaSymbol:
          begin
            WorkSym.AddSymbol(OpState, bak_cPos);
            Result := True;
            Exit;
          end;
        soPropIndentBegin:
          begin
            WorkSym.AddSymbol(OpState, bak_cPos);
            Result := True;
            Exit;
          end;
        soPropIndentEnd:
          begin
            WorkSym.AddSymbol(OpState, bak_cPos);
            Result := True;
            Exit;
          end;
        soBlockIndentEnd:
          begin
            WorkSym.AddSymbol(OpState, bak_cPos);
            Result := True;
            Exit;
          end;
        soBlockIndentBegin:
          begin
            WorkSym.AddSymbol(OpState, bak_cPos);
            Result := True;
            Exit;
          end;
        else
          begin
            WorkSym.AddSymbol(OpState, bak_cPos);
            Result := True;
            Exit;
          end;
      end;
    end;
  Result := False;
end;

function __ParseTextExpressionAsSymbol(ParsingEng: TTextParsing; const uName: SystemString;
  const OnDeclValueCall: TOnDeclValueCall; const OnDeclValueMethod: TOnDeclValueMethod;
  {$IFNDEF FPC} const OnDeclValueProc: TOnDeclValueProc; {$ENDIF FPC}
  RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;

  procedure PrintError(const s: SystemString);
  begin
    if s = '' then
        DoStatus('declaration error', [])
    else
        DoStatus('declaration error %s', [s]);
    DoStatus('');
  end;

  function GetDeclValue(const Decl: SystemString; var v: Variant): TExpressionDeclType;
  begin
    v := Decl;
    Result := edtProcExp;

    if Assigned(OnDeclValueCall) then
        OnDeclValueCall(Decl, Result, v);
    if Assigned(OnDeclValueMethod) then
        OnDeclValueMethod(Decl, Result, v);
    {$IFNDEF FPC}
    if Assigned(OnDeclValueProc) then
        OnDeclValueProc(Decl, Result, v);
    {$ENDIF FPC}
  end;

  function FillProc(var ExpIndex: Integer; const Exps, procExp: TSymbolExpression): TSymbolExpression;
  var
    WasProc         : Boolean;
    LocalExp, ResExp: TSymbolExpression;
    p1, p2, p       : PExpressionListData;
  begin
    if ExpIndex >= Exps.Count then
      begin
        Result := nil;
        Exit;
      end;

    WasProc := procExp <> nil;

    if WasProc then
        LocalExp := procExp.AddExpressionAsValue(True, TSymbolExpression.Create, soParameter, 'param_1', Exps[ExpIndex]^.charPos)^.Expression
    else
        LocalExp := TSymbolExpression.Create;

    Result := LocalExp;

    while ExpIndex < Exps.Count do
      begin
        p1 := Exps[ExpIndex];

        if ExpIndex + 1 < Exps.Count then
            p2 := Exps[ExpIndex + 1]
        else
            p2 := nil;

        if (p1^.DeclType = edtProcExp) then
          begin
            if p2 <> nil then
              begin
                if (p2^.DeclType = edtSymbol) and (p2^.Symbol in [soBlockIndentBegin, soPropIndentBegin]) then
                  begin
                    Inc(ExpIndex, 2);
                    p := LocalExp.AddFunc(p1^.Value, p1^.charPos);
                    FillProc(ExpIndex, Exps, p^.Expression);
                    continue;
                  end;
              end
            else
              begin
                Result.AddFunc(p1^.Value, p1^.charPos);
                Inc(ExpIndex);
                continue;
              end;
          end;

        if (p1^.DeclType = edtSymbol) then
          begin
            if p1^.Symbol in [soBlockIndentBegin, soPropIndentBegin] then
              begin
                Inc(ExpIndex);
                ResExp := FillProc(ExpIndex, Exps, nil);
                if ResExp <> nil then
                    LocalExp.AddExpressionAsValue(True, ResExp, soBlockIndentBegin, p1^.Symbol, p1^.charPos);
                continue;
              end;
            if p1^.Symbol in [soBlockIndentEnd, soPropIndentEnd] then
              begin
                Inc(ExpIndex);
                Exit;
              end;
            if (p1^.Symbol in [soCommaSymbol]) then
              begin
                if not WasProc then
                  begin
                    PrintError('comma Illegal');
                    Exit;
                  end;

                LocalExp := procExp.AddExpressionAsValue(True, TSymbolExpression.Create, soParameter, 'param_' + IntToStr(procExp.Count + 1),
                  Exps[ExpIndex]^.charPos)^.Expression;
                Inc(ExpIndex);
                continue;
              end;
          end;

        LocalExp.AddCopy(p1^);
        Inc(ExpIndex);
      end;
  end;

var
  cPos, bPos, ePos, i                                     : Integer;
  State                                                   : TExpressionParsingState;
  BlockIndent, PropIndent                                 : Integer;
  Container                                               : TSymbolExpression;
  te                                                      : TTextParsing;
  Decl                                                    : TPascalString;
  OpState                                                 : TSymbolOperation;
  isNumber, isSpecialSymbol, isAscii, isTextDecl, isSymbol: Boolean;
  rv                                                      : Variant;
  p                                                       : PExpressionListData;
begin
  Result := nil;

  if ParsingEng.ParsingData.Len < 1 then
      Exit;

  cPos := 1;
  BlockIndent := 0;
  PropIndent := 0;
  State := [esFirst];
  Container := TSymbolExpression.Create;

  while cPos <= ParsingEng.Len do
    begin
      if ParsingEng.isComment(cPos) then
        begin
          cPos := ParsingEng.GetCommentEndPos(cPos);
          continue;
        end;

      isSpecialSymbol := ParsingEng.isSpecialSymbol(cPos);
      if isSpecialSymbol then
        begin
          isNumber := False;
          isTextDecl := False;
          isAscii := False;
          isSymbol := False;
        end
      else
        begin
          isNumber := ParsingEng.isNumber(cPos);
          isTextDecl := ParsingEng.isTextDecl(cPos);
          isAscii := ParsingEng.isAscii(cPos);
          isSymbol := ParsingEng.isSymbol(cPos);
        end;

      if (not(esWaitOp in State)) and (isSpecialSymbol or isNumber or isTextDecl or isAscii) then
        begin
          if not((esWaitValue in State) or (esFirst in State)) then
            begin
              PrintError('');
              break;
            end;

          bPos := cPos;
          if isSpecialSymbol then
            begin
              ePos := ParsingEng.GetSpecialSymbolEndPos(cPos);
              if ParsingEng.GetAsciiBeginPos(ePos) <= ePos then
                  ePos := ParsingEng.GetSpecialSymbolEndPos(ParsingEng.GetAsciiEndPos(ePos));
            end
          else if isNumber then
              ePos := ParsingEng.GetNumberEndPos(cPos)
          else if isTextDecl then
              ePos := ParsingEng.GetTextDeclEndPos(cPos)
          else
              ePos := ParsingEng.GetAsciiEndPos(cPos);
          cPos := ePos;

          Decl := ParsingEng.GetStr(bPos, ePos);
          if isNumber then
            begin
              if Decl.ComparePos(1, '0x') then
                begin
                  Decl.DeleteFirst;
                  Decl[1] := '$';
                end;
              case NumTextType(Decl) of
                nttBool: Container.AddBool(StrToBool(Decl), bPos);
                nttInt: Container.AddInt(StrToInt(Decl), bPos);
                nttInt64: Container.AddInt64(StrToInt64(Decl), bPos);
                {$IFDEF FPC}
                nttUInt64: Container.AddUInt64(StrToQWord(Decl), bPos);
                {$ELSE}
                nttUInt64: Container.AddUInt64(StrToUInt64(Decl), bPos);
                {$ENDIF}
                nttWord: Container.AddWord(StrToInt(Decl), bPos);
                nttByte: Container.AddByte(StrToInt(Decl), bPos);
                nttSmallInt: Container.AddSmallInt(StrToInt(Decl), bPos);
                nttShortInt: Container.AddShortInt(StrToInt(Decl), bPos);
                nttUInt: Container.AddUInt(StrToInt(Decl), bPos);
                nttSingle: Container.AddSingle(StrToFloat(Decl), bPos);
                nttDouble: Container.AddDouble(StrToFloat(Decl), bPos);
                nttCurrency: Container.AddCurrency(StrToFloat(Decl), bPos);
                else
                  begin
                    PrintError(Format('number expression "%s" Illegal', [Decl.Text]));
                    break;
                  end;
              end;
            end
          else if isTextDecl then
            begin
              Container.AddString(ParsingEng.GetTextBody(Decl), bPos);
            end
          else
            case NumTextType(Decl) of
              nttBool: Container.AddBool(StrToBool(Decl), bPos);
              nttInt: Container.AddInt(StrToInt(Decl), bPos);
              nttInt64: Container.AddInt64(StrToInt64(Decl), bPos);
              {$IFDEF FPC}
              nttUInt64: Container.AddUInt64(StrToQWord(Decl), bPos);
              {$ELSE}
              nttUInt64: Container.AddUInt64(StrToUInt64(Decl), bPos);
              {$ENDIF}
              nttWord: Container.AddWord(StrToInt(Decl), bPos);
              nttByte: Container.AddByte(StrToInt(Decl), bPos);
              nttSmallInt: Container.AddSmallInt(StrToInt(Decl), bPos);
              nttShortInt: Container.AddShortInt(StrToInt(Decl), bPos);
              nttUInt: Container.AddUInt(StrToInt(Decl), bPos);
              nttSingle: Container.AddSingle(StrToFloat(Decl), bPos);
              nttDouble: Container.AddDouble(StrToFloat(Decl), bPos);
              nttCurrency: Container.AddCurrency(StrToFloat(Decl), bPos);
              else
                begin
                  case GetDeclValue(Decl, rv) of
                    edtBool: Container.AddBool(rv, bPos);
                    edtInt: Container.AddInt(rv, bPos);
                    edtInt64: Container.AddInt64(rv, bPos);
                    edtUInt64: Container.AddUInt64(rv, bPos);
                    edtWord: Container.AddWord(rv, bPos);
                    edtByte: Container.AddByte(rv, bPos);
                    edtSmallInt: Container.AddSmallInt(rv, bPos);
                    edtShortInt: Container.AddShortInt(rv, bPos);
                    edtUInt: Container.AddUInt(rv, bPos);
                    edtSingle: Container.AddSingle(rv, bPos);
                    edtDouble: Container.AddDouble(rv, bPos);
                    edtCurrency: Container.AddCurrency(rv, bPos);
                    edtString: Container.AddString(rv, bPos);
                    edtProcExp:
                      begin
                        if (RefrenceOpRT <> nil) and (not RefrenceOpRT.ProcList.Exists(rv)) then
                          if (DefaultOpRT <> RefrenceOpRT) and (not DefaultOpRT.ProcList.Exists(rv)) then
                            begin
                              PrintError(Format('function "%s" Illegal', [rv]));
                              break;
                            end;
                        Container.AddFunc(rv, bPos);
                      end;
                    else
                      begin
                        PrintError(Format('define "%s" Illegal', [Decl.Text]));
                        break;
                      end;
                  end;
                end;
            end;
          if not ParseSymbol(ParsingEng, Container, cPos, bPos, ePos, BlockIndent, PropIndent, @State) then
              break
          else
              continue;
        end;

      if (isSymbol) then
        begin
          if not ParseSymbol(ParsingEng, Container, cPos, bPos, ePos, BlockIndent, PropIndent, @State) then
              break
          else
              continue;
        end;

      Inc(cPos);
    end;

  if (BlockIndent + PropIndent = 0) then
    begin
      i := 0;
      Result := FillProc(i, Container, nil);
      if Result = nil then
          PrintError('indent error');
    end
  else
      PrintError('indent error');

  DisposeObject(Container);
end;

function ParseTextExpressionAsSymbol_C(ParsingEng: TTextParsing; const uName: SystemString;
  const OnGetValue: TOnDeclValueCall; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
begin
  {$IFDEF FPC}
  Result := __ParseTextExpressionAsSymbol(ParsingEng, uName, OnGetValue, nil, RefrenceOpRT);
  {$ELSE }
  Result := __ParseTextExpressionAsSymbol(ParsingEng, uName, OnGetValue, nil, nil, RefrenceOpRT);
  {$ENDIF FPC}
end;

function ParseTextExpressionAsSymbol_M(ParsingEng: TTextParsing; const uName: SystemString;
  const OnGetValue: TOnDeclValueMethod; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
begin
  {$IFDEF FPC}
  Result := __ParseTextExpressionAsSymbol(ParsingEng, uName, nil, OnGetValue, RefrenceOpRT);
  {$ELSE }
  Result := __ParseTextExpressionAsSymbol(ParsingEng, uName, nil, OnGetValue, nil, RefrenceOpRT);
  {$ENDIF FPC}
end;

{$IFNDEF FPC}


function ParseTextExpressionAsSymbol_P(ParsingEng: TTextParsing; const uName: SystemString;
  const OnGetValue: TOnDeclValueProc; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
begin
  Result := __ParseTextExpressionAsSymbol(ParsingEng, uName, nil, nil, OnGetValue, RefrenceOpRT);
end;
{$ENDIF FPC}


function ParseTextExpressionAsSymbol(textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueMethod; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
var
  ParsingEng: TTextParsing;
begin
  ParsingEng := TTextParsing.Create(ExpressionText, textStyle, SpecialAsciiToken);
  Result := ParseTextExpressionAsSymbol_M(ParsingEng, uName, OnGetValue, RefrenceOpRT);
  DisposeObject(ParsingEng);
end;

function ParseTextExpressionAsSymbol(const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
var
  ParsingEng: TTextParsing;
begin
  ParsingEng := TTextParsing.Create(ExpressionText, tsPascal, SpecialAsciiToken);
  Result := ParseTextExpressionAsSymbol_M(ParsingEng, '', nil, RefrenceOpRT);
  DisposeObject(ParsingEng);
end;

function ParseTextExpressionAsSymbol(const ExpressionText: SystemString): TSymbolExpression;
var
  ParsingEng: TTextParsing;
begin
  ParsingEng := TTextParsing.Create(ExpressionText, tsPascal, SpecialAsciiToken);
  Result := ParseTextExpressionAsSymbol_M(ParsingEng, '', nil, DefaultOpRT);
  DisposeObject(ParsingEng);
end;

function ParseTextExpressionAsSymbol_M(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueMethod; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
var
  ParsingEng: TTextParsing;
begin
  ParsingEng := TextEngClass.Create(ExpressionText, textStyle, SpecialAsciiToken);
  Result := ParseTextExpressionAsSymbol_M(ParsingEng, '', OnGetValue, RefrenceOpRT);
  DisposeObject(ParsingEng);
end;

function ParseTextExpressionAsSymbol_C(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueCall; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
var
  ParsingEng: TTextParsing;
begin
  ParsingEng := TextEngClass.Create(ExpressionText, textStyle, SpecialAsciiToken);
  Result := ParseTextExpressionAsSymbol_C(ParsingEng, '', OnGetValue, RefrenceOpRT);
  DisposeObject(ParsingEng);
end;

{$IFNDEF FPC}


function ParseTextExpressionAsSymbol_P(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const uName, ExpressionText: SystemString;
  const OnGetValue: TOnDeclValueProc; RefrenceOpRT: TOpCustomRunTime): TSymbolExpression;
var
  ParsingEng: TTextParsing;
begin
  ParsingEng := TextEngClass.Create(ExpressionText, textStyle, SpecialAsciiToken);
  Result := ParseTextExpressionAsSymbol_P(ParsingEng, '', OnGetValue, RefrenceOpRT);
  DisposeObject(ParsingEng);
end;
{$ENDIF FPC}


function RebuildLogicalPrioritySymbol(Exps: TSymbolExpression): TSymbolExpression;
  function SymbolPriority(s1, s2: TSymbolOperation): Integer;

    function FindSymbol(s: TSymbolOperation): Integer;
    var
      i: Integer;
    begin
      for i := low(SymbolOperationPriority) to high(SymbolOperationPriority) do
        if s in SymbolOperationPriority[i] then
            Exit(i);
      raise Exception.Create('no define symbol');
    end;

  begin
    if (s1 in [soUnknow, soCommaSymbol]) or (s2 in [soUnknow, soCommaSymbol]) then
        Exit(0);
    Result := FindSymbol(s2) - FindSymbol(s1);
  end;

var
  SymbolIndex  : Integer;
  newExpression: TSymbolExpression;
  ParseAborted : Boolean;

  procedure PrintError(const s: SystemString);
  begin
    ParseAborted := True;
    if s <> '' then
        DoStatus(Format('Priority symbol failed : %s', [s]))
    else
        DoStatus('Priority symbol failed');
  end;

  procedure ProcessSymbol(OwnerSym: TSymbolOperation);
  var
    p1, p2, startIndent, lastIndent            : PExpressionListData;
    lastSym, lastIndentSym                     : TSymbolOperation;
    LastSymbolPriority, LastOwnerSymbolPriority: Integer;
  begin
    if ParseAborted then
        Exit;
    if SymbolIndex >= Exps.Count then
        Exit;

    if newExpression.Count > 0 then
        startIndent := newExpression.Last
    else
        startIndent := nil;

    lastSym := OwnerSym;
    lastIndent := nil;
    lastIndentSym := OwnerSym;

    while True do
      begin
        if ParseAborted then
            break;

        if SymbolIndex >= Exps.Count then
            break;

        p1 := Exps[SymbolIndex];

        if (p1^.DeclType in AllExpressionValueType) then
          begin
            Inc(SymbolIndex);
            if SymbolIndex >= Exps.Count then
              begin
                newExpression.Add(p1^);
                break;
              end;

            p2 := Exps[SymbolIndex];

            if (p1^.DeclType in MethodToken) and (p2^.DeclType = edtExpressionAsValue) then
              begin
                newExpression.Add(p1^);
                newExpression.Add(p2^);
              end
            else if p2^.DeclType = edtSymbol then
              begin
                if p2^.Symbol in AllowPrioritySymbol then
                  begin
                    LastOwnerSymbolPriority := SymbolPriority(p2^.Symbol, OwnerSym);
                    LastSymbolPriority := SymbolPriority(p2^.Symbol, lastSym);

                    if LastOwnerSymbolPriority > 0 then
                      begin
                        newExpression.Add(p1^);
                        break;
                      end;

                    if LastSymbolPriority < 0 then
                      begin
                        lastIndent := newExpression.AddSymbol(soBlockIndentBegin, p1^.charPos);
                        lastIndentSym := lastSym;
                        newExpression.Add(p1^);
                        newExpression.Add(p2^);

                        Inc(SymbolIndex);
                        ProcessSymbol(p2^.Symbol);
                        newExpression.AddSymbol(soBlockIndentEnd, p2^.charPos);

                        continue;
                      end
                    else if LastSymbolPriority > 0 then
                      begin
                        if startIndent = nil then
                            startIndent := newExpression.First;

                        newExpression.InsertSymbol(newExpression.IndexOf(startIndent), soBlockIndentBegin, startIndent^.charPos);
                        newExpression.Add(p1^);
                        newExpression.AddSymbol(soBlockIndentEnd, p2^.charPos);
                        newExpression.Add(p2^);
                      end
                    else
                      begin
                        newExpression.Add(p1^);
                        newExpression.Add(p2^);
                      end;
                    lastSym := p2^.Symbol;
                  end
                else
                  begin
                    PrintError(SymbolOperationTextDecl[p2^.Symbol].Decl);
                    Exit;
                  end;
              end;
          end
        else if (p1^.DeclType = edtSymbol) then
          begin
            Inc(SymbolIndex);
            if SymbolIndex >= Exps.Count then
              begin
                newExpression.Add(p1^);
                break;
              end;

            p2 := Exps[SymbolIndex];

            if (p2^.DeclType in AllExpressionValueType) then
              begin
                if p1^.Symbol in AllowPrioritySymbol then
                  begin
                    LastSymbolPriority := SymbolPriority(p1^.Symbol, lastIndentSym);

                    if LastSymbolPriority < 0 then
                      begin
                        newExpression.InsertSymbol(newExpression.IndexOf(lastIndent), soBlockIndentBegin, lastIndent^.charPos);
                        newExpression.Add(p1^);
                        lastSym := p1^.Symbol;
                        ProcessSymbol(p1^.Symbol);
                        newExpression.AddSymbol(soBlockIndentEnd, p2^.charPos);
                        continue;
                      end
                    else
                      begin
                        newExpression.Add(p1^);
                        continue;
                      end;
                  end
                else
                  begin
                    PrintError(SymbolOperationTextDecl[p1^.Symbol].Decl);
                    Exit;
                  end;
              end
            else
              begin
                PrintError('expression structor Illegal');
                Exit;
              end;
          end;

        Inc(SymbolIndex);
      end;
  end;

begin
  Result := nil;
  if Exps.AvailValueCount = 0 then
      Exit;

  if Exps.GetSymbolCount([
    soBlockIndentBegin, soBlockIndentEnd,
    soPropIndentBegin, soPropIndentEnd,
    soEolSymbol, soUnknow]) > 0 then
    begin
      PrintError('Illegal symbol');
      Exit;
    end;

  SymbolIndex := 0;
  newExpression := TSymbolExpression.Create;
  ParseAborted := False;

  ProcessSymbol(soUnknow);

  if ParseAborted then
    begin
      newExpression.Free;
      PrintError('Illegal');
    end
  else
      Result := newExpression;
end;

function RebuildAllSymbol(Exps: TSymbolExpression): TSymbolExpression;
var
  SymbolIndex : Integer;
  ParseAborted: Boolean;

  procedure PrintError(const s: SystemString);
  begin
    ParseAborted := True;
    if s <> '' then
        DoStatus(Format('indent symbol failed : %s', [s]))
    else
        DoStatus('indent symbol failed');
  end;

  function ProcessIndent(OwnerIndentSym: TSymbolOperation): TSymbolExpression;
  var
    p1, p2          : PExpressionListData;
    LocalExp, ResExp: TSymbolExpression;
  begin
    LocalExp := TSymbolExpression.Create;
    Result := LocalExp;
    while True do
      begin
        if SymbolIndex >= Exps.Count then
            break;

        p1 := Exps[SymbolIndex];

        if (p1^.DeclType in [edtSymbol]) then
          begin
            if p1^.Symbol in [soBlockIndentBegin, soPropIndentBegin] then
              begin
                Inc(SymbolIndex);

                ResExp := ProcessIndent(p1^.Symbol);
                LocalExp.AddExpressionAsValue(True, ResExp, p1^.Symbol, SymbolOperationTextDecl[p1^.Symbol].Decl, p1^.charPos);

                if SymbolIndex >= Exps.Count then
                  begin
                    PrintError('indent Illegal');
                    Exit;
                  end;
              end
            else if ((OwnerIndentSym = soBlockIndentBegin) and (p1^.Symbol = soBlockIndentEnd)) or
              ((OwnerIndentSym = soPropIndentBegin) and (p1^.Symbol = soPropIndentEnd)) then
              begin
                Exit;
              end
            else if p1^.Symbol in [soCommaSymbol] then
              begin
                LocalExp.Add(p1^);
              end
            else
              begin
                LocalExp.Add(p1^);
              end;
          end
        else if (p1^.DeclType in AllExpressionValueType) then
          begin
            if p1^.DeclType = edtProcExp then
              begin
                LocalExp.Add(p1^);
                Inc(SymbolIndex);
                continue;
              end;

            Inc(SymbolIndex);
            if SymbolIndex >= Exps.Count then
              begin
                LocalExp.Add(p1^);
                break;
              end;

            p2 := Exps[SymbolIndex];

            if p2^.DeclType = edtSymbol then
              begin
                if (p2^.Symbol in [soBlockIndentBegin, soPropIndentBegin]) then
                  begin
                    if (p1^.DeclType in MethodToken) then
                      begin
                        PrintError('method Illegal');
                        Exit;
                      end;

                    LocalExp.Add(p1^);
                    Inc(SymbolIndex);

                    ResExp := ProcessIndent(p2^.Symbol);
                    LocalExp.AddExpressionAsValue(True, ResExp, p2^.Symbol, SymbolOperationTextDecl[p2^.Symbol].Decl, p2^.charPos);

                    if SymbolIndex >= Exps.Count then
                      begin
                        PrintError('indent Illegal');
                        Exit;
                      end;

                  end
                else if ((OwnerIndentSym = soBlockIndentBegin) and (p2^.Symbol = soBlockIndentEnd)) or
                  ((OwnerIndentSym = soPropIndentBegin) and (p2^.Symbol = soPropIndentEnd)) then
                  begin
                    LocalExp.Add(p1^);
                    Exit;
                  end
                else if p2^.Symbol = soCommaSymbol then
                  begin
                    PrintError('Comma Illegal');
                    Exit;
                  end
                else
                  begin
                    LocalExp.Add(p1^);
                    LocalExp.Add(p2^);
                  end;
              end
            else
              begin
                PrintError('expression structor Illegal');
                Exit;
              end;
          end;

        Inc(SymbolIndex);
      end;
  end;

  function ProcessPriority(_e: TSymbolExpression): TSymbolExpression;
  var
    i, j     : Integer;
    e, ResExp: TSymbolExpression;
    p, funcP : PExpressionListData;
  begin
    e := RebuildLogicalPrioritySymbol(_e);
    if e = nil then
      begin
        Result := nil;
        PrintError('parse priority failed');
        Exit;
      end;

    Result := TSymbolExpression.Create;

    for i := 0 to e.Count - 1 do
      begin
        p := e[i];
        if p^.DeclType = edtExpressionAsValue then
          begin
            case p^.Symbol of
              soBlockIndentBegin:
                begin
                  Result.AddSymbol(soBlockIndentBegin, p^.charPos);
                  ResExp := ProcessPriority(p^.Expression);
                  if ResExp <> nil then
                    begin
                      Result.AddExpression(ResExp);
                      DisposeObject(ResExp);
                    end;
                  Result.AddSymbol(soBlockIndentEnd, p^.charPos);
                end;
              soPropIndentBegin:
                begin
                  Result.AddSymbol(soPropIndentBegin, p^.charPos);
                  ResExp := ProcessPriority(p^.Expression);
                  if ResExp <> nil then
                    begin
                      Result.AddExpression(ResExp);
                      DisposeObject(ResExp);
                    end;
                  Result.AddSymbol(soPropIndentEnd, p^.charPos);
                end;
              else
                begin
                  break;
                end;
            end;
          end
        else if p^.DeclType = edtProcExp then
          begin
            funcP := Result.AddFunc(VarToStr(p^.Value), p^.charPos);
            if (p^.Expression.Count > 0) and (p^.Expression.First^.Expression.Count > 0) then
              for j := 0 to p^.Expression.Count - 1 do
                begin
                  ResExp := RebuildAllSymbol(p^.Expression[j]^.Expression);
                  if ResExp <> nil then
                      funcP^.Expression.AddExpressionAsValue(True, ResExp, soParameter, VarToStr(p^.Expression[j]^.Value), p^.Expression[j]^.charPos);
                end;
          end
        else
          begin
            Result.Add(p^);
          end;
      end;
    DisposeObject([e]);
  end;

var
  rse: TSymbolExpression;
begin
  Result := nil;
  SymbolIndex := 0;
  ParseAborted := False;

  rse := ProcessIndent(soUnknow);
  Result := ProcessPriority(rse);
  DisposeObject(rse);
end;

function BuildAsOpCode(DebugMode: Boolean; SymbExps: TSymbolExpression; const uName: SystemString; LineNo: Integer): TOpCode;
var
  NewSymbExps : TSymbolExpression;
  SymbolIndex : Integer;
  BuildAborted: Boolean;
  OpContainer : TCoreClassListForObj;

  procedure PrintError(const s: SystemString);
  begin
    BuildAborted := True;
    if s <> '' then
        DoStatus(Format('build op failed : %s', [s]))
    else
        DoStatus('build op failed');
  end;

  function NewOpValue(uName: SystemString): TOpCode;
  begin
    Result := op_Value.Create(False);
    Result.ParsedInfo := uName;
    Result.ParsedLineNo := LineNo;
    OpContainer.Add(Result);
  end;

  function NewOpProc(uName: SystemString): TOpCode;
  begin
    Result := op_Proc.Create(False);
    Result.ParsedInfo := uName;
    Result.ParsedLineNo := LineNo;
    OpContainer.Add(Result);
  end;

  function NewOpFromSym(sym: TSymbolOperation; const uName: SystemString): TOpCode;
  begin
    case sym of
      soAdd: Result := op_Add.Create(False);
      soSub: Result := op_Sub.Create(False);
      soMul: Result := op_Mul.Create(False);
      soDiv: Result := op_Div.Create(False);
      soMod: Result := op_Mod.Create(False);
      soIntDiv: Result := op_IntDiv.Create(False);
      soPow: Result := op_Pow.Create(False);
      soOr: Result := op_Or.Create(False);
      soAnd: Result := op_And.Create(False);
      soXor: Result := op_Xor.Create(False);
      soEqual: Result := op_Equal.Create(False);
      soLessThan: Result := op_LessThan.Create(False);
      soEqualOrLessThan: Result := op_EqualOrLessThan.Create(False);
      soGreaterThan: Result := op_GreaterThan.Create(False);
      soEqualOrGreaterThan: Result := op_EqualOrGreaterThan.Create(False);
      soNotEqual: Result := op_NotEqual.Create(False);
      soShl: Result := op_Shl.Create(False);
      soShr: Result := op_Shr.Create(False);
      else
        Result := nil;
    end;
    if Result <> nil then
      begin
        Result.ParsedInfo := uName;
        Result.ParsedLineNo := LineNo;

        OpContainer.Add(Result);
      end;
  end;

  function ProcessIndent(OwnerIndentSym: TSymbolOperation): TOpCode;
  var
    i                            : Integer;
    p1, p2                       : PExpressionListData;
    LocalOp, OldOp, ResOp, ProcOp: TOpCode;
  begin
    LocalOp := nil;
    OldOp := nil;
    ResOp := nil;
    Result := nil;

    while True do
      begin
        if SymbolIndex >= NewSymbExps.Count then
          begin
            if LocalOp <> nil then
                Result := LocalOp;
            break;
          end;

        p1 := NewSymbExps[SymbolIndex];

        if (p1^.DeclType in [edtSymbol]) then
          begin
            if p1^.Symbol in [soBlockIndentBegin, soPropIndentBegin] then
              begin
                Inc(SymbolIndex);
                ResOp := ProcessIndent(p1^.Symbol);
                if ResOp <> nil then
                  begin
                    if LocalOp <> nil then
                      begin
                        LocalOp.AddLink(ResOp);
                      end
                    else
                      begin
                        LocalOp := NewOpValue(uName);
                        LocalOp.AddLink(ResOp);
                      end;
                  end
                else
                  begin
                    PrintError('logical cperotion Illegal');
                    break;
                  end;
              end
            else if ((OwnerIndentSym = soBlockIndentBegin) and (p1^.Symbol = soBlockIndentEnd)) or
              ((OwnerIndentSym = soPropIndentBegin) and (p1^.Symbol = soPropIndentEnd)) then
              begin
                Result := LocalOp;
                break;
              end
            else if p1^.Symbol in OpLogicalSymbol then
              begin
                if LocalOp <> nil then
                  begin
                    OldOp := LocalOp;
                    LocalOp := NewOpFromSym(p1^.Symbol, uName);
                    LocalOp.AddLink(OldOp);
                  end
                else
                  begin
                    PrintError('logical cperotion Illegal');
                    break;
                  end;
              end
            else
              begin
                PrintError('logical cperotion Illegal');
                break;
              end;
          end
        else if (p1^.DeclType in AllExpressionValueType) then
          begin
            if p1^.DeclType = edtProcExp then
              begin
                ProcOp := NewOpProc(uName);
                ProcOp.AddValue(p1^.Value);
                for i := 0 to p1^.Expression.Count - 1 do
                  begin
                    ResOp := BuildAsOpCode(False, p1^.Expression[i]^.Expression, uName, LineNo);
                    if ResOp <> nil then
                        ProcOp.AddLink(ResOp)
                    else
                      begin
                        PrintError('method Illegal');
                        break;
                      end;
                  end;

                if LocalOp <> nil then
                  begin
                    LocalOp.AddLink(ProcOp);
                  end
                else
                  begin
                    LocalOp := NewOpValue(uName);
                    LocalOp.AddLink(ProcOp);
                  end;
                Inc(SymbolIndex);
                continue;
              end;

            Inc(SymbolIndex);
            if SymbolIndex >= NewSymbExps.Count then
              begin
                if LocalOp <> nil then
                  begin
                    LocalOp.AddValueT(p1^.Value, dt2op(p1^.DeclType));
                  end
                else
                  begin
                    LocalOp := NewOpValue(uName);
                    LocalOp.AddValueT(p1^.Value, dt2op(p1^.DeclType));
                  end;
                Result := LocalOp;
                break;
              end;

            p2 := NewSymbExps[SymbolIndex];

            if p2^.DeclType = edtSymbol then
              begin
                if (p2^.Symbol in [soBlockIndentBegin, soPropIndentBegin]) then
                  begin
                    // function call
                    if not(p1^.DeclType in MethodToken) then
                      begin
                        PrintError('method Illegal');
                        break;
                      end
                    else
                      begin
                      end;

                    Inc(SymbolIndex);
                    ResOp := ProcessIndent(p2^.Symbol);

                  end
                else if ((OwnerIndentSym = soBlockIndentBegin) and (p2^.Symbol = soBlockIndentEnd)) or
                  ((OwnerIndentSym = soPropIndentBegin) and (p2^.Symbol = soPropIndentEnd)) then
                  begin
                    if LocalOp <> nil then
                      begin
                        LocalOp.AddValueT(p1^.Value, dt2op(p1^.DeclType));
                      end
                    else
                      begin
                        LocalOp := NewOpValue(uName);
                        LocalOp.AddValueT(p1^.Value, dt2op(p1^.DeclType));
                      end;
                    Result := LocalOp;
                    break;
                  end
                else if p2^.Symbol in OpLogicalSymbol then
                  begin
                    if LocalOp <> nil then
                      begin
                        OldOp := LocalOp;
                        OldOp.AddValueT(p1^.Value, dt2op(p1^.DeclType));
                        LocalOp := NewOpFromSym(p2^.Symbol, uName);
                        LocalOp.AddLink(OldOp);
                      end
                    else
                      begin
                        LocalOp := NewOpFromSym(p2^.Symbol, uName);
                        LocalOp.AddValueT(p1^.Value, dt2op(p1^.DeclType));
                      end;
                  end
                else
                  begin
                    PrintError('Illegal');
                    break;
                  end;
              end
            else
              begin
                PrintError('Illegal');
                break;
              end;
          end;

        Inc(SymbolIndex);
      end;
  end;

  procedure ProcessOpContainer(Successed: Boolean);
  var
    i: Integer;
  begin
    for i := 0 to OpContainer.Count - 1 do
      if Successed then
          TOpCode(OpContainer[i]).AutoFreeLink := True
      else
          DisposeObject(TOpCode(OpContainer[i]));
    OpContainer.Clear;
  end;

begin
  Result := nil;
  NewSymbExps := RebuildAllSymbol(SymbExps);
  if NewSymbExps <> nil then
    begin
      if DebugMode then
          NewSymbExps.PrintDebug(True);

      if NewSymbExps.GetSymbolCount([soBlockIndentBegin, soPropIndentBegin]) =
        NewSymbExps.GetSymbolCount([soBlockIndentEnd, soPropIndentEnd]) then
        begin
          OpContainer := TCoreClassListForObj.Create;

          SymbolIndex := 0;
          BuildAborted := False;
          Result := ProcessIndent(soUnknow);
          ProcessOpContainer(Result <> nil);
          DisposeObject(OpContainer);
        end;
      DisposeObject(NewSymbExps);
    end;
end;

function BuildAsOpCode(SymbExps: TSymbolExpression): TOpCode;
begin
  Result := BuildAsOpCode(False, SymbExps, '', 0);
end;

function BuildAsOpCode(DebugMode: Boolean; SymbExps: TSymbolExpression): TOpCode;
begin
  Result := BuildAsOpCode(DebugMode, SymbExps, '', 0);
end;

function BuildAsOpCode(DebugMode: Boolean; textStyle: TTextStyle; const ExpressionText: SystemString): TOpCode;
var
  sym: TSymbolExpression;
begin
  sym := ParseTextExpressionAsSymbol(textStyle, '', ExpressionText, nil, DefaultOpRT);
  Result := BuildAsOpCode(DebugMode, sym, '', 0);
  DisposeObject(sym);
end;

function BuildAsOpCode(textStyle: TTextStyle; const ExpressionText: SystemString): TOpCode;
var
  sym: TSymbolExpression;
begin
  sym := ParseTextExpressionAsSymbol(textStyle, '', ExpressionText, nil, DefaultOpRT);
  Result := BuildAsOpCode(False, sym, '', 0);
  DisposeObject(sym);
end;

function BuildAsOpCode(const ExpressionText: SystemString): TOpCode;
var
  sym: TSymbolExpression;
begin
  sym := ParseTextExpressionAsSymbol(ExpressionText);
  Result := BuildAsOpCode(False, sym, '', 0);
  DisposeObject(sym);
end;

function BuildAsOpCode(DebugMode: Boolean; textStyle: TTextStyle; const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TOpCode;
var
  sym: TSymbolExpression;
begin
  sym := ParseTextExpressionAsSymbol(textStyle, '', ExpressionText, nil, RefrenceOpRT);
  Result := BuildAsOpCode(DebugMode, sym, '', 0);
  DisposeObject(sym);
end;

function BuildAsOpCode(textStyle: TTextStyle; const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TOpCode;
var
  sym: TSymbolExpression;
begin
  sym := ParseTextExpressionAsSymbol(textStyle, '', ExpressionText, nil, RefrenceOpRT);
  Result := BuildAsOpCode(False, sym, '', 0);
  DisposeObject(sym);
end;

function BuildAsOpCode(const ExpressionText: SystemString; RefrenceOpRT: TOpCustomRunTime): TOpCode;
var
  sym: TSymbolExpression;
begin
  sym := ParseTextExpressionAsSymbol(ExpressionText, RefrenceOpRT);
  Result := BuildAsOpCode(False, sym, '', 0);
  DisposeObject(sym);
end;

function EvaluateExpressionValue_M(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const ExpressionText: SystemString; const OnGetValue: TOnDeclValueMethod): Variant;
var
  sym: TSymbolExpression;
  op : TOpCode;
  i  : Integer;
begin
  LockObject(OpCache);
  op := TOpCode(OpCache[ExpressionText]);
  UnLockObject(OpCache);
  if op <> nil then
    begin
      try
          Result := op.Execute(DefaultOpRT);
      except
          Result := NULL;
      end;
    end
  else
    begin
      Result := NULL;
      sym := ParseTextExpressionAsSymbol_M(TextEngClass, textStyle, '', ExpressionText, OnGetValue, DefaultOpRT);

      if sym <> nil then
        begin
          op := BuildAsOpCode(False, sym, 'Main', -1);
          if op <> nil then
            begin
              try
                Result := op.Execute;
                LockObject(OpCache);
                OpCache.Add(ExpressionText, op);
                UnLockObject(OpCache);
              except
                  Result := NULL;
              end;
            end;
          DisposeObject(sym);
        end;
    end;
end;

function EvaluateExpressionValue_C(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const ExpressionText: SystemString; const OnGetValue: TOnDeclValueCall): Variant;
var
  sym: TSymbolExpression;
  op : TOpCode;
  i  : Integer;
begin
  LockObject(OpCache);
  op := TOpCode(OpCache[ExpressionText]);
  UnLockObject(OpCache);
  if op <> nil then
    begin
      try
          Result := op.Execute(DefaultOpRT);
      except
          Result := NULL;
      end;
    end
  else
    begin
      Result := NULL;
      sym := ParseTextExpressionAsSymbol_C(TextEngClass, textStyle, '', ExpressionText, OnGetValue, DefaultOpRT);

      if sym <> nil then
        begin
          op := BuildAsOpCode(False, sym, 'Main', -1);
          if op <> nil then
            begin
              try
                Result := op.Execute;
                LockObject(OpCache);
                OpCache.Add(ExpressionText, op);
                UnLockObject(OpCache);
              except
                  Result := NULL;
              end;
            end;
          DisposeObject(sym);
        end;
    end;
end;

{$IFNDEF FPC}


function EvaluateExpressionValue_P(TextEngClass: TTextParsingClass; textStyle: TTextStyle; const ExpressionText: SystemString; const OnGetValue: TOnDeclValueProc): Variant;
var
  sym: TSymbolExpression;
  op : TOpCode;
  i  : Integer;
begin
  LockObject(OpCache);
  op := TOpCode(OpCache[ExpressionText]);
  UnLockObject(OpCache);
  if op <> nil then
    begin
      try
          Result := op.Execute(DefaultOpRT);
      except
          Result := NULL;
      end;
    end
  else
    begin
      Result := NULL;
      sym := ParseTextExpressionAsSymbol_P(TextEngClass, textStyle, '', ExpressionText, OnGetValue, DefaultOpRT);

      if sym <> nil then
        begin
          op := BuildAsOpCode(False, sym, 'Main', -1);
          if op <> nil then
            begin
              try
                Result := op.Execute;
                LockObject(OpCache);
                OpCache.Add(ExpressionText, op);
                UnLockObject(OpCache);
              except
                  Result := NULL;
              end;
            end;
          DisposeObject(sym);
        end;
    end;
end;
{$ENDIF FPC}


function EvaluateExpressionValue(DebugMode: Boolean; const ExpressionText: SystemString; opRT: TOpCustomRunTime): Variant;
var
  sym: TSymbolExpression;
  op : TOpCode;
  i  : Integer;
begin
  LockObject(OpCache);
  op := TOpCode(OpCache[ExpressionText]);
  UnLockObject(OpCache);
  if op <> nil then
    begin
      try
          Result := op.Execute(opRT);
      except
          Result := NULL;
      end;
    end
  else
    begin
      Result := NULL;
      sym := ParseTextExpressionAsSymbol(ExpressionText, opRT);

      if sym <> nil then
        begin
          op := BuildAsOpCode(False, sym, 'Main', -1);
          if op <> nil then
            begin
              try
                Result := op.Execute(opRT);
                LockObject(OpCache);
                OpCache.Add(ExpressionText, op);
                UnLockObject(OpCache);
              except
                  Result := NULL;
              end;
            end;
          DisposeObject(sym);
        end;
    end;
end;

function EvaluateExpressionValue(const ExpressionText: SystemString; opRT: TOpCustomRunTime): Variant;
begin
  Result := EvaluateExpressionValue(False, ExpressionText, opRT);
end;

function EvaluateExpressionValue(DebugMode: Boolean; const ExpressionText: SystemString): Variant;
begin
  Result := EvaluateExpressionValue(False, ExpressionText, DefaultOpRT);
end;

function EvaluateExpressionValue(const ExpressionText: SystemString): Variant;
begin
  Result := EvaluateExpressionValue(False, ExpressionText);
end;

function EvaluateExpressionValue(textStyle: TTextStyle; const ExpressionText: SystemString; opRT: TOpCustomRunTime): Variant;
var
  sym: TSymbolExpression;
  op : TOpCode;
  i  : Integer;
begin
  LockObject(OpCache);
  op := TOpCode(OpCache[ExpressionText]);
  UnLockObject(OpCache);
  if op <> nil then
    begin
      try
          Result := op.Execute(opRT);
      except
          Result := NULL;
      end;
    end
  else
    begin
      Result := NULL;
      sym := ParseTextExpressionAsSymbol(textStyle, '', ExpressionText, nil, opRT);

      if sym <> nil then
        begin
          op := BuildAsOpCode(sym);
          if op <> nil then
            begin
              try
                Result := op.Execute(opRT);
                LockObject(OpCache);
                OpCache.Add(ExpressionText, op);
                UnLockObject(OpCache);
              except
                  Result := NULL;
              end;
            end;
          DisposeObject(sym);
        end;
    end;
end;

function VariantToExpressionDeclType(var v: Variant): TExpressionDeclType;
begin
  case VarType(v) of
    varSmallint: Result := edtSmallInt;
    varInteger: Result := edtInt;
    varSingle: Result := edtSingle;
    varDouble: Result := edtDouble;
    varCurrency: Result := edtCurrency;
    varBoolean: Result := edtBool;
    varShortInt: Result := edtShortInt;
    varByte: Result := edtByte;
    varWord: Result := edtWord;
    varLongWord: Result := edtUInt;
    varInt64: Result := edtInt64;
    varUInt64: Result := edtUInt64;
    else
      begin
        if VarIsStr(v) then
            Result := edtString
        else
            Result := edtUnknow;
      end;
  end;
end;

constructor TSymbolExpression.Create;
begin
  inherited Create;
  FList := TCoreClassList.Create;
end;

destructor TSymbolExpression.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited Destroy;
end;

procedure TSymbolExpression.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    begin
      if (PExpressionListData(FList[i])^.ExpressionAutoFree) and (PExpressionListData(FList[i])^.Expression <> nil) then
          DisposeObject(PExpressionListData(FList[i])^.Expression);

      Dispose(PExpressionListData(FList[i]));
    end;

  FList.Clear;
end;

procedure TSymbolExpression.PrintDebug(const detail: Boolean; const prefix: SystemString = '');
var
  i: Integer;
  p: PExpressionListData;
begin
  DoStatus(prefix + ' decl: ' + Decl);

  if detail then
    begin
      for i := 0 to Count - 1 do
        begin
          p := GetItems(i);

          DoStatus(prefix + ' id:%d exp:%s symbol:%s val:%s', [i,
            GetEnumName(TypeInfo(TExpressionDeclType), Ord(p^.DeclType)),
            GetEnumName(TypeInfo(TSymbolOperation), Ord(p^.Symbol)),
            VarToStr(p^.Value)]);

        end;

      DoStatus('');

      for i := 0 to Count - 1 do
        begin
          p := GetItems(i);
          if p^.Expression <> nil then
            if p^.Expression.Count > 0 then
                p^.Expression.PrintDebug(detail, prefix + ' -> ' + VarToStr(p^.Value));
        end;
    end;
end;

function TSymbolExpression.Decl: SystemString;
var
  i, j: Integer;
  p   : PExpressionListData;
begin
  Result := '';
  for i := 0 to FList.Count - 1 do
    begin
      p := FList[i];
      case p^.DeclType of
        edtSymbol:
          Result := Result + SymbolOperationTextDecl[p^.Symbol].Decl;
        edtSingle, edtDouble, edtCurrency:
          Result := Result + FloatToStr(p^.Value);
        edtProcExp:
          begin
            Result := Result + VarToStr(p^.Value) + '(';
            for j := 0 to p^.Expression.Count - 1 do
              begin
                if j = 0 then
                    Result := Result + p^.Expression[j]^.Expression.Decl
                else
                    Result := Result + ',' + p^.Expression[j]^.Expression.Decl;
              end;
            Result := Result + ')';
          end;
        edtExpressionAsValue:
          begin
            case p^.Symbol of
              soBlockIndentBegin:
                Result := Format('%s%s%s%s',
                  [Result,
                  SymbolOperationTextDecl[soBlockIndentBegin].Decl,
                  p^.Expression.Decl,
                  SymbolOperationTextDecl[soBlockIndentEnd].Decl
                  ]);
              soPropIndentBegin:
                Result := Format('%s%s%s%s',
                  [Result,
                  SymbolOperationTextDecl[soPropIndentBegin].Decl,
                  p^.Expression.Decl,
                  SymbolOperationTextDecl[soPropIndentEnd].Decl
                  ]);
              soParameter:
                begin
                  Result := Format('%s%s%s%s',
                    [Result,
                    SymbolOperationTextDecl[soBlockIndentBegin].Decl,
                    p^.Expression.Decl,
                    SymbolOperationTextDecl[soBlockIndentEnd].Decl
                    ]);
                end;
              else
                Result := Result + ' !error! ';
            end;
          end;
        edtUnknow: Result := Result + ' !error! ';
        else
          Result := Result + VarToStr(p^.Value);
      end;
    end;
end;

function TSymbolExpression.GetCount(t: TExpressionDeclTypes): Integer;
var
  i: Integer;
  p: PExpressionListData;
begin
  Result := 0;
  for i := 0 to FList.Count - 1 do
    begin
      p := FList[i];
      if p^.DeclType in t then
          Inc(Result);
    end;
end;

function TSymbolExpression.GetSymbolCount(Operations: TSymbolOperations): Integer;
var
  i: Integer;
  p: PExpressionListData;
begin
  Result := 0;
  for i := 0 to FList.Count - 1 do
    begin
      p := FList[i];
      if p^.DeclType = edtSymbol then
        begin
          if p^.Symbol in Operations then
              Inc(Result);
        end;
    end;
end;

function TSymbolExpression.AvailValueCount: Integer;
begin
  Result := GetCount(AllExpressionValueType);
end;

function TSymbolExpression.Count: Integer;
begin
  Result := FList.Count;
end;

function TSymbolExpression.InsertSymbol(const idx: Integer; v: TSymbolOperation; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtSymbol;
  p^.charPos := charPos;
  p^.Symbol := v;
  p^.Value := v;
  FList.Insert(idx, p);
  Result := p;
end;

function TSymbolExpression.Insert(const idx: Integer; v: TExpressionListData): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  p^ := v;
  FList.Insert(idx, p);
  Result := p;
end;

procedure TSymbolExpression.InsertExpression(const idx: Integer; e: TSymbolExpression);
var
  newList: TCoreClassList;
  i      : Integer;
  p      : PExpressionListData;
begin
  newList := TCoreClassList.Create;
  newList.Capacity := e.FList.Count + FList.Count;

  for i := 0 to idx do
      newList.Add(FList[i]);

  for i := 0 to e.FList.Count - 1 do
    begin
      new(p);
      p^ := PExpressionListData(e.FList[i])^;
      newList.Add(p);
    end;

  for i := idx to FList.Count - 1 do
      newList.Add(FList[i]);

  DisposeObject(FList);
  FList := newList;
end;

procedure TSymbolExpression.AddExpression(const e: TSymbolExpression);
var
  i: Integer;
begin
  for i := 0 to e.Count - 1 do
      AddCopy(e[i]^);
end;

function TSymbolExpression.AddSymbol(const v: TSymbolOperation; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtSymbol;
  p^.charPos := charPos;
  p^.Symbol := v;
  p^.Value := SymbolOperationTextDecl[v].Decl;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddBool(const v: Boolean; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtBool;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddInt(const v: Integer; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtInt;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddUInt(const v: Cardinal; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtUInt;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddInt64(const v: int64; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtInt64;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddUInt64(const v: UInt64; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtUInt64;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddWord(const v: Word; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtWord;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddByte(const v: Byte; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtByte;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddSmallInt(const v: SmallInt; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtSmallInt;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddShortInt(const v: ShortInt; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtShortInt;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddSingle(const v: Single; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtSingle;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddDouble(const v: Double; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtDouble;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddCurrency(const v: Currency; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtCurrency;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddString(const v: SystemString; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtString;
  p^.charPos := charPos;
  p^.Value := v;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddFunc(const v: SystemString; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtProcExp;
  p^.charPos := charPos;
  p^.Symbol := soProc;
  p^.Value := v;
  p^.Expression := TSymbolExpression.Create;
  p^.ExpressionAutoFree := True;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddExpressionAsValue(AutoFree: Boolean; Expression: TSymbolExpression; Symbol: TSymbolOperation; Value: Variant; charPos: Integer): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  InitExp(p^);
  p^.DeclType := edtExpressionAsValue;
  p^.charPos := charPos;
  p^.Symbol := Symbol;
  p^.Value := Value;
  p^.Expression := Expression;
  p^.ExpressionAutoFree := AutoFree;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.Add(const v: TExpressionListData): PExpressionListData;
var
  p: PExpressionListData;
begin
  new(p);
  p^ := v;
  p^.ExpressionAutoFree := False;
  FList.Add(p);
  Result := p;
end;

function TSymbolExpression.AddCopy(const v: TExpressionListData): PExpressionListData;
var
  p: PExpressionListData;
  i: Integer;
begin
  new(p);
  p^ := v;
  p^.ExpressionAutoFree := False;
  if v.Expression <> nil then
    begin
      p^.Expression := TSymbolExpression.Create;
      p^.ExpressionAutoFree := True;
      for i := 0 to v.Expression.Count - 1 do
          p^.Expression.AddCopy(v.Expression[i]^)
    end;
  FList.Add(p);
  Result := p;
end;

procedure TSymbolExpression.Delete(const idx: Integer);
var
  p: PExpressionListData;
begin
  p := FList[idx];
  if (p^.ExpressionAutoFree) and (p^.Expression <> nil) then
      DisposeObject(p^.Expression);
  Dispose(p);
  FList.Delete(idx);
end;

procedure TSymbolExpression.DeleteLast;
begin
  Delete(Count - 1);
end;

function TSymbolExpression.Last: PExpressionListData;
begin
  Result := FList.Last;
end;

function TSymbolExpression.First: PExpressionListData;
begin
  Result := FList.First;
end;

function TSymbolExpression.IndexOf(p: PExpressionListData): Integer;
var
  i: Integer;
begin
  for i := FList.Count - 1 downto 0 do
    if FList[i] = p then
        Exit(i);
  Exit(-1);
end;

function TSymbolExpression.GetItems(index: Integer): PExpressionListData;
begin
  Result := FList[index];
end;

initialization

OpCache := THashObjectList.Create(True, 8192);
SpecialAsciiToken := TListPascalString.Create;

finalization

DisposeObject([OpCache, SpecialAsciiToken]);

end.
