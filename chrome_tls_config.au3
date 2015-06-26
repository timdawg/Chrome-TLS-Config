#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Compression=2
#AutoIt3Wrapper_Icon=chrome_Secure.ico
#AutoIt3Wrapper_Res_Description=Google Chrome TLS Configuration
#AutoIt3Wrapper_Res_Language=1033

#include <GUIConstantsEx.au3>
#include <File.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <StringConstants.au3>
#Include <Constants.au3>
#Include <Misc.au3>

Const $script_name = 'Google Chrome TLS Configuration'

;#NoTrayIcon
#RequireAdmin
Opt("TrayAutoPause",0)
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode

; Options
	$ini_path = StringReplace(StringReplace(@ScriptFullPath, ".exe", ".ini"), ".au3", ".ini")
; End Options

; Init Variables
	Global $gui_ctrl = -1
	Global $aChromeShortcuts[1]
	$aChromeShortcuts[0]=0
	Global $tls_cipher_names[1]
	Global $tls_cipher_ids[1]
	$tls_cipher_names[0]=0
	$tls_cipher_ids[0]=0
	Global $tls_cipher_checkboxes[1]
	$tls_cipher_checkboxes[0]=0
; End Init Variables

; Load TLS ciphers into array
	AddTlsCipher('TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256', '0xc02b')
	AddTlsCipher('TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256', '0xc02f')
	AddTlsCipher('TLS_DHE_RSA_WITH_AES_128_GCM_SHA256', '0x009e')
	AddTlsCipher('TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256', '0xcc14')
	AddTlsCipher('TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256', '0xcc13')
	AddTlsCipher('TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256', '0xcc15')
	AddTlsCipher('TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA', '0xc00a')
	AddTlsCipher('TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA', '0xc014')
	AddTlsCipher('TLS_DHE_RSA_WITH_AES_256_CBC_SHA', '0x0039')
	AddTlsCipher('TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA', '0xc009')
	AddTlsCipher('TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA', '0xc013')
	AddTlsCipher('TLS_DHE_RSA_WITH_AES_128_CBC_SHA', '0x0033')
	AddTlsCipher('TLS_ECDHE_ECDSA_WITH_RC4_128_SHA', '0xc007')
	AddTlsCipher('TLS_ECDHE_RSA_WITH_RC4_128_SHA', '0xc011')
	AddTlsCipher('TLS_RSA_WITH_AES_128_GCM_SHA256', '0x009c')
	AddTlsCipher('TLS_RSA_WITH_AES_256_CBC_SHA', '0x0035')
	AddTlsCipher('TLS_RSA_WITH_AES_128_CBC_SHA', '0x002f')
	AddTlsCipher('TLS_RSA_WITH_RC4_128_SHA', '0x0005')
	AddTlsCipher('TLS_RSA_WITH_RC4_128_MD5', '0x0004')
	AddTlsCipher('TLS_RSA_WITH_3DES_EDE_CBC_SHA', '0x000a')
; End Load TLS ciphers into array

; Create GUI
$checkbox_spacing = 20
$ctrl_width = 360
$ctrl_height = 70 + ($tls_cipher_names[0] * $checkbox_spacing) ;380
$ctrl_left = (@DesktopWidth - $ctrl_width) / 2
$ctrl_top = (@DesktopHeight - $ctrl_height) / 2
$gui_ctrl = GUICreate($script_name, $ctrl_width, $ctrl_height, $ctrl_left, $ctrl_top, BitOr($WS_CAPTION, $WS_POPUP, $WS_SYSMENU)) ;, $WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked", $gui_ctrl)

; Title label
$label_title = GUICtrlCreateLabel("Select TLS cipher suites to disable in Google Chrome", 15, 10, 330)
GUICtrlSetFont($label_title, 8.5, 600)

; Add Checkboxes
$y = 30
PopulateCheckboxes(15, $y)

; Apply button
$y += 5
$btn_apply = GUICtrlCreateButton("Apply", 150, $y, 60, 30)
GUICtrlSetFont($btn_apply, 8.5, 600)
GUICtrlSetOnEvent($btn_apply, "btn_apply_Clicked")

; Show GUI
GUISetState(@SW_SHOW, $gui_ctrl)

; Loop - Do nothing (keep GUI up)
While 1
	Sleep(100)
WEnd

