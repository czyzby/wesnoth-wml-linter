import os
import re
from typing import Optional, Pattern, Set

ROOT_WESNOTH_FOLDER = "/wesnoth/"
FILE_NAME_PATTERN = re.compile(
    r'"(?:(.*)", line \d+)|(?:wmllint: converting (.*))|(?:wmlindent: (.*) changed)'
)
SPELLCHECK_PATTERN = re.compile(r'"(.*)", line \d+: possible misspelling')


def get_file_name(
    output_line: str, pattern: Pattern = FILE_NAME_PATTERN
) -> Optional[str]:
    match = pattern.search(output_line)
    return next(filter(None, match.groups())) if match else None


def get_list_of_files_from_linter_output(
    output: str, pattern: Pattern = FILE_NAME_PATTERN
) -> Set[str]:
    return {
        file if not file.startswith("./") else file[2:]
        for line in output.split("\n")
        if (file := get_file_name(line, pattern))
        and not file.startswith(ROOT_WESNOTH_FOLDER)
    }


def verify_cached_tool_outputs() -> bool:
    lint_output = os.environ["lint"]
    files_with_issues = get_list_of_files_from_linter_output(lint_output)
    if files_with_issues:
        print("\nThe following files have syntax issues reported by wmllint:")
        list(map(print, sorted(files_with_issues)))

    indent_output = os.environ["indent"]
    unformatted_files = get_list_of_files_from_linter_output(indent_output)
    if unformatted_files:
        print("\nThe following files have formatting issues reported by wmlindent:")
        list(map(print, sorted(unformatted_files)))

    spellcheck_output = os.environ["spellcheck"]
    files_with_typos = get_list_of_files_from_linter_output(
        spellcheck_output, pattern=SPELLCHECK_PATTERN
    )
    if files_with_typos:
        print("\nThe following files have possible misspellings reported by hunspell:")
        list(map(print, sorted(files_with_typos)))

    return bool(files_with_issues or unformatted_files or files_with_typos)


if __name__ == "__main__":
    are_files_invalid = verify_cached_tool_outputs()
    exit(are_files_invalid)
