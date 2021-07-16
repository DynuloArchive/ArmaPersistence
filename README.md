# Arma Persistence

Persistent Missions for Arma 3

## Requirements

[CBA](https://github.com/CBATeam/CBA_A3/releases/latest)

## Features

- **Track Objects**  
    Tracks the position, rotation, damage, inventory, and more of every object on the map, including terrain buildings

- **Track Groups**  
    Tracks the fire mode, waypoints, and more of every group

- **Track Units**  
    Tracks the stance, behaviour, identity, loadout, and more of every unit
    * Players are not tracked by this system

- **Seamless**  
    Every mission can have it's own save, or multiple missions on the same map can share. Everything is put right where you left it when you restart the mission, no manual saving or loading needed.
    * Do not use the same mission key on two servers at the same time, it will cause issues.

## Note

This repository only contains the client side components of ArmaPersistence. Additional cloud services are required that are not public. If the cloud services are ever shut down, the code will be made public at that time.

## What is tracked

### Objects
- Engine State
- Light State
- Collision Light State
- Fuel Level
- Cargo Fuel Level
- Ammo
- Cargo Ammo Level
- Cargo Repair Level
- Inflamed state (Campfires)
- Plate Number
- Textures
- Hit Point Damage
- Animation Phases (Open Doors, Bar Gate Up/Down)
- Locked State
- Inventory
- ACE Cargo
- ACE spray paint tags

### Groups
- Group ID
- Behaviour
- Speed
- Combat Mode
- Formation
- Waypoints

### Units
- Name
- Loadout
- Face
- Speaker
- Pitch
- Rank
- Flashlight On/Off
- IR Laser On/Off
- Current Weapon (Primary / Secondary / Launcher)
- Stance
- Combat Mode
- Behaviour
- Current Vehicle Seat (Driver / Gunner / Commander / Cargo)
- ACE Surrendering
- ACE Handcuffed
