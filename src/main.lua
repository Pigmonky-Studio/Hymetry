cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

local function main()
    --distance:noteboard上底距离 imageDistance:成像位置与照相机的距离 h:行高 angle:夹角
    local director = cc.Director:getInstance()
    local visibleSize = director:getVisibleSize()
    cc.exports.angle = 2
    cc.exports.distance = 1080/math.tan(math.rad(88))
    cc.exports.imageDistance = 70
    cc.exports.h = 50
    cc.exports.keys = 4

    local startMenuLabelConfig = {}
    startMenuLabelConfig.fontFilePath = "res/fonts/bold.ttf"
    startMenuLabelConfig.fontSize = 100
    local startAboutLabelConfig = {}
    startAboutLabelConfig.fontFilePath = "res/fonts/light.ttf"
    startAboutLabelConfig.fontSize = 20
    local startScene = cc.Scene:create()
    local startBackgroundLayer = cc.Layer:create()
    local startUILayer = cc.Layer:create()
    local startBackground = cc.Sprite:create("res/textures/background.png")
        :setAnchorPoint(0, 0)
        :setPosition(cc.p(0, 0))
    local startPlayLabel = cc.MenuItemLabel:create(cc.Label:createWithTTF(startMenuLabelConfig, "Play!"))
        :setPosition(cc.p(0, 100))
    local startSettingsLabel = cc.MenuItemLabel:create(cc.Label:createWithTTF(startMenuLabelConfig, "Settings"))
        :setPosition(cc.p(0, -100))
    local startMenu = cc.Menu:create(startPlayLabel, startSettingsLabel)
    local startAboutLabel = cc.Label:createWithTTF(startAboutLabelConfig,
        [[Hymetry BUILD_0.0.5. NO DISSEMINATION. 内部版本 不得外传
Copyright © 2022 PIGMONKY STUDIO. All Rights Reserved. 猪猴工作室 版权所有
Created with Cocos2d-x. Font licence at http://www.reeji.com/mfsysm. ]])
        :setAnchorPoint(0.5, 0)
        :setPosition(cc.p(visibleSize.width/2, 5))
    startBackgroundLayer:addChild(startBackground)
    startUILayer:addChild(startMenu)
        :addChild(startAboutLabel)
    startScene:addChild(startBackgroundLayer)
        :addChild(startUILayer)

    local playingScene = cc.Scene:create()
    local playingBackgroundLayer = cc.Layer:create()
    local playingMainLayer = cc.Layer:create()
    local playingUILayer = cc.Layer:create()
    local playingBackground = cc.Sprite:create("res/textures/background.png")
        :setAnchorPoint(0, 0)
        :setPosition(cc.p(0, 0))
    local playingBackButton = ccui.Button:create("res/textures/back_button/normal.png")
        :loadTextureNormal("res/textures/back_button/normal.png")
        :loadTexturePressed("res/textures/back_button/press.png")
        :setAnchorPoint(0, 1)
        :setPosition(cc.p(20, visibleSize.height-20))
    local playingNoteBoard = {}
    playingNoteBoard.background = {}
    for i = 1, 1080 do
        playingNoteBoard.background[i] = cc.Sprite:create("res/textures/note_board/background.png", cc.rect(0, i-1, 2048, 1))
            :setPosition(cc.p(visibleSize.width/2, i))
        playingMainLayer:addChild(playingNoteBoard.background[i])
    end
    playingNoteBoard.splitLines = {}
    playingBackgroundLayer:addChild(playingBackground)
    playingUILayer:addChild(playingBackButton)
    playingScene:addChild(playingBackgroundLayer)
        :addChild(playingMainLayer)
        :addChild(playingUILayer)
        :retain()
    startPlayLabel:registerScriptTapHandler(function(tag, object)
        for i, v in ipairs(playingNoteBoard.background) do
            local offset = distance*(1080-i)/1080
            v:setScaleX(1/(imageDistance+distance)*(imageDistance+offset))
        end
        local a = 2048/(imageDistance+distance)*imageDistance
        for i = 1, keys-1 do
            playingNoteBoard.splitLines[i] = cc.Sprite:create("res/textures/note_board/split_line.png")
                :setAnchorPoint(0.5, 0)
                :setPosition(cc.p(2048/keys*i-(2048-visibleSize.width)/2, 0))
                :setSkewX(90-math.radian2angle(math.atan2(visibleSize.height, (2048-a)/2+a/keys*i-(2048/keys*i))))
            playingMainLayer:addChild(playingNoteBoard.splitLines[i])
        end
        local playingBackButtonTouchListener = cc.EventListenerTouchOneByOne:create()
        playingBackButtonTouchListener:registerScriptHandler(function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
        playingBackButtonTouchListener:registerScriptHandler(function(touch, event)
            if cc.rectContainsPoint(playingBackButton:getBoundingBox(), touch:getLocation()) then
                playingBackButton:getEventDispatcher():removeEventListener(playingBackButtonTouchListener)
                director:replaceScene(cc.TransitionFlipY:create(1, startScene))
                playingBackButton:runAction(cc.Sequence:create(cc.DelayTime:create(1),
                    cc.CallFunc:create(function()
                        for i, v in ipairs(playingNoteBoard.splitLines) do
                            v:removeFromParent()
                        end
                        playingNoteBoard.splitLines = {}
                    end)))
            end
            return true
        end, cc.Handler.EVENT_TOUCH_ENDED)
        playingBackButton:getEventDispatcher():addEventListenerWithFixedPriority(playingBackButtonTouchListener, -1)
        director:pushScene(cc.TransitionFlipY:create(1, playingScene))
    end)

    local settingsLabelConfig = {}
    settingsLabelConfig.fontFilePath = "res/fonts/default.ttf"
    settingsLabelConfig.fontSize = 35
    local settingsScene = cc.Scene:create()
    local settingsBackgroundLayer = cc.Layer:create()
    local settingsMainLayer = cc.Layer:create()
    local settingsUILayer = cc.Layer:create()
    local settingsBackground = cc.Sprite:create("res/textures/background.png")
        :setAnchorPoint(0, 0)
        :setPosition(cc.p(0, 0))
    local settingsBackButton = ccui.Button:create("res/textures/back_button/normal.png")
        :loadTextureNormal("res/textures/back_button/normal.png")
        :loadTexturePressed("res/textures/back_button/press.png")
        :setAnchorPoint(0, 1)
        :setPosition(cc.p(20, visibleSize.height-20))
    local settingsView = {}
    settingsView.background = {}
    for i = 1, 432 do
        settingsView.background[i] = cc.Sprite:create("res/textures/note_board/background.png", cc.rect(0, 2.5*(i-1), 2048, 2.5))
            :setAnchorPoint(0.5, 0)
            :setPosition(cc.p(visibleSize.width/2, visibleSize.height/2+(i-1)))
            :setScaleY(0.4)
        settingsMainLayer:addChild(settingsView.background[i])
    end
    settingsView.splitLines = {}
    director:pushScene(cc.TransitionFlipY:create(1, playingScene))
    local settingsAngleSlider = cc.ControlSlider:create("res/textures/slider/back.png", "res/textures/slider/press_bar.png", "res/textures/slider/node_normal.png", "res/textures/slider/node_press.png")
        :setPosition(cc.p(visibleSize.width/2, visibleSize.height/2-100))
        :setMinimumValue(0)
        :setMaximumValue(20)
        :setValue(2)
    local settingsAngleSliderNamelabel = cc.Label:createWithTTF(settingsLabelConfig, "Included angle")
        :setAnchorPoint(1,0.5)
        :setPosition(cc.p(visibleSize.width/2-540, visibleSize.height/2-100))
    local settingsAngleSliderValueLabel = cc.Label:createWithTTF(settingsLabelConfig, "2°/20°")
        :setAnchorPoint(0,0.5)
        :setPosition(cc.p(visibleSize.width/2+540, visibleSize.height/2-100))
    local settingsDistanceSlider = cc.ControlSlider:create("res/textures/slider/back.png", "res/textures/slider/press_bar.png", "res/textures/slider/node_normal.png", "res/textures/slider/node_press.png")
        :setPosition(cc.p(visibleSize.width/2, visibleSize.height/2-200))
        :setMinimumValue(0)
        :setMaximumValue(1080/math.tan(math.rad(70)))
        :setValue(distance)
    local settingsDistanceSliderNamelabel = cc.Label:createWithTTF(settingsLabelConfig, "Short side distance")
        :setAnchorPoint(1,0.5)
        :setPosition(cc.p(visibleSize.width/2-540, visibleSize.height/2-200))
    local settingsDistanceSliderValueLabel = cc.Label:createWithTTF(settingsLabelConfig, math.round(distance).."px/"..math.round(1080/math.tan(math.rad(70))).."px")
        :setAnchorPoint(0,0.5)
        :setPosition(cc.p(visibleSize.width/2+540, visibleSize.height/2-200))
    local settingsHeightSlider = cc.ControlSlider:create("res/textures/slider/back.png", "res/textures/slider/press_bar.png", "res/textures/slider/node_normal.png", "res/textures/slider/node_press.png")
        :setPosition(cc.p(visibleSize.width/2, visibleSize.height/2-300))
        :setMinimumValue(0)
        :setMaximumValue(visibleSize.height)
        :setValue(50)
    local settingsHeightSliderNamelabel = cc.Label:createWithTTF(settingsLabelConfig, "Row height")
        :setAnchorPoint(1,0.5)
        :setPosition(cc.p(visibleSize.width/2-540, visibleSize.height/2-300))
    local settingsHeightSliderValueLabel = cc.Label:createWithTTF(settingsLabelConfig, "50px/"..math.round(visibleSize.height).."px")
        :setAnchorPoint(0,0.5)
        :setPosition(cc.p(visibleSize.width/2+540, visibleSize.height/2-300))
    local settingsKeysSlider = cc.ControlSlider:create("res/textures/slider/back.png", "res/textures/slider/press_bar.png", "res/textures/slider/node_normal.png", "res/textures/slider/node_press.png")
        :setPosition(cc.p(visibleSize.width/2, visibleSize.height/2-400))
        :setMinimumValue(1)
        :setMaximumValue(10)
        :setValue(4)
    local settingsKeysSliderNamelabel = cc.Label:createWithTTF(settingsLabelConfig, "Keys")
        :setAnchorPoint(1,0.5)
        :setPosition(cc.p(visibleSize.width/2-540, visibleSize.height/2-400))
    local settingsKeysSliderValueLabel = cc.Label:createWithTTF(settingsLabelConfig, "4K/10K")
        :setAnchorPoint(0,0.5)
        :setPosition(cc.p(visibleSize.width/2+540, visibleSize.height/2-400))
    settingsAngleSlider:registerControlEventHandler(function(ref, event)
        cc.exports.angle = math.round(settingsAngleSlider:getValue()*10)/10
        settingsAngleSliderValueLabel:setString(angle.."°/20°")
        local distance = math.round(1080/math.tan(math.rad(90-angle)))
        if math.round(settingsDistanceSlider:getValue()) ~= distance then
            settingsDistanceSlider:setValue(distance)
        end
        local a = 2048/(imageDistance+distance)*imageDistance
        for i, v in ipairs(settingsView.splitLines) do
            v:setSkewX(90-math.radian2angle(math.atan2(visibleSize.height, (2048-a)/2+a/keys*i-(2048/keys*i))))
        end
    end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    settingsDistanceSlider:registerControlEventHandler(function(ref, event)
        cc.exports.distance = math.round(settingsDistanceSlider:getValue())
        settingsDistanceSliderValueLabel:setString(distance.."px/"..math.round(1080/math.tan(math.rad(70))).."px")
        local angle = math.round((90-math.radian2angle(math.atan2(1080, distance)))*10)/10
        if math.round(settingsAngleSlider:getValue()*10)/10 ~= angle then
            settingsAngleSlider:setValue(angle)
        end
        local a = 2048/(imageDistance+distance)*imageDistance
        for i, v in ipairs(settingsView.splitLines) do
            v:setSkewX(90-math.radian2angle(math.atan2(visibleSize.height, (2048-a)/2+a/keys*i-(2048/keys*i))))
        end 
        for i, v in ipairs(settingsView.background) do
            local offset = distance*(1080-2.5*i)/1080
            v:setScaleX(0.4*(1/(imageDistance+distance)*(imageDistance+offset)))
        end
    end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    settingsHeightSlider:registerControlEventHandler(function(ref, event)
        cc.exports.h = math.round(settingsHeightSlider:getValue())
        settingsHeightSliderValueLabel:setString(h.."px/"..math.round(visibleSize.height).."px")
    end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    settingsKeysSlider:registerControlEventHandler(function(ref, event)
        cc.exports.keys = math.round(settingsKeysSlider:getValue())
        settingsKeysSliderValueLabel:setString(keys.."K/10K")
        local a = 2048/(imageDistance+distance)*imageDistance
        while #settingsView.splitLines > keys-1 do
            settingsView.splitLines[#settingsView.splitLines]:removeFromParent()
            table.remove(settingsView.splitLines)
        end
        while #settingsView.splitLines < keys-1 do
            table.insert(settingsView.splitLines, cc.Sprite:create("res/textures/note_board/split_line.png")
                :setAnchorPoint(0.5, 0)
                :setScale(0.4))
            settingsScene:addChild(settingsView.splitLines[#settingsView.splitLines])
        end
        local a = 2048/(imageDistance+distance)*imageDistance
        for i, v in ipairs(settingsView.splitLines) do
            v:setPosition(cc.p((2048/keys*i-(2048-visibleSize.width)/2-visibleSize.width/2)*0.4+visibleSize.width/2, visibleSize.height/2))
                :setSkewX(90-math.radian2angle(math.atan2(visibleSize.height, (2048-a)/2+a/keys*i-(2048/keys*i))))
        end
    end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    settingsBackgroundLayer:addChild(settingsBackground)
    settingsMainLayer:addChild(settingsAngleSlider)
        :addChild(settingsAngleSliderNamelabel)
        :addChild(settingsAngleSliderValueLabel)
        :addChild(settingsDistanceSlider)
        :addChild(settingsDistanceSliderNamelabel)
        :addChild(settingsDistanceSliderValueLabel)
        :addChild(settingsHeightSlider)
        :addChild(settingsHeightSliderNamelabel)
        :addChild(settingsHeightSliderValueLabel)
        :addChild(settingsKeysSlider)
        :addChild(settingsKeysSliderNamelabel)
        :addChild(settingsKeysSliderValueLabel)
    settingsUILayer:addChild(settingsBackButton)
    settingsScene:addChild(settingsBackgroundLayer)
        :addChild(settingsMainLayer)
        :addChild(settingsUILayer)
        :retain()
    startSettingsLabel:registerScriptTapHandler(function(tag, sender)
        for i, v in ipairs(settingsView.background) do
            local offset = distance*(1080-2.5*i)/1080
            v:setScaleX(0.4*(1/(imageDistance+distance)*(imageDistance+offset)))
        end
        while #settingsView.splitLines > keys-1 do
            if settingsView.splitLines[#settingsView.splitLines]:isRunning() == true then
                settingsView.splitLines[#settingsView.splitLines]:removeFromParent()
            end
            table.remove(settingsView.splitLines)
        end
        while #settingsView.splitLines < keys-1 do
            table.insert(settingsView.splitLines, cc.Sprite:create("res/textures/note_board/split_line.png")
                :setAnchorPoint(0.5, 0)
                :setScale(0.4))
            settingsScene:addChild(settingsView.splitLines[#settingsView.splitLines])
        end
        local a = 2048/(imageDistance+distance)*imageDistance
        for i, v in ipairs(settingsView.splitLines) do
            v:setPosition(cc.p(((2048/keys*i-(2048-visibleSize.width)/2)-visibleSize.width/2)*0.4+visibleSize.width/2, visibleSize.height/2))
                :setSkewX(90-math.radian2angle(math.atan2(visibleSize.height, (2048-a)/2+a/keys*i-(2048/keys*i))))
        end
        local settingsBackButtonTouchListener = cc.EventListenerTouchOneByOne:create()
        settingsBackButtonTouchListener:registerScriptHandler(function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
        settingsBackButtonTouchListener:registerScriptHandler(function(touch, event)
            if cc.rectContainsPoint(settingsBackButton:getBoundingBox(), touch:getLocation()) then
                settingsBackButton:getEventDispatcher():removeEventListener(settingsBackButtonTouchListener)
                director:replaceScene(cc.TransitionFlipX:create(1, startScene))
            end
            return true
        end, cc.Handler.EVENT_TOUCH_ENDED)
        settingsBackButton:getEventDispatcher():addEventListenerWithFixedPriority(settingsBackButtonTouchListener, -1)
        director:pushScene(cc.TransitionFlipX:create(1, settingsScene))
    end)

    director:runWithScene(startScene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
