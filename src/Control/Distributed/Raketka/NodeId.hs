module Control.Distributed.Raketka.NodeId where

import Control.Distributed.Process
import Network.Transport.TCP
import Control.Distributed.Raketka.Type.Arg


-- | this library does not try to discover peers. Config hints nodes to try to connect to
nodeId::ServerId -> NodeId
nodeId id0 = NodeId $ encodeEndPointAddress host1 port1 0
    where host1 = host id0
          port1 = show $ port id0  