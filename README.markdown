flash-profiler
==============

this project aims to develop a set of open-source tools for working with the 
[flash.sampler](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/sampler/package-detail.html) API


usage
-----

1. compile Agent.as to Agent.swf (TODO, need to make a script for mxmlc, right now I'm just doing it in TextMate)
2. find your [mm.cfg](http://www.adobe.com/devnet/flashplayer/articles/flash_player_admin_guide/flash_player_admin_guide.pdf) (see section 3), and:
    * add a line like: `PreloadSwf=/path/to/Agent.swf?host=localhost&port=42624`
        * set the _host_ and _port_ appropriately
3. Add *Agent.swf* to your local security domain. See previous PDF.    
3. launch the console, `./console.rb` (TODO, need to pass in host and port to listen on!)
4. launch your flash application, in either the browser (be sure to restart after mm.cfg changes), or with the standalone player    
