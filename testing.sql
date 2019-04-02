select m.title, m.year, m.content_rating, r.imdb_score, g.genre
from movie as m
join rating as r 
    on r.movie_id = m.id
join genre as g 
    on g.movie_id= m.id
where lower(title) like '%star war%' 
order by year;
