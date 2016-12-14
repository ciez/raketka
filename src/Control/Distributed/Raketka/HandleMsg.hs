module Control.Distributed.Raketka.HandleMsg where

import Data.Tagged
import Text.Printf
import Control.Distributed.Process as P hiding (Message, handleMessage)
import Control.Concurrent.STM
import Control.Distributed.Raketka.NewServerInfo
import Control.Distributed.Raketka.Process.Send
import Control.Distributed.Raketka.Type.Server as T
import Control.Distributed.Raketka.Type.Message as M

{- | both 'Info' with 'Ping' and ordinary 'Messages' 

calls 

    * 'newServerInfo'
    * 'handleMessage'
    
    depending on message type
-} 
handleRemoteMessage::Content tag ps s c =>
    Tagged tag (Server ps s) -> Message c -> Process ()
handleRemoteMessage s1@(Tagged Server{..}) msg0 =  
  case msg0 of
    Info ping1 pid1 -> newServerInfo s1 ping1 pid1 
    Message msg1 -> handleMessage s1 msg1


{- | handles replies to 'whereisRemoteAsync', run on init 
in "Control.Distributed.Raketka.Master" -}
handleWhereIsReply::Content tag ps s c =>
    Tagged tag (Server ps s) -> WhereIsReply -> Process () 
handleWhereIsReply _ (P.WhereIsReply _ Nothing) = pure ()
handleWhereIsReply s1@(Tagged Server{..}) (WhereIsReply _ (Just pid0)) =
  la $ sendRemote s1 pid0 $ Info Ping spid


{- | 'ProcessMonitorNotification' e.g. connection lost  -} 
handleMonitorNotification::Content tag ps s c =>
    Tagged tag (Server ps s) -> ProcessMonitorNotification -> Process ()
handleMonitorNotification
       s1@(Tagged Server{..}) (ProcessMonitorNotification _ pid0 reason0) = do
  say (printf "server on %s dropped connection. reason: %s" pid0 (show reason0))
  la $ do
    old_pids1 <- readTVar servers
    writeTVar servers $ onPeerDisConnected' old_pids1 pid0
  onPeerDisConnected s1 pid0 
