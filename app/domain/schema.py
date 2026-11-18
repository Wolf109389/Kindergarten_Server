"""Опис лише дозволених таблиць і полів наявної моделі з лабораторної 3."""
from dataclasses import dataclass

@dataclass(frozen=True)
class Field:
    kind: str
    nullable: bool = False
    max_length: int | None = None
    minimum: int | None = None
    maximum: int | None = None

@dataclass(frozen=True)
class Entity:
    name: str
    keys: tuple[str, ...]
    fields: dict[str, Field]
    auto_key: bool = True

def text(length, nullable=False):
    return Field("text", nullable=nullable, max_length=length)

def integer(minimum=1, maximum=2147483647):
    return Field("int", minimum=minimum, maximum=maximum)

def date(nullable=False):
    return Field("date", nullable=nullable)

money = Field("money")
ENTITIES = {
    "addresses": Entity("addresses", ("address_id",), {
        "city": text(50), "district": text(50, True), "street": text(100),
        "building_number": text(10), "postal_code": text(10, True),
    }),
    "kindergartens": Entity("kindergartens", ("kindergarten_id",), {
        "name": text(100), "address_id": integer(), "phone": text(20, True),
        "email": text(100, True),
    }),
    "positions": Entity("positions", ("positions_id",), {
        "name": text(100), "description": text(255, True),
    }),
    "employees": Entity("employees", ("employee_id",), {
        "last_name": text(50), "first_name": text(50), "middle_name": text(50, True),
        "birth_date": date(), "phone": text(20, True), "email": text(100, True),
    }),
    "employment_history": Entity("employment_history", ("employment_id",), {
        "employee_id": integer(), "kindergarten_id": integer(), "position_id": integer(),
        "hire_date": date(), "dismissal_date": date(True),
    }),
    "salary_payments": Entity("salary_payments", ("salary_payment_id",), {
        "employment_id": integer(), "salary_month": date(), "amount": money,
        "payment_date": date(True),
    }),
    "bonus_payments": Entity("bonus_payments", ("bonus_payment_id",), {
        "employment_id": integer(), "amount": money, "award_date": date(),
        "reason": text(255), "payment_date": date(True),
    }),
    "child_groups": Entity("child_groups", ("group_id",), {
        "kindergarten_id": integer(), "name": text(100), "age_min": integer(0, 127),
        "age_max": integer(0, 127), "capacity": integer(),
    }),
    "children": Entity("children", ("child_id",), {
        "last_name": text(50), "first_name": text(50), "middle_name": text(50, True),
        "birth_date": date(),
    }),
    "group_enrollments": Entity("group_enrollments", ("enrollment_id",), {
        "child_id": integer(), "group_id": integer(), "start_date": date(),
        "end_date": date(True), "departure_reason": text(255, True),
    }),
    "employee_groups": Entity("employee_groups", ("employee_id", "group_id"), {
        "employee_id": integer(), "group_id": integer(),
    }, auto_key=False),
}

# parent table, child table, foreign key in the child table.
RELATIONS = [
    ("addresses", "kindergartens", "address_id"),
    ("kindergartens", "child_groups", "kindergarten_id"),
    ("kindergartens", "employment_history", "kindergarten_id"),
    ("employees", "employment_history", "employee_id"),
    ("positions", "employment_history", "position_id"),
    ("employment_history", "salary_payments", "employment_id"),
    ("employment_history", "bonus_payments", "employment_id"),
    ("children", "group_enrollments", "child_id"),
    ("child_groups", "group_enrollments", "group_id"),
]
