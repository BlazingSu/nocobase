import re
from typing import List, Dict


def map_sql_type(sql_type: str) -> str:
    sql_type = sql_type.lower()
    if sql_type.startswith("int") or sql_type.startswith("bigint"):
        return "integer"
    if sql_type.startswith("float") or sql_type.startswith("double") or sql_type.startswith("decimal"):
        return "float"
    if sql_type.startswith("bool") or sql_type == "tinyint(1)":
        return "boolean"
    if sql_type.startswith("date") and not sql_type.startswith("datetime"):
        return "date"
    if sql_type.startswith("timestamp") or sql_type.startswith("datetime"):
        return "datetime"
    if sql_type.startswith("text"):
        return "text"
    return "string"


def parse_sql_file(path: str) -> List[Dict[str, any]]:
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    tables = []
    pattern = re.compile(r"CREATE\s+TABLE\s+`?(\w+)`?\s*\((.*?)\);", re.S | re.I)
    for table_name, body in pattern.findall(content):
        fields = []
        columns = [c.strip() for c in re.split(r",\s*(?![^()]*\))", body) if c.strip()]
        for col in columns:
            if col.upper().startswith("PRIMARY KEY") or col.upper().startswith("CONSTRAINT") or col.upper().startswith("FOREIGN KEY"):
                continue
            m = re.match(r"`?(\w+)`?\s+([\w()]+)", col)
            if not m:
                continue
            name, dtype = m.groups()
            field_type = map_sql_type(dtype)
            interface = "textarea" if field_type == "text" else "input"
            fields.append({"name": name, "type": field_type, "interface": interface})
        tables.append({"name": table_name, "fields": fields})
    return tables
