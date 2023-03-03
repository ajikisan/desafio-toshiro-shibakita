CREATE TABLE dados (
    AlunoID int,
    Nome varchar(50),
    Sobrenome varchar(50),
    Endereco varchar(150),
    Cidade varchar(50),
    Host varchar(50)
);

INSERT INTO dados (AlunoID, Nome, Sobrenome, Endereco, Cidade, Host)
VALUES ('$valor_rand1' , '$valor_rand2', '$valor_rand2', '$valor_rand2', 
        '$valor_rand2','$host_name');

select * from dados