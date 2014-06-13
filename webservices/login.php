<?php
/* require the user as the parameter */
if(isset($_GET['login']) && isset($_GET['senha'])) {

	/* soak in the passed variable or set our own */
	//$number_of_posts = isset($_GET['num']) ? intval($_GET['num']) : 10; //10 is the default
	
	$login = $_GET['login'];
	$senha = $_GET['senha'];

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumbilling',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	$query = "SELECT id, nome, identificacao FROM usuario WHERE login = '$login' AND senha = '$senha' LIMIT 1";
	
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	if(mysql_num_rows($result))
	{
		while($post = mysql_fetch_assoc($result)) {
			$posts[] = array('usuario'=>$post);
		}
		
		header('Content-type: text/xml;charset=utf-8');
		echo '<user_info>';
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
		echo '</user_info>';
	}
	else
		echo "FALSE";
	@mysql_close($link);
}
?>
