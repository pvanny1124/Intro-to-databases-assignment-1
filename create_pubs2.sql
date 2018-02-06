/* use your database e.g. use F16336pbarnett; then create the tables */
/* I recommend that you input the DML statements in groups as delimited by c-style comments*/
create table authors
        (au_id varchar(11) not null,
        au_lname varchar(40) not null,
        au_fname varchar(20) not null,
        phone char(12) not null,
        address varchar(40) null,
        city varchar(20) null,
        state char(2) null,
        country varchar(12) null,
        postalcode char(10) null);


create table blurbs
        (au_id  VARCHAR(11) not null,
         copy   text null);

create table discounts
        (discounttype   varchar(40) not null,
        stor_id         char(4) null,
        lowqty          smallint null,
        highqty         smallint null,
        discount        float not null);

create table au_pix
        (au_id          char(11) not null,
        pic                     mediumblob null,
        format_type             char(11) null,
        bytesize                int null,
        pixwidth_hor            char(14) null,
        pixwidth_vert           char(14) null);

create table publishers
        (pub_id char(4) not null,
        pub_name varchar(40) null,
        city varchar(20) null,
        state char(2) null,
	CONSTRAINT `pubid_rule` CHECK (pub_id in ("1389", "0736", "0877", "1622", "1756") OR pub_id REGEXP "[0-9][0-9][0-9][0-9]"));

create table roysched
        (title_id varchar(6) not null,
        lorange int null,
        hirange int null,
        royalty int null);

create table sales
        (stor_id char(4) not null,
        ord_num varchar(20) not null,
        date datetime not null);

create table salesdetail
        (stor_id char(4) not null,
        ord_num varchar(20) not null,
        title_id varchar(6) not null,
        qty smallint not null,
        discount float not null,
	CONSTRAINT `titleid_rule` CHECK (title_id REGEXP "[A-Z][A-Z][0-9][0-9][0-9][0-9]" ));

create table stores
        (stor_id char(4) not null,
        stor_name varchar(40) null,
        stor_address varchar(40) null,
        city varchar(20) null,
        state char(2) null,
        country varchar(12) null,
        postalcode char(10) null,
        payterms varchar(12) null);

create table titleauthor
        (au_id varchar(11) not null,
        title_id varchar(6) not null,
        au_ord tinyint null,
        royaltyper int null);

create table titles
        (title_id varchar(11) not null,
        title varchar(80) not null,
        type char(12) not null default "undecided",
        pub_id char(4) null,
        price decimal(50,2) null,
        advance decimal(50,2) null,
        total_sales int null,
        notes varchar(200) null,
        pubdate datetime null,
        contract bit(1) not null,
	CONSTRAINT `titleid_rule` CHECK (title_id REGEXP "[A-Z][A-Z][0-9][0-9][0-9][0-9]" ) );

show tables;
/*add primary keys and constraints*/

alter table titles add primary key (title_id);

alter table titleauthor add constraint pk_auttitle PRIMARY KEY (au_id,title_id);

alter table authors add primary key (au_id);

alter table publishers add primary key (pub_id);

alter table roysched add constraint pk_titleid_lorange PRIMARY KEY (title_id,lorange);

alter table sales add constraint pk_stor_idnum PRIMARY KEY (stor_id,ord_num);

alter table salesdetail add constraint  pk_storordtit PRIMARY KEY (stor_id, ord_num,title_id);

alter table stores add primary key (stor_id);

alter table discounts add constraint pk_discount PRIMARY KEY (discounttype, stor_id);

alter table au_pix add primary key (au_id);

alter table blurbs add primary key (au_id);
/* ************************ADD DATA FROM pubs2_data.sql HERE BEFORE PROCEEDING!***************** */
/*add foreign keys and defaults*/

alter table titleauthor add foreign key (title_id) references titles(title_id);

alter table titleauthor add foreign key(au_id) references authors(au_id);

alter table salesdetail add foreign key(title_id) references titles(title_id);

alter table salesdetail add constraint fk_stor_ord FOREIGN KEY (stor_id,ord_num) references sales(stor_id,ord_num);

