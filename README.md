### raketka

    basic distributed-process node
    
    configurable peers

    Begin reading at Control.Distributed.Raketka.Type.Arg

    see also 
    
    [parconc-examples](https://hackage.haskell.org/package/parconc-examples)
    
    [haskell-distributed tutorials](http://haskell-distributed.github.io/tutorials/1ch.html)  
    
    This library has basic working code to enable to start nodes and to connect them with each other. The library may be extended however you are most likely to write your own code that does much more. This library is simple on purpose. It took me a few days to write this code and make it work.    
    
    To start the program that comes with this library:
    
    start the same program in multiple consoles: 1 per node
     
    pass 2 args:
    
        1. path to config.json (see enclosed test-conf.json)
        2. idx of this node in the cluster: 0 - (length Cluster -1)
    
    The program exchanges pings with other nodes which are expected to pong back. Both pings & pongs are output to stdout
    
    When you shut one node, the other nodes stdout notifications about that node     