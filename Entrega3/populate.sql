drop table categoria cascade;
drop table categoria_simples cascade;
drop table super_categoria cascade;
drop table tem_outra cascade;
drop table produto cascade;
drop table tem_categoria cascade;
drop table IVM cascade;
drop table ponto_de_retalho cascade;
drop table instalada_em cascade;
drop table prateleira cascade;
drop table planograma cascade;
drop table retalhista cascade;
drop table responsavel_por cascade;
drop table evento_reposicao cascade;


create table categoria
   (nome  varchar(80)	not null    unique,
    constraint pk_categoria primary key(nome));

create table categoria_simples
   (nome varchar(80)	not null    unique,
    constraint pk_categoria_simples primary key(nome),
    constraint fk_categoria_simples_categoria foreign key(nome) references categoria(nome) on delete cascade);

create table super_categoria
   (nome varchar(80)	not null    unique,
    constraint pk_super_categoria primary key(nome),
    constraint fk_super_categoria_categoria foreign key(nome) references categoria(nome));


create table tem_outra
   (super_categoria varchar(80)	not null,
    categoria varchar(80) not null unique,
    constraint pk_tem_outra primary key(categoria),
    constraint fk_tem_outra_categoria foreign key(categoria) references categoria(nome) on delete cascade,
    constraint fk_tem_outra_super_categoria foreign key(super_categoria) references super_categoria(nome) on delete cascade);
   

create table produto
    (ean numeric(20,0) not null unique,
    cat varchar(80) not null,
    descr varchar(80) not null,
    constraint pk_produto primary key(ean),
    constraint fk_produto_categoria foreign key(cat) references categoria(nome) on delete cascade);

create table tem_categoria
    (ean numeric(20,0) not null,
    nome varchar(80) not null,
    constraint fk_tem_categoria_produto foreign key(ean) references produto(ean) on delete cascade,
    constraint fk_tem_categoria foreign key(nome) references categoria(nome) on delete cascade);

create table IVM
    (num_serie numeric(20,0) not null,
    fabricante varchar(80) not null,
    constraint pk_IVM primary key(num_serie, fabricante));

create table ponto_de_retalho
    (nome varchar(80) not null  unique,
    distrito varchar(80) not null,
    concelho varchar(80) not null,
    constraint pk_ponto_de_retalho primary key(nome));

create table instalada_em
    (num_serie numeric(20) not null,
    fabricante varchar(80) not null unique,
    local varchar(80) not null,
    constraint pk_instalada_em primary key(num_serie, fabricante),
    constraint fk_instalada_em_ivm foreign key (num_serie, fabricante) references IVM(num_serie, fabricante) on delete cascade,
    constraint fk_instalada_em_ponto_de_retalho foreign key(local) references ponto_de_retalho(nome) on delete cascade);

create table prateleira
   (nro  numeric(20,0)    not null,
    num_serie  numeric(20,0)      not null    unique,
    fabricante   varchar(80)    not null    unique,
    altura   numeric(20,0)    not null,
    nome   varchar(80)    not null,
    constraint pk_prateleira primary key(nro, num_serie, fabricante),
    constraint fk_prateleira_IVM foreign key(fabricante, num_serie) references IVM(fabricante, num_serie) on delete cascade,
    constraint fk_prateleira_categoria foreign key(nome) references categoria(nome) on delete cascade);

create table planograma
   (ean  numeric(20,0)  not null  ,
    nro  numeric(20,0)    not null    ,
    num_serie  numeric(20,0)      not null    ,
    fabricante   varchar(80)    not null   ,
    faces   numeric(20,0)    not null,
    unidades    numeric(20,0) not null,
    loc   varchar(80)    not null,
    constraint pk_planograma primary key(ean, nro, num_serie, fabricante),
    constraint fk_planograma_produto foreign key(ean) references produto(ean) on delete cascade,
    constraint fk_planograma_prateleira foreign key(nro, num_serie, fabricante) references prateleira(nro, num_serie, fabricante) on delete cascade);

create table retalhista
   (tin  numeric(20,0)  not null  unique,
    name varchar(80)  not null unique,
    constraint pk_retalhista primary key(tin));

create table responsavel_por
    (nome_cat varchar(80) not null,
    tin numeric(20,0) not null,
    num_serie numeric(20,0) not null ,
    fabricante varchar(80) not null ,
    constraint fk_responsavel_por_IVM foreign key(num_serie, fabricante) references IVM(num_serie, fabricante) on delete cascade,
    constraint fk_responsavel_por_retalhista foreign key(tin) references retalhista(tin) on delete cascade,
    constraint fk_responsavel_nome_categoria foreign key(nome_cat) references categoria(nome) on delete cascade);

create table evento_reposicao
   (ean  numeric(20,0)  not null,
    nro  numeric(20,0)    not null,
    num_serie  numeric(20,0)      not null,
    fabricante   varchar(80)    not null,
    instante    varchar(80) not null,
    unidades    numeric(20,0) not null,
    tin     numeric(20,0)    not null,
    constraint pk_evento_reposicao primary key(ean, nro, num_serie, fabricante, instante),
    constraint fk_evento_reposicao_planograma foreign key(ean, nro, num_serie, fabricante) references planograma(ean, nro, num_serie, fabricante) on delete cascade,
    constraint fk_evento_reposicao_retalhista foreign key(tin) references retalhista(tin) on delete cascade);


insert into categoria values ('cervejas');
insert into categoria values ('fruta');
insert into categoria values ('almoço');
insert into categoria values ('jantar');
insert into categoria values ('agua');
insert into categoria values ('doces');

insert into categoria_simples values ('doces');
insert into categoria_simples values ('jantar');

