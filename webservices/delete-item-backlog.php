<?php
/* require the user as the parameter */
if(isset($_GET['id']) && intval($_GET['id'])) {

	$id = intval($_GET['id']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	$query = "UPDATE item_backlog SET itbklg_data_exclusao = CURRENT_TIMESTAMP WHERE itbklg_id = $id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	echo $query;
	/* disconnect from the db */
	@mysql_close($link);
}
?>
