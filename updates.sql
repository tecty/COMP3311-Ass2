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


create view actor_path 
	(src_id,movie_id,dest_id)
as 
select 
	a1.actor_id , 
	a1.movie_id ,
	a2.actor_id  
from acting as a1 
join acting as a2 
on 
	a1.movie_id = a2.movie_id and
	a2.actor_id <> a1.actor_id
;



create type movie_path as 
	(src text, movie text, y int , dest text);

create or replace function actor_path_to_strings
	(_src int, _dest int) returns movie_path 
as $$ 
	select a1.name, m.title , m.year, a2.name 
	from actor_path as ap 
	join actor as a1 
		on a1.id=ap.src_id 
	join actor as a2
		on a2.id = ap.dest_id 
	join movie as m 
		on m.id = movie_id
	where ap.src_id = $1 and ap.dest_id = $2;
	;

$$ language sql;



-- create recursive view rec_actor_path  
-- 	(root_id, src_id, movie_id, dest_id, depth)
-- as
-- (
--     select src_id, src_id, movie_id, dest_id, 1 
--     from actor_path 

-- 	union all
	  
-- 	select 
-- 		rec.root_id, a.src_id, a.movie_id, a.dest_id, rec.depth+1
-- 	from rec_actor_path as rec 
-- 	join 
-- 		actor_path as a on a.src_id = rec.dest_id and
-- 		rec.dest_id <> rec.root_id 
-- 	where rec.depth <=5
-- );


-- create type act_rec as 
-- 	(src_id int, movie_id int, dest_id int);

-- create or replace function rec_find(_prev int, _dest int, _depth int) as $$
-- declare 
-- 	_path act_rec;
-- begin
-- 	for _path in
-- 		select * from actor_path where src_id = _prev 

-- end;
-- $$ language plpgsql;
	
	
	
-- create type path_rec as
-- 	(actor_1 int, actor_2 int,actor_3 int,actor_4 int, actor_5 int,actor_6 int);


-- create or replace function find_path(_src int, _dest int) returns setof path_rec
-- as $$ 
-- declare 
-- 	_path path_rec[];
-- 	_this_con act_rec;
-- 	_seen_actor int[]; 
-- 	_not_visit int[];
-- 	_not_visit_index int:= 0;
-- 	_end_flag bool:= false;
-- 	_next int:= 0; 
-- 	-- recursion counter
-- 	_rec_count int := 0;
-- 	-- _degree_flag int:= 0;
-- begin 
-- 	-- add the source to be visit 
-- 	_not_visit := _not_visit || _src;
-- 	loop
-- 		exit when
-- 			_rec_count = 6 or 
-- 			_end_flag = true
-- 		;
-- 		loop
-- 		exit when array_length(_not_visit)=_not_visit_index
-- 			-- pop the first element in the array 
-- 			_next := _not_visit[_not_visit_index];
-- 			_not_visit_index := _not_visit_index + 1;

-- 			for _this_con in 
-- 				select * from actor_path 
-- 				where 
-- 					src_id = _next 
-- 			loop
-- 				if ARRAY[_this_con.dest_id] <@ _seen_actor then 
-- 					raise notice 'Seen: %', _this_con.dest_id;
-- 				elsif _this_con.dest_id = _dest then 
-- 					raise notice 'Found: %', _dest;
-- 					_end_flag:= true;
-- 				else 
-- 					--  add this actor as seen
-- 					_seen_actor := _seen_actor || _this_con.dest_id;
-- 					-- add this actor as next actor to visit 
-- 					_not_visit := _not_visit || _this_con.dest_id;
-- 				end if;
-- 			end loop;
-- 		end loop 


-- 		-- add up the counter 
-- 		_rec_count := _rec_count +1 ;
-- 	end loop;
-- end;
-- $$ language plpgsql;

--  Add your code below

