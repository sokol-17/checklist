insert into checked_object (id, parent_id, name, descr) values (1001, null, 'НИИ ЧаВо', null);
insert into checked_object (id, parent_id, name, descr) values (1002, 1001, 'Отдел Линейного Счастья', 'зав. Фёдор Симеонович Киврин');
insert into checked_object (id, parent_id, name, descr) values (1003, 1001, 'Отдел Универсальных Превращений', 'зав. Жиан Жиакомо');
insert into checked_object (id, parent_id, name, descr) values (1004, 1001, 'Вычислительный центр', 'зав. Александр Иванович Привалов');

insert into checklist (id, name, descr) values (1001, 'Проверка пожарной безопасности', null);
insert into checklist (id, name, descr) values (1002, 'Проверка ИБ', null);

insert into checklist_item (id, type_id, checklist_id, name, is_required, descr) values (1001, 1, 1001, 'Есть пожарный щит?', true, 'Возможные значения: "Да", "Нет" и "Не определено"');
insert into checklist_item (id, type_id, checklist_id, name, is_required, descr) values (1002, 2, 1001, 'Есть ли на пожарном щите следующие элементы?', false, 'Возможные значения: "Ведро", "Багор", "Лопата", "Топор"');
insert into checklist_item (id, type_id, checklist_id, name, is_required, descr) values (1003, 3, 1001, 'Уровень пожарной опасности?', true, 'Возможные значения: "1 класс – опасности нет", "2 класс – малая пожарная опасность", "3 класс – средняя пожарная опасность", "4 класс – высокая пожарная опасность", "5 класс – чрезвычайная пожарная опасность');
insert into checklist_item (id, type_id, checklist_id, name, is_required, descr) values (1004, 4, 1001, 'Объем помещения?', true, null);
insert into checklist_item (id, type_id, checklist_id, name, is_required, descr) values (1005, 4, 1001, 'Оценка защищенности', true, '"Возможные значения: от 1 до 10"');
insert into checklist_item (id, type_id, checklist_id, name, is_required, descr) values (1006, 5, 1001, 'Краткая характеристика объкта', true, null);

insert into crs_checklist_checked_object (id, checklist_id, checked_object_id) values (1001, 1001, 1001);
insert into crs_checklist_checked_object (id, checklist_id, checked_object_id) values (1001, 1002, 1001);

insert into task (id, checked_object_id, name, descr) values(1001, 1001, 'Проверка систем безопасности', null);

insert into crs_task_checked_object (id, task_id, checked_object_id) values(1001, 1001, 1004);

commit;