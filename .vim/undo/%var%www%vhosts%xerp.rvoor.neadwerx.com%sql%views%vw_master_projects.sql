Vim�UnDo� (��	1���t�:j)�O<LC/��0\���9��  
                                   W��    _�                      T       ����                                                                                                                                                                                                                                                                                                                                                             W��     �   S   d  
           LEFT JOIN tb_tier t               ON t.tier = pj.tier       INNER JOIN tb_program pg   &            ON pg.program = pj.program   "    INNER JOIN tb_program_type pgt   1            ON pgt.program_type = pg.program_type   8     LEFT JOIN tb_project_merchandise_classification pmc   '            ON pmc.project = pj.project        LEFT JOIN tb_department d   ,            ON d.department = pmc.department        LEFT JOIN tb_graph g   $            ON g.pk_val = pj.project   &           AND g.graph_type IN( 1, 3 )            LEFT JOIN (   5                      tb_node n_mvp_project_alignment5��