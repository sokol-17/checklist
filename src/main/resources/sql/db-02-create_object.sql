-- создание необходимых объектов
-- таблица типов элементов чек-листов
create table if not exists item_type (
    id    serial
  , code  varchar(15) not null
  , name  varchar(50) not null
  , descr text
);

alter table if exists item_type add constraint item_type_id_pk   primary key (id);
alter table if exists item_type add constraint item_type_code_uk unique (code);
alter sequence if exists item_type_id_seq restart with 10000;

comment on table item_type is 'Типы элементов чек-листов';
comment on column item_type.id    is 'Идентификатор';
comment on column item_type.code  is 'Код';
comment on column item_type.name  is 'Название';
comment on column item_type.descr is 'Описание';

insert into item_type (id, code, name, descr) values (10, 'label', 'Этикетка', 'Текстовое поле без возможности изменения');
insert into item_type (id, code, name, descr) values (20, 'number', 'Числовое поле', 'Поле для ввода числовых значений');
insert into item_type (id, code, name, descr) values (30, 'text', 'Текстовое поле', 'Текстовое поле');
insert into item_type (id, code, name, descr) values (40, 'date', 'Дата и время', 'Дата и время');
insert into item_type (id, code, name, descr) values (50, 'choice', 'Выбор одного элемента', 'Выбор одного элемента из нескольких');
insert into item_type (id, code, name, descr) values (60, 'multi_choice', 'Выбор нескольких элементов', 'Множественный выбор из нескольких элементов');
insert into item_type (id, code, name, descr) values (70, 'interval', 'Интервальные значения', 'Возможно этот тип должен быть на другом уровне');
insert into item_type (id, code, name, descr) values (100, 'custom', 'Выбор нескольких элементов', 'Множественный выбор из нескольких элементов');
commit;

-- таблица списков
create table if not exists value_list (
    id        serial
  , parent_id bigint
  , value     varchar(100)
);

alter table if exists value_list add constraint value_list_id_pk primary key (id);
alter table if exists value_list add constraint value_list_parent_id_fk foreign key (parent_id) references value_list(id);
create index if not exists value_list_parent_id_idx on value_list(parent_id);
alter sequence if exists value_list_id_seq restart with 10000;

comment on table value_list is 'Список возможных значений';
comment on column value_list.id        is 'Идентификатор';
comment on column value_list.parent_id is 'Ссылка на список';
comment on column value_list.value     is 'Название списка, если parent_id is null, иначе значение';

-- таблица чек-листов
create table if not exists checklist (
    id    bigserial
  , name  varchar(50) not null
  , descr text
);

alter table if exists checklist add constraint checklist_id_pk primary key (id);
alter sequence if exists checklist_id_seq restart with 10000;

comment on table checklist is 'Чек-листы';
comment on column checklist.id    is 'Идентификатор';
comment on column checklist.name  is 'Название';
comment on column checklist.descr is 'Описание';

-- таблица элементов чек-листов
create table if not exists item (
    id            bigserial
  , type_id       integer     not null default 10
  , name          varchar(50)
  , is_required   boolean     not null default false
  , is_available  boolean     not null default true
  , serial_number numeric
  , list_id       bigint
  , mask          varchar(50)
  , min           numeric
  , max           numeric
  , descr         text
);

alter table if exists item add constraint item_id_pk primary key (id);
alter table if exists item add constraint item_type_id_fk foreign key (type_id) references item_type(id);
alter table if exists item add constraint item_type_list_id_fk foreign key (list_id) references value_list(id);
create index if not exists item_type_id_idx on item(type_id);
alter sequence if exists item_id_seq restart with 10000;

comment on table item is 'Элементы чек-листа';
comment on column item.id            is 'Идентификатор';
comment on column item.type_id       is 'Тип элемента';
comment on column item.name          is 'Название';
comment on column item.is_required   is 'Обязателен к выполнению?';
comment on column item.is_available  is 'Доступен?';
comment on column item.serial_number is 'Доступен?';
comment on column item.list_id       is 'Список значений (для выбора из списка)';
comment on column item.mask          is 'Маска (для чисел, дат)';
comment on column item.min           is 'Минимальное значение (для чисел)';
comment on column item.max           is 'Максимальное значение (для чисел)';
comment on column item.descr         is 'Описание';

-- таблица связи чек-листов и элементов
create table if not exists crs_checklist_item (
    id           bigserial
  , checklist_id bigint    not null
  , item_id      bigint    not null
);

alter table if exists crs_checklist_item add constraint crs_checklist_item_id_pk primary key (id);
alter table if exists crs_checklist_item add constraint crs_checklist_item_checklist_id_fk foreign key (checklist_id) references checklist(id);
alter table if exists crs_checklist_item add constraint crs_checklist_item_item_id_fk      foreign key (item_id)      references item(id);
create index if not exists crs_checklist_item_checklist_id_item_id_idx on crs_checklist_item(checklist_id, item_id);

comment on table crs_checklist_item is 'Связь между чек-листом и элементом';
comment on column crs_checklist_item.id           is 'Идентификатор';
comment on column crs_checklist_item.checklist_id is 'Чек-лист';
comment on column crs_checklist_item.item_id      is 'Элемент чек-листа';

