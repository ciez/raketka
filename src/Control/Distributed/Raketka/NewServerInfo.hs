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
    say $ printf "%s received %s from %s\n" spid (show ping0) pid0
    old_pids1 <- la $ readTVar servers
    let old_pids2 = peer_pids old_pids1
    la $ writeTVar servers $ onPeerConnected' old_pids1 pid0

    if (ping0 == Ping) then 
        la (sendRemote s1 pid0 $ Info Pong spid)
        else pure ()

    -- monitor the new server
    when (pid0 `notElem` old_pids2) $ void $ monitor pid0

    onPeerConnected s1 pid0
