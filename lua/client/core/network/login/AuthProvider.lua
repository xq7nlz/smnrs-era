--- @class AuthProvider
AuthProvider = {
    WINDOWS_DEVICE = 0,

    GOOGLE_PLAY_GAME = 1,
    GAME_CENTER = 2,
    FACEBOOK = 3,

    ANDROID = 4,
    IOS = 5,
}

---@return AuthProvider
function AuthProvider.GetCurrentAuthProvider()
    if IS_ANDROID_PLATFORM then
        return AuthProvider.ANDROID
    elseif IS_IOS_PLATFORM then
        return AuthProvider.IOS
    else
        return AuthProvider.WINDOWS_DEVICE
    end
end