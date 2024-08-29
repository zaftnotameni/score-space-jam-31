# Score Space JAM 31

Team:

- DanyB0i
- Harmeon
- MiaMia
- ZAFT

## Project Setup

Prefer creating folders based on vertical instead of horizontal slices. E.g.:

```swift
# bad
scenes/
  player.tscn
scripts/
  player.gd
  camera.gd
```

```swift
# good
/player
  player.tscn
  player.gd
/camera
  camera.gd
```

- `./bat/`: scripts to run and deploy the project
- `./exports/`: folder where exports (web, windows, linux) will be generated
- `./project/`: godot project, home of `project.godot`
  - `./addons/`: addons
    - `./behaviors/`: generic simple scriptlets that add composition based functionality to the parent
    - `./project_defaults/`: audio bus, theme, environment, layers
    - `./game_manager/`: audio, state, score
    - `./lootlocker/`: leaderboards
  - `./game/`: main source code specific to the game
  - `./test/`: scrap area to test random stuff before moving into the game
  - `./generated/`: generated via code (not AI) (**do not manually change things in this folder**)
  - `./assets/`: music, sfx, images, etc

### Export and Deployment

Make sure you have 2 things in your `PATH`:

- `butler.exe`
  - [https://itch.io/docs/butler/installing.html](https://itch.io/docs/butler/installing.html)
  - [https://itch.io/docs/butler/login.html](https://itch.io/docs/butler/login.html)
- `Godot_v4.3-stable_win64_console.exe`
  - [https://github.com/godotengine/godot-builds/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip](https://github.com/godotengine/godot-builds/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip)


Must be run from the root of your project.

```ps
bat\export-and-itch-all.bat
```

This will export the project for web, windows, and linux and deploy it all to itch using butler.

The command above is made of a few smaller commands that can all be run independently.
There are also individual commands for each part:

- `bat\export-web.bat`: export for web
- `bat\export-win.bat`: export for linux
- `bat\export-lin.bat`: export for windows
- `bat\itch-web.bat`: deploy for web on itch using butler (requires export first)
- `bat\itch-win.bat`: deploy for linux on itch using butler (requires export first)
- `bat\itch-lin.bat`: deploy for windows on itch using butler (requires export first)
