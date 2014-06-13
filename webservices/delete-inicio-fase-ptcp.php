<?php
/* require the user as the parameter */

if(isset($_GET['trfa_id']) && intval($_GET['trfa_id'])) {

	$trfa_id = intval($_GET['trfa_id']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	$query = "select inic_id from inicio_fase where trfa_id=$trfa_id order by inic_data desc limit 1";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	if(mysql_num_rows($result)) 
	{
		while ($row = mysql_fetch_array($result)) {
			$inic_id = $row[0];
		}
		$query = "SELECT ptcp_id FROM inicio_fase_participacao where inic_id=$inic_id";
		$result = mysql_query($query,$link) or die('Errant query:  '.$query);
		
		$ptcp_id = 0;
		if(mysql_num_rows($result)) 
		{
			while ($row = mysql_fetch_array($result)) {
				$ptcp_id = $row[0];
			}
		}
		
		
		$query = "DELETE FROM inicio_fase_participacao where inic_id=$inic_id";
		mysql_query($query,$link) or die('Errant query:  '.$query);
		
		$query = "update inicio_fase set fase_id = 1 where trfa_id=$trfa_id";
		mysql_query($query,$link) or die('Errant query:  '.$query);
		/*$query = "DELETE FROM participacao WHERE ptcp_id = $ptcp_id";
		mysql_query($query,$link) or die('Errant query:  '.$query);*/
		
		echo $query;
	}
	
	
	
	/* disconnect from the db */
	@mysql_close($link);
}
?>
