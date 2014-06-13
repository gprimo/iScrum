<?php
/* require the user as the parameter */
if(isset($_GET['proj_id']) && isset($_GET['user_id']) && intval($_GET['proj_id']) && intval($_GET['user_id'])) {

	
	$proj_id = intval($_GET['proj_id']);
	$user_id = intval($_GET['user_id']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	$query = "UPDATE usuario SET proj_id_ultimo_acesso = $proj_id WHERE usr_id = $user_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* disconnect from the db */
	@mysql_close($link);
}
?>
