-- создание необходимых объектов
-- таблица типов элементов чек-листов
create table if not exists checklist_item_type (
    id    serial
  , code  varchar(15) not null
  , name  varchar(50) not null
  , descr text
);

alter table if exists checklist_item_type add constraint chechlist_item_type_id_pk primary key (id);

alter table if exists checklist_item_type add constraint checklist_item_type_code_uk unique (code);

alter sequence if exists checklist_item_type_id_seq restart with 10000;

-- таблица чек-листов
create table if not exists checklist (
    id    bigserial
  , name  varchar(50) not null
  , descr text
);

alter table if exists checklist add constraint checklist_id_pk primary key (id);

alter sequence if exists checklist_id_seq restart with 10000;

-- таблица элементов чек-листов
create table if not exists checklist_item (
    id           bigserial
  , type_id      integer     not null
  , checklist_id bigint      not null  
  , name         varchar(50)
  , is_required  boolean     not null
  , descr        text
);

alter table if exists checklist_item add constraint checklist_item_id_pk primary key (id);

alter table if exists checklist_item add constraint checklist_item_type_id_fk foreign key (type_id) references checklist_item_type(id);

create index if not exists checklist_item_type_id_idx on checklist_item(type_id);

alter table if exists checklist_item add constraint checklist_item_checklist_id_fk foreign key (checklist_id) references checklist(id);

create index if not exists checklist_item_checklist_id_idx on checklist_item(checklist_id);

alter sequence if exists checklist_item_id_seq restart with 10000;

-- таблица иерархий проверяемых объектов
create table if not exists checked_object (
    id        bigserial
  , parent_id bigint
  , name      varchar(50)
  , descr     text
);

alter table if exists checked_object add constraint checked_object_id_pk primary key (id);

alter table if exists checked_object add constraint checked_object_parent_id_fk foreign key (parent_id) references checked_object(id);

create index if not exists check_object_parent_id_idx on checked_object(parent_id);

alter sequence if exists checked_object_id_seq restart with 10000;

-- таблица связи чек-листов с проверямыми объектами
create table if not exists crs_checklist_checked_object(
    id                bigserial
  , checklist_id      bigint    not null
  , checked_object_id bigint    not null
);

alter table if exists crs_checklist_checked_object add constraint crs_checklist_checked_object_checklist_id_fk foreign key (checklist_id) references checklist(id);

alter table if exists crs_checklist_checked_object add constraint crs_checklist_checked_object_checked_object_id_fk foreign key (checked_object_id) references checked_object(id);

create index if not exists crs_checklist_checked_object_checklist_id_checked_object_id_idx on crs_checklist_checked_object(checklist_id, checked_object_id);

alter sequence if exists crs_checklist_checked_object_id_seq restart with 10000;

-- таблица задач на проверку объектов
create table if not exists task (
    id                bigserial
  , checked_object_id bigint
  , name              varchar(50)
  , descr             text
);

alter table if exists task add constraint task_id_pk primary key (id);

alter table if exists task add constraint task_checked_object_id_fk foreign key (checked_object_id) references checked_object(id);

create index if not exists task_checked_object_id_idx on task(checked_object_id);

-- таблица связи задач с проверяемыми объектами
create table if not exists crs_task_checked_object (
    id                bigserial
  , task_id           bigint    not null
  , checked_object_id bigint    not null
);

alter table if exists crs_task_checked_object add constraint crs_task_checked_object_task_id_fk foreign key (task_id) references task(id);

alter table if exists crs_task_checked_object add constraint crs_task_checked_object_checked_object_id_fk foreign key (checked_object_id) references checked_object(id);

create index if not exists crs_task_checked_object_task_id_checked_object_id_idx on crs_task_checked_object(task_id, checked_object_id);

alter sequence if exists crs_task_checked_object_id_seq restart with 10000;
