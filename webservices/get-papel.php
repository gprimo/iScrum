<?php
/* require the user as the parameter */
if(isset($_GET['user']) && isset($_GET['project']) && intval($_GET['user'])) {

	/* soak in the passed variable or set our own */
	$format = strtolower($_GET['format']) == 'json' ? 'json' : 'xml'; //xml is the default
	$user_id = intval($_GET['user']); //no default
	$proj_id = intval($_GET['project']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');

	/* grab the posts from the db */
	$query = "SELECT pa_usuario.pplusr_sigla, pa_usuario.pplusr_nome from projeto pr, participacao pa, papel_usuario pa_usuario, participacao_papel_usuario pa_pa_usuario WHERE pr.proj_id = $proj_id AND pr.proj_id = pa.proj_id AND pa.usr_id = $user_id AND pa_pa_usuario.ptcp_id = pa.ptcp_id AND pa_usuario.pplusr_id = pa_pa_usuario.pplusr_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* create one master array of the records */
	$posts = array();
	if(mysql_num_rows($result)) {
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('papel'=>$post);
		}
	}

	/* output in necessary format */
	if($format == 'json') {
		header('Content-type: application/json');
		echo json_encode(array('posts'=>$posts));
	}
	else {
		header('Content-type: text/xml');
		echo '<papeis>';
		foreach($posts as $index => $post) {
			if(is_array($post)) {
				foreach($post as $key => $value) {
					echo '<',$key,'>';
					if(is_array($value)) {
						foreach($value as $tag => $val) {
							echo '<',$tag,'>',htmlentities($val),'</',$tag,'>';
						}
					}
					echo '</',$key,'>';
				}
			}
		}
		echo '</papeis>';
	}

	/* disconnect from the db */
	@mysql_close($link);
}
?>