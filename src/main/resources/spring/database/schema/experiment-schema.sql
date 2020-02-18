-- table for experiment tasks will be shortened. annotatorName has been renamed to systemName
CREATE TABLE IF NOT EXISTS ExperimentTasks (
id int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
experimentType VARCHAR(20),
matching VARCHAR(50),
systemName VARCHAR(100),
datasetName VARCHAR(100),
state int,
lastChanged TIMESTAMP,
version VARCHAR(20)
);


-- table for experiments remains as it is
CREATE TABLE IF NOT EXISTS Experiments (
  id VARCHAR(300) NOT NULL,
  taskId int NOT NULL FOREIGN KEY REFERENCES ExperimentTasks(id),
  PRIMARY KEY (id, taskId)
);


-- index on experiment tasks won't be changed (unless somebody has an idea how to improve it )
DROP INDEX IF EXISTS ExperimentTaskConfig;
CREATE INDEX ExperimentTaskConfig ON ExperimentTasks (matching,experimentType,systemName,datasetName);

-- ExperimentTasks_Version table will be dropped

-- New table added for mapping from resultId to resultName (optional but would make the solution cleaner)
CREATE TABLE IF NOT EXISTS ResultNames (
id int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
name VARCHAR(50)
);

-- ExperimentTasks_AdditionalResults will be renamed to ExperimentTasks_DoubleResults
CREATE TABLE IF NOT EXISTS ExperimentTasks_DoubleResults (
resultId int NOT NULL FOREIGN KEY REFERENCES ResultNames(id),
taskId int NOT NULL FOREIGN KEY REFERENCES ExperimentTasks(id),
resvalue double,
PRIMARY KEY (resultId, taskId)
);

-- New table added for int results (e.g., number of errors)
CREATE TABLE IF NOT EXISTS ExperimentTasks_IntResults (
resultId int NOT NULL FOREIGN KEY REFERENCES ResultNames(id),
taskId int NOT NULL FOREIGN KEY REFERENCES ExperimentTasks(id),
resvalue int,
PRIMARY KEY (resultId, taskId)
);

-- New table added for blob results (e.g., ROC)
CREATE TABLE IF NOT EXISTS ExperimentTasks_BlobResults (
resultId int NOT NULL FOREIGN KEY REFERENCES ResultNames(id),
taskId int NOT NULL FOREIGN KEY REFERENCES ExperimentTasks(id),
resvalue BLOB,
PRIMARY KEY (resultId, taskId)
);

-- SubTask table remains the same
CREATE TABLE IF NOT EXISTS ExperimentTasks_SubTasks (
taskId int NOT NULL FOREIGN KEY REFERENCES ExperimentTasks(id),
subTaskId int NOT NULL FOREIGN KEY REFERENCES ExperimentTasks(id),
PRIMARY KEY (taskId, subTaskId)
);

-- Rename Derczynski dataset
UPDATE ExperimentTasks
SET datasetName = 'Derczynski IPM NEL'
WHERE datasetName = 'Derczynski';