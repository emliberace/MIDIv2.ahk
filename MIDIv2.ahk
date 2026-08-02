;MIDIv2.ahk v1.2
class MIDIv2 {
	_hMidiOut := 0
	_hMidiIn := 0
	_midiInChannelFilter := -1
	_midiOutChannel := 0
	_midiHdrSize := 0
	_bufferSize := 64
	_nbrOfBuffers := 16
	_sysExInputBuffers := []
	_sysExOutputBuffers := []
	_sysExBuf := 0
	_sysExDataLen := 0
	_sysExBufSize := 0
	_midiThrough := False
	_frameRatesTable := [24.0, 25.0, 29.97, 30.0]
	_callbPrefix := "MidiIn"
	_mmcDeviceId := "7F"
	_frameRateCode := 0
	_isMmcEnabled := False
	_isTcEnabled := False
	_isSrtEnabled := False
	_isRpnEnabled := False
	_isNrpnEnabled := False
	_pnTemplate := {
		param: 0,
		value: 0,
		paramsSet: 0,
		valuesSet: 0
	}
	_RPN := []
	_NRPN := []
	_lastRpnNrpnParam := []
	
	_MIDIHDR_size := 0
	_MIDIHDR_lpData := 0
	_MIDIHDR_dwBufferLength := 0
	_MIDIHDR_dwBytesRecorded := 0
	_MIDIHDR_dwUser := 0
	_MIDIHDR_dwFlags := 0
	
	_MHDR_DONE := 0x00000001
	_MHDR_PREPARED := 0x00000002
	_MHDR_INQUEUE := 0x00000004
	
	__New() {
		OutputDebug "New MIDIv2 instance created"
		
		if (A_PtrSize = 8) {
			; 64-bit
			this._MIDIHDR_size := 112	; sizeof(MIDIHDR)
			this._MIDIHDR_lpData := 0
			this._MIDIHDR_dwBufferLength := 8
			this._MIDIHDR_dwBytesRecorded := 12
			this._MIDIHDR_dwUser := 16
			this._MIDIHDR_dwFlags := 24
		} else {
			; 32-bit
			this._MIDIHDR_size := 64	; sizeof(MIDIHDR)
			this._MIDIHDR_lpData := 0
			this._MIDIHDR_dwBufferLength := 4
			this._MIDIHDR_dwBytesRecorded := 8
			this._MIDIHDR_dwUser := 12
			this._MIDIHDR_dwFlags := 16
		}
		
		this._callbackShort := ObjBindMethod(this, "_midiInCallback")
		this._callbackLong := ObjBindMethod(this, "_midiInSysExCallback")
		this._callbackMore := ObjBindMethod(this, "_midiInMoreData")
		this._callbackError := ObjBindMethod(this, "_midiInError")
		this._callbackLongError := ObjBindMethod(this, "_midiInLongError")
		this._callbackSysExDone := ObjBindMethod(this, "_onSysExDone")
		
		; Initialize RPN/NRPN data structures
		Loop 16 {
			this._RPN.Push(this._pnTemplate.Clone())
			this._NRPN.Push(this._pnTemplate.Clone())
			this._lastRpnNrpnParam.Push("")
		}
	}
	
	InputChannel {
		get => this._midiInChannelFilter + 1
		set {
			this._requireInteger(value, A_ThisFunc)
			this._requireRange(value, 0, 16, "Channel", A_ThisFunc)
			
			this._midiInChannelFilter := value - 1
		}
	}
	
	OutputChannel {
		get => this._midiOutChannel + 1
		set {
			this._requireInteger(value, A_ThisFunc)
			this._requireRange(value, 1, 16, "Channel", A_ThisFunc)
			
			this._midiOutChannel := value - 1
		}
	}
	
	MidiThrough {
		get => this._midiThrough
		set {
			this._requireInteger(value, A_ThisFunc)

			if (this._hMidiOut = 0) {
				throw MethodError(
					A_ThisFunc "`nA MIDI Output port must be opened before enabling MIDI Through.",
					A_ThisFunc
				)
			}
			if (this._hMidiIn = 0) {
				throw MethodError(
					A_ThisFunc "`nA MIDI Input port must be opened before enabling MIDI Through.",
					A_ThisFunc
				)
			}
			
			this._midiThrough := (value > 0) ? 1 : 0
		}
	}
	
