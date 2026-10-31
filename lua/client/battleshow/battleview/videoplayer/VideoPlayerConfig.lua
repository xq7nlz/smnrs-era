--- @class VideoPlayerConfig
VideoPlayerConfig = Class(VideoPlayerConfig)

--- @return void
--- @param transform UnityEngine_Transform
function VideoPlayerConfig:Ctor(transform)
	--- @type UnityEngine_GameObject
	self.gameObject = transform.gameObject
	--- @type UnityEngine_Transform
	self.transform = transform.transform
	--- @type UnityEngine_Video_VideoPlayer
	self.videoPlayer = self.transform:Find("video_player"):GetComponent(ComponentName.UnityEngine_Video_VideoPlayer)
	--- @type UnityEngine_UI_RawImage
	self.renderTexture = self.transform:Find("render_texture"):GetComponent(ComponentName.UnityEngine_UI_RawImage)
	--- @type UnityEngine_RectTransform
	self.renderRect = self.transform:Find("render_texture"):GetComponent(ComponentName.UnityEngine_RectTransform)
	--- @type UnityEngine_Canvas
	self.canvas = self.transform:Find(""):GetComponent(ComponentName.UnityEngine_Canvas)
end
