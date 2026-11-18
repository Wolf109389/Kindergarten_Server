from app.dao.base_dao import BaseDAO
from app.domain.schema import ENTITIES

class RelationDAO:
    def __init__(self):
        self.dao = BaseDAO(ENTITIES["employees"])

    def employee_groups(self, employee_id):
        return self.dao._fetch(
            "SELECT cg.* FROM child_groups cg "
            "JOIN employee_groups eg ON eg.group_id = cg.group_id "
            "WHERE eg.employee_id = %s ORDER BY cg.group_id", (employee_id,)
        )

    def group_employees(self, group_id):
        return self.dao._fetch(
            "SELECT e.* FROM employees e "
            "JOIN employee_groups eg ON eg.employee_id = e.employee_id "
            "WHERE eg.group_id = %s ORDER BY e.employee_id", (group_id,)
        )

    def all_employee_group_links(self):
        return self.dao._fetch(
            "SELECT employee_id, group_id FROM employee_groups "
            "ORDER BY employee_id, group_id"
        )
