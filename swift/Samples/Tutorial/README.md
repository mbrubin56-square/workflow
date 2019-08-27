# Tutorial

## Overview

Oh hai there! Looks like you wanna build some software with Workflows! It's a bit different from how we've been doing this before, so let's go through building a simple little TODO app to get the basics down.

## Layout

The project has both a starting point, as well as an example of the completed tutorial.

Nearly all of the software is in cocoapods under the `Frameworks` directory.

To help with the setup, there are already created a few helpers:
- `TutorialViews`: A set of 3 views for the 3 screens we will be building, `Welcome`, `TodoList`, and `TodoEdit`.
- `Tutorial`: This is the starting point to build out the tutorial. It contains view controllers that host the views from `TutorialViews` to see how they display.
    - Additionally, there is a `TutorialContainerViewController` that the appdelegate sets as the root view controller. This will be our launching point for all of our workflows.
- `TutorialFinal`: This is an example of the completed tutorial - could be used as a reference if you get stuck.

# Tutorial Steps

- [Tutorial 1](Tutorial1.md) - Single view backed by a workflow
- [Tutorial 2](Tutorial2.md) - Multiple views and navigation
- [Tutorial 3](Tutorial3.md) - State throughout a tree of workflows
- [Tutorial 4](Tutorial4.md) - Refactoring
