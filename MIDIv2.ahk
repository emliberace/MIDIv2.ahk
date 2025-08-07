;MIDIv2.ahk v1.1
class MIDIv2 {
	_h_MIDI_OUT := {}
	_h_MIDI_OUT.ptr := 0
	_h_MIDI_IN := {}
	_h_MIDI_IN.ptr := 0
	_midiInChannelFilter := -1
	_midiOutChannel := 0
	_MIDIHDR2 := 0
	_midiThrough := False
	_dummyGui := Gui()
	_callbPrefix := "MidiIn"
	_mmcDeviceId := "7F"
	_frameRateCode := 0
	_mmcEnabled := False
	_tcEnabled := False
	_srtEnabled := False
	_rpnEnabled := False
	_nrpnEnabled := False
	_pnStruct := {
		param: 0,
		value: 0,
		paramsSet: 0,
		valuesSet: 0
	}
	_RPN := []
	_NRPN := []
	_RPNNRPN_LastParam := []
	
	__New() {
		OutputDebug "New MIDIv2 instance created"
		
		this._callbackShort := ObjBindMethod(this, "_midiInCallback")
		this._callbackLong := ObjBindMethod(this, "_midiInSysExCallback")
		this._callbackMore := ObjBindMethod(this, "_midiInMoreData")
		this._callbackError := ObjBindMethod(this, "_midiInError")
		this._callbackLongError := ObjBindMethod(this, "_midiInLongError")
		
		this._dummyGui.Opt("+LastFound")
		this._hWnd := WinExist()
		
		; Initialize RPN/NRPN data structures
		Loop 16 {
			this._RPN.Push(this._pnStruct.Clone())
			this._NRPN.Push(this._pnStruct.Clone())
			this._RPNNRPN_LastParam.Push("")
		}
		
		buffer_size := 64000   ; Up to 64k
		this._midiInBuffer := Buffer(buffer_size)
		this._MIDIHDR2 := Buffer(12 * A_PtrSize)
		NumPut("Ptr", this._midiInBuffer.Ptr, this._MIDIHDR2, 0)
		NumPut("UInt", buffer_size, this._MIDIHDR2, A_PtrSize)
		NumPut("UInt", 0, this._MIDIHDR2, 2 * A_PtrSize)	; dwBytesRecorded
		NumPut("Ptr", 0, this._MIDIHDR2, 3 * A_PtrSize)		; dwUser
		NumPut("UInt", 0, this._MIDIHDR2, 4 * A_PtrSize)	; dwFlags
		NumPut("Ptr", 0, this._MIDIHDR2, 5 * A_PtrSize)		; lpNext
		NumPut("Ptr", 0, this._MIDIHDR2, 6 * A_PtrSize)		; reserved
		
		DllCall("LoadLibrary", "Str", "winmm.dll", "Ptr")			
	}
	
	InputChannel {
		get {
			return this._midiInChannelFilter + 1
		}
		set {
			if value >= 0 && value <= 16
				this._midiInChannelFilter := value - 1
		}
	}
	
	OutputChannel {
		get {
			return this._midiOutChannel + 1
		}
		set {
			if value >= 1 && value <= 16
				this._midiOutChannel := value - 1
		}
	}
	
	MidiThrough {
		get {
			return this._midiThrough
		}
		set {
			if value > 0 {
				if this._h_MIDI_OUT.ptr != 0 && this._h_MIDI_IN.ptr != 0
					this._midiThrough := True
				else if this._h_MIDI_OUT.ptr = 0
					MsgBox("Please open a MIDI Output port before enabling MIDI Through", "MIDIv2 - MidiThrough", "48")
				else if this._h_MIDI_IN.ptr = 0
					MsgBox("Please open a MIDI Input port before enabling MIDI Through", "MIDIv2 - MidiThrough", "48")
			}
			else if value = False {
				this._midiThrough := False
			}
		}
	}
	
	CallbackPrefix {
		get {
			return this._callbPrefix
		}
		set {
			this._callbPrefix := value
		}
	}
	
