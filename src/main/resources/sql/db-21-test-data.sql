insert into object (id, parent_id, name, descr) values (1001, null, 'НИИ ЧаВо', null);
insert into object (id, parent_id, name, descr) values (1002, 1001, 'Отдел Линейного Счастья', 'зав. Фёдор Симеонович Киврин');
insert into object (id, parent_id, name, descr) values (1003, 1001, 'Отдел Универсальных Превращений', 'зав. Жиан Жиакомо');
insert into object (id, parent_id, name, descr) values (1004, 1001, 'Вычислительный центр', 'зав. Александр Иванович Привалов');

insert into checklist (id, name, descr) values (1001, 'Проверка пожарной безопасности', null);
insert into checklist (id, name, descr) values (1002, 'Проверка ИБ', null);

commit;