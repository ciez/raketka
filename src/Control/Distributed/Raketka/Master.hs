module Control.Distributed.Raketka.Master where

import Data.Tagged
import Control.Distributed.Process as P
import Control.Monad
import Control.Distributed.Process.Backend.SimpleLocalnet
import Control.Distributed.Raketka.Type.Arg as T
import Control.Distributed.Raketka.Type.Server
import Control.Distributed.Raketka.NodeId as N

{-| * registers own pid
    * calls 'whereisRemoteAsync' for each suggested peer
    * calls 'startServer'  
-}
master::Specific tag ps s c =>
    Backend 
    -> Cluster          -- ^ server ids from config   
    -> Tagged tag Int     -- ^ this server's idx in cluster  
    -> Process ()
master backend0 (Cluster ids0) idx1@(Tagged idx0) = do
  mynode1 <- getSelfNode

  let peers1 = N.nodeId <$> ids0
      this1 = ids0 !! idx0
      service1 = T.service this1
      peers2 = filter (/= mynode1) peers1

  mypid1 <- getSelfPid
  register service1 mypid1

  forM_ peers2 $ \(peer1::NodeId) -> P.whereisRemoteAsync peer1 service1

  startServer $ passTag idx1 this1