-- таблица проверяемых объектов
create table if not exists object (
    id        bigserial
  , parent_id bigint
  , name      varchar(50)
  , descr     text
);

alter table if exists object add constraint object_id_pk primary key (id);
alter table if exists object add constraint object_parent_id_fk foreign key (parent_id) references object(id);
create index if not exists check_object_parent_id_idx on object(parent_id);
alter sequence if exists object_id_seq restart with 10000;

comment on table object is 'Проверяемые объекты';
comment on column object.id        is 'Идентификатор';
comment on column object.parent_id is 'Родительский объект (для иерархических объектов)';
comment on column object.name      is 'Название';
comment on column object.descr     is 'Описание';

-- таблица статусов задач
create table if not exists task_status (
    id     bigserial
  , status varchar(10)
  , descr  text
);

alter table if exists task_status add constraint task_status_id_pk primary key (id);
alter sequence if exists task_status_id_seq restart with 1000;

comment on table task_status is 'Статусы задач';
comment on column task_status.id    is 'Идентификатор';
comment on column task_status.status is 'Статус';
comment on column task_status.descr  is 'Описание';

insert into task_status (id, status, descr) values (10, 'Новая', 'Новая задача');
insert into task_status (id, status, descr) values (20, 'Назначена', 'Назначена на исполнителя');
insert into task_status (id, status, descr) values (30, 'В работе', 'Взята в работу');
insert into task_status (id, status, descr) values (40, 'Выполнена', 'Выполнена');
insert into task_status (id, status, descr) values (50, 'Закрыта', 'Закрыта');
commit;

-- таблица задач на проверку объектов
create table if not exists task (
    id           bigserial
  , name         varchar(50)               not null
  , status_id    bigint                    not null default 1
  , dt_begin     timestamp with time zone
  , dt_end       timestamp with time zone
  , dt_completed timestamp with time zone
  , checklist_id bigint
  , descr        text
);

alter table if exists task add constraint task_id_pk primary key (id);
alter table if exists task add constraint task_status_id_pk foreign key (status_id) references task_status(id);
alter table if exists task add constraint task_checklist_id_fk foreign key (checklist_id) references checklist(id);
create index if not exists taask_checklist_id_idx on task(checklist_id);
create index if not exists task_status_id_idx on task(status_id);
alter sequence if exists task_id_seq restart with 10000;

comment on table task is 'Задачи на проверку';
comment on column task.id           is 'Идентификатор';
comment on column task.name         is 'Название';
comment on column task.status_id    is 'Статус задачи';
comment on column task.dt_begin     is 'Дата и время, когда нужно начать задачу';
comment on column task.dt_end       is 'Дата и время, когда нужно завершить задачу';
comment on column task.dt_completed is 'Дата и время завершения задачи';
comment on column task.checklist_id is 'Чек-лист';
comment on column task.descr        is 'Описание';

-- таблица связи задач с проверяемыми объектами
create table if not exists crs_task_object (
    id        bigserial
  , task_id   bigint    not null
  , object_id bigint    not null
);

alter table if exists crs_task_object add constraint crs_task_object_task_id_fk foreign key (task_id) references task(id);
alter table if exists crs_task_object add constraint crs_task_object_object_id_fk foreign key (object_id) references object(id);
create index if not exists crs_task_object_task_id_object_id_idx on crs_task_object(task_id, object_id);
alter sequence if exists crs_task_object_id_seq restart with 10000;

comment on table crs_task_object is 'Связь задач с объектам';
comment on column crs_task_object.id        is 'Идентификатор';
comment on column crs_task_object.task_id   is 'Задача';
comment on column crs_task_object.object_id is 'Проверяемый объект';

-- таблица результатов проведенных проверок
create table if not exists task_result (
    id           bigserial
  , task_id      bigint
  , checklist_id bigint
  , item_id      bigint
  , number_value numeric
  , text_value   text
  , date_value   date
  , value_id     bigint
);

alter table if exists task_result add constraint task_result_id_pk primary key (id);
alter table if exists task_result add constraint task_result_task_id_fk foreign key (task_id) references task(id);
alter table if exists task_result add constraint task_result_checklist_id_fk foreign key (checklist_id) references checklist(id);
alter table if exists task_result add constraint task_result_item_id_fk foreign key (item_id) references item(id);
alter table if exists task_result add constraint task_result_value_id_fk foreign key (value_id) references value_list(id);
create index if not exists task_result_task_id_checklist_id_item_id_idx on task_result(task_id, checklist_id, item_id);
alter sequence if exists task_result_id_seq restart with 10000;

comment on table task_result is 'Результаты проверок';
comment on column task_result.id           is 'Идентификатор';
comment on column task_result.task_id      is 'Задача';
comment on column task_result.checklist_id is 'Чек-лист';
comment on column task_result.item_id      is 'Элемент чек-листа';
comment on column task_result.number_value is 'Поле для хранения числовых значений';
comment on column task_result.text_value   is 'Поле для хранения текстовых значений';
comment on column task_result.date_value   is 'Поле для хранение даты и времени';
comment on column task_result.value_id     is 'Поле для хранение ссылки на справочник';
