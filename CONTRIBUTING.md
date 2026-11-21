# Contributing
If you'd like to contribute to the mod, please create a fork of this repository and develop whatever features, fixes, or other work you'd like to include in a branch on that fork. Then, create a pull request to merge your branch in.

Tips for ensuring your pull request is merged quickly and smoothly:
* Pull requests that try to accomplish too many different, unrelated goals may take longer to merge as more code will need to be reviewed. This also makes keeping a log of work more difficult for the development team reviewing your pull request. To ensure your pull request is accepted in a timely manner, please create one pull request for each unrelated feature, bug fix, or other contribution you'd like to make. If a pull request contains too many unrelated items, it may be denied outright.
* Pull requests that do not contain a reasonably detailed description of what work was done may be denied or a description may be requested. This not only takes extra time from you, but also the developer or developers reviewing your work.
* To ensure your pull request is reviewed quickly, and to reduce the strain on the developer reviewing your work, please follow good practices when committing to your branch. Commit early, commit often, and write clean, concise, and detailed commit messages. This helps developers understand your development process, and will help your pull request move smoothly through the review. While pull requests that do not follow this guideline will not be denied for it, your pull request may take longer to be reviewed and approved.

## Testing
The cockpit scripts have tests in `tests/` that run them against stubs of the DCS cockpit API. Run them, and add or update tests for the scripts you change, before opening a pull request. They need the Lua 5.1 that DCS ships; from the repository root:

```
"C:\Program Files\Eagle Dynamics\DCS World\bin\luae.exe" tests\run.lua
```

This runs every `tests/test_*.lua` and checks that every Lua file in the mod parses.
