<?php
/* require the user as the parameter */
if(isset($_GET['proj_id']) && intval($_GET['proj_id'])) {

	/* soak in the passed variable or set our own */
	//$number_of_posts = isset($_GET['num']) ? intval($_GET['num']) : 10; //10 is the default
	$format = strtolower($_GET['format']) == 'json' ? 'json' : 'xml'; //xml is the default
	$proj_id = intval($_GET['proj_id']); //no default

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	$query = "
	SELECT DISTINCT pr.proj_nome, pr.proj_descricao, pr.proj_data_inicio, pr.proj_data_inicio_game, pr.proj_data_fim, max(sp.sequencial)-1 as sprints_realizadas, COUNT(ib.itbklg_id_real) as total_historias, tb1.historias_concluidas, tb2.num_releases FROM projeto pr, seq_sprint_generator sp, item_backlog ib, 
	(
		SELECT COUNT(isb.itspt_id) as historias_concluidas FROM item_sprint_backlog isb INNER JOIN  item_backlog ib ON ib.itbklg_id = isb.itspt_id WHERE ib.proj_id = $proj_id AND isb.itspt_status = 'FINALIZADA' 
	) as tb1, 
	(
		SELECT count(rls_id) as num_releases FROM release_projeto where proj_id = $proj_id
	) as tb2
	WHERE sp.idProjeto = pr.proj_id AND pr.proj_id = $proj_id AND ib.proj_id = pr.proj_id and ib.itbklg_data_exclusao is NULL";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* create one master array of the records */
	$posts = array();
	if(mysql_num_rows($result)) {
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('info'=>$post);
		}
	}

	/* output in necessary format */
	if($format == 'json') {
		header('Content-type: application/json');
		echo json_encode(array('posts'=>$posts));
	}
	else {
		header('Content-type: text/xml;charset=utf-8');
		echo '<projeto>';
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
		echo '</projeto>';
	}

	/* disconnect from the db */
	@mysql_close($link);
}
?>
