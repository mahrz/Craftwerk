-- |
-- Module      :  Craftwerk.Core
-- Copyright   :  (c) Malte Harder 2011
-- License     :  MIT
-- Maintainer  :  Malte Harder <malte.harder@gmail.com>
--
-- A high-level and easy to use graphics library with several backends,
-- currently including TikZ, Cairo (craftwerk-cairo) with Gtk UI (craftwerk-gtk)
-- and Gloss (craftwerk-gloss).
-- .
-- Thanks to Jannis Harder for contributions and comments.
-- Thanks to Ben Lippmeier for inspirations from the gloss library.
--

module Craftwerk.Core
       (
         module Craftwerk.Core.Color
       , module Craftwerk.Core.ColorNames
       , module Craftwerk.Core.Style
       , module Craftwerk.Core.Figure

       , module Craftwerk.Core.Driver.Tikz
       , module Craftwerk.Core.Driver.Generic
       ) where

import Craftwerk.Core.Color
import Craftwerk.Core.ColorNames
import Craftwerk.Core.Style
import Craftwerk.Core.Figure

import Craftwerk.Core.Driver.Tikz
import Craftwerk.Core.Driver.Generic