alter table titles add foreign key (pub_id) references publishers(pub_id);

alter table discounts add foreign key (stor_id) references stores(stor_id);

alter table au_pix add foreign key (au_id) references authors(au_id);

alter table blurbs add foreign key(au_id) references authors(au_id);

describe salesdetail;  /* just an example to see how the keys are displayed*/

/* some defaults and index creation*/

alter table titles alter column type set default 'UNDECIDED';

create unique index pubind on publishers (pub_id);

create unique index auidind on authors (au_id);

create index aunmind on authors (au_lname, au_fname);

create unique index titleidind on titles (title_id);

create unique index taind on titleauthor (au_id, title_id);

create index auidind on titleauthor (au_id);

create index titleidind on titleauthor (title_id);

create unique index salesind on sales (stor_id, ord_num);

create index titleidind on salesdetail (title_id);

create index salesdetailind on salesdetail (stor_id, ord_num);

create index titleidind on roysched (title_id);

/* constraints on input-- be prepared to explain*/

/* create and test a view*/

create view titleview as
       select title, au_ord, au_lname,
       price, total_sales, pub_id
       from authors, titles, titleauthor
       where authors.au_id=titleauthor.au_id
       and titles.title_id=titleauthor.title_id;

select * from titleview;

/* create stored procedures -- note that you have to set a new delimiter then unset it so as not to confuse mysql */


DELIMITER //
create procedure byroyalty (IN percentage int)
    begin
    select au_id from titleauthor where titleauthor.royaltyper=percentage;
    end//
DELIMITER ;


set @percentage=25;
call byroyalty(@percentage);


DELIMITER //
create procedure insert_sales_proc(IN stor_id char(4),IN ordernum varchar(20), IN orderdate varchar(40))
    begin
    insert into sales values(stor_id, ordernum,orderdate);
    end//

create procedure insert_salesdetail_proc (IN stor_id char(4), IN ord_num varchar(20), IN title_id varchar(6), IN qty smallint, IN discount float)
     begin
     insert salesdetail values(stor_id,ord_num,title_id,qty,discount);
     end//

DELIMITER ;



 show procedure status;

	
/* use your database e.g. use F16336pbarnett; then create the tables */
/* I recommend that you input the DML statements in groups as delimited by c-style comments*/
create table authors
        (au_id varchar(11) not null,
        au_lname varchar(40) not null,
        au_fname varchar(20) not null,
        phone char(12) not null,
        address varchar(40) null,
        city varchar(20) null,
        state char(2) null,
        country varchar(12) null,
        postalcode char(10) null);


create table blurbs
        (au_id  VARCHAR(11) not null,
         copy   text null);

create table discounts
        (discounttype   varchar(40) not null,
        stor_id         char(4) null,
        lowqty          smallint null,
        highqty         smallint null,
        discount        float not null);

create table au_pix
        (au_id          char(11) not null,
        pic                     mediumblob null,
        format_type             char(11) null,
        bytesize                int null,
        pixwidth_hor            char(14) null,
        pixwidth_vert           char(14) null);

create table publishers
        (pub_id char(4) not null,
        pub_name varchar(40) null,
        city varchar(20) null,
        state char(2) null,
	CONSTRAINT `pubid_rule` CHECK (pub_id in ("1389", "0736", "0877", "1622", "1756") OR pub_id REGEXP "[0-9][0-9][0-9][0-9]"));

create table roysched
        (title_id varchar(6) not null,
        lorange int null,
        hirange int null,
        royalty int null);

create table sales
        (stor_id char(4) not null,
        ord_num varchar(20) not null,
        date datetime not null);

create table salesdetail
        (stor_id char(4) not null,
        ord_num varchar(20) not null,
        title_id varchar(6) not null,
        qty smallint not null,
        discount float not null,
	CONSTRAINT `titleid_rule` CHECK (title_id REGEXP "[A-Z][A-Z][0-9][0-9][0-9][0-9]" ));

create table stores
        (stor_id char(4) not null,
        stor_name varchar(40) null,
        stor_address varchar(40) null,
        city varchar(20) null,
        state char(2) null,
        country varchar(12) null,
        postalcode char(10) null,
        payterms varchar(12) null);

