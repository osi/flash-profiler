flash-profiler
==============

this project aims to develop a set of open-source tools for working with the 
[flash.sampler](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/sampler/package-detail.html) API

**WARNING still very much in-progress**

usage
-----

1. compile Agent.as to Agent.swf (TODO, need to make a script for mxmlc, right now I'm just doing it in TextMate)
2. find your [mm.cfg](http://www.adobe.com/devnet/flashplayer/articles/flash_player_admin_guide/flash_player_admin_guide.pdf) (see section 3), and:
    * add a line like: `PreloadSwf=/path/to/Agent.swf?host=localhost&port=42624`
        * set the _host_ and _port_ appropriately
3. Add *Agent.swf* to your local security domain. See previous PDF.    
4. Launch the FlashProfilerApp application.
5. Launch the Flash program you wish to debug under the Debug version of the player (standalone or in-browser)
6. Connect via the app, and go to town
