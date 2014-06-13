<?php
/* require the user as the parameter */
if(isset($_GET['item_id']) && isset($_GET['user_id']) && isset($_GET['titulo']) && intval($_GET['item_id']) && isset($_GET['proj_id']) && intval($_GET['proj_id'])) {

	$user_id = intval($_GET['user_id']);
	$item_id = intval($_GET['item_id']);
	$proj_id = intval($_GET['proj_id']);
	$titulo = $_GET['titulo'];
	$descricao = $_GET['descricao'];
	$bug = $_GET['bug'];
	$imp = $_GET['imp'];

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	$query = "SELECT MAX(trfa_sequencial) FROM tarefa ta, item_sprint_backlog isb, sprint sp, item_backlog ib WHERE  ta.itspt_id = isb.itspt_id AND ib.proj_id = $proj_id AND isb.itspt_id = ib.itbklg_id AND sp.spt_id = isb.spt_id 
			AND sp.spt_data_final_real IS NULL 
			AND sp.spt_data_cancelamento IS NULL 
			AND isb.itspt_data_exclusao IS NULL 
			AND ta.trfa_data_exclusao IS NULL
			ORDER BY ta.trfa_sequencial ";
			
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_array($result)) {
		$seq_id = $row[0] + 1;
	}
	/*$query = "SELECT ptcp_id FROM participacao WHERE usr_id = $user_id AND proj_id = $proj_id LIMIT 1";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_array($result)) {
		$ptcp_id = $row[0];
	}*/
	//trfa_sequencial: pegar o maior sequencial de tarefa pertencente à sprint
	//inic_atual_id: inserir em inicio_fase a trfa_id, fase_id = 1, inic_data = current_timestamp
	
	$query = "INSERT INTO tarefa (itspt_id, trfa_titulo, trfa_descricao, trfa_bug,trfa_impedimento, trfa_sequencial, trfa_data_inicio) 
	VALUES ($item_id, '$titulo', '$descricao', $bug, $imp, $seq_id, CURRENT_TIMESTAMP )";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	$trfa_id = mysql_insert_id();
	
	$query = "INSERT INTO inicio_fase (trfa_id, fase_id, inic_data) VALUES ($trfa_id, 1, CURRENT_TIMESTAMP)";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	/*$query = "INSERT INTO inicio_fase_participacao (inic_id, ptcp_id) VALUES (" . mysql_insert_id() . ", $ptcp_id)";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);*/
	
	$query = "UPDATE tarefa SET inic_atual_id = " . mysql_insert_id() . "WHERE trfa_id = $trfa_id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	echo "query";
	/* disconnect from the db */
	@mysql_close($link);
}
?>
