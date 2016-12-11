module Main where

import Data.Tagged
import Data.Conf.Json
import System.Environment
import Control.Distributed.Process.Closure
import Control.Distributed.Process.Backend.SimpleLocalnet
import Control.Distributed.Process.Node as Node hiding (newLocalNode)
import Control.Distributed.Raketka.Master
import Control.Distributed.Raketka.Type.Arg
import Control.Distributed.Raketka.Impl.Inst as I


remotable ['server]


main::IO()
main = do
    [path0, idx0] <- getArgs 
    Right c1 @ (Cluster conf1) <- readParse path0::IO (Either String Cluster)
    let this1 = conf1 !! (read idx0::Int)
        thisport1 = show $ port this1
    backend1 <- initializeBackend (host this1) thisport1
                    (__remoteTable initRemoteTable)
    node1 <- newLocalNode backend1
    Node.runProcess node1 
            (master backend1 c1 
                (Tagged $ read idx0::Tagged TByteString Int))