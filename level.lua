level = class:new()

function level:init(l,h,number)
    self.length = l
    self.height = h

    self.background = love.graphics.newImage("images/background.png")

    self.solid = {
        tsImg = love.graphics.newImage("images/tiles_solid.png"),
        tsMarging = 3,
        tsRows = 4,
        tsCols = 4,
        tsWidth = 207,
        tsHeight = 207,
        tileWidth = 48,
        tileHeight = 48,
    	map = {
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
            1, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 1,
            1, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 1,
            2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2,
            3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3,
            3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3
          },
        quads = {}       
    }

    for i=1,#self.solid.map do
        table.insert(self.solid.quads,love.graphics.newQuad( self.solid.tsMarging+((self.solid.map[i]-1) % self.solid.tsRows)*(self.solid.tileWidth+self.solid.tsMarging), self.solid.tsMarging+m_floor((self.solid.map[i]-1)/self.solid.tsCols )*(self.solid.tileHeight+self.solid.tsMarging), self.solid.tileWidth, self.solid.tileHeight, self.solid.tsWidth, self.solid.tsHeight ))
    end

end



function level:draw()

    love.graphics.draw(self.background,0,-40)

    for i=1,#self.solid.map do
        if (self.solid.map[i]~=0) then
            layer = self.solid
            love.graphics.drawq( layer.tsImg,layer.quads[i], getTile(i,"posX"), getTile(i,"posY"),0,1,1,layer.tileWidth/2,layer.tileHeight/2)
        end
    end

end