Func btn_apply_Clicked()
	; Hide GUI
	GUISetState(@SW_HIDE, $gui_ctrl)

	; Open Progress Dialog
	ProgressOn($script_name, 'Configuring TLS Cipher Suite Blacklist', 'Searching for Chrome shortcuts...', -1, -1, $DLG_NOTONTOP)

	; Check This User's Start Menu
	$aShortcuts1 = _FileListToArrayRec(@StartMenuDir, 'Google Chrome.lnk', 1, 1, 0, 2)
	MergeArray($aShortcuts1, $aChromeShortcuts)
	ProgressSet(20)
	Sleep(100)

	; Check This User's Desktop
	$aShortcuts2 = _FileListToArrayRec(@DesktopDir, 'Google Chrome.lnk', 1, 1, 0, 2)
	MergeArray($aShortcuts2, $aChromeShortcuts)
	ProgressSet(40)
	Sleep(100)

	; Check All Users Start Menu
	$aShortcuts3 = _FileListToArrayRec(@StartMenuCommonDir, 'Google Chrome.lnk', 1, 1, 0, 2)
	MergeArray($aShortcuts3, $aChromeShortcuts)
	ProgressSet(60)
	Sleep(100)

	; Check This User's Profile
	$aShortcuts4 = _FileListToArrayRec(@StartMenuCommonDir, 'Google Chrome.lnk', 1, 1, 0, 2)
	MergeArray($aShortcuts4, $aChromeShortcuts)
	ProgressSet(80)
	Sleep(100)

	; Check users directory (all user profiles)
	$users_dir = StringRegExpReplace(@UserProfileDir, '(.*)\\[^\\]*$', '$1')
	$aShortcuts5 = _FileListToArrayRec($users_dir, 'Google Chrome.lnk', 1, 1, 0, 2)
	MergeArray($aShortcuts5, $aChromeShortcuts)
	ProgressSet(100)
	Sleep(100)

	; Loop through checkboxes to get blacklist of cipher suite IDs
	$blacklist = ''
	For $i = 1 To $tls_cipher_names[0]
		; Check if checkbox is checked
		If GUICtrlRead($tls_cipher_checkboxes[$i]) = $GUI_CHECKED Then
			; Add comma before ID (but not to first ID)
			If $blacklist <> '' Then
				$blacklist &= ','
			EndIf
			; Add ID to list
			$blacklist &= $tls_cipher_ids[$i]
		EndIf
		; Save checkbox state to INI file
		IniWrite($ini_path, 'TLS_Ciphers', $tls_cipher_names[$i], _Iif(GUICtrlRead($tls_cipher_checkboxes[$i]) = $GUI_CHECKED, 1, 0))
	Next
	; Blacklist Argument
	$blacklist_arg = '--cipher-suite-blacklist=' & $blacklist

	ProgressSet(0, 'Updating Chrome shortcuts...')
	Sleep(100)

	For $i = 1 To $aChromeShortcuts[0]
		; Get Shortcut info
		$shortcut = FileGetShortcut($aChromeShortcuts[$i])
		;_ArrayDisplay($shortcut, $aChromeShortcuts[$i])

		; Get existing arguments (without the --cipher-suite-blacklist argument and trim extra spaces)
		$existing_args = StringStripWS(StringRegExpReplace($shortcut[2], '--cipher-suite-blacklist=[^ ]*', ''), $STR_STRIPALL)

		; Combine existing args with blacklist args
		$new_args = ''
		If $existing_args <> '' Then
			$new_args = $existing_args & ' '
		EndIf
		$new_args &= $blacklist_arg

		; Create Shortcut
		FileCreateShortcut($shortcut[0],$aChromeShortcuts[$i], $shortcut[1], $new_args, $shortcut[3], $shortcut[4], '', $shortcut[5], $shortcut[6])

		; Update Progress
		ProgressSet($i * 100 / $aChromeShortcuts[0])
		Sleep(100)
	Next
	; Close Progress Dialog
	ProgressOff()
	; Completed MsgBox Dialog
	MsgBox($MB_ICONINFORMATION+$MB_OK, $script_name, 'TLS cipher suite blacklist successfully updated for all shortcuts!')

	; Show GUI
	GUISetState(@SW_SHOW, $gui_ctrl)
EndFunc

; Populates checkboxes for each TLS cipher in the array
Func PopulateCheckboxes($x, ByRef $y)
	For $i = 1 To $tls_cipher_names[0]
		; Create Checkbox and add it to an array
		_ArrayAdd($tls_cipher_checkboxes, GUICtrlCreateCheckbox($tls_cipher_names[$i], $x, $y))
		$tls_cipher_checkboxes[0] += 1
		; Add spacing for next item
		$y += $checkbox_spacing

		; Read checkbox state from INI file
		If Number(IniRead($ini_path, 'TLS_Ciphers', $tls_cipher_names[$i], '0')) > 0 Then
			GUICtrlSetState($tls_cipher_checkboxes[$tls_cipher_checkboxes[0]], $GUI_CHECKED)
		Else
			GUICtrlSetState($tls_cipher_checkboxes[$tls_cipher_checkboxes[0]], $GUI_UNCHECKED)
		EndIf
	Next
EndFunc

; Adds TLS cipher name and ID to arrays
Func AddTlsCipher($cipher_id, $cipher_name)
	_ArrayAdd($tls_cipher_names, $cipher_id)
	_ArrayAdd($tls_cipher_ids, $cipher_name)
	$tls_cipher_names[0] += 1
	$tls_cipher_ids[0] += 1
EndFunc

; Merges data from the source array into the destination array
Func MergeArray(ByRef $src_array, ByRef $dest_array)
	; Make sure $src_array is an array
	If IsArray($src_array) Then
		; Make sure $src_array has items
		If $src_array[0] > 0 Then
			; Loop through array items
			For $x = 1 To $src_array[0]
				; Make sure it doesn't already exist in the destination array
				If _ArraySearch($dest_array, $src_array[$x], 1) < 0 Then
					; Add to array
					_ArrayAdd($dest_array, $src_array[$x])
					; Increment array count
					$dest_array[0] += 1
				EndIf
			Next
		EndIf
	EndIf
EndFunc

Func CLOSEClicked()
	Exit
EndFunc

