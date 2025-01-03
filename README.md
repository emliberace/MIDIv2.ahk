# MIDIv2.ahk (v1.0)


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

See [here](https://emliberace.github.io/MIDIv2.ahk/index.html) for detailed documentation of all the features of the library.
 
## Installation

Download the zip file [MIDIv2.v1.0.zip](https://github.com/emliberace/MIDIv2.ahk/releases/download/v1.0/MIDIv2.v1.0.zip) and extract its content.  
Place the MIDIv2.ahk file in one of the script library paths. (See [here](https://www.autohotkey.com/docs/v2/Scripts.htm#lib) for more info.)  
The folder `\Doc` contains the documentation for the library in a HTML format and can be extracted anywhere.  
The folder `\Examples` contains a number of examples of usage. Extract this folder to a location of your choice.  
(To run one of the examples, simply double-click the .ahk file.)

### Source Code

The source code for the MIDIv2 AutoHotKey library is available in the [`MIDIv2.ahk`](./MIDIv2.ahk) file.

### Prerequisites
Requires [AutoHotKey v2](https://www.autohotkey.com/) to be installed.
