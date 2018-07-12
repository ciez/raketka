module Control.Distributed.Raketka.Impl.Inst where

import Data.ByteString
import Data.Set as S
import Data.Tagged
import Control.Distributed.Process
import Control.Distributed.Raketka.Type.Arg
import Control.Distributed.Raketka.Type.Server
import qualified Control.Distributed.Raketka.Process.Server as S
import Debug.Trace
import Text.Printf


data Slb = Slb  -- ^ Stateless ByteString   

type Server_slb = Server (Set ProcessId) ()


instance Specific Slb (Set ProcessId) () ByteString where
    handleMessage::Tagged Slb Server_slb -> ByteString -> Process ()
    handleMessage serv0 msg0 =
        trace "handleMessage" $ 
        pure ()  --  todo 

    startServer::Tagged Slb ServerId -> () -> Process ()
    startServer (Tagged id0) _ = server id0 

    onPeerConnected::Tagged Slb Server_slb -> ProcessId -> Process ()
    onPeerConnected (Tagged s0) = tracePid "connected to %s"

    onPeerDisConnected::Tagged Slb Server_slb -> ProcessId -> Process ()
    onPeerDisConnected (Tagged s0) = tracePid "disconnected %s"


tracePid::String    -- ^ formattable string with a placeholder for pid
        -> ProcessId
        -> Process ()
tracePid msg0 pid0 =
        trace msg1 $
        pure ()
        where msg1 = printf msg0 pid0


server::ServerId -> Process ()
server id0 = newServer' >>= flip S.server id0


newServer'::Process (Tagged Slb Server_slb)
newServer' = S.newServer () S.empty
