<?php
/* require the user as the parameter */

if(isset($_GET['trfa_id']) && isset($_GET['user_id']) && isset($_GET['proj_id']) && isset($_GET['fase_id']) && intval($_GET['trfa_id']) && intval($_GET['fase_id'])) {

	$trfa_id = intval($_GET['trfa_id']);
	$fase_id = intval($_GET['fase_id']);
	$user_id = $_GET['user_id'];
	$proj_id = $_GET['proj_id'];

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	$query = "update inicio_fase SET fase_id = $fase_id WHERE trfa_id=$trfa_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	echo $query;
	
	$query = "select in_fa_pa.* FROM inicio_fase_participacao in_fa_pa, inicio_fase in_fa WHERE in_fa.trfa_id = $trfa_id AND in_fa_pa.inic_id = in_fa.inic_id AND in_fa.inic_id = 
	(
		SELECT MAX( inic_id ) 
		FROM inicio_fase
		WHERE trfa_id = in_fa.trfa_id
	)";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	echo $query;
	if (!mysql_num_rows($result))
	{
		$query = "SELECT ptcp_id FROM participacao WHERE usr_id = $user_id AND proj_id = $proj_id LIMIT 1";
		$result = mysql_query($query,$link) or die('Errant query:  '.$query);
		while ($row = mysql_fetch_array($result)) {
			$ptcp_id = $row[0];
		}
		echo $query;
		
		$query = "SELECT MAX( inic_id ) FROM inicio_fase WHERE trfa_id = $trfa_id";
		$result = mysql_query($query,$link) or die('Errant query:  '.$query);
		while ($row = mysql_fetch_array($result)) {
			$inic_id = $row[0];
		}
		echo $query;
		
		$query = "INSERT INTO inicio_fase_participacao (inic_id, ptcp_id) VALUES ($inic_id, $ptcp_id)";
		$result = mysql_query($query,$link) or die('Errant query:  '.$query);
		echo $query;
	}
	

	/* disconnect from the db */
	@mysql_close($link);
}
?>
