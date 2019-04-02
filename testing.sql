-- select m.title, m.year, m.content_rating, r.imdb_score, namelist(g.genre)
-- from movie as m
-- join rating as r 
--     on r.movie_id = m.id
-- join genre as g 
--     on g.movie_id= m.id
-- where lower(title) like '%star war%' 
-- group by m.title, m.year, m.content_rating, r.imdb_score
-- order by m.year
-- ;


with g_movie as (
select movie_id, count(*)
from genre as g where g.genre in ('Action','Sci-Fi','Adventure') group by movie_id 
)
select distinct
m.title, m.year, m.content_rating, m.lang,
r.imdb_score, r.num_voted_users
from movie as m 
join rating as r on r.movie_id = m.id join g_movie as g on m.id = g.movie_id 
  and g.count=3 where m.year >=2005 
and m.year<=2005
order by r.imdb_score desc, r.num_voted_users desc
limit 10;
