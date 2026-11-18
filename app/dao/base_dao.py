"""Лише тут виконуються SQL-запити. Значення передаються параметрами %s."""
from app.db import get_connection
from app.domain.schema import ENTITIES

class BaseDAO:
    def __init__(self, entity):
        # Імена таблиць/полів беруться тільки з внутрішнього списку ENTITIES.
        self.entity = ENTITIES[entity.name]

    def _fetch(self, sql, params=(), one=False):
        cursor = get_connection().cursor(dictionary=True, buffered=True)
        try:
            cursor.execute(sql, params)
            return cursor.fetchone() if one else cursor.fetchall()
        finally:
            cursor.close()

    def _where(self):
        return " AND ".join(f"`{key}` = %s" for key in self.entity.keys)

    def list_all(self):
        order = ", ".join(f"`{key}`" for key in self.entity.keys)
        return self._fetch(f"SELECT * FROM `{self.entity.name}` ORDER BY {order}")

    def get(self, keys):
        return self._fetch(
            f"SELECT * FROM `{self.entity.name}` WHERE {self._where()}", keys, one=True
        )

    def list_by(self, field, value):
        if field not in self.entity.fields:
            raise ValueError("Unknown internal relation field")
        order = ", ".join(f"`{key}`" for key in self.entity.keys)
        return self._fetch(
            f"SELECT * FROM `{self.entity.name}` WHERE `{field}` = %s ORDER BY {order}",
            (value,),
        )

    def create(self, values):
        fields = list(values)
        names = ", ".join(f"`{field}`" for field in fields)
        placeholders = ", ".join(["%s"] * len(fields))
        cursor = get_connection().cursor()
        try:
            cursor.execute(
                f"INSERT INTO `{self.entity.name}` ({names}) VALUES ({placeholders})",
                tuple(values[field] for field in fields),
            )
            if self.entity.auto_key:
                return (cursor.lastrowid,)
            return tuple(values[key] for key in self.entity.keys)
        finally:
            cursor.close()

    def update(self, keys, values):
        assignments = ", ".join(f"`{field}` = %s" for field in values)
        cursor = get_connection().cursor()
        try:
            cursor.execute(
                f"UPDATE `{self.entity.name}` SET {assignments} WHERE {self._where()}",
                tuple(values.values()) + tuple(keys),
            )
        finally:
            cursor.close()

    def delete(self, keys):
        cursor = get_connection().cursor()
        try:
            cursor.execute(
                f"DELETE FROM `{self.entity.name}` WHERE {self._where()}", keys
            )
        finally:
            cursor.close()
