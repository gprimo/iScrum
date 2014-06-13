<?php
/* require the user as the parameter */
if(isset($_GET['id']) && isset($_GET['titulo']) && intval($_GET['id']) && isset($_GET['descricao']) && isset($_GET['tipo']) ) {

	$id = intval($_GET['id']);
	$titulo = $_GET['titulo'];
	$descricao = $_GET['descricao'];
	$tipo = $_GET['tipo'];

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	
	if ($tipo == 'Tarefa')
		$query = "UPDATE tarefa SET trfa_titulo = '$titulo', trfa_descricao = '$descricao', trfa_impedimento = 0, trfa_bug = 0 WHERE trfa_id = $id";
	else if ($tipo == 'Impedimento')
		$query = "UPDATE tarefa SET trfa_titulo = '$titulo', trfa_descricao = '$descricao', trfa_impedimento = 1, trfa_bug = 0 WHERE trfa_id = $id";
	else if ($tipo == 'Bug')
		$query = "UPDATE tarefa SET trfa_titulo = '$titulo', trfa_descricao = '$descricao', trfa_impedimento = 0, trfa_bug = 1 WHERE trfa_id = $id";
	echo $query;
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);

	/* disconnect from the db */
	@mysql_close($link);
}
?>
