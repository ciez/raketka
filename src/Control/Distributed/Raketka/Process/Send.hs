module Control.Distributed.Raketka.Process.Send
   (sendRemote,
   sendRemoteAll)  where

import Data.Tagged
import Control.Concurrent.STM
import Control.Distributed.Raketka.Type.Server
import Control.Distributed.Process
              hiding (Message, mask, finally, handleMessage, proxy)
import Control.Distributed.Raketka.Type.Message


{- | send message to 'ProcessId'. 

Other ways of sending messages are not implemented to keep the code basic.  
-}
sendRemote::Content tag ps s c =>
    Tagged tag (Server ps s) -> ProcessId -> Message c -> STM ()
sendRemote (Tagged Server{..}) pid pmsg =
    writeTChan proxychan (send pid pmsg)

{- | broadcast message to all known peers -}
sendRemoteAll::Content tag ps s c =>
    Tagged tag (Server ps s) -> Message c -> STM ()
sendRemoteAll s1@(Tagged server0@Server{..}) pmsg0 = do
    pids1 <- readTVar servers
    mapM_ (\pid1 -> sendRemote s1 pid1 pmsg0) $ peer_pids pids1
