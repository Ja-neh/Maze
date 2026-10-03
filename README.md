# Maze Generator

A Godot project that procedurally generates mazes using the **Recursive Backtracker** algorithm.

## Features

- Procedural maze generation via Recursive Backtracker
- 3D maze built from modular block scenes (walls, floors/grass patches)
- Regenerate maze at runtime via UI button or keyboard input (**G**)

## Requirements

- **Godot 4.5.x**
- GDScript only

## Recursive Backtracker

The algorithm (`Scripts/RecursiveBacktracker.gd`) generates a perfect maze.

1. Start from a random cell.
2. Mark it visited, push it to a stack.
3. While the stack is non-empty:
   - Look at the top cell's unvisited neighbours.
   - If any exist, pick one at random, carve a passage, mark it visited, push it.
   - Otherwise, pop the stack (backtrack).
4. The result is a grid of `WALL` and open cells.

The generator then fills in wall blocks between cells to build the full 3D structure.

## Scene Generation

The main script is currently `Scripts/testing.gd`. It does the following in `_ready()`:

- calls `generate_maze()`

## Runtime Controls

A UI button/KeyG regenerates the maze. On press, all spawned nodes are freed and the maze is rebuilt.

## Online version
https://ja-neh.itch.io/maze-generation

## Running the Project

1. Open `project.godot` in Godot 4.
2. Press **F5** (or the Play button) to run the main scene.
