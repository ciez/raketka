module Control.Distributed.Raketka.NewServerInfo where

import Data.Tagged
import Control.Distributed.Process
  hiding (Message, mask, finally, handleMessage)
import Control.Monad
import Text.Printf
import Control.Concurrent.STM
import Control.Distributed.Raketka.Type.Server
import Control.Distributed.Raketka.Type.Message
import Control.Distributed.Raketka.Process.Send

{- | 'Ping' and 'Pong' handler -}
newServerInfo::Content tag ps s c =>
    Tagged tag (Server ps s) 
    -> Ping 
    -> ProcessId 
    -> Process ()

newServerInfo s1@(Tagged server0@Server{..}) ping0 pid0 = do
    liftIO $ printf "%s received %s from %s\n" spid (show ping0) pid0
    join $ liftIO $ atomically $ do
        old_pids1 <- readTVar servers
        let old_pids2 = peer_pids old_pids1
        writeTVar servers $ onPeerConnected' old_pids1 pid0

        when (ping0 == Ping) $ sendRemote s1 pid0 $ Info Pong spid 
    
        -- monitor the new server
        pure (when (pid0 `notElem` old_pids2) $ void $ monitor pid0)

    onPeerConnected s1 pid0
