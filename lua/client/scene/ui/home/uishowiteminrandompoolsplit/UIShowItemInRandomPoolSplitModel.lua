--- @class UIShowItemInRandomPoolSplitModel : UIBaseModel
UIShowItemInRandomPoolSplitModel = Class(UIShowItemInRandomPoolSplitModel, UIBaseModel)

--- @return void
function UIShowItemInRandomPoolSplitModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIShowItemInRandomPoolSplit, "show_item_in_random_pool_split")

    self.bgDark = true
end

