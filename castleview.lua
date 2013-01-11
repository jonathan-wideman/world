Hero = Tile:extend
{
    image = 'mapobjects.png',
    onUpdate = function (self)
        self.velocity.x = 0
        self.velocity.y = 0
 
        if the.keys:pressed('up') then
            self.velocity.y = -200
        elseif the.keys:pressed('down') then
            self.velocity.y = 200
        end
 
        if the.keys:pressed('left') then
            self.velocity.x = -200
        elseif the.keys:pressed('right') then
            self.velocity.x = 200
        end
    end,

    getSword = function (self)
        if not self.hasSword then
            self.hasSword = true
            the.view:flash({0, 255, 0}, 1)
        end
    end
}


Chest = Tile:extend
{
    image = 'mapobjects.png',
    imageOffset = { x = 32, y = 0 },
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
            if self.hasSword then
                other:getSword()
            end
            self:die()
        end
    end
}


Dragon = Tile:extend
{
    image = 'dragon.png',
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
            if other.hasSword then
                self:die()
            else
                other:die()
            end
        end
    end
}


Zone = Tile:extend
{
    image = 'empty.png',
    isInside = false,
    visible = false,
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
            if not self.isInside then
                if self.onEnter then
                    --s = the.code[self.onEnter]
                    --assert(loadstring(s))()
                    local func = the.scripts[self.onEnter]
                    if func then
                        func(self)
                    else
                        print('Script not loaded: '..self.onEnter)
                    end
                end
                self.isInside = true
            end
        end
    end,

    onUpdate = function (self)
        if self.isInside and not self:collide(the.hero) then
            if self.onExit then
                --s = the.code[self.onExit]
                --assert(loadstring(s))()
                local func = the.scripts[self.onExit]
                if func then
                    func(self)
                else
                    print('Script not loaded: '..self.onExit)
                end
            end
            self.isInside = false
        end
    end
}


CastleView = View:extend
{

    toggleVisibleZones = function (self)
        for i, zone in ipairs(self.zones.sprites) do
            zone.visible = not zone.visible
        end
    end,

    safeCachedText = function (self, file)
        local ok, contents = pcall(function () return Cached:text(file) end)
        if not ok then
            print (contents)
            return nil
        end
        return contents
    end,

    loadScripts = function (self, file)
        the.scripts = {}
        
        local contents = self:safeCachedText(file)
        if not contents then
            return
        end

        local okData, data = pcall(loadstring(contents))
        if okData then
            the.scripts = data
            print ('Successfully loaded scripts from '..file)
        else
            print ('Failed to load scripts from '..file)
        end
    end,

    onNew = function (self)
        local file = 'map'
        self:loadLayers(file..'.lua')
        self:loadScripts(file..'_scripts.lua')
        self.focus = the.hero
        self:clampTo(self.map)
    end,
 
    onUpdate = function (self)
        --self.map:subdisplace(the.hero)
        self.objects:collide(self.objects)
        self.objects:collide(self.zones)

        if the.keys:justPressed('z') and the.keys:pressed('ctrl') and the.keys:pressed('alt') then
            self:toggleVisibleZones()
        end

        if not the.hero.active then
            the.app.view = EndingView:new{ won = false }
        end

        if not the.dragon.active then
            the.app.view = EndingView:new{ won = true }
        end
    end,

    onEndFrame = function (self)
        self.map:subdisplace(the.hero)
    end
}