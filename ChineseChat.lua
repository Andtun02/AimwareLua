-- Lua加载输出控制台的信息
print("||Aimware-V5 中国话 Ver0.1 beta");
print("||立项时间: 2021年4月15日20:02:19");
print("||作者: Andtun | 和豚");
-- api 
-- http://olime.baidu.com/py?input=【拼音】&inputtype=py&bg=0&ed=20&result=hanzi&resultcoding=utf-8&ch_en=0&clientinfo=web&version=1
-- OutText = http.Get("http://olime.baidu.com/py?input=ceshi&inputtype=py&bg=0&ed=20&result=hanzi&resultcoding=utf-8&ch_en=0&clientinfo=web&version=1");
-- print(OutText)

-- 变量
screenX, screenY = draw.GetScreenSize(); --窗口位置
CNapi_head = "http://olime.baidu.com/py?input=";
CNapi_end = "&inputtype=py&bg=0&ed=20&result=hanzi&resultcoding=utf-8&ch_en=0&clientinfo=web&version=1";

-- AW GUI
local tabSet = gui.Tab(gui.Reference("Settings"), "ChineseInput", "中国话")
local guiLocation = gui.Reference("Settings", "中国话"); --查找并创建对UI对象
local NOTICE = gui.Groupbox(guiLocation, "通知:", 20, 20, 265, 400); --创建公告模块
local CIM = gui.Groupbox(guiLocation, "中文输入模块·设置", 20, 150, 265, 400); --创建中文输入模块
local CTM = gui.Groupbox(guiLocation,"聊天翻译模块·设置 | 没做呢", 300, 20, 265, 400); --创建聊天翻译模块
-- 通知模块GUI notice
local ag = gui.Text(NOTICE, "作者：Andtun|和豚  版本：Free\nhttp://awge.net/product/view/246")

-- 中文输入模块GUI CIM
local onCI = gui.Checkbox( CIM, "onci", "启用 中文输入", 0 ); --选择框 是否启用中文输入
local keyVisablyCI = gui.Keybox(CIM,"keyvisablyci","显示/隐藏 输入窗口",0)

-- 聊天翻译模块GUI CTM
local onCTM = gui.Checkbox( CTM, "onci", "启用 聊天翻译", 0 ); --选择框 是否启用中文输入
onCTM:SetDisabled(true);


-- 中文输入窗口模块
CIwindow = gui.Window("CIwindow", "中国话 | 中文输入模块· 拼音转汉字", screenX / 4, screenY / 4, 500, 300);
CIwindow:SetInvisible(true); --隐藏窗口
local CIinput = gui.Editbox(CIwindow, "ciinput", "输入拼音:");
local CIoutBox = gui.Groupbox(CIwindow,"结果:",15,70,320,290);
local CIout = gui.Text(CIoutBox,"Null");
local CIbuttonBox = gui.Groupbox(CIwindow,"按钮专区",340,70,155,400)
local CIview = gui.Button(CIbuttonBox, "预览",function () CIviewChat() end);
local CIteam = gui.Button(CIbuttonBox, "队内发送",function () CIsendTeamChat() end);
local CIall = gui.Button(CIbuttonBox, "全局发送",function () CIsendChat() end);

local function getOutText() -- 获取分割后的中文
    local webOutText = http.Get(CNapi_head..CIinput:GetValue()..CNapi_end); --网页输出中文josn
    local a = webOutText:gsub("[a-zA-Z-0-9]","");
    local b = a:gsub("[[}{:,\"']","");
    local result = b:gsub("[]]","");
    return result;
end

function CIviewChat()
    local OutText = getOutText();
    if vOutText == "  " then
        CIout:SetText("抱歉,Api识别异常 | 原因: 目前也就处于'能用'阶段");
    else
        CIout:SetText(OutText);
    end
end

function CIsendTeamChat()
    local OutText = getOutText();
    if vOutText == "  " then
        CIout:SetText("抱歉,Api识别异常 | 原因: 目前也就处于'能用'阶段");
    else
        CIout:SetText(OutText);
        client.ChatTeamSay(OutText);
    end
end

function CIsendChat() --发送消息
    local OutText = getOutText();
    if OutText == "  " then --空消息判断
        CIout:SetText("抱歉,Api识别异常 | 原因: 目前也就处于'能用'阶段");
    else
        CIout:SetText(OutText);
        client.ChatSay(OutText);
    end
end



local function CIdraw()
    if (onCI:GetValue() ~= true) then 
        keyVisablyCI:SetDisabled(true); --禁用显示隐藏按键设置
    else
        keyVisablyCI:SetDisabled(false); --判断是否设置按键     
        if(keyVisablyCI:GetValue() ~= 0) then
            CIwindow:SetInvisible(false); --显示窗口
        end
        CIwindow:SetOpenKey(keyVisablyCI:GetValue()); --设置窗口打开按键
    end
end
callbacks.Register("Draw", CIdraw); --监听


