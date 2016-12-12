### raketka

    note : package build may fail 

    due to version clash between aeson, vector, primitive packages
    
    https://github.com/ciez/vector is a patched version of vector-0.11.0.0



    * basic distributed-process node
    * configurable peers

    Begin reading at Control.Distributed.Raketka.Type.Arg

    see also: 
    
        *   [parconc-examples](https://hackage.haskell.org/package/parconc-examples)
        *   [haskell-distributed tutorials](http://haskell-distributed.github.io/tutorials/1ch.html)  
    
    This library: 
    
        functionality: 
            * start nodes 
            * connect them with each other
            * exchanges pings with other nodes which are expected to pong back
            * received pings & pongs are output to stdout
            * when 1 node is disconnected or stops, the other nodes stdout notifications about this
    
        may be extended 
        however you are most likely to write your own code that does much more. 
    
        is simple on purpose, does only a few things which seem to be common in distributed arch 
    
    To start the program that comes with this library:
    
        start the same program in multiple consoles: 1 per node
     
        2 args are expected:
    
            1. path to config.json (see test-conf.json)
            2. idx of this node in the cluster: 0 .. (length Cluster -1)    
         