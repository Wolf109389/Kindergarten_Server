from flask import Blueprint, jsonify, request, url_for
from app.domain.schema import ENTITIES, RELATIONS
from app.service.crud_service import CrudService
from app.service.relation_service import RelationService
from app.errors import APIError
from app.db import get_connection

api = Blueprint("api", __name__, url_prefix="/api")

def body():
    if not request.is_json:
        raise APIError("Вибери Body → raw → JSON і Content-Type: application/json", 415)
    return request.get_json()

def register_crud(entity):
    service = CrudService(entity)
    collection = "/" + entity.name
    key_path = "/".join(f"<int:{key}>" for key in entity.keys)

    def list_or_create():
        if request.method == "GET":
            rows = [dto.to_dict() for dto in service.list_all()]
            return jsonify(data=rows, count=len(rows))
        dto = service.create(body())
        values = dto.to_dict()
        location = url_for("api." + entity.name + "_item", **{key: values[key] for key in entity.keys})
        return jsonify(data=values), 201, {"Location": location}

    def item(**keys):
        key_values = tuple(keys[key] for key in entity.keys)
        if request.method == "GET":
            return jsonify(data=service.get(key_values).to_dict())
        if request.method == "PUT":
            return jsonify(data=service.update(key_values, body()).to_dict())
        service.delete(key_values)
        return "", 204

    api.add_url_rule(collection, entity.name + "_collection", list_or_create, methods=["GET", "POST"])
    api.add_url_rule(collection + "/" + key_path, entity.name + "_item", item, methods=["GET", "PUT", "DELETE"])

for entity in ENTITIES.values():
    register_crud(entity)

def register_relation(parent, child, field):
    def related(parent_id):
        result = RelationService().children_of(parent, child, field, parent_id)
        return jsonify(data=[dto.to_dict() for dto in result], count=len(result))
    api.add_url_rule(f"/{parent}/<int:parent_id>/{child}", parent + "_" + child, related)

for relation in RELATIONS:
    register_relation(*relation)

@api.get("/employees/<int:employee_id>/groups")
def employee_groups(employee_id):
    rows = RelationService().groups_for_employee(employee_id)
    return jsonify(data=[dto.to_dict() for dto in rows], count=len(rows))

@api.get("/child_groups/<int:group_id>/employees")
def group_employees(group_id):
    rows = RelationService().employees_for_group(group_id)
    return jsonify(data=[dto.to_dict() for dto in rows], count=len(rows))

@api.get("/relations/employees_groups")
def all_employees_with_groups():
    rows = RelationService().all_employees_with_groups()
    return jsonify(data=[dto.to_dict() for dto in rows], count=len(rows))

@api.get("/health")
def health():
    cursor = get_connection().cursor()
    try:
        cursor.execute("SELECT 1")
        cursor.fetchone()
    finally:
        cursor.close()
    return jsonify(status="ok", database="connected")
