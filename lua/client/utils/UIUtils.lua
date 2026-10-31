--- @type UnityEngine_Rect
local U_Rect = UnityEngine.Rect
--- @type UnityEngine_UI_Selectable_Transition
local U_Transition = UnityEngine.UI.Selectable.Transition
--- @type TMPro_TextAlignmentOptions
local U_TextAlignmentOptions = CS.TMPro.TextAlignmentOptions
--- @type UnityEngine_UI_ContentSizeFitter_FitMode
local U_FitMode = UnityEngine.UI.ContentSizeFitter.FitMode

--- @class UIUtils
UIUtils = {}

UIUtils.color1 = "a18b6c"  -- nau
UIUtils.color2 = "466e08"  -- xanh
UIUtils.color3 = "a89d8b"  -- xam
UIUtils.color4 = "f1b02f"  -- vang
UIUtils.color5 = "686868"  -- xam nhat
UIUtils.color6 = "fd781f"  -- cam
UIUtils.color7 = "fa1c00" -- red
UIUtils.white = "FFF7E9"  -- white B7B7B7
UIUtils.color8 = "B7B7B7"  -- mau toi
UIUtils.color9 = "ECAE2B"  -- vang arena
UIUtils.color10 = "845b37" -- nau Dungeon
UIUtils.color11 = "96dc2a"  -- xanh nhat
UIUtils.color12 = "9c8f78"  -- xam nhat 2
UIUtils.color13 = "7E6B55"

---Pink
UIUtils.pink1 = "ed1f8b"
---Purple
UIUtils.purple1 = "520e31"
---Yellow
UIUtils.yellow1 = "FFD700"
UIUtils.Cement1	 = "89765e"
---Red
UIUtils.red1 = "ff2835"
---Black
UIUtils.black1 = "000000"


UIUtils.color_rarity_1 = "cbd7d1"  -- mau toi
UIUtils.color_rarity_2 = "00bb44"  -- mau toi
UIUtils.color_rarity_3 = "2480fe"  -- mau toi
UIUtils.color_rarity_4 = "bc79fd"  -- mau toi
UIUtils.color_rarity_5 = "ffd615"  -- mau toi
UIUtils.color_rarity_6 = "e46b09"  -- mau toi

----------------------------------------------
--- new color
UIUtils.green_light = "96dc2a" -- xanh sang
UIUtils.green_dark = "466e08" -- xanh toi
UIUtils.red_light = "fa1c00" -- do sang
UIUtils.red_dark = "971309" -- do toi
UIUtils.brown = "584D3D" -- nau
UIUtils.green_normal = "5c821b" -- xanh
UIUtils.sizeItem = U_Vector2(136, 136)
UIUtils.sizeHero = U_Vector2(150, 150)

UIUtils.text_color_with_type = {
	U_Color(137 / 255, 254 / 255, 1, 1), -- water
	U_Color(1, 209 / 255, 154 / 255, 1), -- fire
	U_Color(162 / 255, 1, 229 / 255, 1), -- abyss
	U_Color(243 / 255, 1, 141 / 255, 1), -- nature
	U_Color(1, 245 / 255, 138 / 255, 1), -- light
	U_Color(227 / 255, 201 / 255, 1, 1), -- dark
}
--- faction color but darker
UIUtils.text_dark_color_with_faction_type = {
	U_Color(137 / 255, 254 / 255, 1, 1), -- water
	U_Color(1, 209 / 255, 154 / 255, 1), -- fire
	U_Color(162 / 255, 1, 229 / 255, 1), -- abyss
	U_Color(243 / 255, 1, 141 / 255, 1), -- nature
	U_Color(154 / 255, 147 / 255, 72 / 255, 1), -- light
	U_Color(123 / 255, 0 / 255, 1, 1), -- dark
}

UIUtils.glow_color_with_type = {
	U_Color(0, 0.68, 1, 0.8), -- water
	U_Color(1, 32 / 255, 0, 151 / 255), -- fire
	U_Color(0.035, 0.82, 0.6, 0.8), -- abyss
	U_Color(0.41, 0.84, 0.09, 0.8), -- nature
	U_Color(1, 127 / 255, 0, 150 / 255), -- light
	U_Color(154 / 255, 0, 1, 132 / 255), -- dark
}
UIUtils.ALLY_COLOR = U_Color(45 / 255, 127 / 255, 196 / 255, 1)
UIUtils.OPPONENT_COLOR = U_Color(176 / 255, 72 / 255, 26 / 255, 1)

