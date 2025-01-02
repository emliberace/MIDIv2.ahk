# MIDIv2.ahk


The MIDIv2 library grants basic MIDI functionality to AutoHotKey v2.
Send and receive MIDI in your AHK scripts with ease.  
All functions are conveniently wrapped in a single class.  
</br></br>
If you find this library useful, please consider buying me a cup of coffee! (I do love coffee)  
[![Buy Me a Coffee](https://img.shields.io/badge/Support-Buy%20Me%20a%20Coffee-yellow?style=flat-square&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/emlib)

## Features

- Open and close Input and Output ports
- Get all available MIDI Input/Output ports
- Define a default MIDI Output channel
- Filter incoming MIDI messages to a specific channel
- Send and receive MIDI messages:
  - Note On/Off
  - Continuous Controller
  - Aftertouch
  - Poly Aftertouch
  - Pitchbend
  - Program Change
  - SysEx
  - MMC (MIDI Machine Control)
  - MIDI Time Code (Receive only)
- MIDI Through
  
The library also includes utility functions for handling SysEx messages.

See [here](docs/index.html) for documentation of all the features of the library.
 
## Installation

Simply place the MIDIv2.ahk file in in one of the script library paths. (See [here](https://www.autohotkey.com/docs/v2/Scripts.htm#lib) for more info.)

### Source Code

The source code for the MIDIv2 AutoHotKey library is available in the [`MIDIv2.ahk`](./MIDIv2.ahk) file.

### Prerequisites
Requires [AutoHotKey v2](https://www.autohotkey.com/) to be installed.
