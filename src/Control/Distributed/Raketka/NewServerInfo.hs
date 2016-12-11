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
newServerInfo::Content c =>
    Tagged c Server 
    -> Ping 
    -> ProcessId 
    -> Process ()

newServerInfo s1@(Tagged server0@Server{..}) ping0 pid0 = do
  liftIO $ printf "%s received %s from %s\n" (show spid) (show ping0) (show pid0)
  join $ liftIO $ atomically $ do
    old_pids1 <- readTVar servers
    writeTVar servers (pid0 : filter (/= pid0) old_pids1)

    when (ping0 == Ping) $ sendRemote s1 pid0 $ Info Pong spid 

    -- monitor the new server
    return (when (pid0 `notElem` old_pids1) $ void $ monitor pid0)
