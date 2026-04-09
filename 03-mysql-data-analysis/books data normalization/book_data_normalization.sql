-- Identify the Primary Key
ALTER TABLE `books_data`.`books_dataset` 
CHANGE COLUMN `bid` `bid` VARCHAR(3) NOT NULL ,
ADD PRIMARY KEY (`bid`),
ADD UNIQUE INDEX `bid_UNIQUE` (`bid` ASC) VISIBLE;
;


-- Third Normal Form (3NF)
-- Remove Transitive Dependencies
-- multiple books share the same author or category, there might be redundancy in the data.

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
  ON UPDATE NO ACTION
;

/*
Resulting Structure:

- books_dataset:
  - `bid` (Primary Key)
  - `title`
  - `author_id` (Foreign Key)
  - `category_id` (Foreign Key)
  - `status`

- authors_table:
  - `author_id` (Primary Key)
  - `author_name`

- category_table
  - `category_id` (Primary Key)
  - `category_name`
*/
