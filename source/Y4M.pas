{ ****************************************************************************** }
{ * Yuv for Mpeg support       by qq600585                                     * }
{ * https://github.com/PassByYou888/CoreCipher                                 * }
{ * https://github.com/PassByYou888/ZServer4D                                  * }
{ * https://github.com/PassByYou888/zExpression                                * }
{ * https://github.com/PassByYou888/zTranslate                                 * }
{ * https://github.com/PassByYou888/zSound                                     * }
{ * https://github.com/PassByYou888/zAnalysis                                  * }
{ * https://github.com/PassByYou888/zGameWare                                  * }
{ * https://github.com/PassByYou888/zRasterization                             * }
{ ****************************************************************************** }

unit Y4M;

{$I zDefine.inc}

interface

uses SysUtils, CoreClasses, PascalStrings, UnicodeMixedLib, MemoryRaster, h264image, h264StdInt;

type
  TY4MReader = class
  private
    FWidth, FHeight: uint16_t;
    FFrameCount: uint32_t;
    FCurrentFrame: uint32_t;
    FFrameRate: Single;
    ioHandle: TIOHnd;
    FStartPos: Int64_t;
    FFileHeaderSize: word;
    FFrameSize: uint32_t;
    img: TPlanarImage;
    procedure ParseHeader;
  public
    constructor Create(const filename: TPascalString); overload;
    constructor Create(const stream: TCoreClassStream; const autoFreeSteam: Boolean); overload;
    destructor Destroy; override;

    procedure SeekFirstFrame;
    procedure SeekFrame(frameIndex: uint32_t);
    function ReadFrame: TPlanarImage;

    property Width: uint16_t read FWidth;
    property Height: uint16_t read FHeight;
    property FrameCount: uint32_t read FFrameCount;
    property CurrentFrame: uint32_t read FCurrentFrame;
    property FrameRate: Single read FFrameRate;
  end;

  TY4MWriter = class
  private
    ioHandle: TIOHnd;
    FPerSecondFrame: uint16_t;
    FFrameCount: uint32_t;
    img: TPlanarImage;
  public
    (*
      w: frame FWidth
      h: frame FHeight
      psf: per second frame
      filename: output filename
    *)
    constructor Create(const w, h, psf: uint16_t; const filename: TPascalString); overload;

    (*
      w: frame FWidth
      h: frame FHeight
      psf: per second frame
      stream: output stream
    *)
    constructor Create(const w, h, psf: uint16_t; const stream: TCoreClassStream); overload;

    destructor Destroy; override;

    procedure WriteFrame(raster: TMemoryRaster);
    procedure Flush;

    property PerSecondFrame: uint16_t read FPerSecondFrame;
    property FrameCount: uint32_t read FFrameCount;
    function Y4MSize: Int64_t;
  end;

implementation

type
  TY4MToken    = array [0 .. 8] of uint8_t;
  TFRAME_MAGIC = array [0 .. 5] of uint8_t;

var
  Y4M_Token: TY4MToken      = ($59, $55, $56, $34, $4D, $50, $45, $47, $32);
  FRAME_MAGIC: TFRAME_MAGIC = ($46, $52, $41, $4D, $45, $0A);
  FRAME_MAGIC_SIZE: int32_t = 6;

procedure TY4MReader.ParseHeader;
var
  i, num, denom: integer;
  c, param_c: uint8_t;
  token: TY4MToken;
  s: TPascalString;
begin
  umlBlockRead(ioHandle, token[0], 9);

  if not CompareMemory(@token[0], @Y4M_Token[0], 9) then
      RaiseInfo('Not a Y4M format');

  umlBlockRead(ioHandle, c, 1);

  repeat
    umlBlockRead(ioHandle, param_c, 1);
    s := '';
    umlBlockRead(ioHandle, c, 1);
    repeat
      s.Append(SystemChar(c));
      umlBlockRead(ioHandle, c, 1);
    until (c = 10) or (c = 32);
    case param_c of
      ord('W'):
        FWidth := umlStrToInt(s);
      ord('H'):
        FHeight := umlStrToInt(s);
      ord('F'):
        begin
          num := umlStrToInt(umlGetFirstStr(s, ':'));
          denom := umlStrToInt(umlGetLastStr(s, ':'));
          FFrameRate := num / denom;
        end;
    end;
  until c = 10;

  FFileHeaderSize := umlFilePOS(ioHandle);
end;

constructor TY4MReader.Create(const filename: TPascalString);
begin
  inherited Create;
  FFrameCount := 0;
  FCurrentFrame := 0;

  umlFileOpen(filename, ioHandle, True);
  ParseHeader;

  FFrameSize := FWidth * FHeight + (FWidth * FHeight div 2);
  FFrameCount := (umlFileSize(ioHandle) - FFileHeaderSize) div (FRAME_MAGIC_SIZE + int64(FFrameSize));

  FStartPos := umlFileGetPOS(ioHandle);
  img := TPlanarImage.Create(FWidth, FHeight);
end;

constructor TY4MReader.Create(const stream: TCoreClassStream; const autoFreeSteam: Boolean);
begin
  inherited Create;
  FFrameCount := 0;
  FCurrentFrame := 0;

  umlFileOpenAsStream('stream', stream, ioHandle, True);
  ioHandle.AutoFree := autoFreeSteam;
  ParseHeader;

  FFrameSize := FWidth * FHeight + (FWidth * FHeight div 2);
  FFrameCount := (umlFileSize(ioHandle) - FFileHeaderSize) div (FRAME_MAGIC_SIZE + int64(FFrameSize));

  FStartPos := umlFileGetPOS(ioHandle);
  img := TPlanarImage.Create(FWidth, FHeight);
end;

destructor TY4MReader.Destroy;
begin
  DisposeObject(img);
  umlFileClose(ioHandle);
  inherited Destroy;
end;

procedure TY4MReader.SeekFirstFrame;
begin
  umlFileSeek(ioHandle, FStartPos);
  FCurrentFrame := 0;
end;

procedure TY4MReader.SeekFrame(frameIndex: uint32_t);
var
  fp: Int64_t;
begin
  if frameIndex >= FFrameCount then
      exit;
  fp := FStartPos + frameIndex * (FFrameSize + FRAME_MAGIC_SIZE);
  FCurrentFrame := frameIndex;
end;

function TY4MReader.ReadFrame: TPlanarImage;
var
  magic: TFRAME_MAGIC;
begin
  umlBlockRead(ioHandle, magic[0], FRAME_MAGIC_SIZE);
  if not CompareMemory(@magic[0], @FRAME_MAGIC[0], FRAME_MAGIC_SIZE) then
      RaiseInfo('Not a Y4M Frame');
  umlBlockRead(ioHandle, img.plane[0]^, FFrameSize);
  inc(FCurrentFrame);
  img.frame_num := FCurrentFrame;
  result := img;
end;

constructor TY4MWriter.Create(const w, h, psf: uint16_t; const filename: TPascalString);
var
  s: TPascalString;
  b: TBytes;
begin
  inherited Create;
  s := PFormat('YUV4MPEG2 W%d H%d F%d:1 Ip A0:0' + #10, [w, h, psf]);
  s.FastGetBytes(b);

  umlFileCreate(filename, ioHandle);
  umlBlockWrite(ioHandle, b[0], length(b));

  SetLength(b, 0);
  s := '';

  FPerSecondFrame := psf;
  FFrameCount := 0;
  img := TPlanarImage.Create(w, h);
end;

constructor TY4MWriter.Create(const w, h, psf: uint16_t; const stream: TCoreClassStream);
var
  s: TPascalString;
  b: TBytes;
begin
  inherited Create;
  s := PFormat('YUV4MPEG2 W%d H%d F%d:1 Ip A0:0' + #10, [w, h, psf]);
  s.FastGetBytes(b);

  umlFileCreateAsStream('stream', stream, ioHandle);
  umlBlockWrite(ioHandle, b[0], length(b));

  SetLength(b, 0);
  s := '';

  FPerSecondFrame := psf;
  FFrameCount := 0;
  img := TPlanarImage.Create(w, h);
end;

destructor TY4MWriter.Destroy;
begin
  DisposeObject(img);
  umlFileClose(ioHandle);
  inherited Destroy;
end;

procedure TY4MWriter.WriteFrame(raster: TMemoryRaster);
var
  FrameSize: int32_t;
begin
  umlBlockWrite(ioHandle, FRAME_MAGIC[0], FRAME_MAGIC_SIZE);
  FrameSize := img.Width * img.Height + (img.Width * img.Height div 2);
  img.LoadFromRaster(raster);
  umlBlockWrite(ioHandle, img.plane[0]^, FrameSize);
  inc(FFrameCount);
end;

procedure TY4MWriter.Flush;
begin
  umlFileFlushWrite(ioHandle);
end;

function TY4MWriter.Y4MSize: Int64_t;
begin
  result := umlFileSize(ioHandle);
end;

end.
