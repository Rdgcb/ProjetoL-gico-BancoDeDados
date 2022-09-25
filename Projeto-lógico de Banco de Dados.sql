-- criação do banco de dados para o cenário de E-commerce

create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
		idClient int auto_increment primary key,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        CPF char(11) not null,
        Address varchar(30),
        constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

-- criar tabela produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(10) not null,
        classification_kids bool default false,
        category enum('Eletônico','Roupas','Brinquedos','Alimentos','Móveis'),
        evaluation float default 0,
        size varchar(10)
);

alter table product auto_increment=1;

create table payments(
	idclient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirnado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool,
    constraint fk_orders_client foreign key (idOrderClient) references Clients(idClient)
			on update cascade
);

alter table orders auto_increment=1;

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment=1;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_supplier unique (CNPJ),
    constraint unique_cpf_supplier unique (CPF)
);

alter table seller auto_increment=1;

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idseller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);


-- criar tabela estoque
create table productStorage(
	idProductStorage int auto_increment primary key,
    storageLocations varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment=1;


create table productOrder(
	idPOproduct int, 
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProductStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

show tables;

show databases;

use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';

show tables;

insert into Clientes (Fname, Minit, Lname, CPF, Address)
		values('Afonso', 'M', 'Tavares', 12346789, 'rua norte 807, Centro - Cidade dos Ventos'),
			  ('Luan', 'D', 'Rosa', 987654321, 'rua alameda 329, Centro - Cidade dos Ventos'),
              ('José', 'F', 'Klein', 45678913, 'rua papagaio de pirata 1509, Centro - Cidade dos Ventos'),
              ('Fátima', 'S', 'Ortiz', 789123456, 'rua principal 591, Centro - Cidade dos Ventos'),
              ('Rita', 'T', 'Borges', 98745631, 'rua de trás 15, Centro - Cidade dos Ventos'),
              ('Sandra', 'O', 'Vasconcelos', 654789123, 'rua dos ovnis 74, Centro - Cidade dos Ventos');
              
insert into product (Pname, classification_kids, category, avaliação, size) values
					('Camisa Branca', true, 'Vestimenta', '5', null),
                    ('Armário Multiuso', false, 'Móveis', '4', '128x51x36'),
                    ('Boné', true, 'Vestimenta', '5', null),
                    ('Açúcar de coco', false, 'Alimentos', '4', null),
                    ('Carrinho Hot Whells', true, 'Brinquedos', '4', null),
                    ('Calça Jeans', true, 'Vestimenta', '5', null),
                    ('Smartfone', false, 'Eletrônico', '5', null);
                    
select * from clients;
select * from product;

delete from orders where idOrderClient in (1,2,3,4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
			(1, default, 'compra via aplicativo', null, 1),
            (2, 'Confirmado', 50, 15, 0),
            (3, 'Confirmado', null, null, 1),
            (4, default, 'compra via web site', 150, 0);
            
select * from orders;

insert into productOrder (idPOorder, poQuantity, poStatus) values
			(4,5,2, null),
            (2,5,3, null),
            (3,6,1, null);


insert into productStorage (storageLocation, quantity) values
			('Santa Catarina', 1000),
            ('Rio de Janeiro', 500),
            ('São Paulo', 10),
            ('São Paulo', 100),
            ('Bahia', 10),
            ('Recife', 60);
            
insert into storageLocation (idLproduct, idLstorage, location) values
			(1,2, 'SC'),
            (2,6, 'SP');
		
insert into supplier (SocialName, CNPJ, contact) values
			('Abobora SA', 987654321234567, '21985474'),
            ('Espaço Eletrônicos', 85451964914357, '21985484'),
            ('Móveis Brilho', 93456789393469, '21975745');
            
select * from supplier;

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
			(1,1,500),
            (1,8,400),
            (2,4,633),
            (3,3,8),
            (2,5,80);
            
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
			('Celta Móveis', null, 987654321234567, null, 'Santa Catarina', 488752138),
            ('Afrânio Bonés', null,null, 384729437, 'Rio de Janeiro', 218549231),
            ('Soft', null, 173597621369834, null, 'São Paulo', 111832759);
            
select * from seller;

insert into productSeller (idPseller, idPproduct, prodQuantity) values
			(1,5,60),
            (2,4,10);
            
select * from productSeller;

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname, ' ', Lname) as Client, idOrder as Request, orderStatus as Status  from clients c, orders o where c.idClient = idOrderClient;