	MMC_Enabled {
		get {
			return this._mmcEnabled
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "MIDIv2 - MMC_enabled", "48")
				return
			}
			this._mmcEnabled := (value > 0) ? 1 : 0
		}
	}
	
	MMC_DeviceID {
		get {
			return Number("0x" this._mmcDeviceId)
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "MIDIv2 - MMC_deviceID", "48")
				return
			}
			this._mmcDeviceId := Format("{:02X}", value)
		}
	}
	
	TC_Enabled {
		get {
			return this._tcEnabled
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "MIDIv2 - TC_enabled", "48")
				return
			}
			this._tcEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	SRT_Enabled {
		get {
			return this._srtEnabled
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "MIDIv2 - SRT_Enabled", "48")
				return
			}
			this._srtEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	RPN_Enabled {
		get {
			return this._rpnEnabled
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "MIDIv2 - RPN_Enabled", "48")
				return
			}
			this._rpnEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	NRPN_Enabled {
		get {
			return this._nrpnEnabled
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "NRPN_Enabled", "48")
				return
			}
			this._nrpnEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	RunningStatus_Enabled {
		get {
			return this._runningStatusEnabled
		}
		set {
			if Type(value) != "Integer" {
				MsgBox("Invalid parameter!", "RunningStatus_Enabled", "48")
				return
			}
			this._runningStatusEnabled := (value > 0) ? 1 : 0
		}
	}
	
	GetMidiInDevices() {
		midiDevices := []
		deviceCount := DllCall("winmm.dll\midiInGetNumDevs", "UInt")
		MIDI_DEVICE_STRUCT_LENGTH := 44

		Loop deviceCount {
			deviceNumber := A_Index - 1
			midiStruct := Buffer(MIDI_DEVICE_STRUCT_LENGTH, 0)
			result := DllCall("winmm.dll\midiInGetDevCapsA", "UInt", deviceNumber, "Ptr", midiStruct.Ptr, "UInt", MIDI_DEVICE_STRUCT_LENGTH, "UInt")

			if result != 0 {
				MsgBox("Failed to query MIDI in device.`nDevice number=" deviceNumber, "MIDIv2 - GetMidiInDevices", "48")
				return []
			}

			deviceName := StrGet(midiStruct.Ptr + 8, "CP0")
			midiDevices.Push(deviceName)
		 }
		return midiDevices
	}
	
	GetMidiOutDevices() {
		midiDevices := []
		deviceCount := DllCall("winmm.dll\midiOutGetNumDevs", "UInt")
		MIDI_DEVICE_STRUCT_LENGTH := 44

		Loop deviceCount {
			deviceNumber := A_Index - 1
			midiStruct := Buffer(MIDI_DEVICE_STRUCT_LENGTH, 0)
			result := DllCall("winmm.dll\midiOutGetDevCapsA", "UInt", deviceNumber, "Ptr", midiStruct.Ptr, "UInt", MIDI_DEVICE_STRUCT_LENGTH, "UInt")

			if result != 0 {
				MsgBox("Failed to query MIDI out device.`nDevice number=" deviceNumber, "MIDIv2 - GetMidiOutDevices", "48")
				return []
			}

			deviceName := StrGet(midiStruct.Ptr + 8, "CP0")
			midiDevices.Push(deviceName)
		}

		return midiDevices
	}
	
	OpenMidiOut(devID) {
		result := DllCall("winmm.dll\midiOutOpen", "Ptr*", this._h_MIDI_OUT, "UInt", devID, "Ptr", 0, "Ptr", 0, "UInt", 0)
		if result != 0
			MsgBox("There was an error opening the MIDI Out port with ID=" devID "`nError code: " result, "MIDIv2 - OpenMidiOut", "48")
	}
	
	CloseMidiOut() {
		if this._h_MIDI_OUT.ptr == 0
			return
		
		result := DllCall("winmm.dll\midiOutReset", "UInt", this._h_MIDI_OUT.ptr)
		if result != 0 {
			MsgBox("There was an Error resetting the MIDI Out port.`nError code: " result "This application will now close!", "MIDIv2 - CloseMidiOut", "16")
			ExitApp
		}
		
		result := DllCall("winmm.dll\midiOutClose", "UInt", this._h_MIDI_OUT.ptr)
		if result != 0 {
			MsgBox("There was an Error closing the MIDI Out port.`nError code: " result "This application will now close!", "MIDIv2 - CloseMidiOut", "16")
			ExitApp
		}
		this._h_MIDI_OUT.ptr := 0
	}
	
	SendNoteOff(noteValue, velocity:=64, channel:=-1)	{
		if (noteValue < 0 || noteValue > 127) || (velocity < 0 || velocity > 127) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel:=this._midiOutChannel
		} else {
			channel--
		}		
		this._midiOutShortMsg(((velocity & 0xff) << 16) | ((noteValue & 0xff) << 8) | (channel | 0x80))
	}
	
	SendNoteOn(noteValue, velocity:=127, channel:=-1) {
		if (noteValue < 0 || noteValue > 127) || (velocity < 0 || velocity > 127) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		this._midiOutShortMsg(((velocity & 0xff) << 16 ) | ((noteValue & 0xff) << 8) | (channel | 0x90))
	}
	
	SendPolyPressure(noteValue, value, channel:=-1) {
		if (noteValue < 0 || noteValue > 127) || (value < 0 || value > 127) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {			
			channel--
		}
		this._midiOutShortMsg(((value & 0xff) << 16 ) | ((noteValue & 0xff) << 8) | (channel | 0xA0))
	}
	
	SendControlChange(controller, value, channel := -1) {
		if (controller < 0 || controller > 127) || (value < 0 || value > 127) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		this._midiOutShortMsg(((value & 0xff) << 16) | ((controller & 0xff) << 8) | (channel | 0xB0))
	}
	
	SendControlChangePair(controller, value, channel := -1) {
		if (controller < 0 || controller > 31) || (value < 0 || value > 16383) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		valueMSB := (value >> 7) & 0x7F
		valueLSB := value & 0x7F
		controllerLSB := controller + 32
		this._midiOutShortMsg((valueMSB << 16) | (controller << 8) | (channel | 0xB0))
		this._midiOutShortMsg((valueLSB << 16) | (controllerLSB << 8) | (channel | 0xB0))
	}
	
	SendProgramChange(program, channel := -1) {
		if (program < 0 || program > 127) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		this._midiOutShortMsg(((program & 0xff) << 8) | (channel | 0xC0))
	}
	
	SendAftertouch(value, channel := -1) {
		if (value < 0 || value > 127) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		this._midiOutShortMsg(((value & 0xff) << 8) | (channel | 0xD0))
	}
	
	SendPitchbend(value, channel := -1) {
		if (value < 0 || value > 16383) || (channel != -1 && (channel < 1 || channel > 16))
			return
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		this._midiOutShortMsg((((value >> 7) & 0x7F) << 16) | ((value & 0x7F) << 8) | (channel | 0xE0))
	}
	
	SendRPN(parameter, value, channel := -1) {
		if (parameter < 0 || parameter > 16383) || (value < 0 || value > 16383) || (channel != -1 && (channel < 1 || channel > 16)) {
			MsgBox("Invalid parameter!", "MIDIv2 - SendRPN", "48")
			return
		}
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		paramMSB := (parameter >> 7) & 0x7F
		paramLSB := parameter & 0x7F
		valueMSB := (value >> 7) & 0x7F
		valueLSB := value & 0x7F
		this._midiOutShortMsg((paramMSB << 16) | (0x65 << 8) | (channel | 0xB0))
		this._midiOutShortMsg((paramLSB << 16) | (0x64 << 8) | (channel | 0xB0))
		this._midiOutShortMsg((valueMSB << 16) | (0x06 << 8) | (channel | 0xB0))
		this._midiOutShortMsg((valueLSB << 16) | (0x26 << 8) | (channel | 0xB0))
	}
	
	SendNRPN(parameter, value, channel := -1) {
		if (parameter < 0 || parameter > 16383) || (value < 0 || value > 16383) || (channel != -1 && (channel < 1 || channel > 16)) {
			MsgBox("Invalid parameter!", "MIDIv2 - SendNRPN", "48")
			return
		}
		if channel == -1 {
			channel := this._midiOutChannel
		} else {
			channel--
		}
		paramMSB := (parameter >> 7) & 0x7F
		paramLSB := parameter & 0x7F
		valueMSB := (value >> 7) & 0x7F
		valueLSB := value & 0x7F
		this._midiOutShortMsg((paramMSB << 16) | (0x63 << 8) | (channel | 0xB0))
		this._midiOutShortMsg((paramLSB << 16) | (0x62 << 8) | (channel | 0xB0))
		this._midiOutShortMsg((valueMSB << 16) | (0x06 << 8) | (channel | 0xB0))
		this._midiOutShortMsg((valueLSB << 16) | (0x26 << 8) | (channel | 0xB0))
	}
	
	; MMC +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	MMC_Stop() {
		msg := "F0 7F " this._mmcDeviceId " 06 01 F7"
		this.sendSysEx(msg)
	}
	
	MMC_Play() {
		msg := "F0 7F " this._mmcDeviceId " 06 02 F7"
		this.sendSysEx(msg)
	}
	
	MMC_DPlay() {
		msg := "F0 7F " this._mmcDeviceId " 06 03 F7"
		this.sendSysEx(msg)
	}
	
	MMC_FF() {
		msg := "F0 7F " this._mmcDeviceId " 06 04 F7"
		this.sendSysEx(msg)
	}
	
	MMC_Rewind() {
		msg := "F0 7F " this._mmcDeviceId " 06 05 F7"
		this.sendSysEx(msg)
	}
	
	MMC_Record() {
		msg := "F0 7F " this._mmcDeviceId " 06 06 F7"
		this.sendSysEx(msg)
	}
	
	MMC_RecordExit() {
		msg := "F0 7F " this._mmcDeviceId " 06 07 F7"
		this.sendSysEx(msg)
	}
	
	MMC_RecordPause() {
		msg := "F0 7F " this._mmcDeviceId " 06 08 F7"
		this.sendSysEx(msg)
	}
	
	MMC_Pause() {
		msg := "F0 7F " this._mmcDeviceId " 06 09 F7"
		this.sendSysEx(msg)
	}
	
	MMC_Locate(timeCode) {
		switch Type(timeCode) {
			case "String":
				try {
					arrV := StrSplit(timeCode, ":")
				} catch {
					MsgBox("MMC_TimeCode - Incorrect String format`nFailed to create Array", "MIDIv2 - MMC_Locate", "48")
					return
				}
				if arrV.Length != 4 {
					MsgBox("MMC_TimeCode - Incorrect String format`nIncorrect number of elements", "MIDIv2 - MMC_Locate", "48")
					return
				}					
			case "Array":
				if timeCode.Length != 4 {
					MsgBox("MMC_TimeCode - Incorrect Array length", "MIDIv2 - MMC_Locate", "48")
					return
				}
				arrV := timeCode
		}
		h := Format("{:02X}", (arrV[1] | (this._frameRateCode << 5)))
		m := Format("{:02X}", arrV[2])
		s := Format("{:02X}", arrV[3])
		f := Format("{:02X}", arrV[4])
		msg := "F0 7F " this._mmcDeviceId " 06 44 06 01 " h " " m " " s " " f " 03 F7"
		this.sendSysEx(msg)
	}
	
	MMC_RequestTimeCode() {
		msg := "F0 7F 7F 06 42 01 01 F7"
		this.sendSysEx(msg)
	}
	
	; SRT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SRT_TimingClock() {
		this.sendSysEx("F8")
	}
	
	SRT_Start() {
		this.sendSysEx("FA")
	}
	
	SRT_Continue() {
		this.sendSysEx("FB")
	}
	
	SRT_Stop() {
		this.sendSysEx("FC")
	}
	
	SRT_ActiveSensing() {
		this.sendSysEx("FE")
	}
	
	SRT_SystemReset() {
		this.sendSysEx("FF")
	}
	
	; SysEx +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   SendSysEx(sysexString) {
      ; Convert the string to a buffer
      sysexArray := StrSplit(sysexString, " ")
      bufferSize := sysexArray.Length
      sysExBuffer := Buffer(bufferSize)
      
      Loop bufferSize {
         NumPut("UChar", "0x" sysexArray[A_Index], sysExBuffer, A_Index - 1)
      }

      ; Prepare the MIDIHDR structure
      MIDIHDR := Buffer(12 * A_PtrSize)
      NumPut("Ptr", sysExBuffer.ptr, MIDIHDR, 0)
      NumPut("UInt", bufferSize, MIDIHDR, A_PtrSize)
      NumPut("UInt", 0, MIDIHDR, 2 * A_PtrSize)  ; dwBytesRecorded
      NumPut("Ptr", 0, MIDIHDR, 3 * A_PtrSize)  ; dwUser
      NumPut("UInt", 0, MIDIHDR, 4 * A_PtrSize)  ; dwFlags
      NumPut("Ptr", 0, MIDIHDR, 5 * A_PtrSize)  ; lpNext
      NumPut("Ptr", 0, MIDIHDR, 6 * A_PtrSize)  ; reserved

      ; Prepare SysEx header
      result := DllCall("winmm.dll\midiOutPrepareHeader", "Ptr", this._h_MIDI_OUT, "Ptr", MIDIHDR, "UInt", 12 * A_PtrSize)
      if result != 0 {
         MsgBox("There was an error preparing the system-exclusive message header `nresult = " result, "MIDIv2 - SendSysEx", "48")
         return
      }
      ; Send the SysEx message
      result := DllCall("winmm.dll\midiOutLongMsg", "Ptr", this._h_MIDI_OUT, "Ptr", MIDIHDR, "UInt", 12 * A_PtrSize)
      if result != 0 {
         MsgBox("There was an error sending the system-exclusive message `nresult = " result, "MIDIv2 - SendSysEx", "48")
         return
      }
      ; Unprepare the header after sending the message
      result := DllCall("winmm.dll\midiOutUnprepareHeader", "Ptr", this._h_MIDI_OUT, "Ptr", MIDIHDR, "UInt", 12 * A_PtrSize)
      if result != 0 {
         MsgBox("There was an error unpreparing the system-exclusive message header `nresult = " result, "MIDIv2 - SendSysEx", "48")
      }
   }
	
	; SysEx utlility functions ++++++++++++++++++++++++++++++++++++++++++++++
	ArrayHexToSysEx(arr) {
		if Type(arr) != "Array" {
			MsgBox("Invalid parameter: " Type(arr), "MIDIv2 - ArrayHexToSysEx", "48")
			return ""
		}
		s := ""
		For _, val in arr {
			s .= val " "
		}
		return SubStr(s, 1, -1)
	}
	
	ArrayDecToSysEx(arr) {
		if Type(arr) != "Array" {
			MsgBox("Invalid parameter: " Type(arr), "MIDIv2 - ArrayDecToSysEx", "48")
			return ""
		}
		s := ""
		For _, val in arr {
			s .= Format("{:02X}", val) " "
		}
		return SubStr(s, 1, -1)
	}
	
	TextToSysEx(str) {
		if Type(str) != "String" {
			MsgBox("Invalid parameter: " Type(str), "MIDIv2 - TextToSysEx", "48")
			return ""
		}
		s := ""
		Loop Parse str {
			charValue := Ord(A_LoopField)
			if charValue > 127 {
				MsgBox("ASCII value limit exceeded`nSpecifically: " A_LoopField, "MIDIv2 - TextToSysEx", "48")
				return ""
			}
			s .= Format("{:02X} ", Ord(A_LoopField) " ")
		}
		return SubStr(s, 1, -1)
	}
	
	SysExToText(sysEx) {
		if Type(sysEx) != "String" {
			MsgBox("Invalid parameter: " Type(sysEx), "MIDIv2 - SysExToText", "48")
			return ""
		}
		arr := StrSplit(sysEx, " ")
		if arr.Length < 1
			return ""
		
		s := ""
		for _, hex in arr {
			if StrLower(hex) != "f0" && StrLower(hex) != "f7" {
				s .= Chr("0x" hex)
			}
		}
		return s
	}
	
	_midiOutShortMsg(msg) {
		if this._h_MIDI_OUT.ptr == 0 {
			MsgBox("Sending MIDI failed!`nNo MIDI Out port opened", "MIDIv2", "48")
			return
		}
		
		result := DllCall("winmm.dll\midiOutShortMsg", "Ptr", this._h_MIDI_OUT.ptr, "UInt", msg)
		if result != 0 || (A_LastError != 0 && A_LastError != 997) {
			MsgBox("Error sending `"midiOutShortMsg`".`nresult=" result, "MIDIv2", "48")
			return
		}
	}
	
	; MIDI In +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	OpenMidiIn(devID)	{	
		result := DllCall("winmm.dll\midiInOpen", "Ptr*", this._h_MIDI_IN, "UInt", devID, "Ptr", this._hWnd, "UInt", 0, "UInt", 0x10000)  ; MIDI_CALLBACK_WINDOW
		if result != 0 {
			MsgBox("There was an error opening the MIDI In port `nresult = " result "`nThis application will now close!", "MIDIv2 - OpenMidiIn", "16")
			ExitApp
		}

		result := DllCall("winmm.dll\midiInStart", "Ptr", this._h_MIDI_IN)
		if result != 0 {
			MsgBox("There was an error starting the MIDI In port  `nresult = " result "`nThis application will now close!", "MIDIv2 - OpenMidiIn", "16")
			ExitApp
		}

		result := DllCall("winmm.dll\midiInPrepareHeader", "Ptr", this._h_MIDI_IN, "Ptr", this._MIDIHDR2, "UInt", 12 * A_PtrSize)
		if result != 0 {
			MsgBox("There was an error preparing a MIDI In header `nresult = " result "`nThis application will now close!", "MIDIv2 - OpenMidiIn", "16")
			ExitApp
		}

		result := DllCall("winmm.dll\midiInAddBuffer", "Ptr", this._h_MIDI_IN, "Ptr", this._MIDIHDR2, "UInt", 12 * A_PtrSize)
		if result != 0 {
			MsgBox("There was an error adding a MIDI In buffer `nresult = " result "`nThis application will now close!", "MIDIv2 - OpenMidiIn", "16")
			ExitApp
		}

		; MIDI event types
		MIDI_OPEN := 0x3C1
		MIDI_CLOSE := 0x3C2
		MIDI_DATA := 0x3C3
		MIDI_LONGDATA := 0x3C4
		MIDI_ERROR := 0x3C5
		MIDI_LONGERROR := 0x3C6
		MIDI_MOREDATA := 0x3CC
		
		; Register callbacks
		OnMessage MIDI_DATA, this._callbackShort
		OnMessage MIDI_LONGDATA, this._callbackLong
		OnMessage MIDI_MOREDATA, this._callbackMore
		OnMessage MIDI_ERROR, this._callbackError
		OnMessage MIDI_LONGERROR, this._callbackLongError
	}
	
	CloseMidiIn() {
		if this._h_MIDI_IN.ptr == 0
			return
		result := DllCall("winmm.dll\midiInStop", "Ptr", this._h_MIDI_IN)
		if result != 0 {
			MsgBox("There was an error stopping the MIDI In port `nresult = " result "`nThis application will now close!", "MIDIv2 - CloseMidiIn", "16")
			ExitApp
		}
		result := DllCall("winmm.dll\midiInReset", "Ptr", this._h_MIDI_IN)
		if result != 0 {
			MsgBox("There was an error resetting the MIDI In port `nresult = " result "`nThis application will now close!", "MIDIv2 - CloseMidiIn", "16")
			ExitApp
		}
		result := DllCall("winmm.dll\midiInClose", "Ptr", this._h_MIDI_IN)
		if result != 0 {
			MsgBox("There was an Error closing the MIDI In port.`nError code: " result "`nThis application will now close!", "MIDIv2 - CloseMidiIn", "48")
			return
		}
		this._h_MIDI_IN.ptr := 0
	}
	
	_midiInCallback(wParam, lParam, msg, hwnd) {
		if this._h_MIDI_IN.ptr == 0 {
			return
		}
		
		midiEvent := {}
		midiEvent.EventType := ""		
		callbackFunctions := []
		noArg := False
		static mtc_fr
		static mtc_h
		static mtc_m
		static mtc_s
		static mtc_f

		highByte := lParam & 0xF0 
		lowByte := lParam & 0x0F  ; MIDI channel / SRT Commands
		data1 := (lParam >> 8) & 0xFF
		data2 := (lParam >> 16) & 0xFF
		ch := lowByte + 1

		if this._midiThrough && highByte < 0xF0 {
			this._midiOutShortMsg(lParam)
		}
		
		if this._midiInChannelFilter != -1 && lowByte != this._midiInChannelFilter {
			return
		}
		
		
		switch highByte {
			case 0x80:
				midiEvent.EventType := "NoteOff"
				midiEvent.Channel := ch
				midiEvent.NoteNumber := data1
				midiEvent.Velocity := data2
				callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.NoteNumber))
			case 0x90:
				midiEvent.EventType := "NoteOn"
				midiEvent.Channel := ch
				midiEvent.NoteNumber := data1
				midiEvent.Velocity := data2
				callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.NoteNumber))
			case 0xA0:
				midiEvent.EventType := "PolyPressure"
				midiEvent.Channel := ch
				midiEvent.NoteNumber := data1
				midiEvent.Pressure := data2
				callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.NoteNumber))
			case 0xB0:
				; RPN Parameter
				if this._rpnEnabled && (data1 = 0x64 || data1 = 0x65) {
					if this._RPN[ch].paramsSet = 2 || this._RPN[ch].paramsSet = 0 {
						this._RPN[ch].paramsSet := 1
						this._RPN[ch].param := 0
						this._RPN[ch].valuesSet := 0
					} else if this._RPN[ch].paramsSet = 1 {
						this._RPN[ch].paramsSet := 2
					}
					this._RPNNRPN_LastParam[ch] := "RPN"
					switch data1 {
						case 0x64:
							this._RPN[ch].param |= data2	; Parameter LSB
						case 0x65:
							this._RPN[ch].param |= (data2 << 7)	; Parameter MSB
					}
				; NRPN Parameter
				} else if this._nrpnEnabled && (data1 = 0x62 || data1 = 0x63) {
					if this._NRPN[ch].paramsSet = 2 || this._NRPN[ch].paramsSet = 0 {
						this._NRPN[ch].paramsSet := 1
						this._NRPN[ch].param := 0
						this._NRPN[ch].valuesSet := 0
					} else if this._NRPN[ch].paramsSet = 1 {
						this._NRPN[ch].paramsSet := 2
					}
					this._RPNNRPN_LastParam[ch] := "NRPN"
					switch data1 {
						case 0x62:
							this._NRPN[ch].param |= data2	; Parameter LSB
						case 0x63:
							this._NRPN[ch].param |= (data2 << 7)	; Parameter MSB
					}
				; RPN Value
				} else if this._rpnEnabled && this._RPNNRPN_LastParam[ch] = "RPN" && (data1 = 0x06 || data1 = 0x26) {
					if this._RPN[ch].valuesSet = 2 || this._RPN[ch].valuesSet = 0 {
						this._RPN[ch].valuesSet := 1
						this._RPN[ch].value := 0
					} else if this._RPN[ch].valuesSet = 1 {
						this._RPN[ch].valuesSet := 2
					}
					switch data1 {
						case 0x06:
							this._RPN[ch].value |= (data2 << 7)	; Value MSB
						case 0x26:
							this._RPN[ch].value |= data2	; Value LSB
					}
					; RPN Complete
					if this._RPN[ch].paramsSet = 2 && this._RPN[ch].valuesSet = 2 {
						midiEvent.EventType := "RPN"
						midiEvent.Parameter := this._RPN[ch].param
						midiEvent.Value := this._RPN[ch].value
						midiEvent.Channel := ch
						callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.Parameter))
					}
				; NRPN Value
				} else if this._nrpnEnabled && this._RPNNRPN_LastParam[ch] = "NRPN" && (data1 = 0x06 || data1 = 0x26) {
					if this._NRPN[ch].valuesSet = 2 || this._NRPN[ch].valuesSet = 0 {
						this._NRPN[ch].valuesSet := 1
						this._NRPN[ch].value := 0
					} else if this._NRPN[ch].valuesSet = 1 {
						this._NRPN[ch].valuesSet := 2
					}
					switch data1 {
						case 0x06:
							this._NRPN[ch].value |= (data2 << 7)	; Value MSB
						case 0x26:
							this._NRPN[ch].value |= data2	; Value LSB
					}
					; NRPN Complete
					if this._NRPN[ch].paramsSet = 2 && this._NRPN[ch].valuesSet = 2 {
						midiEvent.EventType := "NRPN"
						midiEvent.Parameter := this._NRPN[ch].param
						midiEvent.Value := this._NRPN[ch].value
						midiEvent.Channel := ch
						callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.Parameter))
					}
				; CC Message
				} else {
					midiEvent.EventType := "ControlChange"
					midiEvent.Channel := ch
					midiEvent.Controller := data1
					midiEvent.Value := data2
					callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.Controller))
				}
			case 0xC0:
				midiEvent.EventType := "ProgramChange"
				midiEvent.Channel := ch
				midiEvent.Program := data1
				callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.Program))
			case 0xD0:
				midiEvent.EventType := "Aftertouch"
				midiEvent.Channel := ch
				midiEvent.Pressure := data1
			case 0xE0:
				midiEvent.EventType := "PitchBend"
				midiEvent.Channel := ch
				midiEvent.PitchBend := (data2 << 7) + data1
			case 0xF0:
				if this._tcEnabled {
					if lowbyte = 0x1 {
						piece := (data1 & 0xF0) >> 4
						switch piece {
							case 0:
								mtc_f := data1 & 0x0F
							case 1:
								mtc_f += (data1 & 0x0F) << 4
							case 2:
								mtc_s := data1 & 0x0F
							case 3:
								mtc_s += (data1 & 0x0F) << 4
							case 4:
								mtc_m := data1 & 0x0F
							case 5:
								mtc_m += (data1 & 0x0F) << 4
							case 6:
								mtc_h := data1 & 0x0F
							case 7:
								mtc_h += (data1 & 0x01) << 4
								mtc_fr := (data1 & 0x06) >> 1
								midiEvent.Hours := mtc_h
								midiEvent.Minutes := mtc_m
								midiEvent.Seconds := mtc_s
								midiEvent.Frames := mtc_f
								midiEvent.FrameRateCode := mtc_fr
								this._frameRateCode := mtc_fr
								frameRates := [24.0, 25.0, 29.97, 30.0]
								midiEvent.FrameRate := frameRates[mtc_fr + 1]
								midiEvent.EventType := "TC_RunningFull"
						}
					}
				}
				if this._srtEnabled {
					switch lowByte {
						case 0x8:
							; Timing Clock
							callbackFunctions.Push(Format("{}{}", this._callbPrefix, "SRT_TimingClock"))
							noArg := True
						case 0xA:
							; Start
							callbackFunctions.Push(Format("{}{}", this._callbPrefix, "SRT_Start"))
							noArg := True
						case 0xB:
							; Continue
							callbackFunctions.Push(Format("{}{}", this._callbPrefix, "SRT_Continue"))
							noArg := True
						case 0xC:
							; Stop
							callbackFunctions.Push(Format("{}{}", this._callbPrefix, "SRT_Stop"))
							noArg := True
						case 0xE:
							; Active Sensing
							callbackFunctions.Push(Format("{}{}", this._callbPrefix, "SRT_ActiveSensing"))
							noArg := True
						case 0xF:
							; System Reset
							callbackFunctions.Push(Format("{}{}", this._callbPrefix, "SRT_SystemReset"))
							noArg := True
					}
				}
		}
		
		if midiEvent.EventType != ""
			callbackFunctions.Push(Format("{}{}", this._callbPrefix, midiEvent.EventType))  ; Add a callback for the event type. E.g. "NoteOn", "ControlChange".

		 ; Try calling all event functions
		for _, funcName in callbackFunctions {
			try {
				if noArg {
					%funcName%()
				} else {
					%funcName%(midiEvent)
				}
			}
		}
	}
	
	_midiInSysExCallback(wParam, lParam, msg, hwnd) {
		if this._h_MIDI_IN.ptr == 0
			return
		
		Critical
		isMMC_TC := False
		sysExEvent := {}
		str := ""
		sysExEvent.ArrHex := []
		sysExEvent.ArrDec := []
		Data := NumGet(lParam+0, 0, "Ptr")
		nbrOfBytes := NumGet(lParam + 0, A_PtrSize + 4, "UInt")
		sysExEvent.Size := nbrOfBytes
		funcName := ""
		noArg := False
		
		if nbrOfBytes < 3
			return

		loop nbrOfBytes {
			oneByte := NumGet(Data + 0, A_Index - 1, "UChar")
			sysExEvent.ArrDec.Push(oneByte)
			hexByte := Format("{:02X}", oneByte)
			sysExEvent.ArrHex.Push(hexByte)
			str .= hexByte " "
		}
		sysExEvent.String := SubStr(str, 1, -1)
		
		if sysExEvent.ArrHex[2] == "7F" {
			; Machine Control Response and Time Code
			if sysExEvent.ArrHex[3] = this._mmcDeviceId || sysExEvent.ArrHex[3] == "7F" {	; Device ID check
				timeCode := {}
				switch sysExEvent.ArrHex[4] {
					case "01":
						if this._tcEnabled {
							isMMC_TC := True
							rawMMC_TC := sysExEvent
							; Time Code (full)						
							timeCode.frames := sysExEvent.ArrDec[9]
							timeCode.seconds := sysExEvent.ArrDec[8]
							timeCode.minutes := sysExEvent.ArrDec[7]
							timeCode.hours := (sysExEvent.ArrDec[6] & 0x1F)
							fr := (sysExEvent.ArrDec[6] & 0x60) >> 5
							timeCode.frameRateCode := fr
							this._frameRateCode := fr
							frameRates := [24.0, 25.0, 29.97, 30.0]
							timeCode.frameRate := frameRates[fr + 1]
							sysExEvent := timeCode
							funcName := Format("{}{}", this._callbPrefix, "TC_Full")
						}
					case "07":
						; MCR (response)
						if this._mmcEnabled {
							isMMC_TC := True
							rawMMC_TC := sysExEvent
							switch sysExEvent.ArrHex[5] {
								case "01":
									; Time Code (Full)
									timeCode.frame := sysExEvent.ArrDec[9]
									timeCode.second := sysExEvent.ArrDec[8]
									timeCode.minute := sysExEvent.ArrDec[7]
									timeCode.hour := (sysExEvent.ArrDec[6] & 0x1F)
									fr := (sysExEvent.ArrDec[6] & 0x60) >> 5
									frameRates := [24.0, 25.0, 29.97, 30.0]
									timeCode.frameRateCode := fr
									this._frameRateCode := fr
									timeCode.frameRate := frameRates[fr + 1]
									sysExEvent := timeCode
									funcName := Format("{}{}", this._callbPrefix, "TC_Full")
								case "48":
									; Motion Control Tally
									switch sysExEvent.ArrHex[7] {
										case "01":
											; Stop
											funcName := Format("{}{}", this._callbPrefix, "MCR_Stop")
											noArg := True
										case "02":
											; Play
											funcName := Format("{}{}", this._callbPrefix, "MCR_Play")
											noArg := True
										case "04":
											; FF
											funcName := Format("{}{}", this._callbPrefix, "MCR_FF")
											noArg := True
										case "05":
											; Rewind
											funcName := Format("{}{}", this._callbPrefix, "MCR_Rewind")
											noArg := True
										case "09":
											; Pause
											funcName := Format("{}{}", this._callbPrefix, "MCR_Pause")
											noArg := True
										case "45":
											; Variable Play
											funcName := Format("{}{}", this._callbPrefix, "MCR_VPlay")
											noArg := True
										case "46":
											; Search
											funcName := Format("{}{}", this._callbPrefix, "MCR_Search")
											noArg := True
										case "47":
											; Shuttle
											funcName := Format("{}{}", this._callbPrefix, "MCR_Shuttle")
											noArg := True
										case "48":
											; Step
											funcName := Format("{}{}", this._callbPrefix, "MCR_Step")
											noArg := True
									}
								case "4D":
									; Record status
									switch (sysExEvent.ArrDec[7] & 0x0F) {
										case 0:
											; No record
											funcName := Format("{}{}", this._callbPrefix, "MCR_RecordOff")
											noArg := True
										case 2:
											; Record all tracks
											funcName := Format("{}{}", this._callbPrefix, "MCR_RecordOn")
											noArg := True
									}
							}
						}
				}
			}
		}
		if !isMMC_TC {		
			funcName := Format("{}{}", this._callbPrefix, "SysEx")
		}
	
		; Reset buffer
		result := DllCall("winmm.dll\midiInAddBuffer", "Ptr", this._h_MIDI_IN, "Ptr", this._MIDIHDR2, "UInt", 12 * A_PtrSize)
		if result != 0	{
			MsgBox("midiInAddBuffer from midiInSysExCallback failed!`n" "Result: " result, "MIDIv2", "48")
			return
		}

		Critical "Off"
		
		; Try calling event functions
		try {
			if funcName != "" {
				if noArg {
					%funcName%()
				} else {
					%funcName%(sysExEvent)
				}
			}
		}
		try {
			if isMMC_TC {
				funcName := Format("{}{}", this._callbPrefix, "MMC_SysEx")
				%funcName%(rawMMC_TC)
			}
		}
	}
	
	_midiInMoreData(wParam, lParam, msg, hwnd) {
		;OutputDebug "more data..."
	}
	_midiInError(wParam, lParam, msg, hwnd) {
		;OutputDebug "Error: lParam: " lParam
	}
	_midiInLongError(wParam, lParam, msg, hwnd) {
		;OutputDebug "LongError: lParam: " lParam
	}
}
