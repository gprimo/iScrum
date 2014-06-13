<?php
if(isset($_GET['project']) && intval($_GET['project'])) {

	/* soak in the passed variable or set our own */
	$proj_id = intval($_GET['project']);

	/* connect to the db */
	$link = mysql_connect('localhost','scrumremote','123') or die('Cannot connect to the DB');
	mysql_select_db('scrumremote',$link) or die('Cannot select the DB');
	mysql_query('SET character_set_connection=utf8');
	mysql_query('SET character_set_client=utf8');
	mysql_query('SET character_set_results=utf8');
	
	/*
		MUDAR ISSO DAQUI PARA TRAZER O SPRINT BACKLOG E DE ACORDO COM CADA HISTÓRIA, COLOCAR AS TAREFAS PERTENCENTES A ELA. SE NÃO HOUVER TAREFA, COLOCAR A HISTÓRIA MESMO ASSIM.
	*/
	
	$query = "
		SELECT 
		ib.itbklg_id, ib.itbklg_titulo

		FROM item_backlog ib, item_sprint_backlog isb, sprint sp, seq_itspt_generator seq
		WHERE ib.itbklg_id = isb.itspt_id
		AND ib.proj_id = $proj_id
		AND isb.itspt_data_exclusao IS NULL 
		AND sp.spt_id = isb.spt_id
		AND sp.spt_data_final_real IS NULL 
		AND sp.spt_data_cancelamento IS NULL 
		AND seq.id_sprint = sp.spt_id
		ORDER BY ib.itbklg_id
	";
	$itens = array();
	$itens_id = array();
	$itens_titulos = array();
	$result = mysql_query($query,$link) or die('Errant query:  '.$query);
	while($row = mysql_fetch_array($result))
	{
		$itens[] = array('item'=>null);
		$itens_id[] = $row[0];
		$itens_titulos[] = $row[1];
	}
	
	$query = "
		SELECT DISTINCT ib.itbklg_id, ib.itbklg_titulo, ta.trfa_titulo, fa.fase_nome, ta.trfa_data_inicio, ta.trfa_id, ta.trfa_descricao, 
		ta.trfa_impedimento, ta.trfa_data_exclusao, infa.inic_id, infa.inic_data, infa.fase_id, ta.trfa_bug, pa.ptcp_sigla
		
		FROM tarefa ta, item_backlog ib, item_sprint_backlog isb, sprint sp, fase fa, inicio_fase infa LEFT JOIN inicio_fase_participacao infa_pa ON infa_pa.inic_id = infa.inic_id LEFT JOIN participacao pa ON pa.ptcp_id = infa_pa.ptcp_id
		WHERE ta.itspt_id = ib.itbklg_id 
		AND ta.itspt_id = isb.itspt_id
		AND ib.proj_id =$proj_id
		AND isb.itspt_id = ib.itbklg_id
		AND sp.spt_id = isb.spt_id
		AND sp.spt_data_final_real IS NULL 
		AND sp.spt_data_cancelamento IS NULL 
		AND isb.itspt_data_exclusao IS NULL 
		AND ta.trfa_data_exclusao IS NULL 
		AND infa.trfa_id = ta.trfa_id
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
	
	//$itens = array();
	if(mysql_num_rows($result)) {
		$id_ant = NULL;
		$i = 0;
		while($post = mysql_fetch_assoc($result)) {
			
			if ($post['itbklg_id'] != $id_ant)
			{
				//echo "novo<br/>";
				//$itens[] = array('item'=>array('tarefa'=>$post));
				
				while ($itens_id[$i] != $post['itbklg_id'])
					$i++;
				
				array_push($itens[$i],array('tarefa'=>$post));
				$i++;
			}
			else
			{
				//echo "anterior = " . ($i - 1) . "<br/>";
				//print_r($itens[$i-1]);
				
				array_push($itens[$i-1],array('tarefa'=>$post));
			}
			$id_ant = $post['itbklg_id'];
			
		}
	}
	
	header('Content-type: text/xml;charset=utf-8');
		echo '<taskboard>';
		foreach($itens as $index=>$item)
		{
			echo '<item>';
			echo "<id>",preg_replace('/&(?!#?[a-z0-9]+;)/', '&amp;', $itens_id[$index]),"</id>";
			echo "<titulo>",preg_replace('/&(?!#?[a-z0-9]+;)/', '&amp;', $itens_titulos[$index]),"</titulo>";
			foreach($item as $key=>$tarefa)
			{
				
				
				foreach($tarefa as $name=>$attrs)
				{	
					echo '<',$name,'>';
					foreach ($attrs as $attr_name=>$attr_value)
					{
						/*if ($attr_name == 'itbklg_id')
						{
							echo "CUZÃO: $attr_value, " . $itens_id[$index];
						}
						if ($attr_name == 'itbklg_id' && $attr_value == $itens_id[$index])
						{*/
							echo '<',$attr_name,'>',preg_replace('/&(?!#?[a-z0-9]+;)/', '&amp;', htmlspecialchars($attr_value)),'</',$attr_name,'>';
						//}
					}
					echo '</',$name,'>';
					
				}
			}
			echo '</item>';
		}
		echo '</taskboard>';
	
	@mysql_close($link);
}
?>