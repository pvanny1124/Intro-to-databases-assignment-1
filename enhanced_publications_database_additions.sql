

/* commands to enhance the publications database, add new tables and add fields and data to existing tables from enhanced_pubs-- run these commands after recreating and verifying the original publications database tables*/
/*Note the counts of rows in the original pubs database before additions.*/
/* 1. alter table titles to add column for agent*/
alter table titles add column ag_id varchar(11);

/* 2. add the agents table by cloning it from enhanced publications database enhanced_pubs*/
create table agents like enhanced_pubs.agents;
insert into agents select * from enhanced_pubs.agents;

/* 3. add a foreign key constraint from titles to agents for ag_id*/
alter table titles add foreign key (ag_id) references agents(ag_id);

/*4 add or alter these columns in existing tables for the sake of the "event driven" demo*/
alter table salesdetail alter column discount set default 0;
alter table authors add column royalties decimal(50,2);
/* 5. add data to existing tables from enhanced publications database enhanced_pubs*/
/* authors, publishers, stores, titles, titleauthor, roysched, sales, salesdetail, discounts,blurbs using the same technique in each -- insert just those not already in the table.*/
/* note that you prefix the remote table with the database name, but need not do this for the local. Also note we are comparing primary keys.*/
/* test the result with a select statement*/

insert into authors select * from enhanced_pubs.authors where au_id not in (select au_id from authors);
select count(*) from authors;
insert into publishers select * from enhanced_pubs.publishers where pub_id not in (select pub_id from publishers);
select count(*) from publishers; 
insert into stores select * from enhanced_pubs.stores where stor_id not in (select stor_id from stores);
select count(*) from stores;
insert into titles select * from enhanced_pubs.titles where title_id not in (select title_id from titles);
select count(*) from titles;
insert into roysched select * from enhanced_pubs.roysched where title_id not in (select title_id from roysched);
select count(*) from roysched;
/* note the 'or'ed subqueries in the next 3 insert statements. Consider why*/
insert into titleauthor select * from enhanced_pubs.titleauthor where title_id not in (select title_id from titleauthor) or au_id not in (select au_id from titleauthor);
select count(*) from titleauthor;
insert into sales select * from enhanced_pubs.sales where stor_id not in (select stor_id from sales) or ord_num not in (select ord_num from sales);
select count(*) from sales;
insert into salesdetail select * from enhanced_pubs.salesdetail where stor_id not in (select stor_id from salesdetail) or ord_num not in (select ord_num from salesdetail) or title_id not in (select title_id from salesdetail);
select count(*) from salesdetail;
/* different procedure here -- replace all records since some problems with original*/
truncate table discounts;
insert into discounts select * from enhanced_pubs.discounts;
/*6. in the case of blurbs table the structure has been altered enough from the original so that this time we are going to drop, recreate and load from enhanced_pubs*/

drop table blurbs;
create table blurbs like enhanced_pubs.blurbs;
show create table enhanced_pubs.blurbs;
show create table blurbs;
/*note that the foreign key constraints are not there so we have to add them*/
alter table blurbs add foreign key (au_id) references authors(au_id);
alter table blurbs add foreign key (title_id) references titles(title_id);
/*now copy the data*/
 insert into blurbs select * from enhanced_pubs.blurbs;
select count(*) from blurbs;

/* 7. now for some tables created by students in previous semesters--customer_sales, pending_orders, store_inventories, reviews, signing_events, periodicals*/
/*run 'show create table' on enhanced_pubs.periodicals and verify that it has no dependencies.  However, reviews is dependent on it! So we clone periodicals first*/

/*periodicals*/
create table periodicals like enhanced_pubs.periodicals;
insert into periodicals select * from enhanced_pubs.periodicals;
select count(*) from periodicals;

/*reviews*/
create table reviews like enhanced_pubs.reviews;
alter table reviews add foreign key(title_id) references titles(title_id );
alter table reviews add foreign key(periodical_id) references periodicals(periodical_id);
insert into reviews select * from enhanced_pubs.reviews;
select count(*) from reviews;

/*customer_sales*/
create table customer_sales like enhanced_pubs.customer_sales;
alter table customer_sales add foreign key(title_id) references titles(title_id);
alter table customer_sales add foreign key(store_id) references stores(stor_id);
insert into customer_sales select * from enhanced_pubs.customer_sales;
select count(*) from customer_sales;

/*pending_orders*/
create table pending_orders like enhanced_pubs.pending_orders;
alter table pending_orders add foreign key (title_id) references titles(title_id);
alter table pending_orders add foreign key (stor_id) references stores(stor_id);
insert into pending_orders select * from enhanced_pubs.pending_orders;
select count(*) from pending_orders;

/*signing events -- same deal, has 3 foreign key dependencies-- consider why*/
create table signing_events like enhanced_pubs.signing_events;
alter table signing_events add foreign key(title_id) references titles(title_id);
alter table signing_events add foreign key(store_id) references stores(stor_id);
alter table signing_events add foreign key(au_id) references authors(au_id);
insert into signing_events select * from enhanced_pubs.signing_events;
select count(*) from signing_events;

/*store_inventories--same deal*/
create table store_inventories like enhanced_pubs.store_inventories;
alter table store_inventories add foreign key (stor_id) references stores(stor_id);
alter table store_inventories add foreign key(title_id) references titles(title_id);
insert into store_inventories select * from enhanced_pubs.store_inventories;
select count(*) from store_inventories;

/*one more for the "event driven" demo*/

/*trigger audit keeps track of trigger actions*/
create table trigger_audit like enhanced_pubs.trigger_audit;

/*8.  now for some fixing up for the "event driven" demo. Let's assign literary agents to titles according to type. I will use this info later*/
update titles set ag_id="000-00-0001" where type="science_fic";
update titles set ag_id="000-00-0002" where type="non_fic";
update titles set ag_id="000-00-0003" where type="early_learni";  
update titles set ag_id="000-00-0004" where type="business";
update titles set ag_id="000-00-0005" where type="fiction";
update titles set ag_id="000-00-0006" where type="thriller";
update titles set ag_id="000-00-0007" where type="psychology";
update titles set ag_id="000-00-0008" where type="computer sci";
update titles set ag_id="000-00-0009" where type="mod_cook";
update titles set ag_id="000-00-0010" where type="UNDECIDED";
update titles set ag_id="000-00-0011" where type="popular_comp";
update titles set ag_id="000-00-0012" where type="romance";
update titles set ag_id="000-00-0013" where type="horror";
update titles set ag_id="000-00-0014" where type="trad_cook";
/* note that because of a foreign key constraint the ag_id has to match an existing record in agents*/
select title, type, ag_id from titles;
/* let's assign prices to books that do not have prices dummied according to type*/
update titles set price=11.99 where type="thriller" and price is NULL;
update titles set price=7.75 where type="romance" and price is NULL;
update titles set price=10.75 where type="thriller" and price is NULL;
/*leftovers*/
update titles set price=11.25 where price is NULL;
