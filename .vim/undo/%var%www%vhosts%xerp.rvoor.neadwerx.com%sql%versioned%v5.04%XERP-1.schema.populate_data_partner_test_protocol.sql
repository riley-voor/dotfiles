Vim�UnDo� �K1"�:��È��@j� ^
��D�t-:�?+�L�5                     5       5   5   5    X��    _�                             ����                                                                                                                                                                                                                                                                                                                                                             X��    �                   5�_�                       �    ����                                                                                                                                                                                                                                                                                                                                                             X���     �                  �               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��    �                -UPDATE tb_data_partner SET test_protocol = ()5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��=     �               �               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��A     �               �               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��F     �               �               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��G    �         	    5�_�      	                      ����                                                                                                                                                                                                                                                                                                                                                             X��Q     �         
       5�_�      
           	          ����                                                                                                                                                                                                                                                                                                                                                             X��U     �                �      
   
    5�_�   	              
           ����                                                                                                                                                                                                                                                                                                                                                             X��X     �                �      
       5�_�   
                         ����                                                                                                                                                                                                                                                                                                                                                             X��q    �                    5�_�                    
       ����                                                                                                                                                                                                                                                                                                                                                             X��z     �   	            ,    SELECT data_partner, production_protocol5�_�                       
    ����                                                                                                                                                                                                                                                                                                                                                             X��{     �                       �             5�_�                    
        ����                                                                                                                                                                                                                                                                                                                                                             X��    �   	                 SELECT data_partner, 5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             X��    �                   �             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��    �                     WHERE test_protocol IS NULL5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             X��   	 �                     FROM tb_data_partner5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V       X���     �   
                        production_protocol5�_�                    
       ����                                                                                                                                                                                                                                                                                                                                                V       X���   
 �   	                SELECT data_partner,5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V       X���    �   
                  FROM tb_data_partner;5�_�                    
       ����                                                                                                                                                                                                                                                                                                                                                V       X���    �   
                �   
          5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V       X���     �                   �             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V       X���     �                5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V       X��    �                   FOR my_data_partner5�_�                    
        ����                                                                                                                                                                                                                                                                                                                            
                    V       X��     �   	   
              SELECT data_partner   2      INTO my_data_partners_without_test_protocols         FROM tb_data_partner   !     WHERE test_protocol IS NULL;5�_�                            ����                                                                                                                                                                                                                                                                                                                            
          
          V       X��     �             �             5�_�                           ����                                                                                                                                                                                                                                                                                                                                                       X��      �               2      INTO my_data_partners_without_test_protocols         FROM tb_data_partner   !     WHERE test_protocol IS NULL;�                   SELECT data_partner5�_�                            ����                                                                                                                                                                                                                                                                                                                                                       X��!    �                 5�_�                       $    ����                                                                                                                                                                                                                                                                                                                                                       X��"    �               %         WHERE test_protocol IS NULL;5�_�                       
    ����                                                                                                                                                                                                                                                                                                                                                       X��'    �                6          INTO my_data_partners_without_test_protocols5�_�                             ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X��-     �                    UPDATE tb_data_partner          SET test_protocol = ?   !     WHERE test_protocol IS NULL;5�_�      !                       ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X��.     �             �             5�_�       "           !          ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X��.     �             5�_�   !   #           "          ����                                                                                                                                                                                                                                                                                                                                                       X��1    �                      SET test_protocol = ?   !     WHERE test_protocol IS NULL;�                   UPDATE tb_data_partner5�_�   "   $           #   
        ����                                                                                                                                                                                                                                                                                                                                                       X��F    �   	   
           5�_�   #   %           $           ����                                                                                                                                                                                                                                                                                                                                                       X��H    �                     5�_�   $   &           %           ����                                                                                                                                                                                                                                                                                                                                                       X��J     �                 5�_�   %   '           &           ����                                                                                                                                                                                                                                                                                                                                                       X��K    �                 5�_�   &   (           '          ����                                                                                                                                                                                                                                                                                                                                                       X��P     �                           SET test_protocol = ?5�_�   '   )           (          ����                                                                                                                                                                                                                                                                                                                                                       X��R     �                          SET test_protocol = 5�_�   (   *           )           ����                                                                                                                                                                                                                                                                                                                                                       X��T     �               !           SET test_protocol = ()5�_�   )   ,           *          ����                                                                                                                                                                                                                                                                                                                                                       X��V     �               	        )5�_�   *   -   +       ,          ����                                                                                                                                                                                                                                                                                                                                                       X��]     �                           SET test_protocol = (5�_�   ,   .           -          ����                                                                                                                                                                                                                                                                                                                                                       X��_     �                               �             5�_�   -   /           .      )    ����                                                                                                                                                                                                                                                                                                                                                       X��f     �                               �             5�_�   .   0           /           ����                                                                                                                                                                                                                                                                                                                                                       X��q    �                        �                           SET test_protocol = 5�_�   /   1           0           ����                                                                                                                                                                                                                                                                                                                                                       X��r    �                 5�_�   0   2           1           ����                                                                                                                                                                                                                                                                                                                                                       X��~    �                5�_�   1   3           2          ����                                                                                                                                                                                                                                                                                                                                                       X��     �                    my_data_partner INTEGER;5�_�   2   4           3           ����                                                                                                                                                                                                                                                                                                                                                       X��     �             �             5�_�   3   5           4           ����                                                                                                                                                                                                                                                                                                                                                       X��     �                END;5�_�   4               5           ����                                                                                                                                                                                                                                                                                                                                                       X��    �             �             5�_�   *           ,   +          ����                                                                                                                                                                                                                                                                                                                                                       X��Z     �                              	        )5��