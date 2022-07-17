# WML Linter

A GitHub Action for [Wesnoth](https://www.wesnoth.org/) add-ons.
Verifies WML files using the WML tools from a partially cloned
[Wesnoth repository](https://github.com/wesnoth/wesnoth).

## Usage

Create a `.github/workflows` folder in your GitHub repository.
Add a workflow that triggers this action. For more info, see
the following examples of GitHub workflows.

The Wesnoth version that the WML files are checked against can
be specified with the `wesnoth-version` parameter. It can match
any Wesnoth [branch](https://github.com/wesnoth/wesnoth/branches)
or [tag](https://github.com/wesnoth/wesnoth/tags).

The folder or file that should be validated can be specified with
the `path` parameter. Lists of directories or files separated by
spaces should also be accepted by most versions of the Wesnoth tools.

The `spellcheck` boolean parameter allows to turn on spellchecking
with `hunspell` against the `en-US` locale. Spellchecking is turned
off by default.

The `lint-flags` and `indent-flags` allow specifying additional
command line flags passed to the `wmllint` and `wmlindent` tools
respectively.

### Examples

A workflow that verifies WML files on every push to the repository,
as well as every pull request:

```yaml
name: lint

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
    - name: Repository checkout
      uses: actions/checkout@v2
    - name: Lint WML
      uses: czyzby/wesnoth-wml-linter@v1
```

A workflow that verifies WML files in the `units/` folder against
Wesnoth 1.16 tools on every push or pull request to a specific branch
with spellchecking and a `-K` flag that causes `wmllint` to ignore
certain warnings:

```yaml
name: lint

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
    - name: Repository checkout
      uses: actions/checkout@v2
    - name: Lint WML
      uses: czyzby/wesnoth-wml-linter@v1
      with:
        path: units/
        wesnoth-version: 1.16
        spellcheck: true
        lint-flags: -K
```

## Notes

Use `@v1` for the latest stable release. Use `@latest` for the latest
version directly from the default development branch.

Note that the linter script currently does not trigger the `wmlscope`
tool as it requires cloning the entire Wesnoth repository (and possibly
external add-ons) to correctly flag missing resources.
