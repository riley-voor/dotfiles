Vim�UnDo� m��d���}��	��)��ՠlP�N�&��   $                                  X��o    _�                             ����                                                                                                                                                                                                                                                                                                                                       #                   X��f     �              !   	    name,       description,       script_path,       allow_local_concurrency,       allow_global_concurrency,       maintainer_email,       max_execution_seconds   
) VALUES (   -    'Consolidated Order Transmitter', -- name   V    'Transmits orders placed in xERP to the customer''s data partner.', -- description   A    'perl/cron/consolidated_order_transmitter.pl', -- script_path   #    '1', -- allow_local_concurrency   $    '1', -- allow_global_concurrency   -    'moshe@neadwerx.com', -- maintainer_email   *    '14400' -- max_execution_seconds 4 hrs   )   ;       -- create script arguments    INSERT INTO tb_script_argument (       script,   
    label,       description,       flag_name,       required,       multiple   ) VALUES   �( ( SELECT script FROM tb_script WHERE name = 'Consolidated Order Transmitter' ), 'separate by project', 'separate by project', '-j', '0', '0' ),   �( ( SELECT script FROM tb_script WHERE name = 'Consolidated Order Transmitter' ), 'line items to transmit (csv)', 'line items to transmit (csv)', '-l', '0', '0' ),   �( ( SELECT script FROM tb_script WHERE name = 'Consolidated Order Transmitter' ), 'data partner name', 'data partner name', '-d', '0', '0' ),   �( ( SELECT script FROM tb_script WHERE name = 'Consolidated Order Transmitter' ), 'priority orders only', 'priority orders only', '-p', '0', '0' ),   �( ( SELECT script FROM tb_script WHERE name = 'Consolidated Order Transmitter' ), 'data partner name (obsolete)', 'data partner name (obsolete)', '-f', '0', '0' )   ;�         #      INSERT INTO tb_script (5�_�                            ����                                                                                                                                                                                                                                                                                                                                       #                   X��g     �         $       �         #    5�_�                             ����                                                                                                                                                                                                                                                                                                                                       $                   X��n    �                -- 5��