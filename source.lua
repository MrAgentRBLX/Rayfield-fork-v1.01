local module = {}
module.__index = module


-- library module --
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()


-- properties --
local windowProp = {
   Name = "Example window",
   LoadingTitle = "Rayfield UI",
   LoadingSubtitle = "by sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "config_rayfield",
      FileName = "rayfield"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Example title",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
}


-- window --
function module:Window(properties)

	if not properties or not (type(properties) == "table") then return warn("[Window]: Properties not found/ incorrect type") end
	for i, v in next, properties do
		if not windowProp[i] then continue end
		windowProp[i] = v
	end

	return setmetatable({
		window = library:CreateWindow(windowProp),
		tabs = {},
		info = {current = ""}
	}, module)

end

-- tab --
function module:Tab(text)
	if self.tabs[text] then return end
	self.tabs[text] = {
		tab = self.window:CreateTab(text),
		elements = {}
	}
	self.info.current = text
	return self
end

-- elements --
function module:Section(text)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Section") then
		Elements[text] = {
			Type = "Section",
			Element = Tab:CreateSection(text)
		}
	else
		return
	end
end

function module:Label(text)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Label") then
		Elements[text] = {
			Type = "Label",
			Element = Tab:CreateLabel(text)
		}
	else
		return
	end
end

function module:Button(text, callback)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Button") then
		Elements[text] = {
			Type = "Button",
			Element = Tab:CreateButton {
				Name = text,
				Callback = callback
			}
		}
	else
		return
	end
end

function module:Toggle(text, toggle, callback)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Button") then
		Elements[text] = {
			Type = "Button",
			Element = Tab:CreateButton {
				Name = text,
				CurrentValue = toggle,
				Callback = callback,
				Flag = text.."_button"
			}
		}
	else
		return
	end
end

function module:Slider(text, range, increment, value, callback, suffix)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Slider") then
		Elements[text] = {
			Type = "Slider",
			Element = Tab:CreateSlider {
				Name = text,
				Range = range,
				Increment = increment,
				CurrentValue = value,
				Callback = callback,
				Flag = text.."_slider",
				Suffix = suffix or ""
			}
		}
	else
		return
	end
end

function module:Dropdown(text, list, option, multi_options, callback)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Dropdown") then
		Elements[text] = {
			Type = "Dropdown",
			Element = Tab:CreateDropdown {
				Name = text,
				Options = list,
				CurrentOption = {option}
				MultipleOptions = multi_options,
				Callback = callback,
				Flag = text.."_dropdown"
			}
		}
	else
		return
	end
end

function module:Keybind(text, keycode, hold_to_use, callback)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Keybind") then
		Elements[text] = {
			Type = "Keybind",
			Element = Tab:CreateDropdown {
				Name = text,
				CurrentKeybind = keycode,
				HoldToInteract = hold_to_use,
				Callback = callback,
				Flag = text.."_keybind"
			}
		}
	else
		return
	end
end

function module:Input(text, input_text, remove_on_lost, callback)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Input") then
		Elements[text] = {
			Type = "Input",
			Element = Tab:CreateInput {
				Name = text,
				PlaceholderText = input_text,
				RemoveTextAfterFocusLost = remove_on_lost
				Callback = callback,
			}
		}
	else
		return
	end
end

function module:Paragraph(text, description)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "Paragraph") then
		Elements[text] = {
			Type = "Paragraph",
			Element = Tab:CreateInput {
				Title = text,
				Content = description
			}
		}
	else
		return
	end
end

function module:ColorPicker(text, color, callback)
	local Tab = self.tabs[self.info.current].tab
	local Elements = self.tabs[self.info.current].elements
	if not Elements[text] or not (Elements[text] and Elements[text].Type ~= "ColorPicker") then
		Elements[text] = {
			Type = "ColorPicker",
			Element = Tab:CreateColorPicker {
				Name = text,
				Color = color,
				Callback = callback,
				Flag = text.."_colorpicker"
			}
		}
	else
		return
	end
end


-- update --
function module:Update(Tab, Element, Value)
	local Tab = self.tabs[Tab]
	local Info = Tab and Tab.Elements[Element]
	if Tab and Element then
		Info.Element:Set(Value)
	end
end


-- notify --
function module:Notify(text, description, duration, image, actions)
	self.window:Notify {
	   Title = text,
	   Content = description,
	   Duration = duration,
	   Image = image,
	   Actions = actions
	}
end

-- removal --
function module:Remove()
	pcall(function()
		self.window:Destroy()
	end)
end


return module
