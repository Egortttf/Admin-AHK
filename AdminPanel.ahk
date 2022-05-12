; 	Автор скрипта: Oscar Millian (RellaX)
; 	Обновил скрипт: Igor Grissi
; 	Специально для администрации Arizona V

IniRead, chkdebuglog, %A_MyDocuments%\AdminPanel\settings.ini, settings, debuglog
if (chkdebuglog == 1)
	global dbuglog := 1

CreateNewFile(FileName)
{
	FileAppend, , %A_WorkingDir%\AdminPanel-%FileName%, UTF-8
	SplashTextOn, 500, 20, Создание файла, Создан новый файл: %FileName% (заполните его)
	Sleep, 3000
	SplashTextOff
}

SendChat(alvl, gtext, chkadminlvl, chkadmintag)
{
	sendbcmd = 1
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - (SendChat-Start) (cmdlvl=%alvl% mylvl=%chkadminlvl% tag=%chkadmintag%) sendbcmd=%sendbcmd%`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	WinActivate, ahk_exe ragemp_v.exe
	While(!WinActive("ahk_exe ragemp_v.exe")) {
	}
	if (chkadmintag != -1)
	{
		SendMessage, 0x50,, 0x4190419,, A
		localtag := " // " chkadmintag
	}
	else
		localtag := ""
	StringReplace, gtext, gtext, !, {!}, All
	StringReplace, gtext, gtext, +, {+}, All
	StringReplace, gtext, gtext, #, {#}, All
	SendInput, {vk54}
	Sleep, %chktextdelay%
	if (chkadminlvl < alvl)
		SendInput, /a %gtext%%localtag%{Enter}
	else
		SendInput, %gtext%{Enter}
	sendbcmd = 0
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - (SendChat-End) «%gtext%» sendbcmd=%sendbcmd%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}

ErrorInputID(idiname)
{
	SplashTextOn, 350, 20, [ Arizona V ]  Admin Panel Lite | Ошибка, Неправильно указан параметр %idiname%!
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - (ErrorInputID) Неправильно указан параметр (%idiname%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	Sleep, 1200
	SplashTextOff
}

EditAdmSettings()
{
	Gui 1: -MaximizeBox -SysMenu
	Gui 1: Add, CheckBox, x10 y10 w280 vBlackInterface, Включить тёмный интерфейс для Admin Panel
	Gui 1: Add, Text, x10 y35 w150, Непрозрачность Admin Panel:
	Gui 1: Add, Slider, x160 y33 w140 vOpacitySlider, 100
	Gui 1: Add, Text, x10 y70 w190, Ваш уровень администрирования:
	Gui 1: Add, DropDownList, x200 y68 w50 Choose1 r6 vSelectAlvl, 1||2||3||4||5||6
	Gui 1: Add, Text, x10 y100 w190, Ваш Тэг запроса наказания в /a:
	Gui 1: Add, Edit, x200 y98 w100 Limit15 vInputAtag, 
	Gui 1: Add, Text, x10 y130 w190, Задержка после открытия (T): мсек. (ставь больше задержку, если текст команды багается в чате) 70 - 200
	Gui 1: Add, Edit, x200 y128 w50 Number Limit3 vChatTextDelay, 70
	Gui 1: Add, Button, gsaveinifilesstart, Сохранить
	Gui 1: Show, , AdminPanel | Настройки
}

EditAdmSettingsValue(valone, valtwo, valthree, valfour, valfive)
{
	Gui 1: -MaximizeBox -SysMenu
	Gui 1: Add, CheckBox, x10 y10 w280 vBlackInterface, Включить тёмный интерфейс для Admin Panel
	Gui 1: Add, Text, x10 y35 w150, Непрозрачность Admin Panel:
	Gui 1: Add, Slider, x160 y33 w140 vOpacitySlider, %valfive%
	Gui 1: Add, Text, x10 y70 w190, Ваш уровень администрирования:
	Gui 1: Add, DropDownList, x200 y68 w50 Choose%valone% r6 vSelectAlvl, 1||2||3||4||5||6
	Gui 1: Add, Text, x10 y100 w190, Ваш Тэг запроса наказания в /a:
	Gui 1: Add, Edit, x200 y98 w100 Limit15 vInputAtag, %valtwo%
	Gui 1: Add, Text, x10 y130 w190, Задержка после открытия (T): мсек. (ставь больше задержку, если текст команды багается в чате) 70 - 200
	Gui 1: Add, Edit, x200 y128 w50 Number Limit3 vChatTextDelay, %valthree%
	Gui 1: Add, Button, gsaveinifilesstart, Сохранить
	GuiControl, , BlackInterface, %valfour%
	Gui 1: Show, , [ Arizona V ]  Admin Panel Lite | Настройки
}

if (dbuglog)
	FileAppend, `n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
if (A_IsAdmin = false)
{
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - (RunAsAdmin) = false`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - (RunAsAdmin)`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8

versionscr = 12.05.2022

urlcheck := "https://disk.yandex.ru/d/HTrkDwHryMas4A"
ComObjError(false)
HTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
HTTP.Open("GET", urlcheck, false)
HTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
HTTP.SetRequestHeader("Referer", url)
HTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
HTTP.Send()
HTTP.WaitForResponse()
global tget := HTTP.ResponseText
	
if tget not contains [Version=%versionscr%]
{
	msgbox, 4, [ Arizona V ]  Admin Panel Lite | Обновление, Доступно новое обновление скрипта!`nЖелаете перейти на страницу загрузки?
	IfMsgBox, Yes
	{
		Run, https://disk.yandex.ru/d/HTrkDwHryMas4A
		ExitApp
	}
}

#MaxThreadsPerHotkey 2
#SingleInstance, force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 0
SetBatchLines -1
ListLines Off
Process, priority, , High

menu, tray, NoStandard
menu, tray, add, Настройки
menu, tray, add, Перезагрузить
menu, tray, add, Информация
menu, tray, add, Выйти

IfNotExist, %A_MyDocuments%\AdminPanel\settings.ini
{
	FileCreateDir, %A_MyDocuments%\AdminPanel
	IniWrite, %versionscr%, %A_MyDocuments%\AdminPanel\settings.ini, settings, version
	EditAdmSettings()
	Return
}
contstart:
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ContStart`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
IniRead, checkvers, %A_MyDocuments%\AdminPanel\settings.ini, settings, version
if (checkvers != versionscr)
{
	IniWrite, %versionscr%, %A_MyDocuments%\AdminPanel\settings.ini, settings, version
	msgbox, 64, [ Arizona V ]  Admin Panel Lite | Обновление %versionscr%, - Оптимизация кода.`n- Убран бинд "аслежу".`n- Бинд "аобъявление" переделан на "асми".`n- Дополненые некоторые скрипты для будущих обновлений
}
IniRead, chkadminlvl, %A_MyDocuments%\AdminPanel\settings.ini, settings, adminlvl
IniRead, chkadmintag, %A_MyDocuments%\AdminPanel\settings.ini, settings, admintag
IniRead, chktextdelay, %A_MyDocuments%\AdminPanel\settings.ini, settings, textdelay
IniRead, chkblackint, %A_MyDocuments%\AdminPanel\settings.ini, settings, blackint
IniRead, chkopacityint, %A_MyDocuments%\AdminPanel\settings.ini, settings, opacityint
if (chkadminlvl == "ERROR") || (chkadmintag == "ERROR") || (chktextdelay == "ERROR") || (chkblackint == "ERROR") || (chkopacityint == "ERROR")
{
	EditAdmSettings()
	Return
}
global chktextdelay := chktextdelay
sucload = 1
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - Скрипт загружен`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Return

saveinifilesstart:
Gui 1: Submit, NoHide
if !RegExMatch(InputAtag, "[A-z]") || RegExMatch(InputAtag, "[0-9]") || (StrLen(InputAtag) < 3) || RegExMatch(InputAtag, "[А-яЁё]")
{
	msgbox, 16, AdminPanel | Ошибка, - Количество символов в Тэге должно быть больше 2!`n- В Тэге не должны присутствовать цифры!`n- Тэг должен быть только в английском формате!
	Return
}
if !(ChatTextDelay >= 70 && ChatTextDelay <= 200)
{
	msgbox, 16, AdminPanel | Ошибка, Задержка не может быть меньше 70 или больше 200!
	Return
}
Gui 1: Destroy
IniWrite, %SelectAlvl%, %A_MyDocuments%\AdminPanel\settings.ini, settings, adminlvl
IniWrite, %InputAtag%, %A_MyDocuments%\AdminPanel\settings.ini, settings, admintag
IniWrite, %ChatTextDelay%, %A_MyDocuments%\AdminPanel\settings.ini, settings, textdelay
IniWrite, %BlackInterface%, %A_MyDocuments%\AdminPanel\settings.ini, settings, blackint
IniWrite, %OpacitySlider%, %A_MyDocuments%\AdminPanel\settings.ini, settings, opacityint
Goto, contstart
Return

!vk24::
IfNotExist, %A_WorkingDir%\AdminPanel-ListOne.txt
{
	CreateNewFile("ListOne.txt")
	Return
}
if (!cklist)
{
	cklist = 1
	FileRead, Contents, %A_WorkingDir%\AdminPanel-ListOne.txt
	SysGet, aScreenWidth, 0
	ToolTip, %Contents%, %aScreenWidth%, 60
}
else
{
	cklist = 0
	ToolTip
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [ListOne] cklist=%cklist%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
if (cklistp)
	cklistp = 0
Return

!vk23::
IfNotExist, %A_WorkingDir%\AdminPanel-ListTwo.txt
{
	CreateNewFile("ListTwo.txt")
	Return
}
if (!cklistp)
{
	cklistp = 1
	FileRead, Contento, %A_WorkingDir%\AdminPanel-ListTwo.txt
	SysGet, aScreenWidth, 0
	ToolTip, %Contento%, %aScreenWidth%, 60
}
else
{
	cklistp = 0
	ToolTip
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [ListTwo] cklistp=%cklistp%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
if (cklist)
	cklist = 0
Return

Настройки:
if (ShowAP)
{
	Gui 2: Destroy
	ShowAP := !ShowAP
}
EditAdmSettingsValue(chkadminlvl, chkadmintag, chktextdelay, chkblackint, chkopacityint)
Return

Перезагрузить:
SoundPlay *64
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [Reload]`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Reload
Return

Информация:
msgbox, 64, [ Arizona V ]  Admin Panel Lite | Информация, Автор скрипта: Oscar Millian (RellaX)`nДоработал скрипт: Igor Grossi (EgorTtt)`nСпециально для Администрации Arizona V`n`n[!] Поменяйте в GTA V: [Настройки-Графика-Тип экрана]`nна «Оконный без рамки», иначе Gui не будет работать.`n`nF3 - Открыть/Закрыть Admin Panel.`nF4 - Свернуть/Развернуть Admin Panel.`n`nAlt+1 - Принять админ-форму (Ctrl+C всю строку).`nCtrl+V - Вставить готовую админ-форму (Ctrl+1 > Ctrl+C).`n`nPause - Взять репорт.`n`nAlt+- - Выключениеи скрипта.`nAlt++ - Перезагрузка скрипта.`n`nAlt+Home - Показать/Скрыть ListOne.`nAlt+End - Показать/Скрыть ListTwo.`n`nРешение ошибок:`n- Скрипт вводит медленно команды/текст`n» Это происходит из-за открытия браузера находясь в игре. Открывайте браузер перед запуском GTA V и не закрывайте.`n- Если возникает какой то баг или ошибка`n» Перезапускайте скрипт сочитанием клавиш Alt++`n`nВерсия скрипта: %versionscr%
Return

!vkbb::
SoundPlay *64
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [Reload]`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Reload
Return

!vkbd::
SoundPlay *16
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [ExitApp]`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Выйти:
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - Выйти`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
ExitApp
Return

$~F3::
if (activecap) || (sendbcmd)
	Return
activecap = 1
if (!sucload)
{
	SplashTextOn, 380, 20, Ошибка, Данные ещё не загрузились! Попробуйте нажать ещё раз
	Sleep, 1000
	SplashTextOff
	activecap = 0
	Return
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] AP-Start`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
if (respcarz) || (offpun) || (automes)
{
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] Error: (respcarz=%respcarz%) (offpun=%offpun%) (automes=%automes%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	activecap = 0
	Return
}
if (winmini)
{
	Gui 2: Destroy
	ShowAP := !ShowAP
	winmini = 0
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] SetWinMini: (winmini=%winmini%) (ShowAP=%ShowAP%)`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}
if (ShowAP)
{
	Gui 2: Destroy
	WinActivate, ahk_exe ragemp_v.exe
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] AP-Destroy`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}
else
{
	if !WinActive("ahk_exe ragemp_v.exe")
	{
		activecap = 0
		Return
	}
	IfNotExist, %A_WorkingDir%\AdminPanel-NamesSkins.txt
	{
		CreateNewFile("NamesSkins.txt")
		activecap = 0
		Return
	}
	FileRead, skinsfile, %A_WorkingDir%\AdminPanel-NamesSkins.txt
	if (skinsfile == "")
	{
		SplashTextOn, 350, 20, Ошибка, Файл NamesSkins.txt пустой, заполните его!
		Sleep, 3000
		SplashTextOff
		activecap = 0
		Return
	}
	IfNotExist, %A_WorkingDir%\AdminPanel-NamesVehs.txt
	{
		CreateNewFile("NamesVehs.txt")
		activecap = 0
		Return
	}
	FileRead, vehsfile, %A_WorkingDir%\AdminPanel-NamesVehs.txt
	if (vehsfile == "")
	{
		SplashTextOn, 350, 20, Ошибка, Файл NamesVehs.txt пустой, заполните его!
		Sleep, 3000
		SplashTextOff
		activecap = 0
		Return
	}
	if (chkblackint)
	{
		Gui 2: Font, s9 bold cWhite, Calibri
		Gui 2: Color, 0x333333, 0x4d4d4d
		if (dbuglog)
			FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] SetBlackAP: chkblackint=%chkblackint%`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	}
	else
	{
		Gui 2: Font, s9 bold, Calibri
		if (dbuglog)
			FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] SetWhiteAP: chkblackint=%chkblackint%`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	}
	Gui 2: -MaximizeBox -SysMenu +AlwaysOnTop +ToolWindow
	;
	Gui 2: Add, Text, x4 y6 w293 h2 +0x10  
	Gui 2: Add, GroupBox, x5 y8 w168 h173, Действие с игроком
	Gui 2: Add, Text, x11 y25 w17 h18 +0x200  , ID:
	Gui 2: Add, Edit, x27 y25 w38 h18 Number Limit4 vInputPid, 
	Gui 2: Add, Button, x68 y25 w26 h18 gRecon, re
	Gui 2: Add, Button, x98 y25 w33 h18 gReoff, reoff
	Gui 2: Add, Button, x10 y47 w50 h18 gGoto, Goto
	Gui 2: Add, Button, x64 y47 w50 h18 gGethere, Gethere
	Gui 2: Add, Button, x10 y113 w50 h18 gTPcar, TPcar
	Gui 2: Add, Button, x10 y69 w50 h18 gSpawn, Spawn
	Gui 2: Add, Button, x64 y69 w50 h18 gFrz, Freeze
	Gui 2: Add, Button, x118 y69 w50 h18 gUnFrz, Unfrze
	Gui 2: Add, Button, x10 y91 w50 h18 gSlap, Slap
	Gui 2: Add, Button, x64 y91 w50 h18 gCure, Cure
	Gui 2: Add, Button, x118 y91 w50 h18 gKill, Kill
	Gui 2: Add, Button, x64 y135 w50 h18 gChkGM, ChkGM
	Gui 2: Add, Button, x64 y113 w50 h18 gSetHP, SetHP
	Gui 2: Add, Button, x118 y113 w50 h18 gSkipQ, SkipQ
	Gui 2: Add, Button, x10 y135 w50 h18 gChkDim vChkDim, ChkDim
	Gui 2: Add, Button, x118 y47 w50 h18 gSetDim, SetDim
	Gui 2: Add, Button, x118 y135 w50 h18 gOguns, Oguns
	Gui 2: Add, Button, x10 y157 w50 h18 gWanted vWanted, Wanted
	Gui 2: Add, Button, x64 y157 w50 h18 gMoney vMoney, Money
	Gui 2: Add, Button, x118 y157 w50 h18 gProps vProps, Props
	; Блоки для 4+
	Gui 2: Add, Text, x5 y185 w170 h2 +0x10 
	Gui 2: Add, Button, x10 y192 w158 h18 gResJCars vResJCars, /ao + Respawn Job Cars
	Gui 2: Add, Button, x10 y216 w75 h18 gOffPun vOffPun, OffPunish
	Gui 2: Add, Button, x93 y216 w75 h18 gActAuto vActAuto, ActionAuto
	Gui 2: Add, Text, x5 y239 w170 h2 +0x10 
	; Админ настройки
	Gui 2: Add, GroupBox, x5 y242 w168 h40, Админ настройки
	Gui 2: Add, Button, x10 y259 w50 h18 gTurnINV, INV
	Gui 2: Add, Button, x64 y259 w50 h18 gTurnAGM, AGM
	Gui 2: Add, Button, x118 y259 w50 h18 gTurnRED, RNAME
	; Полезные ссылки
	Gui 2: Add, GroupBox, x5 y285 w168 h44, Полезные ссылки
	Gui 2: Add, Link, x12 y304 w158 h16, <a href="https://forum.arizona-v.com/forums/obschie-pravila.53/">ОПС</a> I <a href="https://forum.arizona-v.com/forums/pravila-dlja-gosudarstvennyx-struktur.54/">ПГС</a> I <a href="https://forum.arizona-v.com/forums/pravila-dlja-kriminalnyx-struktur.55/">ПКС</a> I <a href="https://sites.google.com/view/arizona-bz/главная-страница">База знаний</a>
	; Действие с авто
	Gui 2: Add, GroupBox, x180 y8 w114 h129, Действие с авто
	Gui 2: Add, Text, x186 y25 w35 h18 +0x200  , VehID:
	Gui 2: Add, Edit, x220 y25 w43 h18 Limit5 Number vInputVehID, 
	Gui 2: Add, Button, x185 y47 w50 h18 gGotoVeh, GVeh
	Gui 2: Add, Button, x239 y47 w50 h18 gGethereVeh, GhVeh
	Gui 2: Add, Button, x185 y69 w50 h18 gGotoInVehOne, InVeh 0
	Gui 2: Add, Button, x239 y69 w50 h18 gGotoInVehTwo, InVeh 1
	Gui 2: Add, Button, x185 y91 w50 h18 gFlipCar, Flip
	Gui 2: Add, Button, x239 y91 w50 h18 gSpCar, Spcar
	Gui 2: Add, Button, x185 y113 w50 h18 gFixCar, Fixcar
	Gui 2: Add, Button, x239 y113 w50 h18 gFixBuggedVeh vFixBuggedVeh, FixBug
	;
	Gui 2: Add, Text, x181 y141 w114 h2 +0x10 
	Gui 2: Add, Text, x181 y147 w16 h18 +0x200  , №:
	Gui 2: Add, Edit, x198 y147 w37 h18 Limit4 Number vInputHomeID, 
	Gui 2: Add, Button, x238 y147 w55 h18 gHomeTP vHomeTP, HomeTP
	Gui 2: Add, Text, x181 y169 w16 h18 +0x200  , №:
	Gui 2: Add, Edit, x198 y169 w37 h18 Limit4 Number vInputBizID, 
	Gui 2: Add, Button, x238 y169 w55 h18 gBizTP vBizTP, BizTP
	;
	Gui 2: Add, DropDownList, x181 y191 w83 Choose1 r7 vSelectTpInt, Интерьер||Остров||Бункер||Серверная||Подземелье||Субмарина
	Gui 2: Add, Button, x267 y191 w26 h22 gGotoTpInt vGotoTpInt, ТП
	;
	Gui 2: Add, Text, x181 y218 w114 h2 +0x10  
	Gui 2: Add, DropDownList, x181 y225 w112 Choose1 r10 vSelectSkinName, %skinsfile%
	Gui 2: Add, Link, x181 y253 w20 h16, <a href="https://wiki.rage.mp/index.php?title=Peds">Ped</a>
	Gui 2: Add, Text, x205 y252 w16 h18 +0x200  , ID:
	Gui 2: Add, Edit, x221 y253 w37 h18 Limit4 Number vInputPidSkin, 
	Gui 2: Add, Button, x261 y253 w32 h18 gSetSkin, Skin
	;
	Gui 2: Add, Text, x181 y273 w114 h2 +0x10  
	Gui 2: Add, DropDownList, x181 y280 w112 Choose1 r10 vSelectVehName, %vehsfile%
	Gui 2: Add, Link, x181 y308 w20 h16, <a href="https://wiki.rage.mp/index.php?title=Vehicles">Veh</a>
	Gui 2: Add, Text, x203 y306 w31 h18 +0x200  , цвет:
	Gui 2: Add, Edit, x232 y306 w30 h18 Limit3 Number vInputVehColor, 
	Gui 2: Add, Button, x265 y306 w28 h18 gCreateVeh vCreateVeh, Veh
	Gui 2: Add, Text, x181 y327 w114 h2 +0x10  
	;
	Gui 2: Add, Text, x4 y335 w293 h2 +0x10  
	;
	Gui 2: Add, Button, x135 y25 w15 h18 gRePrev, «
	Gui 2: Add, Button, x153 y25 w15 h18 gReNext, »
	if (chkadminlvl < 4)
	{
		GuiControl, 2:+Disabled, ResJCars
		GuiControl, 2:+Disabled, OffPun
		GuiControl, 2:+Disabled, InputVehColor
		GuiControl, 2:+Disabled, CreateVeh
	}
	if (chkadminlvl < 3)
	{
		GuiControl, 2:+Disabled, Wanted
		GuiControl, 2:+Disabled, Money
		GuiControl, 2:+Disabled, Props
		GuiControl, 2:+Disabled, GotoTpInt
		GuiControl, 2:+Disabled, ChkGM
		GuiControl, 2:+Disabled, ChkDim
		GuiControl, 2:+Disabled, Oguns
	}
	if (chkadminlvl < 2)
	{
		GuiControl, 2:+Disabled, FixBuggedVeh
		GuiControl, 2:+Disabled, TPcar
		GuiControl, 2:+Disabled, SkipQ
		GuiControl, 2:+Disabled, Oguns
		GuiControl, 2:+Disabled, SetHP
		GuiControl, 2:+Disabled, Kill
		GuiControl, 2:+Disabled, HomeTP
		GuiControl, 2:+Disabled, BizTP
		GuiControl, 2:+Disabled, InputHomeID
		GuiControl, 2:+Disabled, InputBizID
	}
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] AP-Create`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
	BlockInput, On
	SysGet, aScreenHeight, 1
	global azScreenHeight := aScreenHeight/3.04
	Gui 2: Show, NoActivate x0 y%azScreenHeight% w299 h345, [ Arizona V ]  Admin Panel Lite
	myopclvl := 155+chkopacityint
	WinSet, Transparent, %myopclvl%, [ Arizona V ]  Admin Panel Lite
	WinActivate, [ Arizona V ]  Admin Panel Lite
	aScreenHeight := azScreenHeight+58
	DllCall("SetCursorPos", "int", 180, "int", aScreenHeight)
	BlockInput, Off
}
ShowAP := !ShowAP
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F3] ShowAP=%ShowAP%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Sleep, 100
activecap = 0
Return

$~F4::
if (activeap) || (sendbcmd)
	Return
activeap = 1
if (ShowAP)
{
	if WinActive("ahk_exe ragemp_v.exe")
	{
		WinActivate, [ Arizona V ]  Admin Panel Lite
		Gui 2: +AlwaysOnTop
		Gui 2:-Disabled
		if (dbuglog)
			FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F4] Try: AP-Show`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
		While(!WinActive("I  Arizona V  I  Admin Panel")) {
		}
		if (dbuglog)
			FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F4] AP-Show`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
		Sendinput, {vk09}
		BlockInput, On
		WinGetPos, X, Y,,, [ Arizona V ]  Admin Panel Lite
		Xcoords := X+180
		Ycoords := Y+58
		DllCall("SetCursorPos", "int", Xcoords, "int", Ycoords)
		BlockInput, Off
		winmini = 0
	}
	else
	{
		Gui 2:+Disabled
		Gui 2: -AlwaysOnTop
		if (dbuglog)
			FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F4] AP-Hide`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
		WinMinimize, [ Arizona V ]  Admin Panel Lite
		WinActivate, ahk_exe ragemp_v.exe
		winmini = 1
	}
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [F4] winmini=%winmini%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}
Sleep, 100
activeap = 0
Return

Recon:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/re " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Reoff:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
SendChat(1, "/reoff" , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

RePrev:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/reoff" , chkadminlvl, -1 )
Sleep, 500
newInputPid := InputPid-1
GuiControl,, InputPid, %newInputPid%
SendChat(1, "/re " newInputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

ReNext:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/reoff" , chkadminlvl, -1 )
Sleep, 500
newInputPid := InputPid+1
GuiControl,, InputPid, %newInputPid%
SendChat(1, "/re " newInputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Goto:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/goto " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Gethere:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/gethere " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

TPcar:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/tpcar " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Spawn:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/spawn " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Frz:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/freeze " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

UnFrz:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/unfreeze " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Cure:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/cure " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Slap:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/slap " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Kill:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(1, "/kill " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

ChkGM:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(3, "/checkgm " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

SetHP:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
insethp:
InputBox, paramstxt, Изменить здоровье персонажу, Напишите кол-во здоровья персонажу:`nID: «%InputPid%»
if (!ErrorLevel)
{
	if RegExMatch(paramstxt, "[A-zА-яЁё]") || !RegExMatch(paramstxt, "[0-9]") || (StrLen(paramstxt) < 1) || (StrLen(paramstxt) > 3) || (paramstxt < 0) || (paramstxt > 100)
		Goto, insethp
	else
		SendChat(2, "/sethp " InputPid " " paramstxt , chkadminlvl, -1 )
}
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

SkipQ:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(2, "/questnexttask " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

ChkDim:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(2, "/checkdimension " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

SetDim:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
insetdim:
InputBox, paramstxt, Изменить измерение персонажу, Напишите номер измерения персонажу:`nID: «%InputPid%»
if (!ErrorLevel)
{
	if RegExMatch(paramstxt, "[A-zА-яЁё]") || !RegExMatch(paramstxt, "[0-9]") || (StrLen(paramstxt) < 1) || (StrLen(paramstxt) > 7) || (paramstxt < 0) || (paramstxt > 9999999)
		Goto, insetdim
	else
		SendChat(2, "/setdimension " InputPid " " paramstxt , chkadminlvl, -1 )
}
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Oguns:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(3, "/oguns " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Wanted:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(4, "/checkwanted " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Money:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(4, "/checkmoney " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

Props:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPid, "[A-zА-яЁё]") || !RegExMatch(InputPid, "[0-9]") || (StrLen(InputPid) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(4, "/checkprop " InputPid , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

GotoVeh:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
SendChat(1, "/gotoveh " InputVehID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

GethereVeh:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
SendChat(1, "/gethereveh " InputVehID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

GotoInVehOne:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
SendChat(1, "/gotoinveh " InputVehID " 0", chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

GotoInVehTwo:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
SendChat(1, "/gotoinveh " InputVehID " 1", chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

FlipCar:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
SendChat(1, "/flip " InputVehID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

SpCar:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
SendChat(2, "/spcar " InputVehID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

FixCar:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
SendChat(1, "/fixcar " InputVehID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

FixBuggedVeh:
if (busyreport)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehID, "[A-zА-яЁё]") || !RegExMatch(InputVehID, "[0-9]") || (StrLen(InputVehID) < 1)
{
	ErrorInputID("ID авто")
	Return
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - FixBuggedVeh: Try`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
WinActivate, ahk_exe ragemp_v.exe
While(!WinActive("ahk_exe ragemp_v.exe")) {
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - FixBuggedVeh: Start`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Sleep, %chktextdelay%
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /gethereveh %InputVehID%{Enter}
Sleep, 500
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /gethereveh %InputVehID%{Enter}
Sleep, 1000
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /gotoinveh %InputVehID% 1{Enter}
Sleep, 1500
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /fixcar %InputVehID%{Enter}
Sleep, 500
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /spcar %InputVehID%{Enter}
Sleep, 1000
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /gethereveh %InputVehID%{Enter}
Sleep, 5000
WinActivate, [ Arizona V ]  Admin Panel Lite
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - FixBuggedVeh: End`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Return

TurnINV:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
SendChat(1, "/inv", chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

TurnAGM:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
WinActivate, ahk_exe ragemp_v.exe
While(!WinActive("ahk_exe ragemp_v.exe")) {
}
Sleep, %chktextdelay%
SendInput, {vk2d Down}
Sleep, %chktextdelay%
SendInput, {vk2d Up}
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

TurnRED:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
SendChat(1, "/redname", chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

HomeTP:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputHomeID, "[A-zА-яЁё]") || !RegExMatch(InputHomeID, "[0-9]") || (StrLen(InputHomeID) < 1)
{
	ErrorInputID("№ дома")
	Return
}
SendChat(2, "/gotohouse " InputHomeID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

BizTP:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputBizID, "[A-zА-яЁё]") || !RegExMatch(InputBizID, "[0-9]") || (StrLen(InputBizID) < 1)
{
	ErrorInputID("№ бизнеса")
	Return
}
SendChat(2, "/gotobiz " InputBizID , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

GotoTpInt:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if (SelectTpInt == "Интерьер")
	SendChat(3, "/tpc -1507 -2993 -81", chkadminlvl, -1 )
else if (SelectTpInt == "Остров")
	SendChat(3, "/tpc 5052 -5745 17", chkadminlvl, -1 )
else if (SelectTpInt == "Бункер")
	SendChat(3, "/tpc 2151 2921 -61", chkadminlvl, -1 )
else if (SelectTpInt == "Серверная")
	SendChat(3, "/tpc 2158 2920 -81", chkadminlvl, -1 )
else if (SelectTpInt == "Подземелье")
	SendChat(3, "/tpc 899 -3246 -98", chkadminlvl, -1 )
else if (SelectTpInt == "Субмарина")
	SendChat(3, "/tpc 514 4885 -62", chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

SetSkin:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputPidSkin, "[A-zА-яЁё]") || !RegExMatch(InputPidSkin, "[0-9]") || (StrLen(InputPidSkin) < 1)
{
	ErrorInputID("ID игрока")
	Return
}
SendChat(4, "/setskin " InputPidSkin " " SelectSkinName , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

CreateVeh:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Submit, NoHide
if RegExMatch(InputVehColor, "[A-zА-яЁё]") || !RegExMatch(InputVehColor, "[0-9]") || (StrLen(InputVehColor) < 1)
{
	ErrorInputID("Цвета-ID")
	Return
}
SendChat(4, "/veh " SelectVehName " " InputVehColor " " InputVehColor , chkadminlvl, -1 )
WinActivate, [ Arizona V ]  Admin Panel Lite
Return

ResJCars:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Destroy
ShowAP := !ShowAP
respcarz = 1
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ResJCars: Try (ShowAP=%ShowAP%) (respcarz=%respcarz%)`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
WinActivate, ahk_exe ragemp_v.exe
While(!WinActive("ahk_exe ragemp_v.exe")) {
}
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ResJCars: Start`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
SendMessage, 0x50,, 0x4190419,, A
SendInput, {vk54}
Sleep, 269
Sendinput, /ao Через 30 секунд будет респавн рабочего транспорта. Займите водительские места{Enter}
looptime := 30
Loop, 30
{
	ToolTip, Ничего не трогайте! Респавн рабочего транспорта через %looptime% сек., 0, 270
	Sleep, 1000
	looptime--
}
ToolTip
SendMessage, 0x50,, 0x4190419,, A
SendInput, {vk54}
Sleep, %chktextdelay%
Sendinput, /respawnjobcars{Enter}
Sleep, 1000
SendInput, {vk54}
Sleep, %chktextdelay%
Sendinput, /ao Рабочий транспорт зареспавнен{Enter}
respcarz = 0
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ResJCars: End (respcarz=%respcarz%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Return

OffPun:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Destroy
ShowAP := !ShowAP
IfNotExist, %A_WorkingDir%\AdminPanel-OffPunish.txt
{
	CreateNewFile("OffPunish.txt")
	Return
}
FileRead, msactiontxt, %A_WorkingDir%\AdminPanel-OffPunish.txt
if (msactiontxt == "")
{
	SplashTextOn, 300, 20, Ошибка, Файл OffPunish.txt пустой, заполните его!
	Sleep, 3000
	SplashTextOff
	Return
}
Gui 3: Add, Text, , Начать выполнение из OffPunish.txt?:
Gui 3: Add, Button, gfloodact, Выполнить
Gui 3: Add, Text, , %msactiontxt%
Gui 3: Show, , OffPunish
Return

floodact:
Gui 3: Submit
Gui 3: Destroy
offpun = 1
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - OffPunish: Try (offpun=%offpun%)`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
WinActivate, ahk_exe ragemp_v.exe
While(!WinActive("ahk_exe ragemp_v.exe")) {
}
;BlockInput, On
SendMessage, 0x50,, 0x4190419,, A
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - OffPunish: Start`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Sleep, 1000
Loop, Read, %A_WorkingDir%\AdminPanel-OffPunish.txt
{
	FileReadLine, punish, %A_WorkingDir%\AdminPanel-OffPunish.txt, %A_Index%
	ToolTip, Ничего не трогайте! Выполняю:`n«%punish%», 0, 300
	StringReplace, punish, punish, !, {!}, All
	StringReplace, punish, punish, +, {+}, All
	StringReplace, punish, punish, #, {#}, All
	Sleep, 350
	SendInput, {vk54}
	Sleep, %chktextdelay%
	SendInput, %punish%{Enter}
	Sleep, 200
	ToolTip
	MsgBox, 3, OffPunish, Выберите результат последнего действия:`n`n[Да] - Действие выполнено`n[Нет] - Игрок в онлайне`n[Отмена] - Выдало ошибку/Остановить выполнение
	IfMsgBox No
	{
		WinActivate, ahk_exe ragemp_v.exe
		While(!WinActive("ahk_exe ragemp_v.exe")) {
		}
		Sleep, 350
		SendInput, {vk54}
		Sleep, %chktextdelay%
		RegExMatch(punish, "(.*?)\Q \E(.*?)\Q \E(.*)", nickplayer)
		SendInput, /id %nickplayer2%{Enter}
		nickplayer1 := RegExReplace(nickplayer1, "/off", "/")
		fulltxt := nickplayer1 "  " nickplayer3
		InputBox, setfamily, OffPunish, Введите ID игрока вместо ника:,,,,,,,, %fulltxt%
		if (!ErrorLevel)
		{
			Sleep, 350
			SendInput, {vk54}
			Sleep, %chktextdelay%
			SendInput, %setfamily%{Enter}
		}
		WinActivate, ahk_exe ragemp_v.exe
		While(!WinActive("ahk_exe ragemp_v.exe")) {
		}
	}
	else IfMsgBox Cancel
	{
		FileAppend, %punish%`n, %A_WorkingDir%\AdminPanel-ActionERRORS.txt, UTF-8
		MsgBox, 4, OffPunish, Ошибка записана в ActionERRORS.txt!`n`nПродолжить выполнение?
		IfMsgBox No
			Goto, toendo
		else
			WinActivate, ahk_exe ragemp_v.exe
	}
	else
		WinActivate, ahk_exe ragemp_v.exe
	While(!WinActive("ahk_exe ragemp_v.exe")) {
	}
}
toendo:
;BlockInput, Off
offpun = 0
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - OffPunish: End (offpun=%offpun%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Gui 3: Submit
Gui 3: Destroy
Gui 3: Add, Text, , Удалить весь текст из OffPunish.txt?
Gui 3: Add, Button, gdelit, Удалить
Gui 3: Show, , OffPunish
Return

delit:
Gui 3: Submit
Gui 3: Destroy
FileDelete, %A_WorkingDir%\AdminPanel-OffPunish.txt
CreateNewFile("OffPunish.txt")
WinActivate, ahk_exe ragemp_v.exe
Return

ActAuto:
if (busyreport) || (sendbcmd)
	Return
Gui 2: Destroy
ShowAP := !ShowAP
IfNotExist, %A_WorkingDir%\AdminPanel-ActionAuto.txt
{
	CreateNewFile("ActionAuto.txt")
	Return
}
FileRead, msactiontxtauto, %A_WorkingDir%\AdminPanel-ActionAuto.txt
if (msactiontxtauto == "")
{
	SplashTextOn, 350, 20, Ошибка, Файл ActionAuto.txt пустой, заполните его!
	Sleep, 3000
	SplashTextOff
	Return
}
Gui 3: Add, Text, , Начать выполнение из ActionAuto.txt?:
Gui 3: Add, Button, gautofloodact, Выполнить
Gui 3: Add, Text, , %msactiontxtauto%
Gui 3: Show, , ActionAuto
Return

autofloodact:
Gui 3: Submit
Gui 3: Destroy
automes = 1
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ActionAuto: Try (automes=%automes%)`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
WinActivate, ahk_exe ragemp_v.exe
While(!WinActive("ahk_exe ragemp_v.exe")) {
}
;BlockInput, On
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ActionAuto: Start`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
SendMessage, 0x50,, 0x4190419,, A
Sleep, 1000
Loop, Read, %A_WorkingDir%\AdminPanel-ActionAuto.txt
{
	FileReadLine, punishauto, %A_WorkingDir%\AdminPanel-ActionAuto.txt, %A_Index%
	ToolTip, Ничего не трогайте! Выполняю:`n«%punishauto%», 0, 300
	StringReplace, punishauto, punishauto, !, {!}, All
	StringReplace, punishauto, punishauto, +, {+}, All
	StringReplace, punishauto, punishauto, #, {#}, All
	Sleep, 350
	SendInput, {vk54}
	Sleep, %chktextdelay%
	SendInput, %punishauto%{Enter}
	sleepafter := 2000+chktextdelay
	Sleep, %sleepafter%
	ToolTip
}
;BlockInput, Off
automes = 0
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - ActionAuto: End (automes=%automes%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
Gui 3: Add, Text, , Удалить весь текст из ActionAuto.txt?
Gui 3: Add, Button, gdelitauto, Удалить
Gui 3: Show, , ActionAuto
Return

delitauto:
Gui 3: Submit
Gui 3: Destroy
FileDelete, %A_WorkingDir%\AdminPanel-ActionAuto.txt
CreateNewFile("ActionAuto.txt")
WinActivate, ahk_exe ragemp_v.exe
Return

3GuiClose:
Gui 3: Destroy
Return

#IfWinActive, ahk_exe ragemp_v.exe

$~Enter::
if (busyreport)
{
	busyreport = 0
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [Enter] busyreport=%busyreport%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}
Return

$~!1::
if (busyreport) || (sendbcmd) || (respcarz) || (offpun) || (automes)
	Return
SendMessage, 0x50,, 0x4190419,, A
SendInput, {vk54}
Sleep, %chktextdelay%
SendInput, /a {+} форма{Enter}
Sleep, 169
SendInput, {vk54}
DllCall("SetCursorPos", "int", 285, "int", 180)
Return

$~^vk56::
if (sendbcmd) || (respcarz) || (offpun) || (automes)
	Return
if (dbuglog)
	FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [Ctrl+V] Clipboard=%Clipboard%`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
if RegExMatch(Clipboard, "\Q[\E(.*)\Q] CID: \E(.*)\Q, Name: \E(.*?)$", getnickbycid)
{
	Clipboard := ""
	Sendinput, %getnickbycid3%
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [Ctrl+V] getcid: «%getnickbycid3%» (%getnickbycid2%) (%getnickbycid1%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}
else if RegExMatch(Clipboard, "\Q[A] \E(.*?)\Q (\E([0-9]{1,4})\Q): /\E(.*)", useaform)
{
	Clipboard := ""
	StringReplace, useaform3, useaform3, !, {!}, All
	StringReplace, useaform3, useaform3, +, {+}, All
	StringReplace, useaform3, useaform3, #, {#}, All
	SendMessage, 0x50,, 0x4190419,, A
	Sendinput, /%useaform3%
	if (dbuglog)
		FileAppend, [%A_DD%.%A_MM%.%A_Year% %A_Hour%:%A_Min%:%A_Sec%] - [Ctrl+V] aform: «/%useaform3%» (%useaform2%) (%useaform1%)`n`n, %A_WorkingDir%\DebugLogInfo.log, UTF-8
}
Return

; ==============================================================

#Hotstring EndChars `t ; Конечные символы

:?:азд::
SendInput, Здравствуйте,
Return
:?:fpl::
SendInput, Здравствуйте, 
Return	

:?:афорум::
SendInput, Здравствуйте. Вы можете подать жалобу на игрока при наличии доказательств нарушения на форуме forum.arizona-v.com ❤️️ 
Return
:?:fajhev::
SendInput, Здравствуйте. Вы можете подать жалобу на игрока при наличии доказательств нарушения на форуме forum.arizona-v.com ❤️️ 
Return

:?:аслежу::
SendInput, Здравствуйте.Начинаю слежку.❤️️ 
Return
:?:fckt;e::
SendInput, Здравствуйте. Начинаю слежку.❤️️
Return	

:?:мулкейс::
SendInput, Здравствуйте, мультикейс можно получить в TAB>Награды>Ежедневные награды.❤️️ 
Return
:?:vekkeys::
SendInput, Здравствуйте, мультикейс можно получить в TAB>Награды>Ежедневные награды.❤️️ 
Return	

:?:амастерка::
SendInput, Здравствуйте, публичная мастерская находится возле туристического магазина 2/2❤️️ 
Return
:?:fvfcnthrf::
SendInput, Здравствуйте, публичная мастерская находится возле туристического магазина 2/2❤️️ 
Return	

:?:амастерка::
SendInput, Здравствуйте, публичная мастерская находится возле туристического магазина 2/2❤️️ 
Return
:?:fvfcnthrf::
SendInput, Здравствуйте, публичная мастерская находится возле туристического магазина 2/2❤️️ 
Return	

:?:алесопилка::
SendInput, Здравствуйте, Лесопилка находится рядом с Палето-Бей, на карте обозначена зеленым значком.❤️️ 
Return
:?:fktcjgbkrf::
SendInput, Здравствуйте, Лесопилка находится рядом с Палето-Бей, на карте обозначена зеленым значком.❤️️ 
Return	

:?:ашахта::
SendInput, Здравствуйте, Шахта обозначается справа на карте зеленым ромбиком около 13 заправки.❤️️ 
Return
:?:fif[nf::
SendInput, Здравствуйте, Шахта обозначается справа на карте зеленым ромбиком около 13 заправки.❤️️ 
Return	

:?:ашахта::
SendInput, Здравствуйте, Шахта обозначается справа на карте зеленым ромбиком около 13 заправки.❤️️ 
Return
:?:fif[nf::
SendInput, `Здравствуйте, Шахта обозначается справа на карте зеленым ромбиком около 13 заправки.❤️️ 
Return	

:?:аостров::
SendInput, Здравствуйте,Остров находится справа в углу на карте, добраться туда можно только на лодке или воздушном транспорте.❤️️
Return
:?:fjcnhjd::
SendInput, Здравствуйте,Остров находится справа в углу на карте, добраться туда можно только на лодке или воздушном транспорте.❤️️
Return

:?:аостров::
SendInput, Здравствуйте,Остров находится справа в нижнем  углу на карте, добраться туда можно только на лодке или воздушном транспорте.❤️️
Return
:?:fjcnhjd::
SendInput, Здравствуйте,Остров находится справа в нижнем  углу на карте, добраться туда можно только на лодке или воздушном транспорте.❤️️
Return

:?:ачр::
SendInput, Здравствуйте,Черный рынок обозначен на карте двумя красными черепами, и находится внизу гетто.❤️️
Return
:?:fxh::
SendInput, Здравствуйте,Черный рынок обозначен на карте двумя красными черепами, и находится внизу гетто.❤️️
Return

:?:ацр::
SendInput, Здравствуйте, Центральный рынок находится на пляже Санта-Мария и обозначен на карте синим с черным цветом гаражем.❤️️
Return
:?:fwh::
SendInput, Здравствуйте, Центральный рынок находится на пляже Санта-Мария и обозначен на карте синим с черным цветом гаражем.❤️️
Return

:?:откзтп::
SendInput, Здравствуйте,Не телепортируем, вызовите такси, M-Taxi-Вызвать такси❤️️
Return
:?:otkpth::
SendInput, Здравствуйте,Не телепортируем, вызовите такси, M-Taxi-Вызвать такси❤️️
Return

:?:апрости::
SendInput, Здравствуйте. Мы знаем о проблеме и пытаемся её исправить. Приносим свои извинения за предоставленные неудобства.❤️️`
Return
:?:fghjcnb::
SendInput, Здравствуйте. Мы знаем о проблеме и пытаемся её исправить. Приносим свои извинения за предоставленные неудобства.❤️️`
Return

:?:ахотели::
SendInput, Здравствуйте. Мы бы очень хотели вам помочь. Но, мы не можем вмешиваться в РП процесс.❤️️
Return
:?:f[jntkb::
SendInput, Здравствуйте. Мы бы очень хотели вам помочь. Но, мы не можем вмешиваться в РП процесс.❤️️
Return

:?:акейс::
SendInput, Здравствуйте. Его можно забрать в любом почтовом отделении, почтомате (GoPostal или PostOP).❤️️
Return
:?:frtqc::
SendInput, Здравствуйте. Его можно забрать в любом почтовом отделении, почтомате (GoPostal или PostOP).❤️️
Return

:?:ане::
SendInput, Здравствуйте. Не владеем данной информацией.❤️️
Return
:?:fyt::
SendInput, Здравствуйте. Не владеем данной информацией.❤️️
Return

:?:аглиц::
SendInput, Здравствуйте. Лицензию на оружие можно получить у сотрудников BCSO/LSPD.❤️️
Return
:?:fukbw::
SendInput, Здравствуйте. Лицензию на оружие можно получить у сотрудников BCSO/LSPD.❤️️
Return

:?:аказино::
SendInput, Здравствуйте. Вы можете найти казино сверху от первого таксопарка. Маркер казино - это чёрно-белый ромб.❤️️
Return
:?:frfpbyj::
SendInput, Здравствуйте. Вы можете найти казино сверху от первого таксопарка. Маркер казино - это чёрно-белый ромб.❤️️
Return

:?:алск::
SendInput, Здравствуйте. Починить транспорт можно у механиков или заехав в Los Santos Customs.❤️️
Return
:?:fkcr::
SendInput, Здравствуйте. Починить транспорт можно у механиков или заехав в Los Santos Customs.❤️️
Return

:?:акарбаг::
SendInput, Здравствуйте. Нажмите TAB и выберите Статистика - (транспорт), затем открепите авто от места и прикрепите обратно. Это должно вам помочь.❤️️
Return
:?:frfh,fu::
SendInput, Здравствуйте. Нажмите TAB и выберите Статистика - (транспорт), затем открепите авто от места и прикрепите обратно. Это должно вам помочь.❤️️
Return

:?:авипинф::
SendInput, Здравствуйте. Нажмите TAB, выберите Магазин, выберите Премиум и нажмите на Дополнительно.❤️️
Return
:?:fdbgbya::
SendInput, Здравствуйте. Нажмите TAB, выберите Магазин, выберите Премиум и нажмите на Дополнительно.❤️️
Return

:?:аэкс::
SendInput, Здравствуйте. Реальные машины находятся в Эксклюзивном автосалоне. Нажмите M - Навигатор - Уникальный транспорт.❤️️
Return
:?:f'rc::
SendInput, Здравствуйте. Реальные машины находятся в Эксклюзивном автосалоне. Нажмите M - Навигатор - Уникальный транспорт.❤️️
Return

:?:акуратору::
SendInput, Здравствуйте. Передал ваш репорт куратору фракции.❤️️
Return
:?:frehfnjhe::
SendInput, Здравствуйте. Передал ваш репорт куратору фракции.❤️️
Return

:?:ажба::
SendInput, Здравствуйте. Если вы не согласны с действиями Администратора, создайте тему в разделе Жалобы на администратора (forum.arizona-v.com). ⭐️
Return
:?:f;,f::
SendInput, Здравствуйте. Если вы не согласны с действиями Администратора, создайте тему в разделе Жалобы на администратора (forum.arizona-v.com). ⭐️
Return

:?:атех::
SendInput, Здравствуйте. Создайте тему в техническом разделе с описанием проблемы и предоставлением доказательств на форуме forum.arizona-v.com.❤️️
Return
:?:fnt[::
SendInput, Здравствуйте. Создайте тему в техническом разделе с описанием проблемы и предоставлением доказательств на форуме forum.arizona-v.com.❤️️
Return

:?:аждать::
SendInput, Здравствуйте. Попробуйте немного подождать, после чего снова подойдите к метке. ⌛️
Return
:?:f;lfnm::
SendInput, Здравствуйте. Попробуйте немного подождать, после чего снова подойдите к метке. ⌛️
Return

:?:аща::
SendInput, Здравствуйте. Сейчас попробую вам помочь. ☄️
Return
:?:fof::
SendInput, Здравствуйте. Сейчас попробую вам помочь. ☄️
Return

:?:асми::
SendInput, Здравствуйте. Подать объявлением можно с помощью телефона (М - Weazel News). ✨️
Return
:?:fcvb::
SendInput, Здравствуйте. Подать объявлением можно с помощью телефона (М - Weazel News).️ ✨
Return

:?:аквест::
SendInput, Здравствуйте. Используйте TAB - Квесты - Найти ближайший квест.⚡️
Return
:?:frdtcn::
SendInput, Здравствуйте. Используйте TAB - Квесты - Найти ближайший квест.⚡️
Return

:?:априят::
SendInput, | Приятной игры на Arizona V! ❤️️
Return
:?:fghbzn::
SendInput, | Приятной игры на Arizona V! ❤️️
Return

:?:аномера::
SendInput, Здравствуйте, номера можно поставить на метке "Установка номеров" ( Черная табличка на карте в LS)| Приятной игры на Arizona V! ❤️
Return
:?:fyjvthf::
SendInput, Здравствуйте, номера можно поставить на метке "Установка номеров" ( Черная табличка на карте в LS)| Приятной игры на Arizona V! ❤️
Return

:?:арыбалка::
SendInput, Здравствуйте, рыбу можно продать игрокам или сдать NPC (бирюзовый крючек на карте)| Приятной игры на Arizona V! ❤️
Return
:?:fhs,fkrf::
SendInput, Здравствуйте, рыбу можно продать игрокам или сдать NPC (бирюзовый крючек на карте)| Приятной игры на Arizona V! ❤️
Return

:?:атур::
SendInput, Здравствуйте, можно приобрести в магазине туристического снаряжения (Ораньжевое колесо обозрения на карте)| Приятной игры на Arizona V! ❤️
Return
:?:fneh::
SendInput, Здравствуйте, можно приобрести в магазине туристического снаряжения (Ораньжевое колесо обозрения на карте)| Приятной игры на Arizona V! ❤️
Return

:?:асвалка::
SendInput, Здравствуйте, ваш транспорт можно сдать на свалку (M-Навигатор-Важные-Свалка авто) | Приятной игры на Arizona V! ❤️
Return
:?:fcdfkrf::
SendInput, Здравствуйте, ваш транспорт можно сдать на свалку (M-Навигатор-Важные-Свалка авто) | Приятной игры на Arizona V! ❤️
Return

:?:амеханик::
SendInput, Здравствуйте, вызвать автомеханика можно через M-Звонки-Контакты-Служба спасения-Механики | Приятной игры на Arizona V! ❤️
Return
:?:fvt[fybr::
SendInput, Здравствуйте, вызвать автомеханика можно через M-Звонки-Контакты-Служба спасения-Механики | Приятной игры на Arizona V! ❤️
Return

:?:адождь::
SendInput, Здравствуйте, Администрация не контролирует погоду на сервере, все изменения погоды вы можете посмотреть в M-Погода | Приятной игры на Arizona V! ❤️
Return
:?:flj;lm::
SendInput, Здравствуйте, Администрация не контролирует погоду на сервере, все изменения погоды вы можете посмотреть в M-Погода | Приятной игры на Arizona V! ❤️
Return

:?:амаска::
SendInput, Здравствуйте, приобрести маску можно в магазине масок (на карте белая маска) | Приятной игры на Arizona V! ❤️
Return
:?:fvfcrf::
SendInput, Здравствуйте, приобрести маску можно в магазине масок (на карте белая маска) | Приятной игры на Arizona V! ❤️
Return

:?:аштрафстоянка::
SendInput, Здравствуйте, штрафстоянка отображаеися голубым значком машины попавшей в аварию, одна находиться в LS под мостом, другая в Сенди-Шортс | Приятной игры на Arizona V! ❤️
Return
:?:finhfacnjzyrf::
SendInput, Здравствуйте, штрафстоянка отображаеися голубым значком машины попавшей в аварию, одна находиться в LS под мостом, другая в Сенди-Шортс | Приятной игры на Arizona V! ❤️
Return

:?:авопрос::
SendInput, Здравствуйте, уточните ваш вопрос | Приятной игры на Arizona V! ❤️
Return
:?:fdjghjc::
SendInput, Здравствуйте, уточните ваш вопрос | Приятной игры на Arizona V! ❤️
Return

:?:авб::
SendInput, Здравствуйте, ВБ можно получить устроившись в SANG и достигнув 7 ранга | Приятной игры на Arizona V! ❤️
Return
:?:fd,::
SendInput, Здравствуйте, ВБ можно получить устроившись в SANG и достигнув 7 ранга | Приятной игры на Arizona V! ❤️
Return









:?://::
SendInput, // %chkadmintag%
Return






; ==============================================================

:?:.пщещ::
Sleep, %chktextdelay%
Sendinput, `/goto `
Return
:?:.штм::
Sleep, %chktextdelay%
Sendinput, /inv{Enter}
Return
:?:.фвьшты::
Sleep, %chktextdelay%
Sendinput, /admins{Enter}
Return
:?:.пуеруку::
Sleep, %chktextdelay%
Sendinput, `/gethere `
Return
:?:.ыуерз::
Sleep, %chktextdelay%
Sendinput, `/sethp `
Return
:?:.ызсфк::
Sleep, %chktextdelay%
Sendinput, `/spcar `
Return
:?:.ашчсфк::
Sleep, %chktextdelay%
Sendinput, `/fixcar `
Return
:?:.пуерукумур::
Sleep, %chktextdelay%
Sendinput, `/gethereveh `
Return
:?:.зь::
Sleep, %chktextdelay%
Sendinput, `/pm `
Return

; ==============================================================

$~Pause::
SendInput, {vk54}
Sleep, %chktextdelay%
Sendinput, /getreport{Enter}
Return

$~!I::
SendInput, {vk54}
Sleep, %chktextdelay%
Sendinput, /inv{Enter}
Return

$~!Q::
SendInput, {vk54}	
Sleep, %chktextdelay%
Sendinput, `/goto `
Return

$~!E::
SendInput, {vk54}	
Sleep, %chktextdelay%
Sendinput, `/re `
Return