module Craftwerk.Core.Driver.Cairo where

import GHC.Float

import Craftwerk.Core.Figure
import Craftwerk.Core.Color
import Craftwerk.Core.Style

import qualified Graphics.Rendering.Cairo as Cairo

import Control.Monad

pointConvert :: (Float, Float) -> (Double , Double)
pointConvert (a,b) = (float2Double a, float2Double b)

fnC :: (Double -> Double -> c) -> (Float, Float) -> c
fnC f = (uncurry f) . pointConvert

figureToRenderContext :: Figure -> Cairo.Render ()
figureToRenderContext = figureToRenderContextWithStyle defaultStyle

figureToRenderContextWithStyle _ Blank = return ()
figureToRenderContextWithStyle s (Style ns a) = (figureToRenderContextWithStyle (mergeProperties s ns) a)

figureToRenderContextWithStyle s (Rotate r a) = Cairo.save >> 
                                                Cairo.rotate (float2Double r) >> 
                                                figureToRenderContextWithStyle s a >> 
                                                Cairo.restore
                                                
figureToRenderContextWithStyle s (Scale p a) = Cairo.save >> 
                                               (fnC Cairo.scale) p >> 
                                               figureToRenderContextWithStyle s a >> 
                                               Cairo.restore
                                               
figureToRenderContextWithStyle s (Translate p a) = Cairo.save >> 
                                                   (fnC Cairo.translate) p  >> 
                                                   figureToRenderContextWithStyle s a >> 
                                                   Cairo.restore
                                                   
figureToRenderContextWithStyle s (Composition a) = sequence_ (map (figureToRenderContextWithStyle s) a)

figureToRenderContextWithStyle s (Line a) = do 
  let sp = getProperty s
  when (sp fill ) (do cairoSetColor (sp fillColor)
                      cairoPath a sp
                      Cairo.fill)
  when (sp stroke) (do cairoSetColor (sp lineColor)
                       cairoPath a sp
                       Cairo.setLineWidth (float2Double $ sp lineWidth )
                       Cairo.stroke)

                                               
figureToRenderContextWithStyle s (Text a) = Cairo.textPath a >> Cairo.fill

cairoSetColor (RGBA r g b a) = Cairo.setSourceRGB (float2Double r) (float2Double g) (float2Double b)

cairoPath a sp = do (fnC Cairo.moveTo) (head a) 
                    sequence_ (map (fnC Cairo.lineTo) a)
                    when (sp closePath) (Cairo.closePath) 
                       