	CallbackPrefix {
		get => this._callbPrefix
		set {
			this._requireString(value, A_ThisFunc)
			
			firstChar := SubStr(value, 1, 1)
			if (IsInteger(firstChar)) {
				throw TypeError(
					A_ThisFunc "`nFirst character cannot be an integer.",
					A_ThisFunc,
					value
				)
			}

			this._callbPrefix := value
		}
	}
	
	MMC_Enabled {
		get => this._isMmcEnabled
		set {
			this._requireBooleanOrInteger(value, A_ThisFunc)
			
			this._isMmcEnabled := (value > 0) ? 1 : 0
		}
	}
	
	MMC_DeviceID {
		get => Number("0x" this._mmcDeviceId)
		set {
			this._requireInteger(value, A_ThisFunc)
			
			this._mmcDeviceId := Format("{:02X}", value)
		}
	}
	
	TC_Enabled {
		get => this._isTcEnabled
		set {
			this._requireBooleanOrInteger(value, A_ThisFunc)
			
			this._isTcEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	SRT_Enabled {
		get => this._isSrtEnabled
		set {
			this._requireBooleanOrInteger(value, A_ThisFunc)
			
			this._isSrtEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	RPN_Enabled {
		get => this._isRpnEnabled
		set {
			this._requireBooleanOrInteger(value, A_ThisFunc)
			
			this._isRpnEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	NRPN_Enabled {
		get => this._isNrpnEnabled
		set {
			this._requireBooleanOrInteger(value, A_ThisFunc)
			
			this._isNrpnEnabled := (value > 0) ? 1 : 0			
		}
	}
	
	SysExInputBuffers {
		get => this._nbrOfBuffers
		set {
			if (this._hMidiIn = 0) {
				this._requireInteger(value, A_ThisFunc)
				this._requireGreaterThanZero(value, A_ThisFunc)
			
				this._nbrOfBuffers := value
			} else {
				throw MethodError(
					A_ThisFunc "`nSysEx Input buffers cannot be changed while the input port is running.",
					A_ThisFunc
				)
			}
		}
	}
	
	SysExInputBufferSize {
		get => this._bufferSize
		set {
			if (this._hMidiIn = 0) {
				this._requireInteger(value, A_ThisFunc)
				this._requireGreaterThanZero(value, A_ThisFunc)
				
				this._bufferSize := value
			} else {
				throw MethodError(
					A_ThisFunc "`nSysEx Input buffers cannot be changed while the input port is running.",
					A_ThisFunc
				)
			}
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

			if (result != 0) {
				throw MethodError(
				  A_ThisFunc "`nFailed to query MIDI in device.`nDevice number=" deviceNumber,
				  A_ThisFunc
				)
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

			if (result != 0) {
				throw MethodError(
					A_ThisFunc "`nFailed to query MIDI out device.`nDevice number=" deviceNumber,
					A_ThisFunc
				)
			}

			deviceName := StrGet(midiStruct.Ptr + 8, "CP0")
			midiDevices.Push(deviceName)
		}
		return midiDevices
	}
	
	OpenMidiOut(devID) {
		hMidiOut := 0
		result := DllCall("winmm.dll\midiOutOpen"
			, "Ptr*", &hMidiOut
			, "UInt", devID
			, "Ptr", A_ScriptHwnd
			, "Ptr", 0
			, "UInt", 0x10000)	; MIDI_CALLBACK_WINDOW
		if (result != 0) {
			this._hMidiOut := 0
			throw MethodError(
				A_ThisFunc "`nError opening MIDI Out port with ID=" devID "`nError code: " result,
				A_ThisFunc
			)
		}
		
		this._hMidiOut := hMidiOut
		
		MIDI_SYSEXDONE := 0x3C9
		OnMessage MIDI_SYSEXDONE, this._callbackSysExDone
	}
	
	CloseMidiOut() {
		if (this._hMidiOut = 0) {
			return
		}
		
		; Unregister callback
		MIDI_SYSEXDONE := 0x3C9
		OnMessage MIDI_SYSEXDONE, this._callbackSysExDone, 0
		
		result := DllCall("winmm.dll\midiOutReset", "Ptr", this._hMidiOut)
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError resetting the MIDI Out port.`nError code: " result,
				A_ThisFunc
			)
		}
		
		; Cleanup stored buffers
		unprepareError := 0
		MIDIHDRSize := this._MIDIHDR_size
		for buffer in this._sysExOutputBuffers {
			result := DllCall("winmm.dll\midiOutUnprepareHeader"
				, "Ptr", this._hMidiOut
				, "Ptr", buffer.Hdr
				, "UInt", MIDIHDRSize)
			if ((result != 0) && (unprepareError = 0)) {
				unprepareError := result
			}
		}
		this._sysExOutputBuffers := []
		
		result := DllCall("winmm.dll\midiOutClose", "Ptr", this._hMidiOut)
		this._hMidiOut := 0
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError closing the MIDI Out port.`nError code: " result,
				A_ThisFunc
			)
		}
		
		if (unprepareError != 0) {
			throw MethodError(
				A_ThisFunc "`nError unpreparing MIDI output SysEx header.`nresult = " unprepareError,
				A_ThisFunc
			)
		}
	}
	
	SendNoteOff(noteValue, velocity:=64, channel:=-1)	{
		this._requireRange(noteValue, 0, 127, "NoteValue", A_ThisFunc)
		this._requireRange(velocity, 0, 127, "Velocity", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}		
		this._midiOutShortMsg(((velocity & 0xff) << 16) | ((noteValue & 0xff) << 8) | (channel | 0x80))
	}
	
	SendNoteOn(noteValue, velocity:=127, channel:=-1) {
		this._requireRange(noteValue, 0, 127, "NoteValue", A_ThisFunc)
		this._requireRange(velocity, 0, 127, "Velocity", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		this._midiOutShortMsg(((velocity & 0xff) << 16 ) | ((noteValue & 0xff) << 8) | (channel | 0x90))
	}
	
	SendPolyPressure(noteValue, value, channel:=-1) {
		this._requireRange(noteValue, 0, 127, "NoteValue", A_ThisFunc)
		this._requireRange(value, 0, 127, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {			
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		this._midiOutShortMsg(((value & 0xff) << 16 ) | ((noteValue & 0xff) << 8) | (channel | 0xA0))
	}
	
	SendControlChange(controller, value, channel := -1) {
		this._requireRange(controller, 0, 127, "Controller", A_ThisFunc)
		this._requireRange(value, 0, 127, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		this._midiOutShortMsg(((value & 0xff) << 16) | ((controller & 0xff) << 8) | (channel | 0xB0))
	}
	
	SendControlChangePair(controller, value, channel := -1) {
		this._requireRange(controller, 0, 31, "Controller", A_ThisFunc)
		this._requireRange(value, 0, 16383, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		valueMSB := (value >> 7) & 0x7F
		valueLSB := value & 0x7F
		controllerLSB := controller + 32
		this._midiOutShortMsg((valueMSB << 16) | (controller << 8) | (channel | 0xB0))
		this._midiOutShortMsg((valueLSB << 16) | (controllerLSB << 8) | (channel | 0xB0))
	}
	
	SendProgramChange(program, channel := -1) {
		this._requireRange(program, 0, 127, "Program", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		this._midiOutShortMsg(((program & 0xff) << 8) | (channel | 0xC0))
	}
	
	SendAftertouch(value, channel := -1) {
		this._requireRange(value, 0, 127, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		this._midiOutShortMsg(((value & 0xff) << 8) | (channel | 0xD0))
	}
	
	SendPitchbend(value, channel := -1) {
		this._requireRange(value, 0, 16383, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
			channel--
		}
		this._midiOutShortMsg((((value >> 7) & 0x7F) << 16) | ((value & 0x7F) << 8) | (channel | 0xE0))
	}
	
	SendRPN(parameter, value, channel := -1) {
		this._requireRange(parameter, 0, 16383, "Parameter", A_ThisFunc)
		this._requireRange(value, 0, 16383, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
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
		this._requireRange(parameter, 0, 16383, "Parameter", A_ThisFunc)
		this._requireRange(value, 0, 16383, "Value", A_ThisFunc)
		
		if (channel = -1) {
			channel := this._midiOutChannel
		} else {
			this._requireRange(channel, 1, 16, "Channel", A_ThisFunc)
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
					MsgBox("MMC_TimeCode - Incorrect String format`nFailed to create Array", "MIDIv2 - MMC_Locate", 48)
					return
				}
				if (arrV.Length != 4) {
					MsgBox("Incorrect String format`nIncorrect number of elements", "MIDIv2 - MMC_Locate", 48)
					return
				}					
			case "Array":
				if (timeCode.Length != 4) {
					MsgBox("Incorrect Array length", "MIDIv2 - MMC_Locate", 48)
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
		if (this._hMidiOut = 0) {
			throw MethodError(
				A_ThisFunc "`nNo MIDI Output port opened.",
				A_ThisFunc
			)
		}
		
      ; Convert the string to a buffer
      sysexArray := StrSplit(sysexString, " ")
      bufferSize := sysexArray.Length
      dataBuffer := Buffer(bufferSize, 0)
		MIDIHDRSize := this._MIDIHDR_size
      
      Loop bufferSize {
			try {
				NumPut("UChar", "0x" sysexArray[A_Index], dataBuffer, A_Index - 1)
			} catch {
				throw MethodError(
					A_ThisFunc "`nInvalid hexadecimal byte: " sysexArray[A_Index] "`nAt index: " A_Index,
					A_ThisFunc
				)
			}
      }

      ; Prepare the MIDIHDR structure
      MIDIHDR := this._createMIDIHDR(dataBuffer)
		OutputDebug "Sending sysex. MIDIHDR=" MIDIHDR.ptr

      ; Prepare SysEx header
      result := DllCall("winmm.dll\midiOutPrepareHeader"
			, "Ptr", this._hMidiOut
			, "Ptr", MIDIHDR
			, "UInt", MIDIHDRSize)
      if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError preparing the SysEx message header `nresult = " result,
				A_ThisFunc
			)
      }
		
		; Store buffers until MOM_DONE is received.
		this._sysExOutputBuffers.Push({Hdr: MIDIHDR, Data: dataBuffer})
		OutputDebug "Pending=" this._sysExOutputBuffers.Length
		
      ; Send the SysEx message
      result := DllCall("winmm.dll\midiOutLongMsg"
			, "Ptr", this._hMidiOut
			, "Ptr", MIDIHDR
			, "UInt", MIDIHDRSize)
      if (result != 0) {
			this._sysExOutputBuffers.Pop()
			
			result := DllCall("winmm.dll\midiOutUnprepareHeader"
				, "Ptr", this._hMidiOut
				, "Ptr", MIDIHDR
				, "UInt", MIDIHDRSize)
		
			throw MethodError(
				A_ThisFunc "`nError sending SysEx message `nresult = " result,
				A_ThisFunc
			)
      }
   }
	
	_onSysExDone(wParam, lParam, msg, hwnd) {
		; Unprepare the header after sending the message	
		MIDIHDRSize := this._MIDIHDR_size
      result := DllCall("winmm.dll\midiOutUnprepareHeader"
			, "Ptr", this._hMidiOut
			, "Ptr", lParam
			, "UInt", MIDIHDRSize)
      if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError unpreparing the SysEx message header `nresult = " result,
				A_ThisFunc
			)
      }
		
		; Cleanup stored buffer
		for index, item in this._sysExOutputBuffers {
			if (item.Hdr.Ptr = lParam) {
				this._sysExOutputBuffers.RemoveAt(index)
				OutputDebug "Pending=" this._sysExOutputBuffers.Length
				break
			}
		}
		OutputDebug "SysEx complete. MIDIHDR=" lParam
	}
	
	; SysEx utlility functions ++++++++++++++++++++++++++++++++++++++++++++++
	ArrayHexToSysEx(arr) {
		if (Type(arr) != "Array") {
			throw TypeError(
				A_ThisFunc "`nParameter type must be an array.",
				A_ThisFunc
			)
		}
		s := ""
		For _, val in arr {
			s .= val " "
		}
		return SubStr(s, 1, -1)
	}
	
	ArrayDecToSysEx(arr) {
		if (Type(arr) != "Array") {
			throw TypeError(
				A_ThisFunc "`nParameter type must be an array.",
				A_ThisFunc
			)
		}
		s := ""
		For _, val in arr {
			s .= Format("{:02X}", val) " "
		}
		return SubStr(s, 1, -1)
	}
	
	TextToSysEx(str) {
		this._requireString(str, A_ThisFunc)
		
		s := ""
		Loop Parse str {
			charValue := Ord(A_LoopField)
			if charValue > 127 {
				throw ValueError(
					A_ThisFunc "`nASCII value limit exceeded"
					A_ThisFunc,
					A_LoopField
				)
			}
			s .= Format("{:02X} ", Ord(A_LoopField) " ")
		}
		return SubStr(s, 1, -1)
	}
	
	SysExToText(sysEx) {
		this._requireString(sysEx, A_ThisFunc)
		
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
		if (this._hMidiOut = 0) {
			throw MethodError(
				A_ThisFunc "`nNo MIDI Output port opened.",
				A_ThisFunc
			)
		}
		
		result := DllCall("winmm.dll\midiOutShortMsg", "Ptr", this._hMidiOut, "UInt", msg)
		if (result != 0 || (A_LastError != 0 && A_LastError != 997)) {
			throw MethodError(
				A_ThisFunc "`nError sending message.`nresult = " result,
				A_ThisFunc
			)
		}
	}
	
	; MIDI In +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	OpenMidiIn(devID)	{
		; Open MIDI In port
		hMidiIn := 0
		result := DllCall("winmm.dll\midiInOpen"
			, "Ptr*", &hMidiIn
			, "UInt", devID
			, "Ptr", A_ScriptHwnd
			, "UInt", 0
			, "UInt", 0x10000)  ; MIDI_CALLBACK_WINDOW
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError opening MIDI Input port with device ID: " devID "`nresult = " result,
				A_ThisFunc
			)
		}
		this._hMidiIn := hMidiIn
		
		; Prepare input buffers for SysEx
		this._prepareInputBuffers()

		; MIDI event types
		MIDI_OPEN := 0x3C1
		MIDI_CLOSE := 0x3C2
		MIDI_DATA := 0x3C3
		MIDI_LONGDATA := 0x3C4
		MIDI_ERROR := 0x3C5
		MIDI_LONGERROR := 0x3C6
		MIDI_MOREDATA := 0x3CC
		
		; Register MIDI callbacks
		OnMessage MIDI_DATA, this._callbackShort
		OnMessage MIDI_LONGDATA, this._callbackLong
		OnMessage MIDI_MOREDATA, this._callbackMore
		OnMessage MIDI_ERROR, this._callbackError
		OnMessage MIDI_LONGERROR, this._callbackLongError
		
		; Start the MIDI In port
		result := DllCall("winmm.dll\midiInStart", "Ptr", this._hMidiIn)
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError starting MIDI Input port with device ID: " devID "`nresult = " result,
				A_ThisFunc
			)
		}
	}
	
	_prepareInputBuffers() {
		nbrOfBuffers := this._nbrOfBuffers
		bufferSize := this._bufferSize
		MIDIHDRSize := this._MIDIHDR_size
		
		Loop nbrOfBuffers {
			; Allocate data buffer (zeroed)
			dataBuffer := Buffer(bufferSize, 0)
			
			MIDIHDR := this._createMIDIHDR(dataBuffer)
			
			; Prepare + queue
			result := DllCall("winmm.dll\midiInPrepareHeader"
				, "Ptr", this._hMidiIn
				, "Ptr", MIDIHDR
				, "UInt", MIDIHDRSize)
			if (result != 0) {
				throw MethodError(
					A_ThisFunc "`nError preparing MIDI Input Header.`nresult = " result,
					A_ThisFunc
				)
			}

			result := DllCall("winmm.dll\midiInAddBuffer"
				, "Ptr", this._hMidiIn
				, "Ptr", MIDIHDR
				, "UInt", MIDIHDRSize)
			if (result != 0) {
				throw MethodError(
					A_ThisFunc "`nError adding MIDI Input buffer.`nresult = " result,
					A_ThisFunc
				)
			}
			this._sysExInputBuffers.Push({Hdr: MIDIHDR, Data: dataBuffer})
		}
		
		this._sysExBufSize := nbrOfBuffers * bufferSize
		this._sysExBuf := Buffer(this._sysExBufSize)
		this._sysExDataLen := 0
	}
	
	_createMIDIHDR(dataBuffer) {
		MIDIHDRSize := this._MIDIHDR_size
		; Allocate MIDIHDR (zeroed)
		MIDIHDR := Buffer(MIDIHDRSize, 0)
		
		; Populate required fields
		NumPut("Ptr",  dataBuffer.Ptr,  MIDIHDR, this._MIDIHDR_lpData)				; lpData
		NumPut("UInt", dataBuffer.Size, MIDIHDR, this._MIDIHDR_dwBufferLength)	; dwBufferLength
		
		return MIDIHDR
	}

	CloseMidiIn() {
		if (this._hMidiIn = 0) {
			return
		}
		
		result := DllCall("winmm.dll\midiInStop", "Ptr", this._hMidiIn)
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError stopping the MIDI Input port.`nresult = " result,
				A_ThisFunc
			)
		}
		
		result := DllCall("winmm.dll\midiInReset", "Ptr", this._hMidiIn)
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError resetting the MIDI Input port.`nresult = " result,
				A_ThisFunc
			)
		}
		
		unprepareError := 0
		MIDIHDRSize := this._MIDIHDR_size
		for buffer in this._sysExInputBuffers {
			MIDIHDR := buffer.Hdr
			result := DllCall("winmm.dll\midiInUnprepareHeader"
					, "Ptr", this._hMidiIn
					, "Ptr", MIDIHDR
					, "UInt", MIDIHDRSize)
			if ((result != 0) && (unprepareError = 0)) {
				unprepareError := result
			}
		}
		
		result := DllCall("winmm.dll\midiInClose", "Ptr", this._hMidiIn)
		if (result != 0) {
			throw MethodError(
				A_ThisFunc "`nError closing the MIDI Input port.`nresult = " result,
				A_ThisFunc
			)
		}
		
		this._hMidiIn := 0
		this._sysExInputBuffers := []
		
		if (unprepareError != 0) {
			throw MethodError(
				A_ThisFunc "`nError unpreparing MIDI input SysEx header.`nresult = " unprepareError,
				A_ThisFunc
			)
		}
	}
	
	_midiInCallback(wParam, lParam, msg, hwnd) {
		if (this._hMidiIn = 0) {
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

		if (this._midiThrough && highByte < 0xF0) {
			this._midiOutShortMsg(lParam)
		}
		
		if (this._midiInChannelFilter != -1 && lowByte != this._midiInChannelFilter) {
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
				if (this._isRpnEnabled && (data1 = 0x64 || data1 = 0x65)) {
					if (this._RPN[ch].paramsSet = 2 || this._RPN[ch].paramsSet = 0) {
						this._RPN[ch].paramsSet := 1
						this._RPN[ch].param := 0
						this._RPN[ch].valuesSet := 0
					} else if (this._RPN[ch].paramsSet = 1) {
						this._RPN[ch].paramsSet := 2
					}
					this._lastRpnNrpnParam[ch] := "RPN"
					switch data1 {
						case 0x64:
							this._RPN[ch].param |= data2	; Parameter LSB
						case 0x65:
							this._RPN[ch].param |= (data2 << 7)	; Parameter MSB
					}
				; NRPN Parameter
				} else if (this._isNrpnEnabled && (data1 = 0x62 || data1 = 0x63)) {
					if (this._NRPN[ch].paramsSet = 2 || this._NRPN[ch].paramsSet = 0) {
						this._NRPN[ch].paramsSet := 1
						this._NRPN[ch].param := 0
						this._NRPN[ch].valuesSet := 0
					} else if (this._NRPN[ch].paramsSet = 1) {
						this._NRPN[ch].paramsSet := 2
					}
					this._lastRpnNrpnParam[ch] := "NRPN"
					switch data1 {
						case 0x62:
							this._NRPN[ch].param |= data2	; Parameter LSB
						case 0x63:
							this._NRPN[ch].param |= (data2 << 7)	; Parameter MSB
					}
				; RPN Value
				} else if (this._isRpnEnabled && this._lastRpnNrpnParam[ch] = "RPN" && (data1 = 0x06 || data1 = 0x26)) {
					if (this._RPN[ch].valuesSet = 2 || this._RPN[ch].valuesSet = 0) {
						this._RPN[ch].valuesSet := 1
						this._RPN[ch].value := 0
					} else if (this._RPN[ch].valuesSet = 1) {
						this._RPN[ch].valuesSet := 2
					}
					switch data1 {
						case 0x06:
							this._RPN[ch].value |= (data2 << 7)	; Value MSB
						case 0x26:
							this._RPN[ch].value |= data2	; Value LSB
					}
					; RPN Complete
					if (this._RPN[ch].paramsSet = 2 && this._RPN[ch].valuesSet = 2) {
						midiEvent.EventType := "RPN"
						midiEvent.Parameter := this._RPN[ch].param
						midiEvent.Value := this._RPN[ch].value
						midiEvent.Channel := ch
						callbackFunctions.Push(Format("{}{}{}", this._callbPrefix, midiEvent.EventType, midiEvent.Parameter))
					}
				; NRPN Value
				} else if (this._isNrpnEnabled && this._lastRpnNrpnParam[ch] = "NRPN" && (data1 = 0x06 || data1 = 0x26)) {
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
					if (this._NRPN[ch].paramsSet = 2 && this._NRPN[ch].valuesSet = 2) {
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
				if (this._isTcEnabled) {
					if (lowbyte = 0x1) {
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
								midiEvent.FrameRate := this._frameRatesTable[mtc_fr + 1]
								midiEvent.EventType := "TC_RunningFull"
						}
					}
				}
				if (this._isSrtEnabled) {
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
		
		if (midiEvent.EventType != "") {
			; Add a callback for the event type. E.g. "NoteOn", "ControlChange".
			callbackFunctions.Push(Format("{}{}", this._callbPrefix, midiEvent.EventType))
		}

		; Try calling all event functions
		for _, funcName in callbackFunctions {
			try {
				if (noArg) {
					%funcName%()
				} else {
					%funcName%(midiEvent)
				}
			}
		}
	}
	
	_midiInSysExCallback(wParam, lParam, msg, hwnd) {
		Critical -1	; Current thread cannot be interrupted. Message checks are disabled.
		if (this._hMidiIn = 0) {
			return
		}

		nbrOfBytes := NumGet(lParam, this._MIDIHDR_dwBytesRecorded, "UInt")
		pData := NumGet(lParam, this._MIDIHDR_lpData, "Ptr")

		if (nbrOfBytes > 0 && pData) {
			needed := this._sysExDataLen + nbrOfBytes

			if (needed <= this._sysExBufSize) {
				; Append chunk
				DllCall("RtlMoveMemory", "Ptr", this._sysExBuf.Ptr + this._sysExDataLen, "Ptr", pData, "UPtr", nbrOfBytes)
				this._sysExDataLen := needed

				; EOX check (last byte of chunk)
				if (NumGet(pData, nbrOfBytes - 1, "UChar") = 0xF7) {
					this._sysExEventHandler()
					this._sysExDataLen := 0
				}
			} else {
				; Buffer overflow
				this.CloseMidiIn()

				throw MethodError(
				 "Incoming SysEx data exceeded total buffer size.`nThe MIDI Input Port has been closed.",
					A_ThisFunc
				)
			}
		}
		this._requeueBuffer(lParam)
	}
	
	_requeueBuffer(lParam) {
		MIDIHDRSize := this._MIDIHDR_size
		
		NumPut("UInt", 0, lParam, this._MIDIHDR_dwBytesRecorded)
		flags := NumGet(lParam, this._MIDIHDR_dwFlags, "UInt")
		flags := flags & ~this._MHDR_DONE		; clear MHDR_DONE
		flags := flags & ~this._MHDR_INQUEUE	; clear MHDR_INQUEUE
		NumPut("UInt", flags, lParam, this._MIDIHDR_dwFlags)
		result := DllCall("winmm.dll\midiInAddBuffer"
			, "Ptr", this._hMidiIn
			, "Ptr", lParam
			, "UInt", MIDIHDRSize)
		if (result != 0) {
			throw MethodError(
			 "Error re-adding MIDI Input buffer.`nError code: " result,
				A_ThisFunc
			)
		}
	}
	
	_sysExEventHandler() {
		Critical "Off"
		isMMC_TC := False
		sysExDataLen := this._sysExDataLen
		sysExEvent := {}
		str := ""
		sysExEvent.ArrHex := []
		sysExEvent.ArrHex.Length := sysExDataLen
		sysExEvent.ArrDec := []
		sysExEvent.ArrDec.Length := sysExDataLen
		funcName := ""
		noArg := False
		sysExEvent.Size := sysExDataLen
		ptr := this._sysExBuf.ptr
		hexBuf := Buffer(sysExDataLen * 3)
		hexPtr := hexBuf.Ptr

		loop sysExDataLen {
			idx := A_Index
			oneByte := NumGet(ptr + (idx - 1), "UChar")
			sysExEvent.ArrDec[idx] := oneByte
			sysExEvent.ArrHex[idx] := Format("{:02X}", oneByte)
			DllCall("msvcrt\sprintf", "ptr", hexPtr, "astr", sysExEvent.ArrHex[idx] " ", "cdecl")
			hexPtr += 3
		}
		sysExEvent.String := StrGet(hexBuf.Ptr, sysExDataLen * 3 - 1, "CP0") ; Trim trailing space
		
		if (sysExEvent.ArrHex[2] = "7F") {
			; Machine Control Response and Time Code
			if (sysExEvent.ArrHex[3] = this._mmcDeviceId || sysExEvent.ArrHex[3] = "7F") {	; Device ID check
				timeCode := {}
				switch sysExEvent.ArrHex[4] {
					case "01":
						if this._isTcEnabled {
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
							timeCode.frameRate := this._frameRatesTable[fr + 1]
							sysExEvent := timeCode
							funcName := Format("{}{}", this._callbPrefix, "TC_Full")
						}
					case "07":
						; MCR (response)
						if this._isMmcEnabled {
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
		if (!isMMC_TC) {		
			funcName := Format("{}{}", this._callbPrefix, "SysEx")
		}
		
		; Try calling event functions
		try {
			if (funcName != "") {
				if (noArg) {
					%funcName%()
				} else {
					%funcName%(sysExEvent)
				}
			}
		}
		try {
			if (isMMC_TC) {
				funcName := Format("{}{}", this._callbPrefix, "MMC_SysEx")
				%funcName%(rawMMC_TC)
			}
		}
	}
	
	_midiInMoreData(wParam, lParam, msg, hwnd) {
		OutputDebug "more data..."
	}
	_midiInError(wParam, lParam, msg, hwnd) {
		OutputDebug "Error: lParam: " lParam
	}
	_midiInLongError(wParam, lParam, msg, hwnd) {
		OutputDebug "LongError: lParam: " lParam
	}
	
	; Error checks
	_requireRange(value, min, max, name, method) {
		if !IsInteger(value) {
			throw TypeError(
				method "`n" name " must be an integer.",
				"MidiThrough",
				value
			)
		}
		if (value < min || value > max) {
			throw ValueError(
				method "`n" name " must be between " min " and " max ".",
				method,
				value
			)
		}
	}
	
	_requireGreaterThanZero(value, method) {
		if (value < 1) {
			throw ValueError(
				method "`nValue must be greater than zero.",
				method,
				value
			)
		}
	}
	
	_requireInteger(value, method) {
		if !IsInteger(value) {
			throw TypeError(
				method "`nValue must be an integer.",
				method,
				value
			)
		}
	}
	
	_requireBooleanOrInteger(value, method) {
		if !IsInteger(value) {
			throw TypeError(
				method "`nValue must be a boolean or an integer.",
				"MidiThrough",
				value
			)
		}
	}
	
	_requireString(value, method) {
		if (type(value) != "String") {
			throw TypeError(
				method "`nValue must be a string.",
				method,
				value
			)
		}
	}
}
