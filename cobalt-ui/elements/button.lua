local button = {
	x = 1,
	y = 1,
	w = 11,
	h = 2,
	text = "A button",
	backColour = colours.cyan,
	foreColour = colours.white,
	selected = false,
	visible = true,
	type = "button",
	marginleft = 0,
	marginright = 0,
	margintop = 0,
	marginbottom = 0,
	automl = "",
	automr = "",
	automt = "",
	automb = "",
	autow = "perc:50",
	wrap = "left",
	autoh = true,
}
button.__index = button

function button:getPercentages()
	if type(self.w) == "string" then
		self.w = cobalt.getPercentage( self.w )
		self.autow = "perc:" .. self.w
	else
		self.autow = "none"
	end
	if type(self.h) == "string" then
		self.h = cobalt.getPercentage( self.h )
		self.autoh = "perc:" .. self.h
	else
		self.autoh = "none"
	end

	if type(self.marginleft) == "string" then
		self.marginleft = cobalt.getPercentage( self.marginleft )
		self.automl = "perc:" .. self.marginleft
	end
	if type(self.marginright) == "string" then
		self.marginright = cobalt.getPercentage( self.marginright )
		self.automr = "perc:" .. self.marginright
	end
	if type(self.margintop) == "string" then
		self.margintop = cobalt.getPercentage( self.margintop )
		self.automt = "perc:" .. self.margintop
	end
	if type(self.marginbottom) == "string" then
		self.marginbottom = cobalt.getPercentage( self.marginbottom )
		self.automl = "perc:" .. self.marginbottom
	end
	if type(self.x) == "string" then
		self.x = cobalt.getPercentage( self.x )
		self.autox = "perc:" .. self.x
	end
	if type(self.y) == "string" then
		self.y = cobalt.getPercentage( self.y )
		self.autoy = "perc:" .. self.y
	end
end

function button.new( data, parent )
	data = data or { }
	if data.style then
		local t = data.style
		for k, v in pairs( t ) do
			if not data[k] then
				data[k] = v
			end
		end
		data.style = nil
	end
	local self = setmetatable(data,button)
	self.parent = parent
	self:getPercentages()
	self:resize()
	self.state = data.state or parent.state
	table.insert( parent.children, self )
	return self
end

function button:setMargins( t, r, b, l )
	if t then
		self.margintop = t or self.margintop
		if type(t) == "string" then
			self:getPercentages()
		else
			self.automt = "none"
		end
	end
	if r then
		self.marginright = r or self.marginright
		if type(r) == "string" then
			self:getPercentages()
		else
			self.automr = "none"
		end
	end
	if b then
		self.margintop = b or self.margintop
		if type(b) == "string" then
			self:getPercentages()
		else
			self.automb = "none"
		end
	end
	if l then
		self.marginleft = l or self.marginleft
		if type(l) == "string" then
			self:getPercentages()
		else
			self.automl = "none"
		end
	end
	self:resize()
end

function button:resize( w, h )
	if w then
		self.w = w or self.w
		if type( self.w ) == "string" then
			self:getPercentages()
		else
			self.autow = "none"
		end
	end
	if h then
		self.h = h or self.h
		if type( self.h ) == "string" then
			self:getPercentages()
		else
			self.autoh = "none"
		end
	end
	if self.autow:sub( 1, 4 ) == "perc" then
		local perc = self.autow:match("perc:(%d+)")
		cobalt.setPercentage( perc )
		self.w = math.ceil( self.parent.w * cobalt.setPercentage( perc ) )
	end
	if self.automl:sub( 1, 4 ) == "perc" then
		local perc = self.automl:match("perc:(%d+)")
		self.marginleft = math.floor( self.parent.w * cobalt.setPercentage( perc ) )
	end
	if self.automr:sub( 1, 4 ) == "perc" then
		local perc = self.automr:match("perc:(%d+)")
		self.marginright = math.floor( self.parent.w * cobalt.setPercentage( perc ) )
	end
	if self.automt:sub( 1, 4 ) == "perc" then
		local perc = self.automt:match("perc:(%d+)")
		self.margintop = math.floor( self.parent.h * cobalt.setPercentage( perc ) )
	end
	if self.automb:sub( 1, 4 ) == "perc" then
		local perc = self.automb:match("perc:(%d+)")
		self.marginbottom = math.floor( self.parent.h * cobalt.setPercentage( perc ) )
	end
	if self.autox and self.autox:sub( 1, 4 ) == "perc" then
		local perc = self.autox:match("perc:(%d+)")
		self.x = math.floor( self.parent.w * cobalt.setPercentage( perc ) )
	end
	if self.autoy and self.autoy:sub( 1, 4 ) == "perc" then
		local perc = self.autoy:match("perc:(%d+)")
		self.y = math.floor( self.parent.h * cobalt.setPercentage( perc ) )
	end
end

function button:getAbsX()
	return math.floor(self.x + self.parent:getAbsX() + self.marginleft)-1
end

function button:getAbsY()
	return math.floor(self.y + self.parent:getAbsY() + self.margintop)-1
end

function button:draw()
	if self.state == cobalt.state or self.state == "_ALL" and self.visible then
		local colour = self.backColour
		if self.wrap == "center" then
			self.x = math.ceil( (self.parent.w/2)-self.w/2 + self.marginleft )
		end
		if self.selected then
			colour = cobalt.g.lighten( self.backColour )
		end
		if self.h == 1 then
			self.parent.surf:drawLine( self.x + self.marginleft, self.y+1 + self.margintop, self.x + self.w+self.marginleft, self.y+1, " ", colour, self.foreColour )
		else
			self.parent.surf:fillRect( self.x + self.marginleft, self.y + self.margintop, self.x + self.w+self.marginleft, self.y + self.h, " ", colour, self.foreColour )
		end
		self.parent.surf:drawText( self.x+math.ceil((self.w/2)-#self.text/2 +  self.marginleft), math.ceil(self.y+self.h/2)+ self.margintop, self.text, colour, self.foreColour )
	end
end

function button:mousepressed( x, y, button )
	if self.state == cobalt.state or self.state == "_ALL" and self.visible then
		if button == 1 then
			if x >= self:getAbsX() and x <= self:getAbsX() + self.w and y >= self:getAbsY() and y <= self:getAbsY() + self.h then
				self.selected = true
			end
		end
	end
end

function button:mousereleased( x, y, button )
	if self.state == cobalt.state or self.state == "_ALL" and self.visible then
		if button == 1 and x >= self:getAbsX() and x <= self:getAbsX() + self.w and y >= self:getAbsY() and y <= self:getAbsY() + self.h then
			if self.selected then
				if self.onclick then
					self.onclick()
				end
				self.selected = false
			end
		else
			self.selected = false
		end
	end
end

return button
