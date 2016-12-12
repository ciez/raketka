{- | see also 

<https://hackage.haskell.org/package/parconc-examples>

<http://haskell-distributed.github.io/tutorials/1ch.html> 

This library:

    * has basic working code to enable to start nodes and to connect them with each other
    * may be extended however you are most likely to write your own code that does much more 
    * is simple on purpose
    * exchanges pings with other nodes which are expected to pong back 
    * both pings & pongs are output to stdout
    * when a node disconnects or stops, the other nodes stdout notifications about this

==== How to use the program that comes with this library:

    start the same program in multiple consoles: 1 per node
 
    pass 2 args:

        1. path to config.json (see enclosed test-conf.json)
        2. idx of this node in the cluster: 0 .. (length Cluster -1)        

 >>>  ./raketka ./test-conf.json 0    

    stop (ctrl-C) any nodes, see notifications in live consoles     -}
    
module Control.Distributed.Raketka.Type.Arg where

import GHC.Generics
import Data.Aeson
import Data.Binary

-- | one node
data ServerId = ServerId {
        host::String,       -- ^ e.g. localhost or 127.0.0.1 
        port::Int,          -- ^ for node communication
        service::String     -- ^ channel type: choose any string. Use same type for connected nodes or different types for multiple disconnected clusters 
    } deriving (Show,Generic)

instance Binary ServerId


-- | config file structure
data Cluster = Cluster [ServerId] deriving (Generic,Show)


instance FromJSON ServerId
-- ^ to read conf

instance FromJSON Cluster
-- ^ to read conf
