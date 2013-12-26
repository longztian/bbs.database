DROP PROCEDURE IF EXISTS get_tag_root;

DELIMITER ;;
CREATE DEFINER=web@localhost PROCEDURE get_tag_root(IN $tid INT)
    COMMENT 'get parent tags recursively for a given tag'  
BEGIN
    DROP TEMPORARY TABLE IF EXISTS tags_t;
    CREATE TEMPORARY TABLE tags_t (
        id int(10) unsigned,
        name varchar(60),
        description varchar(255),
        parent int(10) unsigned
    ) ENGINE=MEMORY DEFAULT CHARSET=utf8;

    REPEAT
        INSERT INTO tags_t SELECT id, name, description, parent FROM tags WHERE id = $tid  LIMIT 1;
        SELECT parent INTO $tid FROM tags WHERE id = $tid LIMIT 1;
    UNTIL $tid IS NULL
    END REPEAT;
    
    SELECT * FROM tags_t;
    DROP TEMPORARY TABLE tags_t;
END ;;
DELIMITER ;