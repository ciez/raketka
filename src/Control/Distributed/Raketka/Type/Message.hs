module Control.Distributed.Raketka.Type.Message where

import Control.Distributed.Process hiding (Message)
import GHC.Generics (Generic)
import Data.Binary
import Data.Typeable


data Message content = Info Ping ProcessId  -- ^ message sent when nodes join cluster 
                       | Message content    -- ^ other messages 
                       deriving (Typeable, Generic, Show)

data Ping = Ping | Pong deriving (Eq, Show, Generic)

instance Binary content => Binary (Message content)
instance Binary Ping
