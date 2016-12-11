module Control.Distributed.Raketka.Impl.Inst where

import Data.Data
import Data.Binary
import Data.ByteString
import Data.Tagged
import Control.Distributed.Process
import Control.Distributed.Raketka.Type.Arg
import Control.Distributed.Raketka.Type.Server
import qualified Control.Distributed.Raketka.Process.Server as S
import Debug.Trace


newtype TByteString = TByteString ByteString deriving (Data, Typeable, Binary, Show)


instance Specific TByteString where
    handleMessage::Tagged TByteString Server -> TByteString -> Process ()
    handleMessage serv0 msg0 =
        trace "handleMessage" $ 
        pure ()  --  todo 

    startServer::Tagged TByteString ServerId -> Process ()
    startServer (Tagged id0) = server id0


server::ServerId -> Process ()
server id0 = newServer' >>= flip S.server id0


newServer'::Process (Tagged TByteString Server)
newServer' = S.newServer []
