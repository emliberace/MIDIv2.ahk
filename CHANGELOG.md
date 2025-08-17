# Changelog

All notable changes to this project will be documented in this file.

## [v1.1.2] - 2025-08-17
### Added
- #### Properties added
    - SysExInputBuffers
    - SysExInputBufferSize
	 
### Changed
- Incoming SysEx messages now uses multiple buffers which enables larger sized messages to be received
- Minor code cleanup

## [v1.1] - 2025-08-07
### Added
- Added support for RPN/NRPN
- Added support for System Real Time messages
- #### Properties added
    - RPN_Enabled
    - NRPN_Enabled
    - SRT_Enabled
        
- #### Functions added
    - SendRPN()
    - SendNRPN()
    - ControlChangePair()
    - SRT_TimingClock()
    - SRT_Start()
    - SRT_Stop()
    - SRT_ActiveSensing()
    - SRT_SystemReset()
        
- #### Callbacks added
    - RPN
    - NRPN
    - SRT_Timing
    - SRT_Start
    - SRT_Continue
    - SRT_Stop
    - SRT_ActiveSensing
    - SRT_SystemReset

### Changed
- Updated error handling to be more concise and descriptive

### Fixed
- `MMC_DeviceID` **Get** - Now returns Integer and rather than String

## [v1.0] - 2025-01-02
### Initial Release
- First public release of the project.
