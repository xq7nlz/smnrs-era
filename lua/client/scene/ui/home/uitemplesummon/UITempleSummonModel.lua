
--- @class UITempleSummonModel : UIBaseModel
UITempleSummonModel = Class(UITempleSummonModel, UIBaseModel)

--- @return void
function UITempleSummonModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITempleSummon, "temple_summon")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	--- @type UnityEngine_Vector3[] List
	self.positionList = List()
	--- @type number[] List
	self.scaleList = List()
	--- @type UnityEngine_Transform[] List
	self.templeList = List()
	self.timeTempleRotate = 0.3
	--- @type number
	self.timeFog = 0.4
	--- @type number
	self.templeCount = 6
	--- @type number
	self.temple = nil
	--- @type Subject
	self.currentTemple = nil
	--- @type TempleSummonData
	self.templeSummonData = ResourceMgr.GetTempleSummonConfig()
	--- @type TempleSummonResultInBound
    self.templeSummonResult = nil
	--- @type Dictionary ItemIconData
	self.rewardDict = Dictionary()
	--- @type number
	self.bonusWood = 0

	self.positionMouseDown = 0
	self.positionMouseUp = 0

	self.deltaOrbLayer = 5

	self:Init()

	self.bgDark = false
end

--- @return void
function UITempleSummonModel:Init()
	self.positionList:Add(U_Vector3(0, 0, 6))
	self.positionList:Add(U_Vector3(4.5, 0.7, 5))
	self.positionList:Add(U_Vector3(2.45, 1.7, 2))
	self.positionList:Add(U_Vector3(0, 2, 0))
	self.positionList:Add(U_Vector3(-2.45, 1.7, 1))
	self.positionList:Add(U_Vector3(-4.5, 0.7, 4))

	self.scaleList:Add(1)
	self.scaleList:Add(0.6)
	self.scaleList:Add(0.35)
	self.scaleList:Add(0.25)
	self.scaleList:Add(0.35)
	self.scaleList:Add(0.6)
end

