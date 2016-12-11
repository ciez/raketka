module Control.Distributed.Raketka.Impl.LByteString where

import qualified Data.ByteString as B (ByteString,concat)
import qualified Data.ByteString.Lazy as L (ByteString,toChunks,fromChunks)


toStrict::L.ByteString -> B.ByteString
toStrict = B.concat . L.toChunks


toLazy::B.ByteString -> L.ByteString
toLazy bs = L.fromChunks [bs]
