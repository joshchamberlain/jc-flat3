DROP TABLE CONCERN_COMPONENT_EDGE IF EXISTS;
DROP TABLE CONCERN_EDGE IF EXISTS;
DROP TABLE COMPONENT_EDGE IF EXISTS;
DROP TABLE COMPONENT_DOMAIN IF EXISTS;
DROP TABLE COMPONENT IF EXISTS;
DROP TABLE COMPONENT_KIND IF EXISTS;
DROP TABLE EDGE_KIND IF EXISTS;
DROP TABLE CONCERN_DOMAIN IF EXISTS;
DROP TABLE CONCERN IF EXISTS;
DROP SEQUENCE COMPONENT_ID_SEQ IF EXISTS;
DROP SEQUENCE CONCERN_ID_SEQ IF EXISTS;

CREATE SEQUENCE COMPONENT_ID_SEQ AS INTEGER START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE CONCERN_ID_SEQ AS INTEGER START WITH 1 INCREMENT BY 1;

CREATE TABLE COMPONENT_KIND (
id INTEGER NOT NULL PRIMARY KEY ,
name VARCHAR(255) NOT NULL,
CONSTRAINT kindnameuniq UNIQUE(name)
);

CREATE TABLE COMPONENT (
component_id_seq INTEGER  NOT NULL PRIMARY KEY,
name VARCHAR(255)  NOT NULL,
kind_id INTEGER NOT NULL,
handle VARCHAR(255) NOT NULL,
begin_line INTEGER DEFAULT '0' NULL,
begin_col INTEGER DEFAULT '0' NULL,
end_line INTEGER DEFAULT '0' NULL,
end_col INTEGER DEFAULT '0' NULL,
num_lines INTEGER DEFAULT '0' NULL,
UNIQUE(handle),
CONSTRAINT compkindidforeign FOREIGN KEY (kind_id) REFERENCES COMPONENT_KIND (id)
ON UPDATE CASCADE 
ON DELETE RESTRICT
);

CREATE TABLE COMPONENT_DOMAIN (
id INTEGER  NOT NULL PRIMARY KEY,
source_language VARCHAR(255) NOT NULL,
name VARCHAR(255) NOT NULL,
CONSTRAINT compnameunique UNIQUE(name),
CONSTRAINT compidforeign FOREIGN KEY (id) REFERENCES COMPONENT (component_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT
);

CREATE TABLE EDGE_KIND (
edge_kind_id INTEGER  NOT NULL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
UNIQUE(name)
);


CREATE TABLE COMPONENT_EDGE (
from_id INTEGER  NOT NULL,
to_id INTEGER  NOT NULL,
edge_kind_id INTEGER  NOT NULL,
PRIMARY KEY (from_id,to_id,edge_kind_id),
CONSTRAINT compedgefromforeign FOREIGN KEY (from_id) REFERENCES COMPONENT (component_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT,
CONSTRAINT compedgetoforeign FOREIGN KEY (to_id) REFERENCES COMPONENT (component_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT,
CONSTRAINT compedgekindforeign FOREIGN KEY (edge_kind_id) REFERENCES EDGE_KIND (edge_kind_id)
ON UPDATE CASCADE
ON DELETE RESTRICT
);


CREATE TABLE CONCERN (
concern_id_seq INTEGER  NOT NULL PRIMARY KEY ,
name vARCHAR(255) NOT NULL,
short_name vARCHAR(255) NOT NULL,
description vaRCHAR(255)  NULL,
color vARCHAR(255)  NULL
);


CREATE TABLE CONCERN_COMPONENT_EDGE (
from_id INTEGER  NOT NULL,
to_id INTEGER  NOT NULL,
edge_kind_id INTEGER  NOT NULL,
CONSTRAINT cceprimkey PRIMARY KEY (from_id,to_id,edge_kind_id),
CONSTRAINT ccfromidforeign FOREIGN KEY (from_id) REFERENCES CONCERN (concern_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT,
CONSTRAINT cctoidforeign FOREIGN KEY (to_id) REFERENCES COMPONENT (component_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT,
CONSTRAINT ccedgekindforeign FOREIGN KEY (edge_kind_id) REFERENCES EDGE_KIND (edge_kind_id)
ON UPDATE CASCADE
ON DELETE RESTRICT
);

CREATE TABLE CONCERN_EDGE (
from_id INTEGER  NOT NULL,
to_id INTEGER  NOT NULL,
edge_kind_id INTEGER  NOT NULL,
PRIMARY KEY (from_id,to_id,edge_kind_id),
CONSTRAINT cfromidforeign FOREIGN KEY (from_id) REFERENCES CONCERN (concern_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT,
CONSTRAINT ctoidforeign FOREIGN KEY (to_id) REFERENCES CONCERN (concern_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT,
CONSTRAINT cedgekindforeign FOREIGN KEY (edge_kind_id) REFERENCES EDGE_KIND (edge_kind_id)
ON UPDATE CASCADE
ON DELETE RESTRICT
);

CREATE TABLE CONCERN_DOMAIN (
id iNTEGER  NOT NULL,
name vARCHAR(255)  NOT NULL PRIMARY KEY,
short_name vaRCHAR(255)  NOT NULL,
description vaRCHAR(255)  NOT NULL,
kind vaRCHAR(255)  NOT NULL,
UNIQUE(name),
CONSTRAINT concernidforeign FOREIGN KEY (id) REFERENCES CONCERN (concern_id_seq)
ON UPDATE CASCADE
ON DELETE RESTRICT
);

insert into component_kind values(1,'PROJECT');
insert into component_kind values(2,'PACKAGE');
insert into component_kind values(3,'CLASS');
insert into component_kind values(4,'METHOD');
insert into component_kind values(5,'FIELD');
insert into component_kind values(6,'STATEMENT');
insert into component_kind values(7,'FILE');

insert into edge_kind values(1, 'CONTAINS');
insert into edge_kind values(2, 'RELATED_TO');
insert into edge_kind values(3, 'EXECUTED_BY');
insert into edge_kind values(4, 'DEPENDS_ON_REMOVAL');
insert into edge_kind values(5, 'FIXED_FOR');

COMMIT;
SHUTDOWN;