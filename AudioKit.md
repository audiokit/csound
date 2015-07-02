# Csound for AudioKit

This [fork](http://github.com/audiokit/csound) of Csound includes a variety of changes to make it work better with the [AudioKit](http://audiokit.io) library.

## Installer Scripts
A set of scripts are included under `installer/audiokit`. Their main purpose is to build libraries and frameworks (static and dynamic) for the purpose of bundling with iOS and OS X applications using AudioKit. The scripts generate universal libraries (Intel and ARM) for both platforms.

These scripts also require the [libsndfile](http://github.com/audiokit/libsndfile) library to be built, but this is currently the only dependency.

The `$AK_ROOT` environment variable is supposed to be set to point to the AudioKit source tree, where the binaries will be placed in appropriate locations.

## Opcodes
Some opcodes have been added to the library to enhance communication with AudioKit.

### SoundFonts
These opcodes are used internally by the `AKSoundFont` class in AudioKit.

* `sfilistapi` duplicates the functionality of `sfilist` to get the list of instruments defined in a Sound Font file, but produces strings in a format that can be unambiguously parsed by AudioKit.
	* Its usage includes an additional number parameter used to identify the object being handled in the Csound response, i.e. `sflistapi soundfont, 123`.
	* Csound responds with messages of the following format for each of the instruments:
		* `SFI:number,instrument_number,'name string'`
	* The list of instruments is terminated by a line of the following format:
		* `SFI:number,END,total_number_of_instruments`
* `sfplistapi` likewise duplicates `sfplist` for lists of presets.
	* It also includes an additional number parameter to identify the request in the output, i.e. `sfplistapi soundfont, 123`.
	*  Csound responds with messages of the following format for each of the presets:
		* `SFP:number,preset_number,'name string',program,bank`
	* The list of presets is terminated by a line of the following format:
		* `SFP:number,END,total_number_of_presets`

