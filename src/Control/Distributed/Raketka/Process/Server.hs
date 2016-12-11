module Control.Distributed.Raketka.Process.Server where

import Data.Tagged hiding (proxy)
import Control.Concurrent.STM
import Control.Distributed.Raketka.HandleMsg as H
import Control.Distributed.Process as P hiding (proxy)
import Control.Distributed.Raketka.Process.Send
import Control.Distributed.Raketka.Type.Message
import Control.Distributed.Raketka.Type.Server as S
import Control.Distributed.Raketka.Type.Arg as T
import Control.Monad
import Debug.Trace
import qualified Data.Map as Map

{- | * init 'proxy'
    * send out pings
    * 'receiveWait's for messages       -}
server::Content c =>
    Tagged c Server -> ServerId -> Process ()
server s1@(Tagged server0) id0  = do
  P.spawnLocal (proxy s1)

  pid1 <- getSelfPid
  liftIO $ atomically $ sendRemoteAll s1 $ Info Ping pid1

  forever $
    P.receiveWait
      [ P.match $ H.handleRemoteMessage s1
      , P.match $ handleMonitorNotification s1
      , P.matchIf (\(WhereIsReply l _) -> l == (service id0)) $
                handleWhereIsReply s1
      , P.matchAny $
            liftIO . traceIO . ("matchAny" ++) . show       -- unknown messages
      ]


-- | pipeline for sending msgs
proxy::Content c =>
    Tagged c Server -> Process ()
proxy (Tagged Server{..}) = forever $ join $
    liftIO $ atomically $ readTChan proxychan


-- | init 'Server' store
newServer::Content c =>
     [ProcessId] -> Process (Tagged c Server)
newServer pids0 = do
  pid1 <- getSelfPid
  liftIO $ do
    s1 <- newTVarIO pids0
    c1 <- newTVarIO Map.empty
    o1 <- newTChanIO
    pure $ Tagged Server { 
            servers = s1, 
            proxychan = o1, 
            spid = pid1
        }
