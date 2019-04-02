-- COMP3311 19s1 Assignment 2
--
-- updates.sql
--
-- Written by <<YOUR NAME>> (<<YOUR ID>>), Apr 2019

--  This script takes a "vanilla" imdb database (a2.db) and
--  make all of the changes necessary to make the databas
--  work correctly with your PHP scripts.
--  
--  Such changes might involve adding new views,
--  PLpgSQL functions, triggers, etc. Other changes might
--  involve dropping or redefining existing
--  views and functions (if any and if applicable).
--  You are not allowed to create new tables for this assignment.
--  
--  Make sure that this script does EVERYTHING necessary to
--  upgrade a vanilla database; if we need to chase you up
--  because you forgot to include some of the changes, and
--  your system will not work correctly because of this, you
--  will lose half of your assignment 2 final mark as penalty.
--

--  This is to ensure that there is no trailing spaces in movie titles,
--  as some tasks need to perform full title search.
UPDATE movie SET title = TRIM (title);


-- connect the name list by ','
create or replace function removefirst(_str text) returns text 
as $$
begin
	return substr(_str, 2,length(_str)-1);
end;
$$ language plpgsql;

create or replace function namePuls(_list text, _name text) returns text 
as $$
begin
	_list := _list || ','||_name;
	return _list;
end;
$$ language plpgsql;

create aggregate namelist(text)(
	stype = text,
	initcond = '',
	sfunc = namePuls,
	finalfunc  = removefirst
);

--  Add your code below
--
