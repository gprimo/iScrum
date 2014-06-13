<?php
if(isset($_GET['user']) && intval($_GET['user'])) {
	

	$user_id = intval($_GET['user']);

	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	
	$query = "SELECT usr.proj_id_ultimo_acesso, pr.proj_nome, sp.sequencial FROM usuario usr, projeto pr, seq_sprint_generator sp WHERE usr_id = $user_id AND pr.proj_id = usr.proj_id_ultimo_acesso AND pr.proj_id = sp.idProjeto";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	
	$projeto_padrao = "";
	if(mysql_num_rows($result)) {
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('info'=>$post);
		}
		
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
	else
		echo "FALSE";
	
	
	

	
	@mysql_close($link);
}
?>
