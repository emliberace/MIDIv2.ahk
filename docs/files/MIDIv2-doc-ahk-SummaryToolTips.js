﻿NDSummary.OnToolTipsLoaded("File:MIDIv2.doc.ahk",{3:"<div class=\"NDToolTip TGroup LAutoHotKey\"><div class=\"TTSummary\"><b>Copyright ©2025 emlib</b></div></div>",2:"<div class=\"NDToolTip TGroup LAutoHotKey\"><div class=\"TTSummary\">The MIDIv2 library grants MIDI functionality to AutoHotKey v2. All functions are conveniently wrapped in a single class.</div></div>",8:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or Get a channel filter for the MIDI Input port</div></div>",78:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or Get a default output channel</div></div>",77:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or Get MIDI Through functionality</div></div>",76:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or Get a function name prefix for use in callback functions</div></div>",79:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype79\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">GetMidiInDevices()</div></div><div class=\"TTSummary\">Retrieves all available MIDI input ports</div></div>",80:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype80\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">GetMidiOutDevices()</div></div><div class=\"TTSummary\">Retrieves all available MIDI output ports</div></div>",13:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype13\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">OpenMidiOut(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">devID</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div><div class=\"TTSummary\">Opens an available MIDI port for sending messages.</div></div>",14:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype14\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">CloseMidiOut()</div></div><div class=\"TTSummary\">Closes an open output port. If an output port is not open, CloseMidiOut has no effect.</div></div>",81:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype81\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">OpenMidiIn(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">devID</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div><div class=\"TTSummary\">Opens an available MIDI port for receiving messages.</div></div>",16:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype16\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">CloseMidiIn()</div></div><div class=\"TTSummary\">Closes an open input port. If an input port is not open, CloseMidiIn has no effect.</div></div>",19:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype19\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/4/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/4/2\">SendNoteOn(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">noteValue,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">velocity,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"3/2/4/3\" data-NarrowGridArea=\"4/1/5/2\" style=\"grid-area:3/2/4/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"3/3/4/4\" data-NarrowGridArea=\"4/2/5/3\" style=\"grid-area:3/3/4/4\">channel</div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"3/4/4/5\" data-NarrowGridArea=\"5/1/6/4\" style=\"grid-area:3/4/4/5\">)</div></div></div></div><div class=\"TTSummary\">Send a Note On message with an optional Velocity value and MIDI Channel</div></div>",20:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype20\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/4/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/4/2\">SendNoteOff(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">noteValue,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">velocity,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"3/2/4/3\" data-NarrowGridArea=\"4/1/5/2\" style=\"grid-area:3/2/4/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"3/3/4/4\" data-NarrowGridArea=\"4/2/5/3\" style=\"grid-area:3/3/4/4\">channel</div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"3/4/4/5\" data-NarrowGridArea=\"5/1/6/4\" style=\"grid-area:3/4/4/5\">)</div></div></div></div><div class=\"TTSummary\">Send a Note Off message with an optional Velocity value and MIDI Channel</div></div>",21:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype21\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/4/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/4/2\">SendPolyPressure(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">noteValue,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">value,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"3/2/4/3\" data-NarrowGridArea=\"4/1/5/2\" style=\"grid-area:3/2/4/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"3/3/4/4\" data-NarrowGridArea=\"4/2/5/3\" style=\"grid-area:3/3/4/4\">channel</div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"3/4/4/5\" data-NarrowGridArea=\"5/1/6/4\" style=\"grid-area:3/4/4/5\">)</div></div></div></div><div class=\"TTSummary\">Send Poly Pressure (polyphonic aftertouch) on a specific MIDI note</div></div>",22:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype22\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/4/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/4/2\">SendControlChange(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">number,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">value,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"3/2/4/3\" data-NarrowGridArea=\"4/1/5/2\" style=\"grid-area:3/2/4/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"3/3/4/4\" data-NarrowGridArea=\"4/2/5/3\" style=\"grid-area:3/3/4/4\">channel</div><div class=\"PAfterParameters\" data-WideGridArea=\"3/4/4/5\" data-NarrowGridArea=\"5/1/6/4\" style=\"grid-area:3/4/4/5\">)</div></div></div></div><div class=\"TTSummary\">Send a Control Change (MIDI CC) message</div></div>",23:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype23\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/3/2\">SendProgramChange(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">program,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">channel</div><div class=\"PAfterParameters NegativeLeftSpaceOnWide\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"4/1/5/4\" style=\"grid-area:2/4/3/5\">)</div></div></div></div><div class=\"TTSummary\">Send a Program Change message</div></div>",24:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype24\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/3/2\">SendAftertouch(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">value,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">channel</div><div class=\"PAfterParameters\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"4/1/5/4\" style=\"grid-area:2/4/3/5\">)</div></div></div></div><div class=\"TTSummary\">Send Aftertouch</div></div>",25:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype25\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/3/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/3/2\">SendPitchbend(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">value,</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"2/2/3/3\" data-NarrowGridArea=\"3/1/4/2\" style=\"grid-area:2/2/3/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"2/3/3/4\" data-NarrowGridArea=\"3/2/4/3\" style=\"grid-area:2/3/3/4\">channel</div><div class=\"PAfterParameters\" data-WideGridArea=\"2/4/3/5\" data-NarrowGridArea=\"4/1/5/4\" style=\"grid-area:2/4/3/5\">)</div></div></div></div><div class=\"TTSummary\">Send Pitchbend</div></div>",82:"<div class=\"NDToolTip TSection LAutoHotKey\"><div class=\"TTSummary\">SysEx messages can be sent and received using MIDIv2.</div></div>",28:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype28\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">SendSysEx(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">string</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">sysExString</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div></div>",83:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype83\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">ArrayHexToSysEx(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">string</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">arr[]</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div><div class=\"TTSummary\">Converts an array of hexadecimal numbers to a SysEx string</div></div>",84:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype84\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">ArrayDecToSysEx(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">int</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">arr[]</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div><div class=\"TTSummary\">Converts an array of decimal numbers to a SysEx string</div></div>",85:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype85\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">TextToSysEx(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">string</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">str</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div><div class=\"TTSummary\">Converts an ASCII encoded text string to a SysEx format</div></div>",32:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype32\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"4\" data-NarrowColumnCount=\"3\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/4\" style=\"grid-area:1/1/2/2\">SysExToText(</div><div class=\"PType InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">string</span>&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\">sysEx</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"3/1/4/4\" style=\"grid-area:1/4/2/5\">)</div></div></div></div><div class=\"TTSummary\">Converts a SysEx message to an ASCII encoded text string</div></div>",33:"<div class=\"NDToolTip TSection LAutoHotKey\"><div class=\"TTSummary\">When a MIDI message is received by the port opened with OpenMidiIn, a corresponding event handler (callback function) is triggered.</div></div>",86:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype86\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">NoteOn[n](</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Note On message</div></div>",87:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype87\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">NoteOff[n](</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Note Off message</div></div>",88:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype88\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">PolyPressure[n](</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Poly Pressure message</div></div>",38:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype38\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">ControlChange[n](</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Control Change message</div></div>",39:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype39\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">ProgramChange(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Program Change message</div></div>",40:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype40\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">Aftertouch(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Aftertouch message</div></div>",41:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype41\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">Pitchbend(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">midiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI Pitchbend message</div></div>",89:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype89\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">SysEx(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">sysExEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">MIDI SysEx messages</div></div>",43:"<div class=\"NDToolTip TSection LAutoHotKey\"><div class=\"TTSummary\">MIDI Machine Control and MIDI Time Code</div></div>",45:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or get support for Machine Control callbacks.</div></div>",46:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or get support for Time Code callbacks.</div></div>",90:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Set or Get the Device ID used to send and receive MMC/MCR data</div></div>",49:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype49\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_Stop()</div></div><div class=\"TTSummary\">Change MCS (Motion Control State) to Stop</div></div>",50:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype50\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_Play()</div></div><div class=\"TTSummary\">Change MCS (Motion Control State) to Play</div></div>",51:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype51\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_DPlay()</div></div><div class=\"TTSummary\">Change MCS (Motion Control State) to Deferred Play</div></div>",52:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype52\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_FF()</div></div><div class=\"TTSummary\">Change MCS to Fast Forward</div></div>",53:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype53\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_Rewind()</div></div><div class=\"TTSummary\">Change MCS to Rewind</div></div>",54:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype54\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_Record()</div></div><div class=\"TTSummary\">Change MCS to Record Strobe</div></div>",55:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype55\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_RecordExit()</div></div><div class=\"TTSummary\">End recording on all recording tracks</div></div>",56:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype56\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_RecordPause()</div></div><div class=\"TTSummary\">Set target device to a ready-to-record state</div></div>",57:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype57\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_Pause()</div></div><div class=\"TTSummary\">Instruct the target device to stop as soon as possible</div></div>",58:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype58\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"5\" data-NarrowColumnCount=\"4\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/5\" style=\"grid-area:1/1/2/2\">MMC_Locate(</div><div class=\"PModifierQualifier InFirstParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\"><span class=\"SHKeyword\">string</span> or&nbsp;</div><div class=\"PType\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"2/2/3/3\" style=\"grid-area:1/3/2/4\"><span class=\"SHKeyword\">int</span>[]&nbsp;</div><div class=\"PName InLastParameterColumn\" data-WideGridArea=\"1/4/2/5\" data-NarrowGridArea=\"2/3/3/4\" style=\"grid-area:1/4/2/5\">timeCode</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/5/2/6\" data-NarrowGridArea=\"3/1/4/5\" style=\"grid-area:1/5/2/6\">)</div></div></div></div><div class=\"TTSummary\">Locate to new Time Code</div></div>",59:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype59\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MMC_RequestTimeCode()</div></div><div class=\"TTSummary\">Request current Time Code and Frame Rate</div></div>",61:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype61\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">TC_Full(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">timeCode</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Receive current Time Code</div></div>",62:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype62\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Stop()</div></div><div class=\"TTSummary\">Current Motion Control State (MCS) is Stop</div></div>",63:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype63\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Play()</div></div><div class=\"TTSummary\">MCS is Play</div></div>",64:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype64\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_FF()</div></div><div class=\"TTSummary\">MCS is Fast Forward</div></div>",65:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype65\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Rewind()</div></div><div class=\"TTSummary\">MCS is Rewind</div></div>",66:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype66\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Pause()</div></div><div class=\"TTSummary\">MCS is Pause</div></div>",67:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype67\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_VPlay()</div></div><div class=\"TTSummary\">MCS is Variable Play</div></div>",68:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype68\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Search()</div></div><div class=\"TTSummary\">MCS is Search</div></div>",69:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype69\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Shuttle()</div></div><div class=\"TTSummary\">MCS is Shuttle</div></div>",70:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype70\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_Step()</div></div><div class=\"TTSummary\">MCS is Step</div></div>",71:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype71\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_RecordOff()</div></div><div class=\"TTSummary\">Record Mode is off</div></div>",72:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype72\" class=\"NDPrototype\"><div class=\"PSection PPlainSection\">MCR_RecordOn()</div></div><div class=\"TTSummary\">Record Mode is on</div></div>",91:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype91\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">MMC_SysEx(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">sysExEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Machine Control Response or State in a SysEx object</div></div>",74:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype74\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><div class=\"PParameterCells\" data-WideColumnCount=\"3\" data-NarrowColumnCount=\"2\"><div class=\"PBeforeParameters\" data-WideGridArea=\"1/1/2/2\" data-NarrowGridArea=\"1/1/2/3\" style=\"grid-area:1/1/2/2\">TC_RunningFull(</div><div class=\"PName InFirstParameterColumn InLastParameterColumn\" data-WideGridArea=\"1/2/2/3\" data-NarrowGridArea=\"2/1/3/2\" style=\"grid-area:1/2/2/3\">MidiEvent</div><div class=\"PAfterParameters\" data-WideGridArea=\"1/3/2/4\" data-NarrowGridArea=\"3/1/4/3\" style=\"grid-area:1/3/2/4\">)</div></div></div></div><div class=\"TTSummary\">Time Code from running transport</div></div>"});