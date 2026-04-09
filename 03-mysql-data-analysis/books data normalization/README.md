DATABASE NORMALIZATION:

Database normalization is a systematic approach to organizing data in a relational database to reduce redundancy and improve data integrity. The primary objectives are to eliminate duplicate data and ensure logical data storage. 

The process involves decomposing a database into smaller, related tables and defining relationships between them, following a series of guidelines known as normal forms. Each normal form addresses specific types of anomalies:

1. **First Normal Form (1NF):** Ensures that each column contains atomic (indivisible) values and that each entry in a column is of the same data type.

2. **Second Normal Form (2NF):** Achieved when a table is in 1NF and all non-key attributes are fully functionally dependent on the primary key, eliminating partial dependencies.

3. **Third Normal Form (3NF):** Achieved when a table is in 2NF and all the attributes are functionally dependent only on the primary key, removing transitive dependencies.

Higher normal forms, such as Boyce-Codd Normal Form (BCNF), Fourth Normal Form (4NF), and Fifth Normal Form (5NF), address more complex scenarios to further reduce redundancy and dependency issues.

Applying these normalization principles in MySQL involves:

- **Designing Tables:** Structuring tables to conform to the desired normal form.

- **Defining Relationships:** Establishing foreign keys to represent relationships between tables.

- **Enforcing Constraints:** Implementing primary keys, foreign keys, and unique constraints to maintain data integrity.

By adhering to normalization principles, you can create efficient, scalable, and maintainable databases in MySQL. 

For a visual explanation of normalization concepts, you might find the following video helpful:

 -- Identify the Primary Key
ALTER TABLE `books_data`.`books_dataset` 
CHANGE COLUMN `bid` `bid` VARCHAR(3) NOT NULL ,
ADD PRIMARY KEY (`bid`),
ADD UNIQUE INDEX `bid_UNIQUE` (`bid` ASC) VISIBLE;
;


-- Normalizing the books_dataset to first normal form 1NF
CREATE TEMPORARY TABLE books_dataset_1nf
 SELECT 
	 *,
	 substring_index(author, ' ', 1) AS author_fname,
	substring(author from instr(author, ' ') +1) AS author_lname
 FROM books_dataset;
 
 
 

-- Third Normal Form (3NF)
-- Remove Transitive Dependencies
     - multiple books share the same author or category, there might be redundancy in the data.

CREATE TABLE authors_table (
    author_id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY author_id_pkey (author_id)
) SELECT author FROM
    books_dataset;
 
 
CREATE TABLE category_table (
    category_id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY categoryr_id_pkey (category_id)
) SELECT category FROM
    books_dataset;
		 
		 
-- Add new columns for author_id and category_id in the Books table
ALTER TABLE books_dataset 
ADD COLUMN author_id INT,
ADD COLUMN category_id INT;

-- Populate the author_id column based on the Authors table
UPDATE books_dataset
INNER JOIN authors_table ON (books_dataset.author = authors_table.author)
SET books_dataset.author_id = authors_table.author_id
;

-- Drop the author column from the books_dataset table
ALTER TABLE books_dataset DROP COLUMN author;

-- Populate the category_id column based on the category table
UPDATE books_dataset
INNER JOIN category_table ON (books_dataset.category = category_table.category)
SET books_dataset.category_id = category_table.category_id
;

-- Drop the category column from the books_dataset table
ALTER TABLE books_dataset DROP COLUMN category;


-- Establish Relationships:
ALTER TABLE `books_data`.`books_dataset` 
ADD INDEX `fk_author_idx` (`author_id` ASC) VISIBLE,
ADD INDEX `fk_category_idx` (`category_id` ASC) VISIBLE;
;
ALTER TABLE `books_data`.`books_dataset` 
ADD CONSTRAINT `fk_author`
  FOREIGN KEY (`author_id`)
  REFERENCES `books_data`.`authors_table` (`author_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_category`
  FOREIGN KEY (`category_id`)
  REFERENCES `books_data`.`category_table` (`category_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


**Resulting Structure:**

- **Books Table:**
  - `bid` (Primary Key)
  - `title`
  - `author_id` (Foreign Key)
  - `category_id` (Foreign Key)
  - `status`

- **Authors Table:**
  - `author_id` (Primary Key)
  - `author_name`

- **Categories Table:**
  - `category_id` (Primary Key)
  - `category_name`


 