UIUtils.RECORD_WIN = U_Color(106 / 255, 138 / 255, 17 / 255, 1)
UIUtils.RECORD_LOSE = U_Color(171 / 255, 38 / 255, 38 / 255, 1)
---@return string
--- @param text string
function UIUtils.SetColorString(color, text)
	return string.format("<color=#%s>%s</color>", color, text)
end

--- @param rarity number
function UIUtils.GetColorRarity(rarity)
	if rarity == 1 then
		return UIUtils.color_rarity_1
	elseif rarity == 2 then
		return UIUtils.color_rarity_2
	elseif rarity == 3 then
		return UIUtils.color_rarity_3
	elseif rarity == 4 then
		return UIUtils.color_rarity_4
	elseif rarity == 5 then
		return UIUtils.color_rarity_5
	elseif rarity == 6 then
		return UIUtils.color_rarity_6
	end
	return UIUtils.color_rarity_1
end

---@return void
--- @param button UnityEngine_UI_Button
--- @param interactable boolean
function UIUtils.SetInteractableButton(button, interactable)
	button.interactable = interactable
	if button.transition ~= U_Transition.None then
		if interactable == true then
			if button.transition ~= U_Transition.Animation then
				local animator = button.gameObject:GetComponent(ComponentName.UnityEngine_Animator)
				if animator ~= nil then
					button.transition = U_Transition.Animation
				end
			end
		else
			if button.transition ~= U_Transition.ColorTint then
				button.transition = U_Transition.ColorTint
			end
		end
	end
end

--- @param text UnityEngine_UI_Text
function UIUtils.CopyToClipboard(text)
	local te = CS.UnityEngine.TextEditor()
	te.text = tostring(text)
	te:SelectAll()
	te:Copy()
	SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("copy_to_clipboard"))
end

--- @param text UnityEngine_UI_Text
function UIUtils.AlignText(text)
	Coroutine.start(function()
		while text.enabled == false do
			coroutine.waitforendofframe()
		end
		--- @type UnityEngine_UI_ContentSizeFitter
		local contentSize = text.gameObject:AddComponent(ComponentName.UnityEngine_UI_ContentSizeFitter)
		contentSize.horizontalFit = U_FitMode.PreferredSize
		coroutine.waitforendofframe()
		text.alignment = U_TextAnchor.MiddleCenter
		coroutine.waitforendofframe()
		U_Object.Destroy(contentSize)
		text.alignment = U_TextAnchor.MiddleLeft
	end)

end

--- @param text TMPro_TextMeshProUGUI
function UIUtils.AlignTextMeshPro(text)
	Coroutine.start(function()
		while text.enabled == false do
			coroutine.waitforendofframe()
		end
		--- @type UnityEngine_UI_ContentSizeFitter
		local contentSize = text.gameObject:AddComponent(ComponentName.UnityEngine_UI_ContentSizeFitter)
		contentSize.horizontalFit = U_FitMode.PreferredSize
		coroutine.waitforendofframe()
		text.alignment = U_TextAlignmentOptions.Midline
		coroutine.waitforendofframe()
		U_Object.Destroy(contentSize)
		text.enableWordWrapping = false
		text.alignment = U_TextAlignmentOptions.MidlineLeft
	end)

end

--- @return void
--- @param transform UnityEngine_RectTransform
function UIUtils.SetUIParent(transform, parent)
	UIUtils.SetAnchor(transform)
	UIUtils.SetParent(transform, parent)
end

