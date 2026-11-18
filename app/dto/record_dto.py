"""DTO перетворює записи БД у JSON-сумісні дані без втрати точності грошей."""
from dataclasses import dataclass
from datetime import date, datetime
from decimal import Decimal

def json_value(value):
    if isinstance(value, (date, datetime)):
        return value.isoformat()
    if isinstance(value, Decimal):
        return format(value, ".2f")
    if isinstance(value, dict):
        return {key: json_value(item) for key, item in value.items()}
    if isinstance(value, (list, tuple)):
        return [json_value(item) for item in value]
    return value

@dataclass(frozen=True)
class RecordDTO:
    data: dict

    def to_dict(self):
        return json_value(self.data)
