Vim�UnDo� t�{���6����.li,�`X��{~�K����      ufn_label_last_transaction( "XERP-11178: renaming the 2 procurement coordinator roles so they're labels are unique" );             Q       Q   Q   Q    X��}    _�                             ����                                                                                                                                                                                                                                                                                                                                                             X��(     �                  �               5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             X��/     �                 fn_label_last_transaction();5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             X��2    �                  fn_label_last_transaction( "" );5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X��e    �                 5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             X���     �             �             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             X���    �                 DO5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        X���    �   
          �             �   
             END     $$       language plpgsql5�_�      	                      ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �                "    my_name        VARCHAR( 128 );       my_value       JSON;       my_rank        INTEGER;5�_�      
           	          ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �                   my_description JSON;5�_�   	              
          ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �                   my_ JSON;5�_�   
                    *    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               /    my_store_environment_business_unit_pk JSON;5�_�                       *    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               +    my_store_environment_business_unit_pk ;5�_�                       0    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �             �             5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X���    �               2    my_store_environment_business_unit_pk INTEGER;5�_�                       *    ����                                                                                                                                                                                                                                                                                                                                                  V        X���    �               2    my_store_environment_business_unit_pk INTEGER;5�_�                       .    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �             �             5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               7    my_store_environment_business_unit_pk      INTEGER;5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               '    my_store_environment_      INTEGER;5�_�                       9    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               F    my_store_environment_procurement_coordinator_role_pk      INTEGER;5�_�                       4    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �             �             5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               A    my_store_environment_procurement_coordinator_role_pk INTEGER;5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               7    my_ronment_procurement_coordinator_role_pk INTEGER;5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X���    �               /    my_procurement_coordinator_role_pk INTEGER;5�_�                       9    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               A    my_store_environment_procurement_coordinator_role_pk INTEGER;5�_�                       /    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               7    my_merchandising_services_business_unit_pk INTEGER;5�_�                       /    ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �               7    my_store_environment_business_unit_pk      INTEGER;5�_�                       ;    ����                                                                                                                                                                                                                                                                                                                                                  V        X���    �               D    my_store_environment_business_unit_pk                   INTEGER;5�_�                    	        ����                                                                                                                                                                                                                                                                                                                                                  V        X���     �                5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        X��     �   
                  FROM tb_business_unit5�_�                    	       ����                                                                                                                                                                                                                                                                                                                                                  V        X��     �      
             SELECT business_unit5�_�                             ����                                                                                                                                                                                                                                                                                                                                                  V        X��   	 �                     WHERE get_translation( 5�_�      !                      ����                                                                                                                                                                                                                                                                                                                                                  V        X��     �                    WHERE get_translation(5�_�       "           !      *    ����                                                                                                                                                                                                                                                                                                                                                  V        X��#     �               +     WHERE get_translation( bu.label ) = ''5�_�   !   #           "      <    ����                                                                                                                                                                                                                                                                                                                                                  V        X��*   
 �               <     WHERE get_translation( bu.label ) = 'Store Environment'5�_�   "   $           #           ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��-     �             �             5�_�   #   %           $          ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��0     �               0      INTO my_store_environment_business_unit_pk5�_�   $   &           %          ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��1     �                     INTO my_siness_unit_pk5�_�   %   '           &          ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��3     �                     INTO my_business_unit_pk5�_�   &   (           '          ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��5    �                     INTO my__business_unit_pk5�_�   '   )           (      *    ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��H     �               =     WHERE get_translation( bu.label ) = 'Store Environment';5�_�   (   *           )      *    ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��H     �               8     WHERE get_translation( bu.label ) = ' Environment';5�_�   )   +           *      *    ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��I    �               ,     WHERE get_translation( bu.label ) = '';5�_�   *   ,           +      ?    ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��S     �                   �             5�_�   +   -           ,           ����                                                                                                                                                                                                                                                                                                                            	             <       V   <    X��X     �                5�_�   ,   .           -           ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X��f     �                F    my_store_environment_procurement_coordinator_role_pk      INTEGER;   F    my_merchandising_services_procurement_coordinator_role_pk INTEGER;5�_�   -   /           .          ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X��n     �                   UPDATE 5�_�   .   0           /          ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X���     �                      SET label = 5�_�   /   1           0          ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X���     �                      SET label = ?5�_�   0   2           1           ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X���     �                5�_�   1   3           2      '    ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X���     �               (     WHERE get_translation( label ) = ''5�_�   2   4           3      =    ����                                                                                                                                                                                                                                                                                                                               
          
       V   
    X���    �                   �             5�_�   3   5           4           ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���     �             �             5�_�   4   6           5          ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���     �             5�_�   5   7           6          ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���     �               @       AND business_unit = my_store_environment_business_unit_pk5�_�   6   8           7          ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���     �                      AND business_unit = 5�_�   7   9           8      @    ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���     �               @       AND business_unit = my_store_environment_business_unit_pk5�_�   8   :           9          ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���     �                      AND business_unit = my  5�_�   9   ;           :           ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X���    �                H       AND business_unit = my_merchandising_services_business_unit_pk;  5�_�   :   <           ;      /    ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X��3     �               F    my_merchandising_services_business_unit_pk                INTEGER;5�_�   ;   =           <      /    ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X��4    �               F    my_store_environment_business_unit_pk                     INTEGER;5�_�   <   ?           =      >    ����                                                                                                                                                                                                                                                                                                                                         ?       V   ?    X��B    �               ?     WHERE get_translation( label ) = 'Procurement Coordinator'5�_�   =   @   >       ?          ����                                                                                                                                                                                                                                                                                                                                                             X���     �                      SET label = ? -- TODO5�_�   ?   A           @          ����                                                                                                                                                                                                                                                                                                                                                             X���     �                      SET label = 5�_�   @   B           A      #    ����                                                                                                                                                                                                                                                                                                                                                             X���     �               $       SET label = add_translation()5�_�   A   C           B      +    ����                                                                                                                                                                                                                                                                                                                                                             X���     �               /       SET label = add_translation( null, '', )5�_�   B   D           C      X    ����                                                                                                                                                                                                                                                                                                                                                             X���     �               Z       SET label = add_translation( null, 'Procurement Coordinator (Store Environment)', )5�_�   C   E           D      Z    ����                                                                                                                                                                                                                                                                                                                                                             X���    �               ]       SET label = add_translation( null, 'Procurement Coordinator (Store Environment)', '' )5�_�   D   F           E          ����                                                                                                                                                                                                                                                                                                                                                             X���     �                      SET label = ? -- TODO5�_�   E   G           F          ����                                                                                                                                                                                                                                                                                                                                                             X���     �                      SET label = 5�_�   F   H           G      #    ����                                                                                                                                                                                                                                                                                                                                                             X���     �               $       SET label = add_translation()5�_�   G   I           H      +    ����                                                                                                                                                                                                                                                                                                                                                             X���    �               -       SET label = add_translation( null, '')5�_�   H   J           I      [    ����                                                                                                                                                                                                                                                                                                                                                             X���     �               ]       SET label = add_translation( null, 'Procurement Coordinator (Merchandising Services)')5�_�   I   K           J      [    ����                                                                                                                                                                                                                                                                                                                                                             X���     �               ^       SET label = add_translation( null, 'Procurement Coordinator (Merchandising Services),')5�_�   J   L           K      \    ����                                                                                                                                                                                                                                                                                                                                                             X���    �               ]       SET label = add_translation( null, 'Procurement Coordinator (Merchandising Services)')5�_�   K   M           L      h    ����                                                                                                                                                                                                                                                                                                                                                             X���    �               i       SET label = add_translation( null, 'Procurement Coordinator (Merchandising Services)', 'fallback')5�_�   L   N           M           ����                                                                                                                                                                                                                                                                                                                                                             X��    �                 ufn_label_last_transaction( "XERP-11178: renaming the 2 procurement coordinator roles so they're labels are unique" );5�_�   M   O           N      "    ����                                                                                                                                                                                                                                                                                                                                                             X��o     �                 |SELECT fn_label_last_transaction( "XERP-11178: renaming the 2 procurement coordinator roles so they're labels are unique" );5�_�   N   P           O      x    ����                                                                                                                                                                                                                                                                                                                                                             X��r    �                 |SELECT fn_label_last_transaction( 'XERP-11178: renaming the 2 procurement coordinator roles so they're labels are unique" );5�_�   O   Q           P      c    ����                                                                                                                                                                                                                                                                                                                                                             X��x    �                 |SELECT fn_label_last_transaction( 'XERP-11178: renaming the 2 procurement coordinator roles so they're labels are unique' );5�_�   P               Q      e    ����                                                                                                                                                                                                                                                                                                                                                             X��|    �                 {SELECT fn_label_last_transaction( 'XERP-11178: renaming the 2 procurement coordinator roles so theyre labels are unique' );5�_�   =           ?   >          ����                                                                                                                                                                                                                                                                                                                                                             X���     �              5��