--- @return void
--- @param ui UnityEngine_RectTransform
function UIUtils.SetSafeArea(ui)
	---@type UnityEngine_Rect
	local safeArea = U_Screen.safeArea
	--safeArea = U_Rect(132, 63, 2336, 1125)
	if U_Screen.orientation == CS.UnityEngine.ScreenOrientation.LandscapeRight then
		safeArea = U_Rect(0, 0, U_Screen.width - safeArea.x, U_Screen.height)
	else
		safeArea = U_Rect(safeArea.x, 0, U_Screen.width, U_Screen.height)
	end
	---@type UnityEngine_Vector2
	local resolution = uiCanvas:GetResolution()
	ui.offsetMin = U_Vector2((safeArea.x / U_Screen.width) * resolution.x, (safeArea.y / U_Screen.height) * resolution.y)
	ui.offsetMax = U_Vector2((safeArea.width / U_Screen.width - 1) * resolution.x, (safeArea.height / U_Screen.height - 1) * resolution.y)
end

--- @return void
--- @param ui UnityEngine_RectTransform
function UIUtils.SetAnchor(ui)
	ui.anchorMin = U_Vector2(0.5, 0.5)
	ui.anchorMax = U_Vector2(0.5, 0.5)
	ui.pivot = U_Vector2(0.5, 0.5)
end

--- @return void
--- @param transform UnityEngine_Transform
function UIUtils.SetParent(transform, parent)
	assert(transform)
	parent = parent or zgUnity.transform
	transform:SetParent(parent)
	transform.localPosition = U_Vector3.zero
	transform.localScale = U_Vector3.one
	transform.localEulerAngles = U_Vector3.zero
end

--- @return void
--- @param ui UnityEngine_UI_Image
---@param number number
function UIUtils.SlideImageHorizontal(ui, number)
	---@type UnityEngine_Sprite
	local sprite = ui.sprite
	local size = sprite.border.x + sprite.border.z
	local sizeDelta = sprite.bounds.size.x * 100 - size
	ui.rectTransform.sizeDelta = U_Vector2(size + sizeDelta * (number - 1), sprite.bounds.size.y * 100)
end

--- @return void
--- @param ui UnityEngine_UI_Image
---@param number number
function UIUtils.SlideImageVertical(ui, number)
	---@type UnityEngine_Sprite
	local sprite = ui.sprite
	local size = sprite.border.y + sprite.border.w
	local sizeDelta = sprite.bounds.size.y * 100 - size
	ui.rectTransform.sizeDelta = U_Vector2(sprite.bounds.size.x * 100, size + sizeDelta * (number - 1))
end

--- @return void
--- @param trigger UnityEngine_EventSystems_EventTrigger
--- @param onPointEnter function
--- @param onPointExit function
function UIUtils.SetTrigger(trigger, onPointEnter, onPointExit, onPointClick, onPointUp, onPointDrop, onPointDown)
	--XDebug.Log("UIUtils.SetTrigger")
	assert(trigger)
	trigger.triggers:Clear()
	if onPointEnter ~= nil then
		--- @type UnityEngine_EventSystems_EventTrigger_Entry
		local entryPointEnter = U_EventSystems.EventTrigger.Entry()
		entryPointEnter.eventID = U_EventSystems.EventTriggerType.PointerEnter
		entryPointEnter.callback:AddListener(function(data)
			-- XDebug.Log("onPointEnter")
			onPointEnter()
		end)
		trigger.triggers:Add(entryPointEnter)
	end

	if onPointDown ~= nil then
		--- @type UnityEngine_EventSystems_EventTrigger_Entry
		local entryPointDown = U_EventSystems.EventTrigger.Entry()
		entryPointDown.eventID = U_EventSystems.EventTriggerType.PointerDown
		entryPointDown.callback:AddListener(function(data)
			-- XDebug.Log("onPointDown")
			onPointDown()
		end)
		trigger.triggers:Add(entryPointDown)
	end

	if onPointExit ~= nil then
		--- @type UnityEngine_EventSystems_EventTrigger_Entry
		local entryPointExit = U_EventSystems.EventTrigger.Entry()
		entryPointExit.eventID = U_EventSystems.EventTriggerType.PointerExit
		entryPointExit.callback:AddListener(function(data)
			-- XDebug.Log("onPointExit")
			onPointExit()
		end)
		trigger.triggers:Add(entryPointExit)
	end

	if onPointClick ~= nil then
		--- @type UnityEngine_EventSystems_EventTrigger_Entry
		local entryPoint = U_EventSystems.EventTrigger.Entry()
		entryPoint.eventID = U_EventSystems.EventTriggerType.PointerClick
		entryPoint.callback:AddListener(function(data)
			-- XDebug.Log("onPointClick")
			onPointClick()
		end)
		trigger.triggers:Add(entryPoint)
	end

	if onPointUp ~= nil then
		--- @type UnityEngine_EventSystems_EventTrigger_Entry
		local entryPoint = U_EventSystems.EventTrigger.Entry()
		entryPoint.eventID = U_EventSystems.EventTriggerType.PointerUp
		entryPoint.callback:AddListener(function(data)
			--  XDebug.Log("onPointUp")
			onPointUp()
		end)
		trigger.triggers:Add(entryPoint)
	end

	if onPointDrop ~= nil then
		--- @type UnityEngine_EventSystems_EventTrigger_Entry
		local entryPoint = U_EventSystems.EventTrigger.Entry()
		entryPoint.eventID = U_EventSystems.EventTriggerType.Drop
		entryPoint.callback:AddListener(function(data)
			-- XDebug.Log("onPointDrop")
			onPointDrop()
		end)
		trigger.triggers:Add(entryPoint)
	end
