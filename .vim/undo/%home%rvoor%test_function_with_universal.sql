Vim�UnDo� t��q�N�C��Dm��v���a|��6���:       ),                             X��    _�                             ����                                                                                                                                                                                                                                                                                                                                                             X���     �                   �               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X���    �                  5�_�                    #       ����                                                                                                                                                                                                                                                                                                                                                             X���    �   "              ),5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        X���    �                tt_prefix_entities AS   (5�_�                    !        ����                                                                                                                                                                                                                                                                                                                                                  V       X���    �       !          )5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V       X���     �                9    -- this CTE gets the entities that have the passed in5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V       X���    �                6    -- this  gets the entities that have the passed in5�_�      	                     ����                                                                                                                                                                                                                                                                                                                                                  V       X���    �                5    -- this gets the entities that have the passed in5�_�                 	      7    ����                                                                                                                                                                                                                                                                                                                                                  V       X��
    �                9    -- this gets all the entities that have the passed in5�_�   	       
                 ����                                                                                                                                                                                                                                                                                                                                                             X��    �                ),5�_�   	             
      H    ����                                                                                                                                                                                                                                                                                                                                                             X��     �                O    SELECT to_tsquery( 'simple'::REGCONFIG, ?prefix? ) AS tsquery_search --TODO5�_�   
                    4    ����                                                                                                                                                                                                                                                                                                                                                             X��!   
 �                N    SELECT to_tsquery( 'simple'::REGCONFIG, 'steve' ) AS tsquery_search --TODO5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��7    �                )5��