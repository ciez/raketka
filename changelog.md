#####  1.1.1
    change common state from TVar s to s
    
    pass init common state  

#####  1.1
    add custom state to Server
    
    peer state type is a configurable param
    
    note : package build may fail 

    due to version clash between aeson, vector, primitive packages
    
    https://github.com/ciez/vector is a patched version of vector-0.11.0.0
    
    I do not claim to have any knowledge about vector package workings. 

    Did basic refactoring: moved some code to a different module and followed some GHC suggestions. It builds and it works with raketka.  
    

#####  1.0
    start multiple nodes
    
    on start nodes ping suggested (in config) nodes - which pong back - and establish monitored connections
