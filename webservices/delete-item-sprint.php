<?php
/* require the user as the parameter */
if(isset($_GET['id']) && intval($_GET['id'])) {

	$id = intval($_GET['id']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	/* grab the posts from the db */
	
	$query = "SELECT * FROM item_backlog WHERE itbklg_id = $id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while ($row = mysql_fetch_assoc($result)) {
		$proj_id = $row['proj_id'];
		$ptcp_id = $row['ptcp_id'];
		$itbklg_titulo = $row['itbklg_titulo'];
		$itbklg_descricao = $row['itbklg_descricao'] ? "'" . $row['itbklg_descricao'] ."'" : 'NULL';
		$itbklg_pontos_valor_agregado = $row['itbklg_pontos_valor_agregado'] ? "'" . $row['itbklg_pontos_valor_agregado'] ."'" : 'NULL';
		$itbklg_pontos_prioridade = $row['itbklg_pontos_prioridade'];
		$itbklg_historia_pai = $row['itbklg_historia_pai'] ? "'" . $row['itbklg_historia_pai'] ."'" : 'NULL';
		$itbklg_pontos_estimativa = $row['itbklg_pontos_estimativa'] ? "'" . $row['itbklg_pontos_estimativa'] ."'" : 'NULL';
		$itbklg_data_aceitacao = $row['itbklg_data_aceitacao'] ? "'" . $row['itbklg_data_aceitacao'] ."'" : 'NULL';
		$itbklg_data_exclusao = $row['itbklg_data_exclusao'] ? "'" . $row['itbklg_data_exclusao'] ."'" : 'NULL';
		$itbklg_justificativa_exclusao = $row['itbklg_justificativa_exclusao'] ? $row['itbklg_justificativa_exclusao'] ."'" : 'NULL';
		$itbklg_data_cadastro = $row['itbklg_data_cadastro'] ? "'" . $row['itbklg_data_cadastro'] ."'" : 'NULL';
		$itbklg_bug = $row['itbklg_bug'];
		$versao = $row['versao'];
		$itbklg_sequencial = $row['itbklg_sequencial'] ? $row['itbklg_sequencial'] : 'NULL';
		$itbklg_tags = $row['itbklg_tags'] ? "'" . $row['itbklg_tags'] ."'" : 'NULL';
		$itbklg_possui_anexo = $row['itbklg_possui_anexo'];
	}
	
	$query = "UPDATE item_sprint_backlog SET itspt_data_exclusao = CURRENT_TIMESTAMP WHERE itspt_id = $id";
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	$query = "INSERT INTO item_backlog(proj_id, ptcp_id, itbklg_titulo, itbklg_descricao, itbklg_pontos_valor_agregado, itbklg_pontos_prioridade, itbklg_historia_pai, itbklg_id_real,  itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_justificativa_exclusao, itbklg_data_cadastro, itbklg_bug, versao, itbklg_sequencial, itbklg_tags, itbklg_possui_anexo) VALUES 
	
	($proj_id, $ptcp_id, '$itbklg_titulo', $itbklg_descricao, $itbklg_pontos_valor_agregado, $itbklg_pontos_prioridade, $itbklg_historia_pai, $id, $itbklg_pontos_estimativa, $itbklg_data_aceitacao, $itbklg_data_exclusao,$itbklg_justificativa_exclusao, $itbklg_data_cadastro, $itbklg_bug, $versao, $itbklg_sequencial, $itbklg_tags, $itbklg_possui_anexo)";
	
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	
	echo $query;
	/* disconnect from the db */
	@mysql_close($link);
}
?>
