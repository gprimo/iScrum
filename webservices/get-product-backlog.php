<?php
/* require the user as the parameter */
if(isset($_GET['user']) && isset($_GET['project']) && isset($_GET['option']) && intval($_GET['user'])) {

	/* soak in the passed variable or set our own */
	$format = strtolower($_GET['format']) == 'json' ? 'json' : 'xml'; //xml is the default
	$user_id = intval($_GET['user']); //no default
	$proj_id = intval($_GET['project']);
	$option = strtolower($_GET['option']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	if ($option == 'propostas')
		$query = "SELECT ib.itbklg_id, ib.itbklg_sequencial, ib.proj_id, ib.itbklg_id_real, ib.itbklg_titulo, ib.itbklg_descricao, ib.itbklg_pontos_estimativa, ib.itbklg_data_aceitacao, ib.itbklg_data_exclusao, ib.ptcp_id FROM item_backlog ib, participacao pa WHERE pa.usr_id = $user_id AND pa.proj_id = ib.proj_id AND ib.proj_id = $proj_id AND ib.itbklg_data_aceitacao IS NULL AND ib.itbklg_data_exclusao IS NULL";
	else
	{
		$query = "SELECT ib.itbklg_id, ib.itbklg_sequencial, ib.proj_id, ib.itbklg_id_real, ib.itbklg_titulo, ib.itbklg_descricao, ib.itbklg_pontos_estimativa, ib.itbklg_data_aceitacao, ib.itbklg_data_exclusao, ib.ptcp_id FROM item_backlog ib WHERE ib.proj_id = $proj_id AND ib.itbklg_data_aceitacao IS NOT NULL AND ib.itbklg_data_exclusao IS NULL AND ib.itbklg_id NOT IN (SELECT isb.itspt_id FROM item_sprint_backlog isb)";
	}
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* create one master array of the records */
	$posts = array();
	if(mysql_num_rows($result)) {
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('historia'=>$post);
		}
	}
	/* output in necessary format */
	if($format == 'json') {
		header('Content-type: application/json');
		echo json_encode(array('posts'=>$posts));
	}
	else {
		
		header('Content-type: text/xml;charset=utf-8');
		echo '<product_backlog>';
		foreach($posts as $index => $post) {
			if(is_array($post)) {
				foreach($post as $key => $value) {
					echo '<',$key,'>';
					if(is_array($value)) {
						foreach($value as $tag => $val) {
							echo '<',$tag,'>',preg_replace('/&(?!#?[a-z0-9]+;)/', '&amp;', $val),'</',$tag,'>';
						}
					}
					echo '</',$key,'>';
				}
			}
		}
		echo '</product_backlog>';
	}

	/* disconnect from the db */
	@mysql_close($link);
}
?>