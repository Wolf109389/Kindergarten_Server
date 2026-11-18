from datetime import date
from decimal import Decimal
import pytest
from app import create_app
from app.domain.schema import ENTITIES
from app.dto.record_dto import RecordDTO
from app.errors import APIError
from app.service.crud_service import CrudService

def test_money_and_date_dto():
    assert RecordDTO({"amount": Decimal("123.40"), "date": date(2026, 1, 2)}).to_dict() == {
        "amount": "123.40", "date": "2026-01-02"
    }

@pytest.mark.parametrize("value", [True, -1, "nan", "Infinity", "1.001", "100000000.00", {}, None])
def test_bad_amount(value):
    service = CrudService(ENTITIES["salary_payments"])
    with pytest.raises(APIError):
        service.validate({"employment_id": 1, "salary_month": "2026-09-01", "amount": value})

def test_missing_and_unknown_fields():
    service = CrudService(ENTITIES["children"])
    for body in [{}, [], {"child_id": 1}]:
        with pytest.raises(APIError): service.validate(body)

def test_dates_and_age_rules():
    service = CrudService(ENTITIES["group_enrollments"])
    for start, end in [("2026-02-30", None), ("2026-09-01", "2026-08-31"), ("20260901", None)]:
        with pytest.raises(APIError):
            service.validate({"child_id":1,"group_id":1,"start_date":start,"end_date":end})
    with pytest.raises(APIError):
        CrudService(ENTITIES["child_groups"]).validate({
            "kindergarten_id":1,"name":"Група","age_min":5,"age_max":3,"capacity":20
        })

def test_http_errors_without_database():
    client = create_app({"TESTING":True}).test_client()
    assert client.get("/not-found").status_code == 404
    assert client.post("/api/children",data="text").status_code == 415
    assert client.post("/api/children",json={}).status_code == 400
    assert client.post("/api/children",data="{",content_type="application/json").status_code == 400