end

--- @return void
--- @param value number
function UIUtils.SetTextTestValue(config, value)
	--if IS_EDITOR_PLATFORM then
	--if zgUnity.IsTest and IS_EDITOR_PLATFORM then
	--    if config.textFullMoney == nil then
	--        ---@type UnityEngine_GameObject
	--        local gameObject = U_GameObject("text_full_money")
	--        gameObject.transform:SetParent(config.transform)
	--        gameObject.transform.localPosition = U_Vector3.zero
	--        --- @type UnityEngine_UI_Text
	--        config.textFullMoney = gameObject:AddComponent(ComponentName.UnityEngine_UI_Text)
	--        config.textFullMoney.enabled = false
	--    end
	--    config.textFullMoney.text = tostring(value)
	--end
	--end
end

--- @return void
---@param gameObject UnityEngine_GameObject
---@param isActive boolean
function UIUtils.SetActiveColor(gameObject, isActive)
	UIUtils.SetActiveColorByMaterial(gameObject, isActive, "ui_gray_mat")
end

--- @return void
---@param gameObject UnityEngine_GameObject
---@param isActive boolean
function UIUtils.SetActiveColorDisable(gameObject, isActive)
	UIUtils.SetActiveColorByMaterial(gameObject, isActive, "ui_disable_mat")
end

--- @return void
---@param gameObject UnityEngine_GameObject
---@param isActive boolean
---@param materialName string
function UIUtils.SetActiveColorByMaterial(gameObject, isActive, materialName)
	local material
	if isActive == false then
		material = ResourceLoadUtils.LoadMaterial(materialName)
	else
		material = nil
	end
	local graphics = gameObject:GetComponentsInChildren(ComponentName.UnityEngine_UI_Graphic, true)
	for i = 0, graphics.Length - 1 do
		graphics[i].material = material
	end
end

--- @return string
--- @param quantity number
--- @param maxSize number
function UIUtils.FormatTextConsumeResource(quantity, maxSize)
	local color = quantity > 0 and UIUtils.green_light or UIUtils.color7
	return UIUtils.SetColorString(color, string.format("(%d/%d)", quantity, maxSize))
end

--- @return void
--- @param image UnityEngine_UI_Image
function UIUtils.SetFillSizeImage(image, x, y)
	image:SetNativeSize()
	if x ~= nil and y ~= nil then
		local ratito = image.rectTransform.sizeDelta.x / image.rectTransform.sizeDelta.y
		if ratito > x / y then
			image.rectTransform.sizeDelta = U_Vector2(x, x / ratito)
		else
			image.rectTransform.sizeDelta = U_Vector2(y * ratito, y)
		end
	end
end

--- @return void
---@param image UnityEngine_UI_Image
function UIUtils.FillSizeHeroView(image)
	---@type Vector2
	local size = image.sprite.bounds.size
	image.fillAmount = math.min(size.x / size.y, 1)
	local width = image.rectTransform.sizeDelta.x
	image.rectTransform.sizeDelta = U_Vector2(width, width * size.y / size.x)
end