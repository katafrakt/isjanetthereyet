-- up
create table stats (
  id serial primary key,
  num_repos int not null,
  num_users int not null,
  num_files int not null,
  day date not null,
  created_at integer not null default (extract(epoch from now()):: integer),
  updated_at integer
)

-- down
drop table stats