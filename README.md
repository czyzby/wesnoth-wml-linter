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
the `path` parameter.

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
Wesnoth 1.16 tools on every push or pull request to a specific branch:

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
```

## Notes

Use `@v1` for the latest stable release. Use `@latest` for the latest
version directly from the default development branch.

Note that the linter script does not trigger `wmlscope` and omits
spellchecking due to false positives that can fail the workflow.
