import os
import re
from typing import Optional, Pattern, Set

ROOT_WESNOTH_FOLDER = "/wesnoth/"
FILE_NAME_PATTERN = re.compile(
    r'"(?:(.*)", line \d+)|(?:wmllint: converting (.*))|(?:wmlindent: (.*) changed)'
)
SPELLCHECK_PATTERN = re.compile(r'"(.*)", line \d+: possible misspelling')


def get_file_name(
    output_line: str,
    include: Pattern = FILE_NAME_PATTERN,
    exclude: Optional[Pattern] = None,
) -> Optional[str]:
    if exclude and exclude.search(output_line):
        return None
    match = include.search(output_line)
    return next(filter(None, match.groups())) if match else None


def get_list_of_files_from_linter_output(
    output: str, include: Pattern = FILE_NAME_PATTERN, exclude: Optional[Pattern] = None
) -> Set[str]:
    return {
        file if not file.startswith("./") else file[2:]
        for line in output.split("\n")
        if (file := get_file_name(line, include, exclude))
        and not file.startswith(ROOT_WESNOTH_FOLDER)
    }


def report_on_cached_tool_outputs() -> None:
    lint_output = os.environ["lint"]
    files_with_issues = get_list_of_files_from_linter_output(
        lint_output, exclude=SPELLCHECK_PATTERN
    )
    if files_with_issues:
        print("\nThe following files have syntax issues reported by wmllint:")
        list(map(print, sorted(files_with_issues)))

    indent_output = os.environ["indent"]
    unformatted_files = get_list_of_files_from_linter_output(indent_output)
    if unformatted_files:
        print("\nThe following files have formatting issues reported by wmlindent:")
        list(map(print, sorted(unformatted_files)))

    files_with_typos = get_list_of_files_from_linter_output(
        lint_output, include=SPELLCHECK_PATTERN
    )
    if files_with_typos:
        print("\nThe following files have possible misspellings reported by hunspell:")
        list(map(print, sorted(files_with_typos)))


if __name__ == "__main__":
    report_on_cached_tool_outputs()
