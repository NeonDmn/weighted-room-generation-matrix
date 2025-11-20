This repo is my personal helper tool for managing randomly generated rooms, created with games like "DOORS" in mind.
For now it's harcoded to produce files that can only be imported into unreal if you have a data table with specifically named struct variables. I plan on making it more flexible in the future.
For now works only as a project on Godot 4.5

You start by providing a levelID and a display name. The display name doesn't matter and is only relevant to this program.
Creating a level adds it to the drawer on the left and to the level list on the right.
The drawer is where you select any level you've created.
By selecting a level inside the drawer and clicking "+" button that sits beside any level in a level list, you add the selected ID as the next spawn possibility to the level on the list.
The Idea is that every level has a list of possible next levels, and this tool lets you precisely control this list.
Every level added as a spawn possibility of another level also has a spawn probability.
I made it because my system required me to keep track of level id strings which were also level names in editor, so creating this kind of list or even updating after a one level name change would've been a pain.

Features:
- Create "levels" just by providing an id
- Add any created id (from the drawer) to any created id (on the list), yes, even to itself since the next level can also be the same as current if you want
- Basic mistake prevention. Any id can only be added to the level pool or the next level pool once
- Set spawn probabilities for every individual level in the next level list
- By the press of a button normalize all probabilities in the list so that the sum of their probabilities equals 100%
- Exporting created list as easy to read .json
- Importing lists by providing .json

Use example:
1. In engine you create a level with a given ID.
2. If the same ID was used to describe the level in this tool, the engine can read the list of next possible levels from the exported file
3. When the next room has to be generated you can fetch the list of possible next levels by using the current level ID. Each next level is described as a Map/Dictionary type entry [string : float] ([level_id : probability])
4. From this point on it's up to your implementation
