; MouseMediaGestures.ahk
; AutoHotKey script that maps mouse side buttons with gesture controls to allow for better media controls
    ; Press and release bottom mouse side button - Play/Pause
    ; Press and hold bottom mouse side button & drag mouse UP, then release - Volume Up
    ; Press and hold bottom mouse side button & drag mouse DOWN, then release - Volume Down
    ; Press and hold bottom mouse side button & drag mouse RIGHT, then release - Next Track
    ; Press and hold bottom mouse side button & drag mouse LEFT, then release - Previous Track
    ; Press and release top mouse side button - Windows Task View
    

CoordMode, Mouse, Screen ;sets coordinate mode for MouseMove/Click/Drag to be relative to the desktop (entire screen)

MouseMoveStartDistanceX := 400 ;the amount of pixels your cursor needs to move horizontally to start the action
MouseMoveStartDistanceY := 5 ;the amount of pixels your cursor needs to move vertically to start the action
KeyIsPressed := 0
count := 0

XButton1:: ;register that bottom mouse side button has been clicked in and is being held (so long as KeyIsPressed=1)
    KeyIsPressed := 1
    MouseGetPos, MouseStartPositionX, MouseStartPositionY
    while (KeyIsPressed = 1)
    {
        MouseGetPos, MouseCurrentPositionX, MouseCurrentPositionY
        MouseMoveCurrentDistanceX := MouseStartPositionX - MouseCurrentPositionX
        if ((MouseMoveCurrentDistanceX) < (-1 * MouseMoveStartDistanceX)) ;button held down and mouse moved right
        {
            Send {Media_Next}
            MouseStartPositionX := MouseCurrentPositionX
	        KeyIsPressed := 0 ;this line makes track skips incremental (must perform gesture again for each skip)
            count++
        }
        if ((MouseMoveCurrentDistanceX) > (MouseMoveStartDistanceX)) ;button held down and mouse moved left
        {
            Send {Media_Prev}
            MouseStartPositionX := MouseCurrentPositionX
	        KeyIsPressed := 0 ;this line makes track skips incremental (must perform gesture again for each skip)
            count++   
        }
	    MouseMoveCurrentDistanceY := MouseStartPositionY - MouseCurrentPositionY
        if ((MouseMoveCurrentDistanceY) < (-1 * MouseMoveStartDistanceY)) ;button held down and mouse moved down
        {
            Send {Volume_Down}
            MouseStartPositionY := MouseCurrentPositionY
            count++
        }
        if ((MouseMoveCurrentDistanceY) > (MouseMoveStartDistanceY)) ;button held down and mouse moved up
        {
            Send {Volume_Up}
            MouseStartPositionY := MouseCurrentPositionY
            count++
        }
    }
return

XButton1 UP:: ;fires whenever bottom mouse side button has been simply released (no gestures)
    KeyIsPressed := 0 ;resets KeyIsPressed to await another trigger action
    if (count = 0) ;this is what "ignores" button releases unless no gesture trigger has been fired. Mouse must be still for this to fire.
    {
        Send {Media_Play_Pause}
    }
    count := 0
return

XButton2::send #{tab} ;activates Windows Task View on top mouse side button press
