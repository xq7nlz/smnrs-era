--- @class TowerLockConfig
TowerLockConfig = Class(TowerLockConfig)

function TowerLockConfig:Ctor(levelRequire,min,max)
	--- @type number
	self.levelRequire = levelRequire
	--- @type number
	self.min = min
	--- @type number
	self.max = max
end