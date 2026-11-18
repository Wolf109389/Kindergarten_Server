from app.dao.base_dao import BaseDAO
from app.dao.relation_dao import RelationDAO
from app.domain.schema import ENTITIES
from app.dto.record_dto import RecordDTO
from app.service.crud_service import CrudService

class RelationService:
    def __init__(self):
        self.dao = RelationDAO()

    def children_of(self, parent, child, field, parent_id):
        CrudService(ENTITIES[parent]).get((parent_id,))
        return [RecordDTO(row) for row in BaseDAO(ENTITIES[child]).list_by(field, parent_id)]

    def groups_for_employee(self, employee_id):
        CrudService(ENTITIES["employees"]).get((employee_id,))
        return [RecordDTO(row) for row in self.dao.employee_groups(employee_id)]

    def employees_for_group(self, group_id):
        CrudService(ENTITIES["child_groups"]).get((group_id,))
        return [RecordDTO(row) for row in self.dao.group_employees(group_id)]

    def all_employees_with_groups(self):
        employees = BaseDAO(ENTITIES["employees"]).list_all()
        groups = {row["group_id"]: row for row in BaseDAO(ENTITIES["child_groups"]).list_all()}
        linked = {}
        for link in self.dao.all_employee_group_links():
            linked.setdefault(link["employee_id"], []).append(groups[link["group_id"]])
        return [RecordDTO({**row, "groups": linked.get(row["employee_id"], [])}) for row in employees]
