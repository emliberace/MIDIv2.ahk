# MIDIv2.ahk


The MIDIv2 library grants MIDI functionality to AutoHotkey v2.
Send and receive MIDI in your AHK scripts with ease.  
All functions and properties are conveniently wrapped in a single class.  
</br></br>
**Online Documentation:**
</br>
https://emliberace.github.io/MIDIv2.ahk/index.html
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
  - Control Change
  - RPN/NRPN
  - Aftertouch
  - Poly Aftertouch
  - Pitchbend
  - Program Change
  - SysEx
  - MMC (MIDI Machine Control)
  - MIDI Time Code
  - System Real-Time messages
- MIDI Through

 
## Installation

Download the zip file [MIDIv2.v1.2.zip](https://github.com/emliberace/MIDIv2.ahk/releases/download/v1.2/MIDIv2.v1.2.zip) and extract its content.  
Place `MIDIv2.ahk` in one of AutoHotkey's library folders. (See https://www.autohotkey.com/docs/v2/Scripts.htm#lib for more info.)  
The folder `Doc` contains the documentation for the library in an HTML format and can be extracted anywhere. (Also available online: https://emliberace.github.io/MIDIv2.ahk/index.html)  
The `Examples` folder contains a number of examples of usage. Extract this folder to a location of your choice.  
(To run one of the examples, simply double-click the .ahk file.)

### Source Code

The source code for the MIDIv2 AutoHotkey library is available in the [`MIDIv2.ahk`](./MIDIv2.ahk) file.

### Prerequisites
Requires [AutoHotkey v2](https://www.autohotkey.com/) to be installed.

## License
MIDIv2 is released under the GNU General Public License v3.0.
