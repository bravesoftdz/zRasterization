program HelloWorld;

uses
  System.StartUpCopy,
  FMX.Forms,
  HelloWorldFrm in 'HelloWorldFrm.pas' {Form1},
  Agg2D in '..\..\source\Agg2D.pas',
  AggAlphaMaskUnpacked8 in '..\..\source\AggAlphaMaskUnpacked8.pas',
  AggArc in '..\..\source\AggArc.pas',
  AggArray in '..\..\source\AggArray.pas',
  AggArrowHead in '..\..\source\AggArrowHead.pas',
  AggBasics in '..\..\source\AggBasics.pas',
  AggBezierArc in '..\..\source\AggBezierArc.pas',
  AggBitsetIterator in '..\..\source\AggBitsetIterator.pas',
  AggBlur in '..\..\source\AggBlur.pas',
  AggBoundingRect in '..\..\source\AggBoundingRect.pas',
  AggBSpline in '..\..\source\AggBSpline.pas',
  AggClipLiangBarsky in '..\..\source\AggClipLiangBarsky.pas',
  AggColor32 in '..\..\source\AggColor32.pas',
  AggColorConversion in '..\..\source\AggColorConversion.pas',
  AggControl in '..\..\source\AggControl.pas',
  AggConvAdaptorVcgen in '..\..\source\AggConvAdaptorVcgen.pas',
  AggConvAdaptorVpgen in '..\..\source\AggConvAdaptorVpgen.pas',
  AggConvBSpline in '..\..\source\AggConvBSpline.pas',
  AggConvClipPolygon in '..\..\source\AggConvClipPolygon.pas',
  AggConvClipPolyline in '..\..\source\AggConvClipPolyline.pas',
  AggConvConcat in '..\..\source\AggConvConcat.pas',
  AggConvContour in '..\..\source\AggConvContour.pas',
  AggConvCurve in '..\..\source\AggConvCurve.pas',
  AggConvDash in '..\..\source\AggConvDash.pas',
  AggConvGpc in '..\..\source\AggConvGpc.pas',
  AggConvMarker in '..\..\source\AggConvMarker.pas',
  AggConvMarkerAdaptor in '..\..\source\AggConvMarkerAdaptor.pas',
  AggConvSegmentator in '..\..\source\AggConvSegmentator.pas',
  AggConvShortenPath in '..\..\source\AggConvShortenPath.pas',
  AggConvSmoothPoly in '..\..\source\AggConvSmoothPoly.pas',
  AggConvStroke in '..\..\source\AggConvStroke.pas',
  AggConvTransform in '..\..\source\AggConvTransform.pas',
  AggCurves in '..\..\source\AggCurves.pas',
  AggDdaLine in '..\..\source\AggDdaLine.pas',
  AggEllipse in '..\..\source\AggEllipse.pas',
  AggEllipseBresenham in '..\..\source\AggEllipseBresenham.pas',
  AggGammaFunctions in '..\..\source\AggGammaFunctions.pas',
  AggGammaLUT in '..\..\source\AggGammaLUT.pas',
  AggGradientLut in '..\..\source\AggGradientLut.pas',
  AggImageFilters in '..\..\source\AggImageFilters.pas',
  AggLineAABasics in '..\..\source\AggLineAABasics.pas',
  AggMath in '..\..\source\AggMath.pas',
  AggMathStroke in '..\..\source\AggMathStroke.pas',
  AggPathStorage in '..\..\source\AggPathStorage.pas',
  AggPathStorageInteger in '..\..\source\AggPathStorageInteger.pas',
  AggPatternFiltersRgba in '..\..\source\AggPatternFiltersRgba.pas',
  AggPixelFormat in '..\..\source\AggPixelFormat.pas',
  AggPixelFormatAlphaMaskAdaptor in '..\..\source\AggPixelFormatAlphaMaskAdaptor.pas',
  AggPixelFormatGray in '..\..\source\AggPixelFormatGray.pas',
  AggPixelFormatRgb in '..\..\source\AggPixelFormatRgb.pas',
  AggPixelFormatRgba in '..\..\source\AggPixelFormatRgba.pas',
  AggPixelFormatRgbPacked in '..\..\source\AggPixelFormatRgbPacked.pas',
  AggPixelFormatTransposer in '..\..\source\AggPixelFormatTransposer.pas',
  AggQuadratureOscillator in '..\..\source\AggQuadratureOscillator.pas',
  AggRasterizerCellsAA in '..\..\source\AggRasterizerCellsAA.pas',
  AggRasterizerCompoundAA in '..\..\source\AggRasterizerCompoundAA.pas',
  AggRasterizerOutline in '..\..\source\AggRasterizerOutline.pas',
  AggRasterizerOutlineAA in '..\..\source\AggRasterizerOutlineAA.pas',
  AggRasterizerScanLine in '..\..\source\AggRasterizerScanLine.pas',
  AggRasterizerScanLineAA in '..\..\source\AggRasterizerScanLineAA.pas',
  AggRasterizerScanlineClip in '..\..\source\AggRasterizerScanlineClip.pas',
  AggRendererBase in '..\..\source\AggRendererBase.pas',
  AggRendererMarkers in '..\..\source\AggRendererMarkers.pas',
  AggRendererMultiClip in '..\..\source\AggRendererMultiClip.pas',
  AggRendererOutlineAA in '..\..\source\AggRendererOutlineAA.pas',
  AggRendererOutlineImage in '..\..\source\AggRendererOutlineImage.pas',
  AggRendererPrimitives in '..\..\source\AggRendererPrimitives.pas',
  AggRendererScanLine in '..\..\source\AggRendererScanLine.pas',
  AggRenderingBuffer in '..\..\source\AggRenderingBuffer.pas',
  AggRenderingBufferDynaRow in '..\..\source\AggRenderingBufferDynaRow.pas',
  AggRenderScanlines in '..\..\source\AggRenderScanlines.pas',
  AggRoundedRect in '..\..\source\AggRoundedRect.pas',
  AggScanline in '..\..\source\AggScanline.pas',
  AggScanlineBin in '..\..\source\AggScanlineBin.pas',
  AggScanlineBooleanAlgebra in '..\..\source\AggScanlineBooleanAlgebra.pas',
  AggScanlinePacked in '..\..\source\AggScanlinePacked.pas',
  AggScanlineStorageAA in '..\..\source\AggScanlineStorageAA.pas',
  AggScanlineStorageBin in '..\..\source\AggScanlineStorageBin.pas',
  AggScanlineUnpacked in '..\..\source\AggScanlineUnpacked.pas',
  AggShortenPath in '..\..\source\AggShortenPath.pas',
  AggSimulEq in '..\..\source\AggSimulEq.pas',
  AggSpanAllocator in '..\..\source\AggSpanAllocator.pas',
  AggSpanConverter in '..\..\source\AggSpanConverter.pas',
  AggSpanGenerator in '..\..\source\AggSpanGenerator.pas',
  AggSpanGouraud in '..\..\source\AggSpanGouraud.pas',
  AggSpanGouraudGray in '..\..\source\AggSpanGouraudGray.pas',
  AggSpanGouraudRgba in '..\..\source\AggSpanGouraudRgba.pas',
  AggSpanGradient in '..\..\source\AggSpanGradient.pas',
  AggSpanGradientAlpha in '..\..\source\AggSpanGradientAlpha.pas',
  AggSpanGradientContour in '..\..\source\AggSpanGradientContour.pas',
  AggSpanGradientImage in '..\..\source\AggSpanGradientImage.pas',
  AggSpanImageFilter in '..\..\source\AggSpanImageFilter.pas',
  AggSpanImageFilterGray in '..\..\source\AggSpanImageFilterGray.pas',
  AggSpanImageFilterRgb in '..\..\source\AggSpanImageFilterRgb.pas',
  AggSpanImageFilterRgba in '..\..\source\AggSpanImageFilterRgba.pas',
  AggSpanImageResample in '..\..\source\AggSpanImageResample.pas',
  AggSpanImageResampleGray in '..\..\source\AggSpanImageResampleGray.pas',
  AggSpanImageResampleRgb in '..\..\source\AggSpanImageResampleRgb.pas',
  AggSpanImageResampleRgba in '..\..\source\AggSpanImageResampleRgba.pas',
  AggSpanInterpolatorAdaptor in '..\..\source\AggSpanInterpolatorAdaptor.pas',
  AggSpanInterpolatorLinear in '..\..\source\AggSpanInterpolatorLinear.pas',
  AggSpanInterpolatorPerspective in '..\..\source\AggSpanInterpolatorPerspective.pas',
  AggSpanInterpolatorTrans in '..\..\source\AggSpanInterpolatorTrans.pas',
  AggSpanPattern in '..\..\source\AggSpanPattern.pas',
  AggSpanPatternFilterGray in '..\..\source\AggSpanPatternFilterGray.pas',
  AggSpanPatternFilterRgb in '..\..\source\AggSpanPatternFilterRgb.pas',
  AggSpanPatternFilterRgba in '..\..\source\AggSpanPatternFilterRgba.pas',
  AggSpanPatternResampleGray in '..\..\source\AggSpanPatternResampleGray.pas',
  AggSpanPatternResampleRgb in '..\..\source\AggSpanPatternResampleRgb.pas',
  AggSpanPatternResampleRgba in '..\..\source\AggSpanPatternResampleRgba.pas',
  AggSpanPatternRgb in '..\..\source\AggSpanPatternRgb.pas',
  AggSpanPatternRgba in '..\..\source\AggSpanPatternRgba.pas',
  AggSpanSolid in '..\..\source\AggSpanSolid.pas',
  AggSpanSubdivAdaptor in '..\..\source\AggSpanSubdivAdaptor.pas',
  AggSpiral in '..\..\source\AggSpiral.pas',
  AggTransAffine in '..\..\source\AggTransAffine.pas',
  AggTransBilinear in '..\..\source\AggTransBilinear.pas',
  AggTransDoublePath in '..\..\source\AggTransDoublePath.pas',
  AggTransPerspective in '..\..\source\AggTransPerspective.pas',
  AggTransSinglePath in '..\..\source\AggTransSinglePath.pas',
  AggTransViewport in '..\..\source\AggTransViewport.pas',
  AggTransWarpMagnifier in '..\..\source\AggTransWarpMagnifier.pas',
  AggVcgenBSpline in '..\..\source\AggVcgenBSpline.pas',
  AggVcgenContour in '..\..\source\AggVcgenContour.pas',
  AggVcgenDash in '..\..\source\AggVcgenDash.pas',
  AggVcgenMarkersTerm in '..\..\source\AggVcgenMarkersTerm.pas',
  AggVcgenSmoothPoly1 in '..\..\source\AggVcgenSmoothPoly1.pas',
  AggVcgenStroke in '..\..\source\AggVcgenStroke.pas',
  AggVcgenVertexSequence in '..\..\source\AggVcgenVertexSequence.pas',
  AggVertexSequence in '..\..\source\AggVertexSequence.pas',
  AggVertexSource in '..\..\source\AggVertexSource.pas',
  AggVpGen in '..\..\source\AggVpGen.pas',
  AggVpGenClipPolygon in '..\..\source\AggVpGenClipPolygon.pas',
  AggVpGenClipPolyline in '..\..\source\AggVpGenClipPolyline.pas',
  AggVpGenSegmentator in '..\..\source\AggVpGenSegmentator.pas',
  BulletMovementEngine in '..\..\source\BulletMovementEngine.pas',
  Cadencer in '..\..\source\Cadencer.pas',
  CoreCipher in '..\..\source\CoreCipher.pas',
  CoreClasses in '..\..\source\CoreClasses.pas',
  CoreCompress in '..\..\source\CoreCompress.pas',
  DataFrameEngine in '..\..\source\DataFrameEngine.pas',
  DBCompressPackageForFile in '..\..\source\DBCompressPackageForFile.pas',
  DoStatusIO in '..\..\source\DoStatusIO.pas',
  Fast_MD5 in '..\..\source\Fast_MD5.pas',
  Geometry2DUnit in '..\..\source\Geometry2DUnit.pas',
  Geometry3DUnit in '..\..\source\Geometry3DUnit.pas',
  GeometryLib in '..\..\source\GeometryLib.pas',
  GeometryRotationUnit in '..\..\source\GeometryRotationUnit.pas',
  gpc in '..\..\source\gpc.pas',
  h264 in '..\..\source\h264.pas',
  h264_FPCGenericStructlist in '..\..\source\h264_FPCGenericStructlist.pas',
  h264BitStream in '..\..\source\h264BitStream.pas',
  h264Common in '..\..\source\h264Common.pas',
  h264Encoder in '..\..\source\h264Encoder.pas',
  h264Frame in '..\..\source\h264Frame.pas',
  h264Image in '..\..\source\h264Image.pas',
  h264inter_pred in '..\..\source\h264inter_pred.pas',
  h264Intra_pred in '..\..\source\h264Intra_pred.pas',
  h264Loopfilter in '..\..\source\h264Loopfilter.pas',
  h264Macroblock in '..\..\source\h264Macroblock.pas',
  h264MB_encoder in '..\..\source\h264MB_encoder.pas',
  h264Motion_comp in '..\..\source\h264Motion_comp.pas',
  h264Motion_est in '..\..\source\h264Motion_est.pas',
  h264motion_est_search in '..\..\source\h264motion_est_search.pas',
  h264Parameters in '..\..\source\h264Parameters.pas',
  h264Pixel in '..\..\source\h264Pixel.pas',
  h264RateControl in '..\..\source\h264RateControl.pas',
  h264Stats in '..\..\source\h264Stats.pas',
  h264Stdint in '..\..\source\h264Stdint.pas',
  h264stream in '..\..\source\h264stream.pas',
  h264tables in '..\..\source\h264tables.pas',
  h264Transquant in '..\..\source\h264Transquant.pas',
  h264Util in '..\..\source\h264Util.pas',
  h264VLC in '..\..\source\h264VLC.pas',
  ItemStream in '..\..\source\ItemStream.pas',
  JLSBaseCodec in '..\..\source\JLSBaseCodec.pas',
  JLSBitIO in '..\..\source\JLSBitIO.pas',
  JLSCodec in '..\..\source\JLSCodec.pas',
  JLSDecoder in '..\..\source\JLSDecoder.pas',
  JLSEncoder in '..\..\source\JLSEncoder.pas',
  JLSGlobal in '..\..\source\JLSGlobal.pas',
  JLSJpegmark in '..\..\source\JLSJpegmark.pas',
  JLSLossless in '..\..\source\JLSLossless.pas',
  JLSLossy in '..\..\source\JLSLossy.pas',
  JLSMelcode in '..\..\source\JLSMelcode.pas',
  JsonDataObjects in '..\..\source\JsonDataObjects.pas',
  LibraryManager in '..\..\source\LibraryManager.pas',
  ListEngine in '..\..\source\ListEngine.pas',
  MediaCenter in '..\..\source\MediaCenter.pas',
  MemoryRaster in '..\..\source\MemoryRaster.pas',
  MemoryStream64 in '..\..\source\MemoryStream64.pas',
  MH in '..\..\source\MH.pas',
  MH_1 in '..\..\source\MH_1.pas',
  MH_2 in '..\..\source\MH_2.pas',
  MH_3 in '..\..\source\MH_3.pas',
  MH_ZDB in '..\..\source\MH_ZDB.pas',
  NotifyObjectBase in '..\..\source\NotifyObjectBase.pas',
  ObjectData in '..\..\source\ObjectData.pas',
  ObjectDataManager in '..\..\source\ObjectDataManager.pas',
  opCode in '..\..\source\opCode.pas',
  Optimize.Move.Win32 in '..\..\source\Optimize.Move.Win32.pas',
  PascalStrings in '..\..\source\PascalStrings.pas',
  StreamList in '..\..\source\StreamList.pas',
  TextDataEngine in '..\..\source\TextDataEngine.pas',
  TextParsing in '..\..\source\TextParsing.pas',
  TextTable in '..\..\source\TextTable.pas',
  UnicodeMixedLib in '..\..\source\UnicodeMixedLib.pas',
  UPascalStrings in '..\..\source\UPascalStrings.pas',
  Y4M in '..\..\source\Y4M.pas',
  ZDBEngine in '..\..\source\ZDBEngine.pas',
  ZDBLocalManager in '..\..\source\ZDBLocalManager.pas',
  zDrawEngine in '..\..\source\zDrawEngine.pas',
  zDrawEngineSoftH264 in '..\..\source\zDrawEngineSoftH264.pas',
  zDrawEngineSoftY4M in '..\..\source\zDrawEngineSoftY4M.pas',
  zExpression in '..\..\source\zExpression.pas',
  zSound in '..\..\source\zSound.pas',
  MovementEngine in '..\..\source\MovementEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
