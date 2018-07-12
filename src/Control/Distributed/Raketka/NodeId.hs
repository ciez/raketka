module Control.Distributed.Raketka.NodeId where

import Control.Distributed.Process
import Network.Transport.TCP
import Control.Distributed.Raketka.Type.Arg
import Network.Transport ( EndPointAddress(..) )
import qualified Data.ByteString.Char8 as BSC (pack)
import qualified Network.Socket as N


-- | this library does not try to discover peers. Config hints nodes to try to connect to
nodeId::ServerId -> NodeId
nodeId id0 = NodeId $ encodeEndPointAddress host1 port1 0
    where host1 = host id0
          port1 = show $ port id0

-- | Encode end point address. From network-transport-tcp Network.Transport.TCP.Internal
encodeEndPointAddress :: N.HostName
                      -> N.ServiceName
                      -> EndPointId
                      -> EndPointAddress
encodeEndPointAddress host0 port0 ix0 = EndPointAddress . BSC.pack $
  host0 ++ ":" ++ port0 ++ ":" ++ show ix0
