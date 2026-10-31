local CHAT_CONFIG_PATH = "csv/chat/chat_config.csv"

--- @class ChatConfig
ChatConfig = Class(ChatConfig)

function ChatConfig:Ctor()
    --- @type number
    self.messageLength = nil
    --- @type number
    self.historyLength = nil

    self:Init()
end

function ChatConfig:Init()
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(CHAT_CONFIG_PATH)
        self.messageLength = tonumber(parseData[1].chat_message_length)
        self.historyLength = tonumber(parseData[1].chat_history_length)
end

return ChatConfig