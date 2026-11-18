import re
from datetime import date
from decimal import Decimal, InvalidOperation
from app.dao.base_dao import BaseDAO
from app.db import get_connection
from app.dto.record_dto import RecordDTO
from app.errors import APIError

class CrudService:
    def __init__(self, entity):
        self.entity = entity
        self.dao = BaseDAO(entity)

    def list_all(self):
        return [RecordDTO(row) for row in self.dao.list_all()]

    def get(self, keys):
        row = self.dao.get(keys)
        if row is None:
            raise APIError("Запис не знайдено", 404)
        return RecordDTO(row)

    def _value(self, name, value, field):
        if value is None:
            if field.nullable:
                return None
            raise APIError(f"Поле {name} не може бути null")
        if field.kind == "text":
            if not isinstance(value, str) or not value.strip():
                raise APIError(f"Поле {name} має бути непорожнім текстом")
            if len(value) > field.max_length:
                raise APIError(f"Поле {name}: максимум {field.max_length} символів")
            return value
        if field.kind == "int":
            if type(value) is not int or not field.minimum <= value <= field.maximum:
                raise APIError(f"Поле {name}: потрібне ціле число від {field.minimum} до {field.maximum}")
            return value
        if field.kind == "date":
            if not isinstance(value, str) or not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
                raise APIError(f"Поле {name}: формат дати YYYY-MM-DD")
            try:
                result = date.fromisoformat(value)
                if result.year < 1000:
                    raise ValueError()
                return result
            except ValueError:
                raise APIError(f"Поле {name}: некоректна дата") from None
        if field.kind == "money":
            if isinstance(value, bool) or not isinstance(value, (str, int, float)):
                raise APIError(f"Поле {name}: потрібна сума")
            try:
                amount = Decimal(str(value))
                if not amount.is_finite() or amount < 0 or amount > Decimal("99999999.99"):
                    raise InvalidOperation()
                if amount != amount.quantize(Decimal("0.01")):
                    raise InvalidOperation()
                return amount
            except (InvalidOperation, ValueError):
                raise APIError(f"Поле {name}: невід’ємна сума з максимум 2 знаками після крапки") from None
        raise ValueError("Unsupported internal field type")

    def validate(self, data):
        if not isinstance(data, dict):
            raise APIError("Тіло запиту має бути JSON-об’єктом")
        unknown = set(data) - set(self.entity.fields)
        if unknown:
            raise APIError("Зайві або незмінні поля: " + ", ".join(sorted(unknown)))
        values = {}
        for name, field in self.entity.fields.items():
            if name not in data and not field.nullable:
                raise APIError(f"Відсутнє обов’язкове поле {name}")
            values[name] = self._value(name, data.get(name), field)
        if self.entity.name == "child_groups" and values["age_min"] > values["age_max"]:
            raise APIError("age_min не може перевищувати age_max")
        for start, end in [("hire_date", "dismissal_date"), ("start_date", "end_date")]:
            if start in values and values.get(end) is not None and values[end] < values[start]:
                raise APIError(f"{end} не може бути раніше за {start}")
        if "birth_date" in values and values["birth_date"] > date.today():
            raise APIError("Дата народження не може бути в майбутньому")
        return values

    def create(self, data):
        values = self.validate(data)
        keys = self.dao.create(values)
        result = self.get(keys)
        get_connection().commit()
        return result

    def update(self, keys, data):
        values = self.validate(data)
        self.get(keys)
        self.dao.update(keys, values)
        # For employee_groups a PUT can change the composite key as a whole.
        new_keys = keys if self.entity.auto_key else tuple(values[k] for k in self.entity.keys)
        result = self.get(new_keys)
        get_connection().commit()
        return result

    def delete(self, keys):
        self.get(keys)
        self.dao.delete(keys)
        get_connection().commit()