create table titleauthor
        (au_id varchar(11) not null,
        title_id varchar(6) not null,
        au_ord tinyint null,
        royaltyper int null);

create table titles
        (title_id varchar(11) not null,
        title varchar(80) not null,
        type char(12) not null default "undecided",
        pub_id char(4) null,
        price decimal(50,2) null,
        advance decimal(50,2) null,
        total_sales int null,
        notes varchar(200) null,
        pubdate datetime null,
        contract bit(1) not null,
	CONSTRAINT `titleid_rule` CHECK (title_id REGEXP "[A-Z][A-Z][0-9][0-9][0-9][0-9]" ) );

show tables;
/*add primary keys and constraints*/

alter table titles add primary key (title_id);

alter table titleauthor add constraint pk_auttitle PRIMARY KEY (au_id,title_id);

alter table authors add primary key (au_id);

alter table publishers add primary key (pub_id);

alter table roysched add constraint pk_titleid_lorange PRIMARY KEY (title_id,lorange);

alter table sales add constraint pk_stor_idnum PRIMARY KEY (stor_id,ord_num);

alter table salesdetail add constraint  pk_storordtit PRIMARY KEY (stor_id, ord_num,title_id);

alter table stores add primary key (stor_id);

alter table discounts add constraint pk_discount PRIMARY KEY (discounttype, stor_id);

alter table au_pix add primary key (au_id);

alter table blurbs add primary key (au_id);
/* ************************ADD DATA FROM pubs2_data.sql HERE BEFORE PROCEEDING!***************** */
/*add foreign keys and defaults*/

alter table titleauthor add foreign key (title_id) references titles(title_id);

alter table titleauthor add foreign key(au_id) references authors(au_id);

alter table salesdetail add foreign key(title_id) references titles(title_id);

alter table salesdetail add constraint fk_stor_ord FOREIGN KEY (stor_id,ord_num) references sales(stor_id,ord_num);

alter table titles add foreign key (pub_id) references publishers(pub_id);

alter table discounts add foreign key (stor_id) references stores(stor_id);

alter table au_pix add foreign key (au_id) references authors(au_id);

alter table blurbs add foreign key(au_id) references authors(au_id);

describe salesdetail;  /* just an example to see how the keys are displayed*/

/* some defaults and index creation*/

alter table titles alter column type set default 'UNDECIDED';

create unique index pubind on publishers (pub_id);

create unique index auidind on authors (au_id);

create index aunmind on authors (au_lname, au_fname);

create unique index titleidind on titles (title_id);

create unique index taind on titleauthor (au_id, title_id);

create index auidind on titleauthor (au_id);

create index titleidind on titleauthor (title_id);

create unique index salesind on sales (stor_id, ord_num);

create index titleidind on salesdetail (title_id);

create index salesdetailind on salesdetail (stor_id, ord_num);

create index titleidind on roysched (title_id);

/* constraints on input-- be prepared to explain*/

/* create and test a view*/

create view titleview as
       select title, au_ord, au_lname,
       price, total_sales, pub_id
       from authors, titles, titleauthor
       where authors.au_id=titleauthor.au_id
       and titles.title_id=titleauthor.title_id;

select * from titleview;

/* create stored procedures -- note that you have to set a new delimiter then unset it so as not to confuse mysql */


DELIMITER //
create procedure byroyalty (IN percentage int)
    begin
    select au_id from titleauthor where titleauthor.royaltyper=percentage;
    end//
DELIMITER ;


set @percentage=25;
call byroyalty(@percentage);


DELIMITER //
create procedure insert_sales_proc(IN stor_id char(4),IN ordernum varchar(20), IN orderdate varchar(40))
    begin
    insert into sales values(stor_id, ordernum,orderdate);
    end//

create procedure insert_salesdetail_proc (IN stor_id char(4), IN ord_num varchar(20), IN title_id varchar(6), IN qty smallint, IN discount float)
     begin
     insert salesdetail values(stor_id,ord_num,title_id,qty,discount);
     end//

DELIMITER ;



 show procedure status;

