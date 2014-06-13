<?php
/* require the user as the parameter */
if(isset($_GET['id']) && intval($_GET['id']) && isset($_GET['proj_id']) && intval($_GET['proj_id']) ) {

	
	$itbklg_id = intval($_GET['id']);
	$proj_id = intval($_GET['proj_id']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	$query = "SELECT max(spt_id) FROM sprint where proj_id = $proj_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_array($result)) {
		$spt_id = $row[0];
	}
	$query = "SELECT MAX(itspt_sequencial) FROM item_sprint_backlog where spt_id = $spt_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_array($result)) {
		$seq_id = $row[0];
	}
	
	$query = "INSERT INTO item_sprint_backlog(itspt_id, spt_id, itspt_data_insercao, itspt_sequencial, itspt_status) VALUES ($itbklg_id, $spt_id, CURRENT_TIMESTAMP, $seq_id, 'NAO_INICIADA')";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	echo "OK";
	/* disconnect from the db */
	@mysql_close($link);
}
?>
