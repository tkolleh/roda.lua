# Plan for Issue #16: Keep demo related files in the demo directory

## Objective
Move all demo-related files to the `demo/` directory to prevent polluting the root directory, while ensuring the ability to generate the demo GIF remains intact. Update references in code, documentation, and the `justfile` for a seamless experience.

## Current State
- `demo.lua` (root): The actual demo script used for recording.
- `demo.tape` (root): The VHS tape file used to generate the GIF.
- `demo/demo.lua`: An older/different version of the demo script.
- `docs/recording-demo.md`: Documentation on how to record the demo.
- `assets/demo.gif`: The generated GIF.

## Step-by-Step Plan

1. **Determine which demo script to use**
   - Compare `demo.lua` (root) and `demo/demo.lua` to determine which better demonstrates the capabilities of the project.
   - Select the better file, review it for any issues, and ensure it uses the correct `lx lua` shebang and path setup.
   - Move/save the chosen file to `demo/demo.lua` and delete the other one.
   - Ensure the comments at the top of the file reflect the new execution instructions (`just demo run` and `just demo record`).

2. **Move and Update `demo.tape`**
   - Move the VHS tape file: `mv demo.tape demo/demo.tape`
   - Update header comments in `demo.tape` to reflect the new paths.
   - Update the command typed in the tape to be `Type "just demo run"` (so the GIF shows the user using the just recipe).
   - Ensure the output path is correct (e.g., `Output assets/demo.gif`), assuming `just demo record` will run it from the root directory.

3. **Move Demo Documentation to `demo/`**
   - Move the markdown file: `mv docs/recording-demo.md demo/recording-demo.md`
   - Update `demo/recording-demo.md` to refer to its new location and reference the new `just demo run` and `just demo record` commands.
   - Update the main `README.md` to point to the new location of the recording demo documentation (`demo/recording-demo.md`).

4. **Create `demo/mod.just` and update `justfile`**
   - Create a new just module at `demo/mod.just` to contain the demo-related recipes.
   - Add explicit recipes:
     - `run`: A recipe that runs `lx lua -- demo/demo.lua`.
     - `record`: A recipe that runs `vhs demo/demo.tape`.
   - Update the main `justfile` to include this new module by adding `mod demo`.

5. **Test and Verify**
   - Run `just demo run` to ensure the script executes correctly.
   - Run `just demo record` to ensure the GIF is generated correctly in `assets/demo.gif` and the workflow remains intact.