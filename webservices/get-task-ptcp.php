<?php
/* require the user as the parameter */
if(isset($_GET['trfa_id']) && intval($_GET['trfa_id'])) {

	/* soak in the passed variable or set our own */
	//$number_of_posts = isset($_GET['num']) ? intval($_GET['num']) : 10; //10 is the default
	$format = strtolower($_GET['format']) == 'json' ? 'json' : 'xml'; //xml is the default
	$trfa_id = intval($_GET['trfa_id']); 
	
	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	$query = "select pa.ptcp_sigla, in_fa.fase_id from participacao pa, inicio_fase_participacao in_fa_pa, inicio_fase in_fa where pa.ptcp_status='ATIVO' AND pa.ptcp_id = in_fa_pa.ptcp_id AND in_fa_pa.inic_id = in_fa.inic_id AND in_fa.trfa_id = $trfa_id AND in_fa.inic_id = 
	(
		SELECT MAX( inic_id ) 
		FROM inicio_fase
		WHERE trfa_id = in_fa.trfa_id
	)";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* create one master array of the records */
	$posts = array();
	if(mysql_num_rows($result)) {
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('participacao'=>$post);
		}
	}

	/* output in necessary format */
	if($format == 'json') {
		header('Content-type: application/json');
		echo json_encode(array('posts'=>$posts));
	}
	else {
		header('Content-type: text/xml;charset=utf-8');
		echo '<ptcp>';
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
		echo '</ptcp>';
	}

	/* disconnect from the db */
	@mysql_close($link);
}
?>
