<?php
/* require the user as the parameter */
if(isset($_GET['user']) && isset($_GET['project']) && intval($_GET['user'])) {

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
	$query = "
		SELECT ib.itbklg_sequencial,ib.itbklg_titulo, ib.itbklg_pontos_estimativa,
		
		isb.spt_id, 
		isb.itspt_id, 
		isb.itspt_sequencial, 
		isb.itspt_status, 
		isb.itspt_data_exclusao, 
		seq.sequencial, 
		sp.spt_data_final_real, 
		sp.spt_data_cancelamento, 
		ib.proj_id,
		ib.itbklg_descricao 
		
		FROM item_backlog ib, item_sprint_backlog isb, sprint sp, seq_itspt_generator seq
		WHERE ib.itbklg_id = isb.itspt_id
		AND ib.proj_id = $proj_id
		AND isb.itspt_data_exclusao IS NULL 
		AND sp.spt_id = isb.spt_id
		AND sp.spt_data_final_real IS NULL 
		AND sp.spt_data_cancelamento IS NULL 
		AND seq.id_sprint = sp.spt_id
		ORDER BY seq.sequencial
	";
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
		echo '<sprint_backlog>';
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
		echo '</sprint_backlog>';
	}

	/* disconnect from the db */
	@mysql_close($link);
}
?>