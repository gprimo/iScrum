<?php
if(isset($_GET['task_id']) && intval($_GET['task_id'])) {

	/* soak in the passed variable or set our own */
	$task_id = intval($_GET['task_id']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	//$query = "SELECT ta.trfa_id, ib.itbklg_titulo, ta.trfa_titulo FROM tarefa ta, item_backlog ib, item_sprint_backlog isb,sprint sp WHERE ta.itspt_id = ib.itbklg_id AND ta.itspt_id = isb.itspt_id AND isb.itspt_id = ib.itbklg_id AND sp.spt_id = isb.spt_id AND sp.spt_data_final_real IS NULL AND sp.spt_data_cancelamento IS NULL AND isb.itspt_data_exclusao IS NULL AND ta.trfa_data_exclusao IS NULL";
	$query = "
			SELECT ib.itbklg_id, ib.itbklg_titulo, ta.trfa_titulo, fa.fase_nome, ta.trfa_data_inicio, ta.trfa_id, ta.trfa_descricao, 
			ta.trfa_impedimento, ta.trfa_data_exclusao, infa.inic_id, infa.inic_data, infa.fase_id, ta.trfa_bug 
			
			FROM tarefa ta, item_backlog ib, item_sprint_backlog isb, sprint sp, fase fa, inicio_fase infa
			WHERE ta.itspt_id = ib.itbklg_id
			AND ta.itspt_id = isb.itspt_id
			AND isb.itspt_id = ib.itbklg_id
			AND sp.spt_id = isb.spt_id
			AND sp.spt_data_final_real IS NULL 
			AND sp.spt_data_cancelamento IS NULL 
			AND isb.itspt_data_exclusao IS NULL 
			AND ta.trfa_data_exclusao IS NULL 
			AND infa.trfa_id = ta.trfa_id
			AND ta.trfa_id = $task_id
			AND fa.fase_id = infa.fase_id
			AND infa.inic_id = 
			( 
				SELECT MAX( inic_id ) 
				FROM inicio_fase
				WHERE trfa_id = ta.trfa_id 
			)
			
			ORDER BY ib.itbklg_id
	";
	
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	$posts = array();
	if(mysql_num_rows($result)) {
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('tarefa'=>$post);
		}
	}

	/* output in necessary format */
	if($format == 'json') {
		header('Content-type: application/json');
		echo json_encode(array('posts'=>$posts));
	}
	else {
		header('Content-type: text/xml;charset=utf-8');
		
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

	}

	/* disconnect from the db */
	@mysql_close($link);
}
?>