insert into super_categoria values ('almoço');
insert into super_categoria values ('jantar');

insert into tem_outra values ('jantar', 'agua');
insert into tem_outra values ('jantar', 'fruta');
insert into tem_outra values ('almoço', 'cervejas');
insert into tem_outra values ('almoço', 'doces');

insert into produto values (239,'cervejas','heineken');
insert into produto values (373,'cervejas','superbock');
insert into produto values (302,'fruta','anona');
insert into produto values (915,'fruta','banana');
insert into produto values (696,'agua','monchique');
insert into produto values (232,'agua','luso');
insert into produto values (193,'jantar','bacalhau à braz');
insert into produto values (078,'jantar','tosta');
insert into produto values (300,'almoço','cachorro');
insert into produto values (891,'almoço','hamburguer');
insert into produto values (498,'doces','baba de camelo');
insert into produto values (598,'doces','M&N');

insert into tem_categoria values(239,'cervejas');
insert into tem_categoria values(373,'cervejas');
insert into tem_categoria values(302,'fruta');
insert into tem_categoria values(915,'fruta');
insert into tem_categoria values(696,'agua');
insert into tem_categoria values(232,'agua');
insert into tem_categoria values(193,'jantar');
insert into tem_categoria values(078,'jantar');
insert into tem_categoria values(300,'almoço');
insert into tem_categoria values(891,'almoço');
insert into tem_categoria values(498,'doces');
insert into tem_categoria values(598,'doces');


insert into IVM values (0987654,'samsung');
insert into IVM values (345689,'sony');
insert into IVM values (54382490485785,'apple');
insert into IVM values (2423567,'asus');
insert into IVM values (8765765436,'glorious');
insert into IVM values (586658943,'zara');

insert into ponto_de_retalho values ('roubo', 'lisboa', 'cacém');
insert into ponto_de_retalho values ('moita', 'leiria', 'co(i)na');
insert into ponto_de_retalho values ('amieira', 'leiria', 'marinha Grande');
insert into ponto_de_retalho values ('ghetto', 'lisboa', 'odivelas');
insert into ponto_de_retalho values ('pero neto', 'leiria', 'marinha Grande');
insert into ponto_de_retalho values ('martingança', 'leiria', 'marinha Grande');

insert into instalada_em values (0987654,'samsung','roubo');
insert into instalada_em values (345689,'sony','moita');
insert into instalada_em values (54382490485785,'apple','amieira');
insert into instalada_em values (2423567,'asus','ghetto');
insert into instalada_em values (8765765436,'glorious','pero neto');
insert into instalada_em values (586658943,'zara','martingança');

insert into prateleira values (1, 0987654, 'samsung', 90, 'doces');
insert into prateleira values (2, 2423567, 'asus', 80, 'cervejas');
insert into prateleira values (3, 345689, 'sony', 100, 'agua');
insert into prateleira values (4, 54382490485785, 'apple', 50, 'fruta');

insert into retalhista values (6546541654165, 'valete');
insert into retalhista values (9878465234840, 'vanessa');
insert into retalhista values (1564820156464, 'bernardo');
insert into retalhista values (5484821214482, 'hugo');
insert into retalhista values (8314530548760, 'goncalo');
insert into retalhista values (3354412054521, 'bonifacio');
insert into retalhista values (9999999999999, 'jacaré');

insert into responsavel_por values ('cervejas', 6546541654165, 0987654,'samsung');
insert into responsavel_por values ('doces', 6546541654165, 0987654,'samsung');
insert into responsavel_por values ('fruta', 9878465234840, 345689,'sony');
insert into responsavel_por values ('almoço', 1564820156464, 54382490485785,'apple');
insert into responsavel_por values ('jantar', 5484821214482, 2423567,'asus');
insert into responsavel_por values ('agua', 8314530548760, 8765765436,'glorious');
insert into responsavel_por values ('doces', 3354412054521, 586658943,'zara');

insert into planograma values (239,2, 2423567, 'asus', 10, 30, 'ghetto' );
insert into planograma values (373,4, 54382490485785, 'apple',4, 40, 'amieira' );
insert into planograma values (302,4, 54382490485785, 'apple',7, 50, 'amieira' );
insert into planograma values (915,4, 54382490485785, 'apple',2, 13, 'amieira');
insert into planograma values (696,3, 345689, 'sony',4, 20, 'moita' );
insert into planograma values (232,3, 345689, 'sony',6, 18, 'moita' );
insert into planograma values (498,1, 0987654, 'samsung',2, 10, 'roubo');
insert into planograma values (598,2, 2423567, 'asus',2, 10, 'ghetto');

insert into evento_reposicao values (239,2, 2423567, 'asus', '11/08/2021 17h 53m 6s', 5, 5484821214482);
insert into evento_reposicao values (373,4, 54382490485785, 'apple','12/02/2021 21h 1m 7s', 3, 1564820156464);
insert into evento_reposicao values (302,4, 54382490485785, 'apple','29/09/2021 7h 33m 8s', 2, 1564820156464);
insert into evento_reposicao values (915,4, 54382490485785, 'apple','21/03/2021 18h 43m 9s', 1, 1564820156464);
insert into evento_reposicao values (696,3, 345689, 'sony','13/02/2021 17h 53m 6s', 5, 9878465234840);
insert into evento_reposicao values (232,3, 345689, 'sony','15/05/2020 17h 53m 27s', 4, 9878465234840);
insert into evento_reposicao values (498,1, 0987654, 'samsung','18/06/2022 13h 25m 8s', 2, 6546541654165);
insert into evento_reposicao values (598,2, 2423567, 'asus','11/08/2021 23h 53m 56s', 1, 5484821214482);