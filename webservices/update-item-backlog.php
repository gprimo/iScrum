<?php
/* require the user as the parameter */
if(isset($_GET['id']) && isset($_GET['titulo']) && intval($_GET['id']) && isset($_GET['descricao']) && isset($_GET['estimativa']) ) {

	$id = intval($_GET['id']);
	$titulo = $_GET['titulo'];
	$descricao = $_GET['descricao'];
	$estimativa = $_GET['estimativa'] != '' ? $_GET['estimativa'] : 'NULL';
	$aceitacao = $_GET['aceitacao'];

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	if ($aceitacao == 1)
		$query = "UPDATE item_backlog SET itbklg_titulo = '$titulo', itbklg_descricao = '$descricao', itbklg_pontos_estimativa = $estimativa, itbklg_data_aceitacao = CURRENT_TIMESTAMP WHERE itbklg_id = $id";
	else
		$query = "UPDATE item_backlog SET itbklg_titulo = '$titulo', itbklg_descricao = '$descricao', itbklg_pontos_estimativa = $estimativa, itbklg_data_aceitacao = NULL WHERE itbklg_id = $id";
	echo $query;
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* disconnect from the db */
	@mysql_close($link);
}
?>
