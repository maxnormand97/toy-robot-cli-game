# Toy Robot CLI Game

A simulation of a robot moving on a 6x6 square grid, implemented as a Ruby REPL command-line application.

---

## Note for reviewer

Thanks for taking the time to review this submission.

I have purposely left a concise commit history which you can follow to show my approach to the problem. Alternately in this document, I have outlined how I approached the problem and my use of AI during it. I hope you enjoy reading it, and I look forward to talking about the process and solution sometime!

## Requirements

- Ruby 3.0 or later

---

## Setup

Install dependencies:

```bash
bundle install
```

Install Git hooks:

```bash
bundle exec overcommit --install
```

Dependencies:

- `rubocop` (linting and code quality)
- `overcommit` (lightweight local quality gate for hooks)

---

## Running the Application

```bash
bundle exec ruby main.rb
```

The application starts an interactive REPL. Type commands at the `>` prompt.

---

## Running the Tests

```bash
bundle exec ruby -Itest test/test_grid.rb
bundle exec ruby -Itest test/test_robot.rb
bundle exec ruby -Itest test/test_main.rb
```

---

## Commands

- `PLACE X,Y,O`: Place robot at position X,Y facing N, E, S, or W
- `MOVE`: Move one step forward in the current direction
- `LEFT`: Turn 90 degrees to the left
- `RIGHT`: Turn 90 degrees to the right
- `REPORT`: Print current position and orientation (e.g. `1,2,N`)
- `HELP` or `?`: Show available commands
- `EXIT`: Quit the application

Commands are case-insensitive. `place 0,0,n` and `PLACE 0,0,N` are equivalent.

---

## Examples

```text
> PLACE 0,0,E
> MOVE
> REPORT
1,0,E

> PLACE 0,0,N
> MOVE
> MOVE
> RIGHT
> MOVE
> REPORT
1,2,E
```

---

## Assumptions and Design Decisions

### Grid coordinates are zero-based

The grid is 6x6. Valid coordinates are **0 to 5** on both axes. Position (0,0) is the south-west corner.

### PLACE can be issued multiple times

A second valid `PLACE` command will reposition the robot. This is explicitly supported per the spec: *"all other commands (including another PLACE) are to be obeyed"*.

### Pre-placement guidance

The spec states that commands issued before a valid `PLACE` should be *ignored*. This implementation intentionally deviates slightly by printing a clear guidance message (`Robot must be placed first using PLACE X,Y,O`) rather than failing silently. This was a deliberate UX decision to help users understand why nothing is happening, consistent with how real-world CLI tools behave.

If strict spec behavior is preferred, this can be switched to silent ignore with a small CLI change.

---

## Edge Cases Covered

- Out-of-bounds moves are rejected; robot stays in place
- Invalid PLACE format prints a usage message
- Invalid orientation (e.g. `PLACE 1,1,Q`) is rejected
- Out-of-bounds PLACE coordinates are rejected
- Decimal coordinates (e.g. `PLACE 1.5,2,N`) are rejected
- Extra arguments (e.g. `PLACE 1,2,N,EXTRA`) are rejected
- Lowercase and mixed-case commands are accepted
- Extra spaces in PLACE arguments are handled (e.g. `PLACE 1 , 2 , N`)
- Pre-placement commands print a guidance message

---

## Further Improvements to Consider

### Output after commands

For better discoverability, `MOVE` could optionally print the updated position after each successful move (or automatically call `REPORT`).

### Improved CLI output

CLI output could be improved with a presentation-focused gem such as `tty-prompt` or `colorize`.

### Grid and Robot Output

A dedicated presentation class could render a simple text grid after each valid command so users can see robot position visually.

### Multi-robot support

Extend the grid to track multiple named robots, with optional collision detection. This would require the `Grid` to manage occupancy state.

### Route history

Track the robot's movement history and expose it via a `HISTORY` command or on exit, useful for debugging or replay.

### Configurable grid size

Allow grid size to be passed as a CLI argument, for example: `ruby main.rb --grid-size 10`.

The separation between `Grid` and `Robot` was intentional to make this extension easier.

## Notes on development process and AI

AI was used to assist the development of this project. It was NOT used to code the whole thing rather as another pair of
eyes for code reviewing and also to discuss refactoring / extensions.

Typically my development process and how I work with AI goes like so:

1. I will use a markdown editor (Obsidian) as my primary source of note taking OR the code files themselves. There I will architect the approach myself. (Planning is a crucial step in good development practices)
2. Once I have a clear understanding of the problem then an approach to the problem I will then construct a concise prompt (Prompt engineering is extremely important in using these things efficiently), to critique my approach and output flaw recommendations and improvements
3. Then with a refined plan we can begin implementations. I will often code out the initial classes and methods myself (based on how much time I have), because its good to still practice coding and method recall (these things can make you lazy lol).
4. If the spec is clear, in this case it was. I will write out tests and test cases preferably as soon as possible. The more effort you put in at the start for this the more it pays off towards the end, I guess this is my approach to TDD.
5. Almost immediately I would set up some kind of linting enforcement or CI. For this task because I wanted to keep things lightweight, we have `rubocop` and `overcommit` as dev dependencies, this forces rubocop and tests to run on each commit to ensure no garbage is pushed up-stream (I did not do a feature branch based workflow for this thats 'overkill').
6. Before and during each commit I will often use Copilot (in ask mode) any suggestions and improvements for refactoring, I often leave TODO's and NOTE's myself to attack later. For commits I prefer to keep them small, atomic and detailed (good commit messages have saved my butt so many times!)
7. If I have a blocker and I'm running out of steam thats when I would use Agent mode (where it will do actual writing for you), with this I will still ensure I write out the problem clearly and all my debugging to give the Agent the best possible chance to a good solution. (Often in a chat I always enforce it to run lint and tests after any change).
8. I will use Agent mode as well for repetitive tasks and large refactoring changes, I will always review these changes and ask any questions about approach to solution if I don't understand something. If its a new concept or something that I haven't touched in a while I will switch to Ask mode and if I want to go on a learning tangent ( I do love tangents) I do it in another chat instance.
9. Then for new features or bug fixes we essentially rinse and repeat this: plan -> refine - implementation -> test -> refine -> lint and review -> commit

As the brief mentions *"put as much effort and care as you would in production code"*. Thus the reasoning of using AI as a critical code reviewer and also for general improvement tips and spec validation makes this code more production ready and safer. A single human can forget things, and make mistakes. A single human with the power to talk to incredibly intelligent LLM's (if used correctly) is a force to be reckoned with.
