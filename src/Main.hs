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


remotable ['I.server]


main::IO()
main = do
    [path0, idx0] <- getArgs 
    Right c1 @ (Cluster conf1) <- readParse path0::IO (Either String Cluster)
    let idx1 = read idx0::Int
    idKnown c1 $ Tagged idx1


idKnown::Cluster -> Tagged Slb Int -> IO()
idKnown cl1@(Cluster cl0) idx1@(Tagged idx0) = do
    backend1 <- initializeBackend (host id1) thisport1
                    (__remoteTable initRemoteTable)
    node1 <- newLocalNode backend1
    Node.runProcess node1 
            (master backend1 cl1 
                idx1
                ())
    where thisport1 = show $ port id1
          id1 = cl0 !! idx0  
                