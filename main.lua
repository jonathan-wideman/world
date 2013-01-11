STRICT = true
DEBUG = true
 
require 'zoetrope'
require 'castleview'
require 'endingview'
 
the.app = App:new
{
    onRun = function (self)
         self.view = CastleView:new()
    end
}