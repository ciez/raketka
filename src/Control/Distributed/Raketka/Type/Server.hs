{-# LANGUAGE RankNTypes #-}
module Control.Distributed.Raketka.Type.Server where

import Control.Concurrent.STM
import Control.Distributed.Process.Serializable
import Control.Distributed.Process hiding (Message)
import Control.Distributed.Raketka.Type.Arg
import Data.Tagged

-- | constraint type
type Content c = (Specific c, Serializable c, Show c)

{- | see example implementation in "Control.Distributed.Raketka.Impl.Inst"

    this file is part of the package, is not displayed in docs because it is part of a program, not the library.
    
    see also Main.hs there is important code there 
-}
class Specific c where
    handleMessage::Tagged c Server -> c -> Process ()
    startServer::Tagged c ServerId -> Process ()


passTag::Tagged a b -> c -> Tagged a c
passTag _ = Tagged


data Server = Server
      { proxychan::TChan (Process ())  -- ^ pipeline for sending messages 
        , servers::TVar [ProcessId]    -- ^ to broadcast to entire cluster 
        , spid::ProcessId              -- ^ this node's pid   
        }
               