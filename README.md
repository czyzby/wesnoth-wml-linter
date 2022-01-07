# WML Linter

A GitHub Action for [Wesnoth](https://www.wesnoth.org/) add-ons.
Verifies WML files using the WML tools from a partially cloned
[Wesnoth repository](https://github.com/wesnoth/wesnoth).

## Usage

Create a `.github/workflows` folder in your GitHub repository.
Add a workflow that triggers this action. For more info, see
the following examples of GitHub workflows.

### Examples

A workflow that verifies WML files on every push to the repository,
as well as every pull request:

```yaml
name: lint

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Repository checkout
      uses: actions/checkout@v2
    - name: WML Lint
      uses: czyzby/wesnoth-wml-linter@v1
```

A workflow that verifies WML files on every push or pull request
to a specific branch:

```yaml
name: lint

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Repository checkout
      uses: actions/checkout@v2
    - name: WML Lint
      uses: czyzby/wesnoth-wml-linter@v1
```

## Notes

Use `@v1` for the latest stable release. Use `@latest` for the latest
version directly from the default development branch.

Note that the linter script does not trigger `wmlscope` or perform
spellchecking due to false positives that can fail the workflow.
