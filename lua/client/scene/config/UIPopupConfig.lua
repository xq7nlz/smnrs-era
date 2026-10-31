
--- @class UIPopupHideType
UIPopupHideType = {
    NONE = 1,
    HIDE_ALL = 4, -- except special
}

--- use to detect close or not when call close all and deactive scene
--- @class UIPopupType
UIPopupType = {
    NORMAL_POPUP = 1, -- hide all times
    BLUR_POPUP = 2, -- normal popup but blur when show
    NO_BLUR_POPUP = 3, -- normal popup but can't blur when show
    SPECIAL_POPUP = 4, -- dont hide when hide all
}