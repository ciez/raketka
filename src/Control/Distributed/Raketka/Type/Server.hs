{-# LANGUAGE RankNTypes #-}
module Control.Distributed.Raketka.Type.Server where

import Control.Concurrent.STM
import Control.Distributed.Process.Serializable
import Control.Distributed.Process hiding (Message)
import Control.Distributed.Raketka.Type.Arg
import Data.Tagged
import Data.Set


{- | constraint type

    __c__ is Message content type, implementation-specific      -}
type Content tag ps s c = (PeerInfo ps, Specific tag ps s c, Serializable c, Show c)

{- | methods in this instance are called in library, defined in the program (this or another program that consumes this library)
    
    see example implementation in "Control.Distributed.Raketka.Impl.Inst"

    "Control.Distributed.Raketka.Impl.Inst" is part of the package, is not displayed in docs because it is part of a program, not the library.
    
    see also Main.hs there is important code there
    
    __c__ is Message content type, implementation-specific  
-}
class Specific tag ps s c | tag -> ps, tag -> s, tag -> c where
    startServer::Tagged tag ServerId -> Process ()
    handleMessage::Tagged tag (Server ps s) -> c -> Process ()
    onPeerConnected::Tagged tag (Server ps s) -> ProcessId -> Process ()
    onPeerDisConnected::Tagged tag (Server ps s) -> ProcessId -> Process ()


class PeerInfo ps where
    onPeerConnected'::ps -> ProcessId -> ps
    onPeerDisConnected'::ps -> ProcessId -> ps
    peer_pids::ps -> [ProcessId]


instance PeerInfo (Set ProcessId) where
    onPeerConnected'::Set ProcessId -> ProcessId -> Set ProcessId
    onPeerConnected' s0 pid0 = insert pid0 s0 
    
    onPeerDisConnected'::Set ProcessId -> ProcessId -> Set ProcessId
    onPeerDisConnected' s0 pid0 = delete pid0 s0
    
    peer_pids::Set ProcessId -> [ProcessId]
    peer_pids = toList
       

-- | pass tag between different types 
passTag::Tagged a b -> c -> Tagged a c
passTag _ = Tagged


data Server ps s = Server
      { proxychan::TChan (Process ())  -- ^ pipeline for sending messages 
        , servers::TVar ps      -- ^ peer specific store 
        , spid::ProcessId       -- ^ this node's pid
        , state::TVar s         -- ^ this node's common store 
        }
               