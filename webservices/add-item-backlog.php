<?php
/* require the user as the parameter */
if(isset($_GET['proj_id']) && isset($_GET['user_id']) && intval($_GET['proj_id']) && intval($_GET['user_id'])) {

	
	$proj_id = intval($_GET['proj_id']);
	$user_id = intval($_GET['user_id']);
	$titulo = $_GET['titulo'];
	$descricao = $_GET['descricao'];
	$estimativa = $_GET['estimativa'];

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	$query = "SELECT ptcp_id FROM participacao WHERE usr_id = $user_id and proj_id = $proj_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_array($result)) {
		$ptcp_id = $row[0];
	}
	
	$query = "SELECT sequencial FROM seq_historia_generator where id_projeto = $proj_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_array($result)) {
		$seq = $row[0];
	}
	
	
	$query = "INSERT INTO item_backlog(proj_id, ptcp_id, itbklg_titulo, itbklg_descricao,itbklg_pontos_estimativa, versao, itbklg_sequencial) VALUES ($proj_id, $ptcp_id, '$titulo', '$descricao', '$estimativa', 0, $seq)";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	$query = "UPDATE item_backlog SET itbklg_id_real = " . mysql_insert_id() . " WHERE itbklg_id = " . mysql_insert_id();
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	$seq++;
	$query = "UPDATE seq_historia_generator SET sequencial=$seq where id_projeto = $proj_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	echo "OK";
	/* disconnect from the db */
	@mysql_close($link);
}
?>
