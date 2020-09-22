-- OzzyWM (Ozzy's Window Manager)
local OzzyWM={}
OzzyWM.__index = OzzyWM

-- Metadata
OzzyWM.name = "OzzyWM"
OzzyWM.version = "1.5"
OzzyWM.author = "Özgün Çağrı AYDIN"
OzzyWM.homepage = "https://ozguncagri.com"
OzzyWM.license = "MIT - https://opensource.org/licenses/MIT"

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
	local max = screen:frame()
	local oneCol = max.w / 8

	return win, f, screen, max, oneCol
end

-- Move window to left and set width (columnSize) to eight of screen width
OzzyWM.leftColumn = function(columnSize)
	return function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		f.x = max.x
		f.y = max.y
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
		f.y = max.y
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

OzzyWM.windowSlider = function()
	-- Slide window to right edge of the screen without resizing it
	OzzyWM.mod3Binder("Right", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		-- Move window to one screen right if it's touching right edge of current screen
		if f.x == (max.x + max.w) - f.w then
      -- Move to the Next Window.
      local rightScreen = win:screen():next()
      win:moveToScreen(rightScreen, true, true)
		else
			f.x = (max.x + max.w) - f.w
			win:setFrame(f)
		end
	end)

	-- Slide window to left edge of the screen without resizing it
	OzzyWM.mod3Binder("Left", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		-- Move window to one screen left if it's touching left edge of current screen
		if f.x == max.x then
      -- Move to the Previous Window.
      local leftScreen = win:screen():previous()
      win:moveToScreen(leftScreen, true, true)
		else
			f.x = max.x
			win:setFrame(f)
		end
	end)

	-- Slide window middle of the screen in x and y axis
	OzzyWM.mod3Binder("Space", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		win:centerOnScreen()
	end)
end

OzzyWM.windowSnapper = function()
	local isWindowSnappedToLeftHalf = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.x == max.x and f.y == max.y and f.w == oneCol * 4 and f.h == max.h
	end

	local isWindowSnappedToLeftQuarter = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.x == max.x and f.y == max.y and f.w == oneCol * 2 and f.h == max.h
	end

	local isWindowSnappedToRightHalf = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.x == max.x + (max.w - (oneCol * 4)) and f.y == max.y and f.w == oneCol * 4 and f.h == max.h
	end

	local isWindowSnappedToRightQuarter = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.x == max.x + (max.w - (oneCol * 2)) and f.y == max.y and f.w == oneCol * 2 and f.h == max.h
	end

	local isWindowSnappedToTopHalf = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.y == max.y and f.x == max.x and f.w == max.w and f.h == math.floor(max.h / 2)
	end

	local isWindowSnappedToTopQuarter = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.y == max.y and f.x == max.x and f.w == max.w and f.h == math.floor(max.h / 4)
	end

	local isWindowSnappedToBottomHalf = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.y == (max.y + max.h) - f.h and f.x == max.x and f.w == max.w and f.h == math.floor(max.h / 2)
	end

	local isWindowSnappedToBottomQuarter = function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		return f.w == max.w and f.h == math.floor(max.h / 4) and f.y == (math.floor(max.h / 4) * 3) + max.y and f.x == max.x
	end

	OzzyWM.mod4Binder("Up", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		-- Snap window to top-left or right quarter of current screen
		if isWindowSnappedToLeftHalf() or isWindowSnappedToRightHalf() then
			f.h = math.floor(max.h / 2)
			win:setFrame(f)
			return
		end

		-- Snap window to top quarter or left-right 1/16 of current screen
		if isWindowSnappedToTopHalf() or isWindowSnappedToLeftQuarter() or isWindowSnappedToRightQuarter() then
			f.h = math.floor(max.h / 4)
			win:setFrame(f)
			return
		end

		-- Snap window to top half of current screen
		f.y = max.y
		f.x = max.x
		f.w = max.w
		f.h = math.floor(max.h / 2)

		win:setFrame(f)
	end)

	OzzyWM.mod4Binder("Right", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		-- Snap window to top or bottom right quarter of current screen
		if isWindowSnappedToTopHalf() or isWindowSnappedToBottomHalf() then
			f.x = max.x + (max.w - (oneCol * 4))
			f.w = oneCol * 4
			win:setFrame(f)
			return
		end

		-- Snap window to right quarter or top-bottom 1/16 of current screen
		if isWindowSnappedToRightHalf() or isWindowSnappedToTopQuarter() or isWindowSnappedToBottomQuarter() then
			f.x = max.x + (max.w - (oneCol * 2))
			f.w = oneCol * 2
			win:setFrame(f)
			return
		end

		-- Snap window to right half of current screen
		f.x = max.x + (max.w - (oneCol * 4))
		f.y = max.y
		f.w = oneCol * 4
		f.h = max.h

		win:setFrame(f)
	end)

	OzzyWM.mod4Binder("Down", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		-- Snap window to bottom-left or right quarter of current screen
		if isWindowSnappedToLeftHalf() or isWindowSnappedToRightHalf() then
			f.y = math.floor(max.h / 2) + max.y
			f.h = math.floor(max.h / 2)
			win:setFrame(f)
			return
		end

		-- Snap window to bottom quarter or left-right 1/16 of current screen
		if isWindowSnappedToBottomHalf() or isWindowSnappedToLeftQuarter() or isWindowSnappedToRightQuarter() then
			f.h = math.floor(max.h / 4)
			f.y = (math.floor(max.h / 4) * 3) + max.y
			win:setFrame(f)
			return
		end

		-- Snap window to bottom half of current screen
		f.w = max.w
		f.h = math.floor(max.h / 2)
		f.y = (max.y + max.h) - f.h
		f.x = max.x

		win:setFrame(f)
	end)

	OzzyWM.mod4Binder("Left", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()

		-- Snap window to top or bottom right quarter of current screen
		if isWindowSnappedToTopHalf() or isWindowSnappedToBottomHalf() then
			f.w = oneCol * 4
			win:setFrame(f)
			return
		end

		-- Snap window to left quarter of current screen
		if isWindowSnappedToLeftHalf() or isWindowSnappedToTopQuarter() or isWindowSnappedToBottomQuarter() then
			f.w = oneCol * 2
			win:setFrame(f)
			return
		end

		-- Snap window to left half of current screen
		f.x = max.x
		f.y = max.y
		f.w = oneCol * 4
		f.h = max.h

		win:setFrame(f)
	end)
end

OzzyWM.windowZoomer = function()
	-- Toggles the zoom state of the window (this is effectively equivalent to clicking the green maximize/fullscreen button at the top left of a window)
	OzzyWM.mod4Binder("Space", function()
		local win, f, screen, max, oneCol = OzzyWM.currentWindowAndScreenElements()
		win:toggleZoom()
	end)
end

function OzzyWM:init()
	-- Activate all hotkeys
	OzzyWM.alternateAppSwitcher()
	OzzyWM.numericalWindowDocker()
	OzzyWM.windowSlider()
	OzzyWM.windowSnapper()
	OzzyWM.windowZoomer()
end

return OzzyWM
