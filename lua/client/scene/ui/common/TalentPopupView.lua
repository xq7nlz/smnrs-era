require "lua.client.scene.ui.home.uiHeroMenu2.UISlotEquipTalent"
--- @class TalentPopupView
TalentPopupView = Class(TalentPopupView)

function TalentPopupView:Ctor(transform, onNoti)
	--- @type TalentPopupConfig
	self.config = UIBaseConfig(transform)
	--- @type Dictionary
	self.talentSlotDict = Dictionary()
	---@type boolean
	self.onNoti = true
	if onNoti ~= nil then
		self.onNoti = onNoti
	end
	self:InitTalentItems()
end

function TalentPopupView:ToggleShow()
	self.config.gameObject:SetActive(not self.config.gameObject.activeSelf)
end

function TalentPopupView:Disable()
	self.config.gameObject:SetActive(false)
end

function TalentPopupView:InitTalentItems()
	self.config.closeArrow.onClick:AddListener(function()
		self:ToggleShow()
	end)
	self.talentSlotDict:Add(SlotEquipmentType.Talent, UISlotEquipTalent(self.config.talent1, self.onNoti))
	self.talentSlotDict:Add(SlotEquipmentType.Talent2, UISlotEquipTalent(self.config.talent2, self.onNoti))
end

function TalentPopupView:InitTalentButtonListener(callback)
	--- @param v UISlotEquipTalent
	--- @param k number
	for k, v in pairs(self.talentSlotDict:GetItems()) do
		v.config.button.onClick:RemoveAllListeners()
		v.config.button.onClick:AddListener(function()
			callback(k)
		end)
	end
end

--- @return void
function TalentPopupView:UpdateAllUITalent(heroResource)
	--- @param v UISlotEquipTalent
	for k,v in pairs(self.talentSlotDict:GetItems())do
		v:UpdateTalent(k,heroResource)
	end
end