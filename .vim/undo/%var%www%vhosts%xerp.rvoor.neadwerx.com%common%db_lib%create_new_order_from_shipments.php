Vim�UnDo� (ˑz(�3� �q��9B�O�Lf ����w�  C                 ,       ,   ,   ,    W���    _�                    !       ����                                                                                                                                                                                                                                                                                                                                                             W��     �   !   #  A          �   !   #  @    5�_�                    "       ����                                                                                                                                                                                                                                                                                                                                                             W��&     �   !   #  A           $labor_team_type_query = '';5�_�                    "   )    ����                                                                                                                                                                                                                                                                                                                                                             W��D     �   "   $  A    �   "   #  A    5�_�                    #       ����                                                                                                                                                                                                                                                                                                                                                             W��E     �   "   $  B      ,    $labor_team_type_query = 'select value';5�_�                    "       ����                                                                                                                                                                                                                                                                                                                                                             W��H     �   !   #  B      ,    $labor_team_type_query = 'select value';5�_�                    #       ����                                                                                                                                                                                                                                                                                                                                                             W��J     �   "   $  B      -    $labor_team_type_query .= 'select value';5�_�      	              #       ����                                                                                                                                                                                                                                                                                                                                                             W��K     �   "   $  B      '    $labor_team_type_query .= ' value';5�_�      
           	   #       ����                                                                                                                                                                                                                                                                                                                                                             W��K     �   "   $  B      !    $labor_team_type_query .= '';5�_�   	              
   #   .    ����                                                                                                                                                                                                                                                                                                                                                             W��Q     �   #   %  B    �   #   $  B    5�_�   
                 $   !    ����                                                                                                                                                                                                                                                                                                                                                             W��S     �   #   %  C      1    $labor_team_type_query .= '  from tb_config';5�_�                    $   !    ����                                                                                                                                                                                                                                                                                                                                                             W��T     �   #   %  C      -    $labor_team_type_query .= '   tb_config';5�_�                    $   &    ����                                                                                                                                                                                                                                                                                                                                                             W��W     �   #   %  C      1    $labor_team_type_query .= ' where tb_config';5�_�                    $   &    ����                                                                                                                                                                                                                                                                                                                                                             W��[     �   #   %  C      (    $labor_team_type_query .= ' where ';5�_�                    $   /    ����                                                                                                                                                                                                                                                                                                                                                             W��i     �   #   %  C      3    $labor_team_type_query .= ' where name = \"\"';5�_�                    $   -    ����                                                                                                                                                                                                                                                                                                                                                             W��j     �   #   %  C      2    $labor_team_type_query .= ' where name = \""';5�_�                    $   -    ����                                                                                                                                                                                                                                                                                                                                                             W��m     �   #   %  C      1    $labor_team_type_query .= ' where name = ""';5�_�                    $   -    ����                                                                                                                                                                                                                                                                                                                                                             W��m     �   #   %  C      0    $labor_team_type_query .= ' where name = "';5�_�                    $   -    ����                                                                                                                                                                                                                                                                                                                                                             W��n     �   #   %  C      /    $labor_team_type_query .= ' where name = ';5�_�                    $   .    ����                                                                                                                                                                                                                                                                                                                                                             W��r     �   #   %  C      1    $labor_team_type_query .= ' where name = ''';5�_�                    $   -    ����                                                                                                                                                                                                                                                                                                                                                             W��s     �   #   %  C      2    $labor_team_type_query .= ' where name = '\'';5�_�                    %       ����                                                                                                                                                                                                                                                                                                                                                             W���     �   $   &  C      3    $labor_team_type = LABOR_TEAM_TYPE_STORE_OTHER;5�_�                    %       ����                                                                                                                                                                                                                                                                                                                                                             W���     �   $   &  C          $labor_team_type = ;5�_�                    %   !    ����                                                                                                                                                                                                                                                                                                                                                             W���     �   $   &  C      $    $labor_team_type = query_row();;5�_�                    %   "    ����                                                                                                                                                                                                                                                                                                                                                             W���    �   $   &  C      &    $labor_team_type = query_row(  );;5�_�                    %   L    ����                                                                                                                                                                                                                                                                                                                                                             W���    �   $   &  C      N    $labor_team_type = query_row( DB_READ_ONLY, $labor_team_type_query, [] );;5�_�                    $   /    ����                                                                                                                                                                                                                                                                                                                                                             W��r     �   #   %  C      3    $labor_team_type_query .= ' where name = \'\'';5�_�                    $   J    ����                                                                                                                                                                                                                                                                                                                                                             W���    �   #   %  C      N    $labor_team_type_query .= ' where name = \'labor_team_type:store_other\'';5�_�                    &       ����                                                                                                                                                                                                                                                                                                                                       &          V       W��;    �   %   '          -    $now             = date( 'Y-m-d H:i:s' );�   $   &          M    $labor_team_type = query_row( DB_READ_ONLY, $labor_team_type_query, [] );�   #   %          Q    $labor_team_type_query .= ' where name = \'labor_team_type:store_other.pk\'';�   "   $          1    $labor_team_type_query .= '  from tb_config';�   !   #          -    $labor_team_type_query  = 'select value';�       "              $quantity        = 1;�      !          *    $order_type      = ORDER_TYPE_FREIGHT;5�_�                           ����                                                                                                                                                                                                                                                                                                                                       &          V       W��B    �         C      4    //$order_direction    = ORDER_DIRECTION_INBOUND;5�_�                     %       ����                                                                                                                                                                                                                                                                                                                                       &          V       W��Y     �   %   '  D          �   %   '  C    5�_�      !               &   
    ����                                                                                                                                                                                                                                                                                                                                       '          V       W��d     �   %   '  D          debug();5�_�       "           !   &       ����                                                                                                                                                                                                                                                                                                                                       '          V       W��e    �   %   '  D          debug(  );5�_�   !   #           "   %       ����                                                                                                                                                                                                                                                                                                                                       '          V       W��k    �   %   '  E          �   %   '  D    5�_�   "   $           #           ����                                                                                                                                                                                                                                                                                                                                                             W��     �        F       �      
  E    5�_�   #   &           $   
       ����                                                                                                                                                                                                                                                                                                                                                             W��$    �   	   
          create_new_od    5�_�   $   '   %       &   '       ����                                                                                                                                                                                                                                                                                                                                                             W��M     �   &   (  E          debug( $labor_team_type );5�_�   &   (           '   '       ����                                                                                                                                                                                                                                                                                                                                                             W��N    �   &   (  E          ( $labor_team_type );5�_�   '   )           (   '       ����                                                                                                                                                                                                                                                                                                                                                             W��T     �   &   (  E      "    error_log( $labor_team_type );5�_�   (   *           )   '       ����                                                                                                                                                                                                                                                                                                                                                             W��W    �   &   (  E      '    error_log( '' . $labor_team_type );5�_�   )   +           *   '       ����                                                                                                                                                                                                                                                                                                                                                             W��s     �   &   (  E      /    error_log( 'HAHAHA: ' . $labor_team_type );5�_�   *   ,           +   '   6    ����                                                                                                                                                                                                                                                                                                                                                             W��w    �   &   (  E      8    error_log( 'HAHAHA: ' . implode( $labor_team_type );5�_�   +               ,   &       ����                                                                                                                                                                                                                                                                                                                                                             W���    �   %   &              # TODO ryan's testing   :    error_log( 'HAHAHA: ' . implode( $labor_team_type ) );5�_�   $           &   %   &        ����                                                                                                                                                                                                                                                                                                                                                             W���   
 �   %   (        5�_�                     !       ����                                                                                                                                                                                                                                                                                                                                                             W��     �   !   "  @       5��