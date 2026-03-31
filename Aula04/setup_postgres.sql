DROP TABLE IF EXISTS Consulta CASCADE;
DROP TABLE IF EXISTS Medico CASCADE;
DROP TABLE IF EXISTS Paciente CASCADE;
DROP TABLE IF EXISTS Convenio CASCADE;

CREATE TABLE Convenio (
    id_convenio INTEGER PRIMARY KEY,
    nome_convenio VARCHAR(100) NOT NULL
);

CREATE TABLE Paciente (
    cpf_paciente CHAR(11) PRIMARY KEY,
    nome_paciente TEXT NOT NULL,
    telefone_paciente VARCHAR(15)
);

CREATE TABLE Medico (
    crm_medico VARCHAR(20) PRIMARY KEY,
    nome_medico TEXT NOT NULL,
    especialidade_medico VARCHAR(50)
);

CREATE TABLE Consulta (
    id_consulta INTEGER PRIMARY KEY,
    data_consulta DATE NOT NULL,
    hora_consulta TIME NOT NULL,
    valor_consulta NUMERIC(10,2),
    fk_cpf_paciente CHAR(11) REFERENCES Paciente(cpf_paciente),
    fk_crm_medico VARCHAR(20) REFERENCES Medico(crm_medico),
    fk_id_convenio INTEGER REFERENCES Convenio(id_convenio)
);

-- Inserts
INSERT INTO Convenio VALUES (1, 'Unimed');
INSERT INTO Convenio VALUES (2, 'Bradesco Saúde');
INSERT INTO Convenio VALUES (3, 'Particular');

-- Inserindo Pacientes
INSERT INTO Paciente VALUES ('11122233344', 'Ana Silva', '(11) 98888-1111');
INSERT INTO Paciente VALUES ('22233344455', 'Bruno Oliveira', '(11) 97777-2222');
INSERT INTO Paciente VALUES ('33344455566', 'Carla Souza', '(11) 96666-3333');
INSERT INTO Paciente VALUES ('44455566677', 'Gustavo Tavares', '(11) 95555-4444');
INSERT INTO Paciente VALUES ('55566677788', 'Maria Santos', '(11) 94444-5555');

-- Inserindo Médicos
INSERT INTO Medico VALUES ('CRM-SP123', 'Dr. Arnaldo Neto', 'Cardiologia');
INSERT INTO Medico VALUES ('CRM-SP456', 'Dra. Beatriz Lima', 'Pediatria');
INSERT INTO Medico VALUES ('CRM-SP789', 'Dr. Carlos Mendes', 'Ortopedia');

-- Inserindo Consultas
INSERT INTO Consulta VALUES (101, '2026-03-25', '09:00', 250.00, '11122233344', 'CRM-SP123', 1);
INSERT INTO Consulta VALUES (102, '2026-03-25', '10:30', 300.00, '22233344455', 'CRM-SP456', 2);
INSERT INTO Consulta VALUES (103, '2026-03-26', '14:00', 200.00, '33344455566', 'CRM-SP789', 3);
INSERT INTO Consulta VALUES (104, '2026-03-27', '08:30', 300.00, '11122233344', 'CRM-SP456', 1);
INSERT INTO Consulta VALUES (105, '2026-03-28', '11:00', 250.00, '22233344455', 'CRM-SP123', 2);