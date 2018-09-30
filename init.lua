--- === OzzyWM ===
---
--- Ozzy's Window Manager

local OzzyWM={}
OzzyWM.__index = OzzyWM

-- Metadata
OzzyWM.name = "OzzyWM"
OzzyWM.version = "1.0"
OzzyWM.author = "Özgün Çağrı AYDIN"
OzzyWM.homepage = "https://github.com/ozguncagri/OzzyWM"
OzzyWM.license = "MIT - https://opensource.org/licenses/MIT"

-- Window move and resize factor definitions ------
OzzyWM.windowMoveFactor = 10
OzzyWM.windowShrinkFactor = 20
OzzyWM.windowExpandFactor = 20

-- Shortcut button definitions ------
OzzyWM.mod3Buttons = {"cmd", "alt", "ctrl"}
OzzyWM.mod4Buttons = {"shift", "cmd", "alt", "ctrl"}

-- Get current window elements ------
OzzyWM.currentWindowAndScreenElements = function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	local oneCol = max.w / 8

	return win, f, screen, max, oneCol
end

-- Move window to left and set width (columnSize) to eight of screen width ------
OzzyWM.leftColumn = function(columnSize)
	return function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = 0
		f.y = 0
		f.w = oneCol * columnSize
		f.h = max.h
		win:setFrame(f)
	end
end

-- Move window to right and set width (columnSize) to eight of screen width ------
OzzyWM.rightColumn = function(columnSize)
	return function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = max.w - (oneCol * columnSize)
		f.y = 0
		f.w = oneCol * columnSize
		f.h = max.h
		win:setFrame(f)
	end
end

-- 3 modification binder wrapper
OzzyWM.mod3Binder = function(key, operation)
	hs.hotkey.bind({"cmd", "alt", "ctrl"}, key, operation)
end

-- 4 modification binder wrapper
OzzyWM.mod4Binder = function(key, operation)
	hs.hotkey.bind({"shift", "cmd", "alt", "ctrl"}, key, operation)
end

OzzyWM.alternateAppSwitcher = function()
	-- Alternate application switcher settings ------
	switcher = hs.window.switcher.new()
	switcher.ui.onlyActiveApplication = false
	switcher.ui.showTitles = false
	switcher.ui.showThumbnails = false
	switcher.ui.thumbnailSize = 64
	switcher.ui.showSelectedThumbnail = true
	switcher.ui.selectedThumbnailSize = 256
	switcher.ui.showSelectedTitle = false

	-- Application switcher : next item binding ------
	hs.hotkey.bind('cmd', '"', function()
		switcher:next()
	end)

	-- Application switcher : previous item binding ------
	hs.hotkey.bind('cmd-shift', '"', function()
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
	-- Shrink window anchoring with top and left ------
	OzzyWM.mod3Binder("9", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.w = f.w - OzzyWM.windowShrinkFactor
		f.h = f.h - OzzyWM.windowShrinkFactor
		win:setFrame(f)
	end)

	-- Shrink window anchoring with center of window ------
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
	-- Expand window anchoring with top and left ------
	OzzyWM.mod3Binder("0", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.w = f.w + OzzyWM.windowExpandFactor
		f.h = f.h + OzzyWM.windowExpandFactor
		win:setFrame(f)
	end)

	-- Expand window anchoring with center of window ------
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
	-- Slide window to top edge of the screen without resizing it ------
	OzzyWM.mod3Binder("Up", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = 0
		win:setFrame(f)
	end)

	-- Slide window to right edge of the screen without resizing it ------
	OzzyWM.mod3Binder("Right", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = max.w - f.w
		win:setFrame(f)
	end)

	-- Slide window to bottom edge of the screen without resizing it ------
	OzzyWM.mod3Binder("Down", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = max.h - f.h
		f.y = f.y + 22
		win:setFrame(f)
	end)

	-- Slide window to left edge of the screen without resizing it ------
	OzzyWM.mod3Binder("Left", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = 0
		win:setFrame(f)
	end)

	-- Slide window middle of the screen in x and y axis ------
	OzzyWM.mod3Binder("Space", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = (max.h / 2) - (f.h / 2)
		f.x = (max.w / 2) - (f.w / 2)
		f.y = f.y + 11
		win:setFrame(f)
	end)
end

OzzyWM.windowMover = function()
	-- Move window 10 pixel up ------
	OzzyWM.mod4Binder("Up", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = f.y - OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)

	-- Move window 10 pixel right ------
	OzzyWM.mod4Binder("Right", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = f.x + OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)

	-- Move window 10 pixel down ------
	OzzyWM.mod4Binder("Down", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.y = f.y + OzzyWM.windowMoveFactor
		win:setFrame(f)
	end)

	-- Move window 10 pixel left ------
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