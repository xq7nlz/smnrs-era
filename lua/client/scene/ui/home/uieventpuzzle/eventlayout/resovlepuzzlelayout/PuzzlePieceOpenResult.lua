--- @class PuzzlePieceOpenResult
PuzzlePieceOpenResult = Class(PuzzlePieceOpenResult)

--- @param view UIEventPuzzleView
function PuzzlePieceOpenResult:Ctor()
	--- @type number
	self.pieceId = 0
	--- @type List
	self.listRewards = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PuzzlePieceOpenResult:Serialize(buffer)
	self.pieceId = buffer:GetInt()
	self.listRewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
end