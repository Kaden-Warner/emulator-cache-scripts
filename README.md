# emulator-cache-scripts
A collection of Windows scripts that cache emulator roms to disk before launching

## Use-case
I store my ROMs on an offsite file server that is a mapped drive in Windows. Since the fileserver was over WAN, the latency when streaming the file to Dolphin would cause stutters when aspects of the game were loading. (EX. the final lap of Mario Kart Wii would freeze for a few seconds while it loads the final lap music)

These scripts counteract that by creating a local cache of games while not simply cloning the whole repository of ROMs to a local drive. This allows all my ROMs to be visible in Playnite, while only being downloaded if I want to play it.

## Dolphin
### dolphin_wrapper.bat
Usage: ```dolphin_wrapper.bat <full file path of rom in mapped drive>```

Edit configurations in script to your respective file paths

This will launch Dolphin with the cached version of the rom. If the rom is not already downloaded, it will copy it from the mapped drive

### cleanup_cache.ps1
Usage: Execution via batch file or Task Scheduler. Example Task Scheduler xml in repo. 

Edit paths and configs in script to your liking

This will cleanup the cache according to the configured parameters (Default: Not played within 14 days, Cache size cannot exceed 50GB)
