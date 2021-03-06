-- |
-- Module      :  Graphics.Craftwerk.Core.Style
-- Copyright   :  (c) Malte Harder 2011
-- License     :  MIT
-- Maintainer  :  Malte Harder <malte.harder@gmail.com>
--
-- Styles in craftwerk are nodes in the figure tree and the style at the node is
-- applied to all subnodes. If a field of a style is empty (i.e its value
-- is 'Nothing') the value of the next parent style node is applied.

module Graphics.Craftwerk.Core.Style (
  -- * Data types
      StyleProperties(..)
    , LineCap(..)
    , LineJoin(..)
    , ArrowTip(..)

  -- * Named styles
  , emptyStyle
  , newStyle
  , defaultStyle
  , setLineWidth
  , fillOnly
  , strokeOnly

  -- * Property values
  , yes
  , no
  , rgb
  , width
  , verythin
  , thin
  , semithick
  , thick
  , verythick
  , ultrathick
  , limit
  , phase

  -- * Property access and merging
  , getProperty
  , mergeProperties

    -- * Arrow functions
  , arrow
  , (<=>)
  , (===)
  , (==>)
  , (<==)

  ) where

import Graphics.Craftwerk.Core.Color

import Data.Maybe

data ArrowDummy = ArrowDummy deriving Show
data ArrowTip = TipNone |  TipDefault deriving (Show,Eq)

type ArrowTips = (ArrowTip, ArrowTip)

data LineCap = CapRect | CapButt | CapRound deriving (Show,Eq)
data LineJoin = JoinRound | JoinBevel | JoinMiter deriving (Show,Eq)

-- | A record holding all possible properties.
data StyleProperties =
  StyleProperties { lineWidth :: Maybe Double
                  , lineColor :: Maybe FigureColor
                  , fillColor :: Maybe FigureColor
                  , fill :: Maybe Bool
                  , stroke :: Maybe Bool
                  , clip :: Maybe Bool
                  , closePath :: Maybe Bool
                  , dashes :: Maybe [Double]
                  , dashPhase :: Maybe Double
                  , lineCap :: Maybe LineCap
                  , lineJoin :: Maybe LineJoin
                  , miterLimit :: Maybe Double
                  , arrowTips :: Maybe ArrowTips
                  } deriving (Show, Eq)


-- | A style where no property has been set.
emptyStyle :: StyleProperties
emptyStyle = StyleProperties
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing
             Nothing

-- | Alias for empty style, makes style construction nicer.
newStyle :: StyleProperties
newStyle = emptyStyle

-- | The default style used at the root node of any 'Figure'.
defaultStyle :: StyleProperties
defaultStyle =
  StyleProperties { lineWidth = Just 1.0
                  , lineColor = Just black
                  , fillColor = Just white
                  , stroke = Just True
                  , fill = Just False
                  , clip = Just False
                  , closePath = Just False
                  , dashes = Just [] :: Maybe [Double]
                  , dashPhase = Just 0.0
                  , lineCap = Just CapButt
                  , lineJoin = Just JoinMiter
                  , miterLimit = Just 10.0
                  , arrowTips = Just (TipNone, TipNone)
                  }

setLineWidth :: Maybe Double -> StyleProperties
setLineWidth a = newStyle { lineWidth = a }

fillOnly :: StyleProperties
fillOnly = newStyle { fill = yes, stroke = no }

strokeOnly :: StyleProperties
strokeOnly = newStyle { fill = no, stroke = yes}

-- | Alias for 'Just True' to make style specification more convenient.
yes :: Maybe Bool
yes = Just True

-- | Alias for 'Just False' to make style specification more convenient.
no :: Maybe Bool
no = Just False

-- | Make a rgb color property.
rgb :: Double -> Double -> Double -> Maybe FigureColor
rgb r g b = Just $ sRGB r g b

-- | Alias for 'Just'
width :: Double -> Maybe Double
width = Just

-- | Width 0.2.
verythin ::  Maybe Double
verythin = width 0.2

-- | Width 0.4.
thin ::  Maybe Double
thin = width 0.4

-- | Width 0.6.
semithick ::  Maybe Double
semithick = width 0.6

-- | Width 0.8.
thick ::  Maybe Double
thick = width 0.8

-- | Width 1.2.
verythick ::  Maybe Double
verythick = width 1.2

-- | Width 1.6.
ultrathick ::  Maybe Double
ultrathick = width 1.6

-- | Alias for 'Just'.
limit :: Double -> Maybe Double
limit = width

-- | Alias for 'Just'.
phase :: Double -> Maybe Double
phase = width

-- | Read a property from a style property record returning the value of
-- the default style if the value is 'Nothing'.
getProperty :: StyleProperties -> (StyleProperties -> Maybe a) -> a
getProperty s f = fromMaybe (fromJust $ f defaultStyle) (f s)

mergeProperty :: StyleProperties ->
                 StyleProperties ->
                 (StyleProperties -> Maybe a) ->
                 Maybe a
mergeProperty s t f = case f t of
  Nothing -> f s
  x -> x

-- | Merge two property records, where the second argument overwrites fields of
-- the first unless a field is 'Nothing'.
mergeProperties :: StyleProperties ->
                   StyleProperties ->
                   StyleProperties
mergeProperties s t =
  StyleProperties { lineWidth = mergeProperty s t lineWidth
                  , lineColor = mergeProperty s t lineColor
                  , fillColor = mergeProperty s t fillColor
                  , fill = mergeProperty s t fill
                  , stroke = mergeProperty s t stroke
                  , clip = mergeProperty s t clip
                  , closePath = mergeProperty s t closePath
                  , dashes = mergeProperty s t dashes
                  , dashPhase = mergeProperty s t dashPhase
                  , lineCap = mergeProperty s t lineCap
                  , lineJoin = mergeProperty s t lineJoin
                  , miterLimit = mergeProperty s t miterLimit
                  , arrowTips = mergeProperty s t arrowTips
                  }

-- * Arrow styles

-- | Arrow tip styles can be specified by using the notation 'arrow (<==)'
arrow :: (ArrowDummy -> ArrowTips) -> Maybe ArrowTips
arrow f = Just (f ArrowDummy)

(<=>) :: ArrowDummy  -> ArrowTips
(<=>) _ = (TipDefault, TipDefault)

(===) :: ArrowDummy  -> ArrowTips
(===) _ = (TipNone, TipNone)

(==>) :: ArrowDummy  -> ArrowTips
(==>) _ = (TipNone, TipDefault)

(<==) :: ArrowDummy  -> ArrowTips
(<==) _ = (TipDefault, TipNone)
