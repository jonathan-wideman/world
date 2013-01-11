EndingView = View:extend
{
	onNew = function (self)
		local message

		if self.won then
			message = 'Congratulations! You have slain the dragon.'
		else
			message = 'The Dragon ate you!  Try finding a sword.'
		end

		self:add(Text:new{ x = 0, y = 300, width = the.app.width, text = message, align = 'center' })
	end
}