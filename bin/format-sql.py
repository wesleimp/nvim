import sys
import sqlparse

input = sys.stdin.read()
formatted_sql = sqlparse.format(
    input,
    keyword_case="upper",
    reindent=True,
    wrap_after=80,
    strip_comments=True,
    output_format="sql",
    identifier_case="lower",
    indent_after_first=True,
    indent_columns=True,
)

print(formatted_sql.strip())
