*--------------------------------------------
* Titulo : P1 (2022-2023) - Caesar Cipher
* Autores: Marc Link Cladera y Jesus Castillo Benito
*--------------------------------------------
            ORG $1000
DISP:       EQU 3
DICT_SIZE:  EQU 5
DICT_IN:    DC.B 'ABCDE'
DICT_OUT:   DS.B DICT_SIZE
TEXT_SIZE:  EQU 26
TEXT_IN:    DC.B 'ESTRUCTURA DE COMPUTADORES'
TEXT_OUT:   DS.B TEXT_SIZE
NCHANGES:   DS.W 1
            DS.W 0
*--------------------------------------------    

START:
        MOVE.W  #0,NCHANGES
        MOVE.B  #DICT_SIZE,D0
        SUBQ.B  #1,D0
        ; el registro A1 servira para recorrer el dict_in
        MOVEA.L #0,A0
        ; el registro A1 servira para recorrer el dict_out
        MOVEA.L #0,A1
        ADDQ.L  #DISP,A1
        MOVE.L  #TEXT_SIZE,D1
        SUBQ.L  #1,D1
        MOVE.L  #DICT_SIZE,D2
        SUBQ.L  #1,D2
       
LOOP_CHANGE_CHAR:
        ; en el registro D3 guardamos el valor de DICT_SIZE -1
        MOVE.B  #0,D3
        MOVE.B  #DICT_SIZE,D3
        SUBQ.B  #1,D3
        ; el registro D4 lo usaremos para guardar la suma que nos
        ; permitirá saber si nos salimos del vector
        MOVE.L  #0,D4
        MOVE.L  #DISP,D4
        ADD.L   A0,D4
        CMP     D3,D4
        BLS     AT_VECTOR
        MOVE.B  #DICT_SIZE,D3
        SUB.L   D3,D4
        MOVE.L  D4,A1
        
AT_VECTOR: 
        MOVE.B  DICT_IN(A0),DICT_OUT(A1)
        ADDQ    #1,A0
        ADDQ    #1,A1
        DBRA    D0,LOOP_CHANGE_CHAR
        
        ; A0 servira para recorrer el TEXT_IN y TEXT_OUT
        MOVE.L  #0,A0
        ; liberamos el registro D3 para asi poder almacenar
        ; el caracter del texto
        MOVE.L  #0,D3
        MOVE.L  #0,D4
        
LOOP_TEXT:
        ; A1 servira para controlar DICT_OUT y DICT_IN
        ; Se reestablecera el valor en cada iteracion
        ; sobre el bucle del texto
        MOVE.L  #0,A1
        MOVE.B  TEXT_IN(A0),D3
        ; movemos directamente el caracter al TEXT_OUT por
        ; si ese caracter no se encuentra en el diccionario.
        ; En el caso de que se encontrase, sobreescribiremos 
        ; ese espacio de memoria con el valor correspondiente
        MOVE.B  D3,TEXT_OUT(A0)
        
LOOP_DICT:
        MOVE.B  DICT_IN(A1),D4
        CMP     D3,D4
        BNE     NOT_EQUALS
        MOVE.B  DICT_OUT(A1),TEXT_OUT(A0)
        ADDQ.W  #1,NCHANGES

NOT_EQUALS:
        ; aumentamos A1 para avanzar sobre los vectores DICT
        ADDQ.L  #1,A1
        DBRA    D2,LOOP_DICT
        ; le volvemos a dar valor a D2
        MOVE.L  #DICT_SIZE,D2
        SUBQ.L  #1,D2
        ; aumentamos A0 para avanzar sobre los vectores TEXT
        ADDQ.L  #1,A0
        DBRA    D1,LOOP_TEXT
        
        ; en este momento hemos generado el DICT_OUT

    SIMHALT             ; halt simulator

    END    START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
