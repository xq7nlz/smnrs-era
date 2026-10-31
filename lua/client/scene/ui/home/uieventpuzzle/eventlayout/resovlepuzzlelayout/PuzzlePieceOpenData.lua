--- @class PuzzlePieceOpenData
PuzzlePieceOpenData = Class(PuzzlePieceOpenData)

--- @param view UIEventPuzzleView
function PuzzlePieceOpenData:Ctor()
	--- @type Dictionary
	self.heroPieceHistories = Dictionary()
	--- @type number
	self.heroId = 0
	--- @type boolean
	self.isClaimed = false
end

--- @return PuzzlePieceOpenData
--- @param buffer UnifiedNetwork_ByteBuf
function PuzzlePieceOpenData.CreateByBuffer(buffer)
	--- @type PuzzlePieceOpenData
	local data = PuzzlePieceOpenData()
	data.heroId = buffer:GetInt()
	local size = buffer:GetByte()
	for i = 1, 32 do
		data.heroPieceHistories:Add(i,false)
	end
	for i = 1, size do
		data.heroPieceHistories:Add(buffer:GetInt(),true)
	end
	data.isClaimed = buffer:GetBool()
	return data
end


function PuzzlePieceOpenData.CreateInstance(heroId)
	local inst = PuzzlePieceOpenData()
	--- @type number
	inst.heroId = heroId

	for i = 1, 32 do
		inst.heroPieceHistories:Add(i,false)
	end

	return inst
end