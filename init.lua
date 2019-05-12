-- OzzyWM (Ozzy's Window Manager)
local OzzyWM={}
OzzyWM.__index = OzzyWM

-- Metadata
OzzyWM.name = "OzzyWM"
OzzyWM.version = "1.3"
OzzyWM.author = "Özgün Çağrı AYDIN"
OzzyWM.homepage = "https://ozguncagri.com"
OzzyWM.license = "MIT - https://opensource.org/licenses/MIT"

-- Window move and resize factor definitions
OzzyWM.windowMoveFactor = 10
OzzyWM.windowShrinkFactor = 20
OzzyWM.windowExpandFactor = 20

OzzyWM.deepCopy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[OzzyWM.deepCopy(orig_key)] = OzzyWM.deepCopy(orig_value)
        end
        setmetatable(copy, OzzyWM.deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- 3 modification binder wrapper
OzzyWM.mod3Binder = function(key, operation)
	hs.hotkey.bind({"cmd", "alt", "ctrl"}, key, operation)
end

-- 4 modification binder wrapper
OzzyWM.mod4Binder = function(key, operation)
	hs.hotkey.bind({"shift", "cmd", "alt", "ctrl"}, key, operation)
end

-- Get current window elements
OzzyWM.currentWindowAndScreenElements = function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:fullFrame()
	local oneCol = max.w / 8

	return win, f, screen, max, oneCol
end

-- Move window to left and set width (columnSize) to eight of screen width
OzzyWM.leftColumn = function(columnSize)
	return function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = max.x
		f.y = 0
		f.w = oneCol * columnSize
		f.h = max.h
		win:setFrame(f)
	end
end

-- Move window to right and set width (columnSize) to eight of screen width
OzzyWM.rightColumn = function(columnSize)
	return function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = max.x + (max.w - (oneCol * columnSize))
		f.y = 0
		f.w = oneCol * columnSize
		f.h = max.h
		win:setFrame(f)
	end
end

OzzyWM.alternateAppSwitcher = function()
	-- Alternate application switcher settings
	switcher = hs.window.switcher.new()
	switcher.ui.onlyActiveApplication = false
	switcher.ui.showTitles = false
	switcher.ui.showThumbnails = false
	switcher.ui.thumbnailSize = 64
	switcher.ui.showSelectedThumbnail = true
	switcher.ui.selectedThumbnailSize = 256
	switcher.ui.showSelectedTitle = false

	-- Application switcher : next item binding
	hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Tab", function()
		switcher:next()
	end)

	-- Application switcher : previous item binding
	hs.hotkey.bind({"shift", "cmd", "alt", "ctrl"}, "Tab", function()
		switcher:previous()
	end)
end

OzzyWM.numericalWindowDocker = function()
	-- Expand/Shrink active window to selected column number anchoring to left side of the screen
	OzzyWM.mod3Binder("1", OzzyWM.leftColumn(1))
	OzzyWM.mod3Binder("2", OzzyWM.leftColumn(2))
	OzzyWM.mod3Binder("3", OzzyWM.leftColumn(3))
	OzzyWM.mod3Binder("4", OzzyWM.leftColumn(4))
	OzzyWM.mod3Binder("5", OzzyWM.leftColumn(5))
	OzzyWM.mod3Binder("6", OzzyWM.leftColumn(6))
	OzzyWM.mod3Binder("7", OzzyWM.leftColumn(7))
	OzzyWM.mod3Binder("8", OzzyWM.leftColumn(8))

	-- Expand/Shrink active window to selected column number anchoring to right side of the screen
	OzzyWM.mod4Binder("1", OzzyWM.rightColumn(1))
	OzzyWM.mod4Binder("2", OzzyWM.rightColumn(2))
	OzzyWM.mod4Binder("3", OzzyWM.rightColumn(3))
	OzzyWM.mod4Binder("4", OzzyWM.rightColumn(4))
	OzzyWM.mod4Binder("5", OzzyWM.rightColumn(5))
	OzzyWM.mod4Binder("6", OzzyWM.rightColumn(6))
	OzzyWM.mod4Binder("7", OzzyWM.rightColumn(7))
	OzzyWM.mod4Binder("8", OzzyWM.rightColumn(8))
end

OzzyWM.windowShrinker = function()
	-- Shrink window anchoring with top and left
	OzzyWM.mod3Binder("9", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.w = f.w - OzzyWM.windowShrinkFactor
		f.h = f.h - OzzyWM.windowShrinkFactor
		win:setFrame(f)
	end)

	-- Shrink window anchoring with center of window
	OzzyWM.mod4Binder("9", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = f.x + (OzzyWM.windowShrinkFactor / 2)
		f.y = f.y + (OzzyWM.windowShrinkFactor / 2)
		f.w = f.w - OzzyWM.windowShrinkFactor
		f.h = f.h - OzzyWM.windowShrinkFactor
		win:setFrame(f)
	end)
end

OzzyWM.windowExpander = function()
	-- Expand window anchoring with top and left
	OzzyWM.mod3Binder("0", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.w = f.w + OzzyWM.windowExpandFactor
		f.h = f.h + OzzyWM.windowExpandFactor
		win:setFrame(f)
	end)

	-- Expand window anchoring with center of window
	OzzyWM.mod4Binder("0", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = f.x - (OzzyWM.windowExpandFactor / 2)
		f.y = f.y - (OzzyWM.windowExpandFactor / 2)
		f.w = f.w + OzzyWM.windowExpandFactor
		f.h = f.h + OzzyWM.windowExpandFactor
		win:setFrame(f)
	end)
end

OzzyWM.windowSlider = function()
	-- Slide window to top edge of the screen without resizing it
	OzzyWM.mod3Binder("Up", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		local oldPosition = OzzyWM.deepCopy(f)

		f.y = max.y

		-- Move window to one screen up if it's touching top edge of current screen
		if oldPosition.y == f.y then
			win:moveOneScreenNorth(true, true)
		else
			win:setFrame(f)
		end
	end)

	-- Slide window to right edge of the screen without resizing it
	OzzyWM.mod3Binder("Right", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		local oldPosition = OzzyWM.deepCopy(f)

		f.x = (max.x + max.w) - f.w

		-- Move window to one screen right if it's touching right edge of current screen
		if oldPosition.x == f.x then
			win:moveOneScreenEast(true, true)
		else
			win:setFrame(f)
		end
	end)

	-- Slide window to bottom edge of the screen without resizing it
	OzzyWM.mod3Binder("Down", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		local oldPosition = OzzyWM.deepCopy(f)

		f.y = max.h - f.h

		-- Move window to one screen down if it's touching bottom edge of current screen
		if oldPosition.y == f.y then
			win:moveOneScreenSouth(true, true)
		else
			win:setFrame(f)
		end
	end)

	-- Slide window to left edge of the screen without resizing it
	OzzyWM.mod3Binder("Left", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		local oldPosition = OzzyWM.deepCopy(f)

		f.x = max.x

		-- Move window to one screen left if it's touching left edge of current screen
		if oldPosition.x == f.x then
			win:moveOneScreenWest(true, true)
		else
			win:setFrame(f)
		end
	end)

	-- Slide window middle of the screen in x and y axis
	OzzyWM.mod3Binder("Space", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = (max.h / 2) - (f.h / 2)
		f.x = (max.x + ((max.w / 2) - (f.w / 2)))

		win:setFrame(f)
	end)
end

OzzyWM.windowMover = function()
	-- Move window 10 pixel up
	OzzyWM.mod4Binder("Up", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = f.y - OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)

	-- Move window 10 pixel right
	OzzyWM.mod4Binder("Right", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = f.x + OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)

	-- Move window 10 pixel down
	OzzyWM.mod4Binder("Down", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = f.y + OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)

	-- Move window 10 pixel left
	OzzyWM.mod4Binder("Left", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = f.x - OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)
end

function OzzyWM:init()
	-- Activate all hotkeys
	OzzyWM.alternateAppSwitcher()
	OzzyWM.numericalWindowDocker()
	OzzyWM.windowShrinker()
	OzzyWM.windowExpander()
	OzzyWM.windowSlider()
	OzzyWM.windowMover()
end

return OzzyWM