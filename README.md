This repo is my personal helper tool for managing randomly generated rooms, created with games like "DOORS" in mind.
For now it's harcoded to produce files that can only be imported into unreal if you have a data table with specifically named struct variables. I plan on making it more flexible in the future.

You start by providing a levelID and a display name. The display name doesn't matter and is only relevant to this program.
Creating a level add it to the drawer on the left and the level list on the right.
The drawer is where you select any level you've created.
The level list is when you can add the selected level as a spawn possibility for the level on the list.
The Idea is that every level has a list of possible next levels, and this tool lets you precisely control this list.
Every level added as a spawn possibility of another level also has a spawn probability.

Exporting creates a .json file so it can be used anywhere.

Example:
1. In engine you create a level with a given ID.
2. If the same ID was used to describe the level in this tool, the engine can read the list of next possible levels from the exported file
3. When the next room has to be generated you can fetch the list of possible next levels by using the current level ID. Each next level is described as [string : float] ([level_id : probability])
4. From this point on it's up to your implementation
